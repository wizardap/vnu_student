import firebase_admin
from firebase_admin import credentials, firestore
import json

# Khởi tạo Firebase Admin SDK

SERVICE_ACCOUNT_KEY = "lib/scripts/vnu-student-firebase-adminsdk-p65wi-cd831b7db8.json"
SOURCE_DATA = "lib/scripts/home/data.json"

cred = credentials.Certificate(SERVICE_ACCOUNT_KEY)
firebase_admin.initialize_app(cred)

# Tham chiếu đến Firestore
db = firestore.client()

def add_notifications(data):
    """Thêm thông báo vào collection 'notifications'."""
    for notification in data:
        doc_ref = db.collection('notifications').document()
        doc_ref.set({
            "userId": notification.get("userId"),
            "type": notification.get("type"),
            "title": notification.get("title"),
            "content": notification.get("content"),
            "imageUrl": notification.get("imageUrl"),
            "isRead": notification.get("isRead", False),
            "timestamp": firestore.SERVER_TIMESTAMP
        })
        print(f"Notification '{notification['title']}' added successfully.")

def add_news(data):
    """Thêm tin tức vào collection 'news'."""
    for news_item in data:
        doc_ref = db.collection('news').document()
        doc_ref.set({
            "userId": news_item.get("userId"),
            "title": news_item.get("title"),
            "content": news_item.get("content"),
            "imageUrl": news_item.get("imageUrl"),
            "isRead": news_item.get("isRead", False),
            "timestamp": firestore.SERVER_TIMESTAMP
        })
        print(f"News '{news_item['title']}' added successfully.")

def main():
    # Đọc dữ liệu từ file JSON
    with open(SOURCE_DATA, "r") as file:
        data = json.load(file)

    # Thêm dữ liệu vào Firestore
    if "notifications" in data:
        add_notifications(data["notifications"])

    if "news" in data:
        add_news(data["news"])

if __name__ == "__main__":
    main()
