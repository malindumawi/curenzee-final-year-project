
💰 CurenZee - Currency Recognition Mobile Application
==================================================

🚀 Project Overview
CurenZee is a mobile-based system designed to assist visually impaired individuals in Sri Lanka by recognizing currency notes and coins in real-time using object detection techniques.

The system uses advanced machine learning and computer vision models to provide accurate currency identification along with audible feedback, enabling users to perform financial transactions independently.

--------------------------------------------------
🎯 Problem Statement
--------------------------------------------------
Visually impaired individuals face significant challenges when identifying Sri Lankan currency, especially in low-light environments and with worn-out notes or coins.

Existing solutions:
- Lack support for both notes and coins
- Perform poorly in low-light conditions
- Do not support real-time multi-denomination detection
- Lack accessibility features

--------------------------------------------------
💡 Proposed Solution
--------------------------------------------------
CurenZee provides a real-time mobile application that:
- Detects multiple currency notes and coins
- Works in different lighting conditions
- Provides audio feedback
- Enhances usability for visually impaired users

--------------------------------------------------
🛠️ Tech Stack
--------------------------------------------------
Frontend:
- Flutter (Android Application)

Backend:
- Flask API

Machine Learning:
- YOLOv8 (Object Detection Model)
- Logistic Regression (Light Condition Classification)
- CLAHE (Low-light Image Enhancement)

Other:
- Firebase (optional integration)
- Python, NumPy, TensorFlow/Keras

--------------------------------------------------
📂 Project Structure
--------------------------------------------------
/CurenZee
│
├── curenzee_application/        -> Flutter mobile application
│   ├── lib/                    -> Main app logic
│   ├── assets/                 -> Images and resources
│   ├── android/ios/web/        -> Platform-specific builds
│   └── pubspec.yaml            -> Dependencies
│
├── currency_detection_backend/ -> Flask backend + ML models
│   ├── app.py                  -> Main API server
│   ├── best.pt                 -> YOLOv8 trained model
│   ├── Low_light_classifier.pkl -> Light condition model
│   ├── requirements.txt        -> Dependencies
│   └── Dockerfile              -> Containerization
│
└── Documentation
    ├── Thesis.pdf
    ├── Presentation.pdf
    └── Demo.mp4

--------------------------------------------------
⚙️ Key Features
--------------------------------------------------
✔ Real-time currency detection  
✔ Supports both notes and coins  
✔ Low-light detection using CLAHE  
✔ Audio feedback for accessibility  
✔ User-friendly mobile interface  
✔ Fast processing (~2 seconds response time)  

--------------------------------------------------
📊 Model Performance
--------------------------------------------------
Object Detection (YOLOv8):
- Precision: 0.871
- Recall: 0.94
- mAP50: 0.966
- mAP50-95: 0.841

Light Classification Model:
- Accuracy: 0.99
- Precision: 0.995
- Recall: 0.995

(System performance validated through testing) fileciteturn4file0

--------------------------------------------------
🧪 Testing
--------------------------------------------------
- Functional testing
- Integration testing
- Performance testing
- Usability testing
- Edge case testing

--------------------------------------------------
📊 Outcomes
--------------------------------------------------
- Accurate real-time currency detection
- Works under varying environmental conditions
- Improves independence of visually impaired users
- Demonstrates practical AI-based assistive technology

--------------------------------------------------
🔮 Future Enhancements
--------------------------------------------------
- Multi-language audio support
- Offline mode optimization
- Cloud-based model improvements
- Enhanced UI/UX for accessibility
- Integration with wearable devices

--------------------------------------------------
⚠️ Disclaimer
--------------------------------------------------
This project was developed for academic purposes and research.

--------------------------------------------------
👤 Author
--------------------------------------------------
Malindu Wijayarathna
BEng(Hons) in Software Engineering

--------------------------------------------------
📄 License
--------------------------------------------------
This project is for academic and educational purposes only.

==================================================

