import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as IMG;
import 'search_contacts.dart';
import 'database/hold-image.dart';
import 'package:image_picker/image_picker.dart';
import 'database/database_manager.dart';
import 'package:flutter/material.dart';
import 'database/Model.dart';
import 'database/utility.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DbManager dbManager = new DbManager();
  Model? model;
  List<Model>? modelList;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController numberTextController = TextEditingController();

String image = "";
  @override
  void initState() {
    super.initState();
  printDatabaseData();
  }
void printDatabaseData() async {
  final data = await dbManager.getAllData();
  data.forEach((item) {
    print('ID: ${item.id}, Name: ${item.personName}, Number: ${item.number}, Photo: ${item.photoName}');
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('contacts buddy'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
                              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchContacts()),
                );
},
          ),
],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return DialogBox().dialog(
                context: context,
                onPressed: () async {
  ImageData imageData = ImageData();
image = imageData.getData();

                  Model model = new Model(
                    personName: nameTextController.text,
                    number: numberTextController.text,
                    photoName: image,

                  );
                  int? id = await dbManager.insertData(model);
                  print("data inserted ${id}");
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    setState(() {
                      nameTextController.text = "";
                      numberTextController.text = "";
                    });
                    Navigator.of(context).pop();
                  });
                },
                textEditingController1: nameTextController,
                textEditingController2: numberTextController,
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.red,
        ),
      ),
  


      body: FutureBuilder(
        future: dbManager.getDataList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            modelList = snapshot.data as List<Model>?;
            return ListView.builder(
              itemCount: modelList?.length,
              itemBuilder: (context, index) {
                Model _model = modelList![index];
                return ItemCard(
                  model: _model,
                  nameTextController: nameTextController,
                  numberTextController: numberTextController,
                  onDeletePress: () {
                    dbManager.deleteData(_model);
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      setState(() {});
                    });
                  },
                  onEditPress: () {
                    nameTextController.text = _model.personName ?? "";
                    numberTextController.text = _model.number ?? "";
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DialogBox().dialog(
                          context: context,
                          onPressed: () {
  ImageData imageData = ImageData();
image = imageData.getData();

                            Model __model = Model(
                              id: _model.id,
                              personName: nameTextController.text,
                              number: numberTextController.text,
                    photoName: image,

                            );
                            dbManager.updateData(__model);
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              setState(() {
                                nameTextController.text = "";
                                numberTextController.text = "";
                              });
                            });
                            Navigator.of(context).pop();
                          },
                          textEditingController2: numberTextController,
                          textEditingController1: nameTextController,
                        );
                      },
                    );
                  },
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class DialogBox {
  Widget dialog({
    BuildContext? context,
    Function? onPressed,
    Function? onSelectImage,
    TextEditingController? textEditingController1,
    TextEditingController? textEditingController2,
  String imgString = "", 
}) {
    return AlertDialog(
      title: Text("Enter person Data"),
      content: Container(
        height: 150,
        child: Column(
          children: [
            TextFormField(
              controller: textEditingController1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: "Enter person name"),
              onFieldSubmitted: (value) {
                //nameTextFocusNode?.unfocus();
                //FocusScope.of(context!).requestFocus(ageTextFocusNode);
              },
            ),
            TextFormField(
              controller: textEditingController2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter number"),
              onFieldSubmitted: (value) {
                //ageTextFocusNode?.unfocus();
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
onPressed: () async {
  // Handle image selection
  final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (imageFile != null) {
    Uint8List bytes = await imageFile.readAsBytes();
    IMG.Image? img = IMG.decodeImage(bytes);
    IMG.Image resized = IMG.copyResize(img!, width: 200, height: 200);
    Uint8List resizedImg = Uint8List.fromList(IMG.encodePng(resized));

    final String imgString = Utility.base64String(resizedImg);

    // Store the base64 string in the database
    ImageData imageData = ImageData();
    imageData.addData(imgString);
  } else {
    print('Image selection canceled.');
  }
},
child: Text("Select Image"),
            ),
          ],
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.of(context!).pop();
          },
          color: Colors.blue,
          child: Text("Cancel"),
        ),
        MaterialButton(
          onPressed: () {
            onPressed!();
          },
          child: Text("Save"),
          color: Colors.blue,
        ),
      ],
    );
  }
}

class ItemCard extends StatefulWidget {
  Model? model;
  TextEditingController? nameTextController;
  TextEditingController? numberTextController;
  Function? onDeletePress;
  Function? onEditPress;

  ItemCard({
    this.model,
    this.nameTextController,
    this.numberTextController,
    this.onDeletePress,
    this.onEditPress,
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final DbManager dbManager = new DbManager();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Display the image if available
              if (widget.model?.photoName != null)
                Container(
                  width: 60,
                  height: 60,
                  child: Image.memory(
                    Utility.dataFromBase64String(widget.model!.photoName!),
                    fit: BoxFit.cover,
                  ),
                ),

              // Display other details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Name: ${widget.model?.personName}',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    'Number: ${widget.model?.number}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () {
                        widget.onEditPress!();
                        if (widget.model?.photoName != null) {
                          print(widget.model!.photoName!);
                        }                     
else {
print('the photo is empty');
}
 },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () {
                        widget.onDeletePress!();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}