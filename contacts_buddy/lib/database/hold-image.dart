class ImageData {
  // Private constructor to prevent multiple instances
  ImageData._privateConstructor();

  static final ImageData _instance = ImageData._privateConstructor();

  factory ImageData() {
    return _instance;
  }

  String data = "";

  // Method to add data
  void addData(String newData) {
    data = newData;
    print('brown $data');
  }

  // Method to retrieve data
  String getData() {
    return data;
  }
}
