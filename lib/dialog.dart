import 'package:flutter/material.dart';
import './strings.dart' as str;

class FormData {
  final String title;
  final TextFormField input;

  const FormData({@required this.title, @required this.input});
}

class SimpleInputDialog extends StatelessWidget {
  final String title;
  final List<FormData> forms;
  final _formKey = GlobalKey<FormState>();

  SimpleInputDialog({
    Key key,
    @required this.title,
    @required this.forms,
  }) : super(key: key);

  static Future<bool> asDialog({
    @required BuildContext context,
    @required String title,
    @required List<FormData> forms,
  }) =>
      showDialog<bool>(
        context: context,
        builder: (context) => SimpleInputDialog(
          title: title,
          forms: forms,
        ),
      );

  void onSubmit(BuildContext context) async {
    final state = _formKey.currentState;
    if (!state.validate()) {
      return;
    }
    state.save();
    Navigator.of(context).pop(true);
  }

  void onCancel(BuildContext context) {
    Navigator.of(context).pop(false);
  }

  Widget _bottom(BuildContext ctx) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: () => onSubmit(ctx),
              child: Text(str.saveButton),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () => onCancel(ctx),
              child: Text(str.cancelButton),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
          ),
        ],
      );

  Form get _form => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: forms
              .map(
                (f) => Row(
                  children: [
                    Expanded(
                      child: Center(child: Text(f.title)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: f.input,
                    ),
                  ],
                ),
              )
              .toList(growable: false),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              _form,
              SizedBox(
                height: 30,
              ),
              _bottom(context),
            ],
          ),
        ),
      ),
    );
  }
}
