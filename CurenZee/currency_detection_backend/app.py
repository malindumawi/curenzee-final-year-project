import re
from collections import defaultdict

import cv2
import joblib
import numpy as np
from flask import Flask, request, jsonify
from sklearn.cluster import KMeans
from ultralytics import YOLO

app = Flask(__name__)

# Load Logistic Regression model for light condition detection
logistic_model = joblib.load('Low_light_classifier.pkl')

# Load YOLOv8 model for object detection
model = YOLO('best.pt')
class_names = model.names

img_height, img_width = 128, 128


def extract_dominant_color(image, k=3):
    resized_img = cv2.resize(image, (img_height, img_width))
    pixels = resized_img.reshape(-1, 3)
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(pixels)
    dominant_color = kmeans.cluster_centers_[np.argmax(np.bincount(kmeans.labels_))]
    return dominant_color


def detect_light_condition(image):
    img_rgb = image_process(image)
    dominant_color = extract_dominant_color(img_rgb)
    feature = dominant_color.reshape(1, -1)
    prediction = logistic_model.predict(feature)[0]

    class_names = {0: "Normal Light", 1: "low_light"}
    return class_names[prediction]


def image_process(image):
    # Ensure image is already a NumPy array
    img_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    return img_rgb


def enhance_low_light(image):
    lab = cv2.cvtColor(image, cv2.COLOR_BGR2LAB)
    l, a, b = cv2.split(lab)
    clahe = cv2.createCLAHE(clipLimit=3.0, tileGridSize=(8, 8))
    cl = clahe.apply(l)
    enhanced_lab = cv2.merge((cl, a, b))
    return cv2.cvtColor(enhanced_lab, cv2.COLOR_LAB2BGR)


@app.route('/detect', methods=['POST'])
def detect():
    if 'image' not in request.files:
        return jsonify({"error": "No image file provided"}), 400

    image_file = request.files['image']

    try:
        # Read the file content once and store it in memory
        file_content = image_file.read()

        if not file_content:
            return jsonify({"error": "Uploaded image file is empty."}), 400

        # Convert to numpy array for OpenCV
        image_bytes = np.frombuffer(file_content, np.uint8)

        # Decode the image
        img_rgb = cv2.imdecode(image_bytes, cv2.IMREAD_COLOR)
        if img_rgb is None:
            return jsonify({"error": "Invalid or unsupported image format."}), 400

        # Check light condition
        light_condition = detect_light_condition(img_rgb)
        enhanced_image = img_rgb
        detections = []
        object_counts = defaultdict(int)

        if light_condition == "low_light":
            # Enhance image for low light condition
            enhanced_image = enhance_low_light(img_rgb)

        # Run YOLO model
        results = model(enhanced_image)

        # Process detections and count unique class occurrences
        for result in results[0].boxes:
            box = result.xyxy[0].tolist()
            class_id = int(result.cls[0].item())
            confidence = float(result.conf[0].item())
            class_name = class_names.get(class_id, f"Class_{class_id}")
            formatted_class_name = re.sub(r'\D', '', class_name)  # Remove non-numeric characters

            # If class has been detected before, don't count it again
            if formatted_class_name not in object_counts:
                object_counts[formatted_class_name] = 1
            else:
                object_counts[formatted_class_name] += 1

            detections.append({
                "class_name": class_name,
                "object_counts": {formatted_class_name: object_counts[formatted_class_name]},
                "class_id": class_id,
                "confidence": confidence,
                "box": box
            })

        # Return results with final object counts
        final_object_counts = [{"value": key, "count": object_counts[key]} for key in sorted(object_counts.keys())]

        return jsonify({
            "light_condition": light_condition,
            "results": detections,
            "detections": final_object_counts
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
