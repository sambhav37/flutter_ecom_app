import 'package:flutter/material.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    // TODO: implement dispose
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid =
        _form.currentState.validate(); // this will run all the validators
    if (!isValid) {
      return;
    }
    _form.currentState.save(); // this will run all the onSaved methods
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              textInputAction:
                  TextInputAction.next, // show in soft keyboard what to do
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Please provide a value";
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                  title: value,
                  price: _editedProduct.price,
                  description: _editedProduct.description,
                  imageUrl: _editedProduct.imageUrl,
                  id: null,
                );
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter a price";
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                if (double.parse(value) <= 0) {
                  return 'Please enter a value greater then 0';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                  title: _editedProduct.title,
                  price: double.parse(value),
                  description: _editedProduct.description,
                  imageUrl: _editedProduct.imageUrl,
                  id: null,
                );
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _descriptionFocusNode,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter a description";
                }
                if (value.length < 10) {
                  return 'Should be at least 10 characters in length';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                  title: _editedProduct.title,
                  price: _editedProduct.price,
                  description: value,
                  imageUrl: _editedProduct.imageUrl,
                  id: null,
                );
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(
                    top: 8,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: _imageUrlController.text.isEmpty
                      ? Text('Enter a URL')
                      : FittedBox(
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Image URL'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                    focusNode: _imageUrlFocusNode,
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter an image URL";
                      }
                      if (!value.startsWith('http')) {
                        return 'Please enter a valid url';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        title: _editedProduct.title,
                        price: _editedProduct.price,
                        description: _editedProduct.description,
                        imageUrl: value,
                        id: null,
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
