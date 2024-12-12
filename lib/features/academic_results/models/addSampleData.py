import firebase_admin
from firebase_admin import credentials, firestore
import json

# Chỉ định đường dẫn tệp JSON
SERVICE_ACCOUNT_FILE = "lib/scripts/vnu-student-firebase-adminsdk-p65wi-cd831b7db8.json"

# Khởi tạo Firebase Admin SDK
def initialize_firebase():
    try:
        cred = credentials.Certificate(SERVICE_ACCOUNT_FILE)
        firebase_admin.initialize_app(cred)
        print("Kết nối Firebase thành công!")
    except Exception as e:
        print(f"Lỗi khi kết nối Firebase: {e}")

# Kết nối đến Firestore
def get_firestore_client():
    return firestore.client()

# Thêm dữ liệu vào Firestore
def upload_json_to_firestore(collection_name, document_id, json_file):
    try:
        # Kết nối Firestore
        db = get_firestore_client()

        # Đọc dữ liệu từ file JSON
        with open(json_file, "r", encoding="utf-8") as file:
            data = json.load(file)

        # Tải dữ liệu lên Firestore
        db.collection(collection_name).document(document_id).set(data)
        print(f"Dữ liệu từ {json_file} đã được tải lên Firestore!")
    except Exception as e:
        print(f"Có lỗi xảy ra khi tải lên Firestore: {e}")

# Chạy chương trình
if __name__ == "__main__":
    # Bước 1: Khởi tạo Firebase
    initialize_firebase()


    # Bước 2: Chỉ định tệp JSON chứa dữ liệu cần tải lên
    json_file_path = "lib/features/academic_results/models/data.json"

    # Bước 3: Tải dữ liệu lên Firestore
    upload_json_to_firestore(
        collection_name="academic_results",
        document_id="user_12345",
        json_file=json_file_path,
    )
