import firebase_admin
from firebase_admin import credentials, firestore
import json

# Đường dẫn đến file Service Account Key
SERVICE_ACCOUNT_KEY = "lib/scripts/vnu-student-firebase-adminsdk-p65wi-1150272638.json"
SOURCE_DATA = "lib/scripts/home/data.json"

# Khởi tạo Firebase Admin SDK
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
            "details": notification.get("details"),
            "imageUrl": notification.get("imageUrl"),
            "timestamp": firestore.SERVER_TIMESTAMP,
            "department": notification.get("department"),
            "contactEmail": notification.get("contactEmail"),
            "contactPhone": notification.get("contactPhone"),
            "isRead": notification.get("isRead", False),
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
            "details": news_item.get("details"),
            "imageUrl": news_item.get("imageUrl"),
            "timestamp": firestore.SERVER_TIMESTAMP,
            "department": news_item.get("department"),
            "contactEmail": news_item.get("contactEmail"),
            "contactPhone": news_item.get("contactPhone"),
            "isRead": news_item.get("isRead", False),
        })
        print(f"News '{news_item['title']}' added successfully.")

def main():
    # Đọc dữ liệu từ file JSON
    with open(SOURCE_DATA, "r", encoding="utf-8") as file:
        data = json.load(file)

    # Thêm dữ liệu vào Firestore
    if "notifications" in data:
        add_notifications(data["notifications"])

    if "news" in data:
        add_news(data["news"])

if __name__ == "__main__":
    main()
