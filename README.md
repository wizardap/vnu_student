# vnu_student

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

#Source code sau khi đã chỉnh sửa: [https://code.visualstudio.com]
#Các mô tả về cài đặt:
##Cài đặt Flutter SDK 
1.1 Tải Flutter SDK tại link [https://docs.flutter.dev/release/archive]
1.2 Cập nhật PATH
Cài đặt command line tools của Android Studio
2.1 Tải command line tools của Android Studio tại link [https://www.google.com/url?q=https://developer.android.com/studio&sa=D&source=docs&ust=1732120529994525&usg=AOvVaw20-FQVchEwcKDCo4LSdq2B]
2.2 Đặt thư mục đúng cấu trúc
Nếu trong thư mục cmdline-tools không có thư mục latest, thì tạo thư mục latest, và di chuyển hết tất cả thư mục trong cmdline-tools vào latest
	2.3 Cập nhật PATH cho cmdline-tools
	2.3 Chạy lệnh trên terminal để chấp nhận các điều khoản 
sdkmanager --licenses
	2.4 Cài đặt các thành phần cần thiết 
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
	2.5 Kiểm tra cài đặt với flutter, nếu có lỗi flutter sẽ hướng dẫn khắc phục
flutter doctor


Cài đặt giả lập (trên terminal)
3.1 Cài đặt AVD
sdkmanager "system-images;android-33;google_apis;x86_64"
	3.2 Tạo thiết bị giả lập
sdkmanager "system-images;android-33;google_apis;x86_64"
	Chú ý: Bạn có thể thiết lập thông số khác để phù hợp với giả lập bạn muốn
Cài đặt Visual Studio Code (Vscode)
4.1 Tải vscode tại link [https://code.visualstudio.com]
4.2 Tải extension Flutter
Tạo thư mục project Flutter 
5.1 Mở Pallete trên vscode (chọn Flutter: New Project)
5.2 Khởi động giả lập (chọn Flutter: Launch emulator)
Chọn giả lập bạn muốn
	5.3 Mở terminal tại project và chạy lệnh
Flutter run

