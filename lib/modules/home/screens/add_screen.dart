import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' as fp;
import 'package:task_crud/modules/home/bloc/crud_bloc.dart';
import 'package:task_crud/modules/home/model/crud_model.dart';

@RoutePage()
class AddScreen extends StatefulWidget implements AutoRouteWrapper {
  const AddScreen({super.key, required this.crudBloc, this.crudModelEdit});

  final CrudBloc crudBloc;
  final CrudModel? crudModelEdit;

  @override
  State<AddScreen> createState() => _AddScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider.value(
      value: crudBloc,
      child: this,
    );
  }
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController txtTitle = TextEditingController();
  TextEditingController txtDesc = TextEditingController();
  GlobalKey<FormState> formAddKey = GlobalKey<FormState>();
  CrudModel crudModel = const CrudModel();
  Random random = Random();

  bool isFav = false;

  @override
  void initState() {
    super.initState();
    if (widget.crudModelEdit != null) {
      crudModel = widget.crudModelEdit ?? const CrudModel();
      txtTitle.text = widget.crudModelEdit?.title ?? '';
      txtDesc.text = widget.crudModelEdit?.description ?? '';
      isFav = widget.crudModelEdit?.fav ?? false;
    }
  }

  @override
  void dispose() {
    txtTitle.dispose();
    txtDesc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = context.router;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title: widget.crudModelEdit != null ? const Text('Edit Data') : const Text('Add Data'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formAddKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Title",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
                TextFormField(
                  validator: (value) {
                    if (txtTitle.text.isEmpty) {
                      return "Please fill this field.";
                    } else {
                      return null;
                    }
                  },
                  controller: txtTitle,
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 18.0),
                  child: Text(
                    "Description",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (txtDesc.text.isEmpty) {
                      return "Please fill this field.";
                    } else {
                      return null;
                    }
                  },
                  maxLines: 10,
                  controller: txtDesc,
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 18.0),
                  child: Text(
                    'Favourite',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        
                  ),
                ),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Switch(
                      value: isFav,
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        isFav = !isFav;
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          widget.crudModelEdit != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () {
                      dataDelete(widget.crudModelEdit?.id ?? 0);
                      router.maybePop();
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.delete_forever),
                  ),
                )
              : const SizedBox.shrink(),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              if (formAddKey.currentState?.validate() ?? false) {
                if (widget.crudModelEdit != null) {
                  dataUpdate(crudModel.copyWith(
                    title: txtTitle.text.trim(),
                    description: txtDesc.text.trim(),
                    fav: isFav,
                  ));
                } else {
                  dataAdd(crudModel.copyWith(
                    title: txtTitle.text.trim(),
                    description: txtDesc.text.trim(),
                    fav: isFav,
                    id: random.nextInt(100000),
                  ));
                }
                router.maybePop();
              }
            },
            backgroundColor: Colors.purple.shade200,
            foregroundColor: Colors.white,
            child: const Icon(Icons.save),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  fp.Unit dataUpdate(CrudModel crudModel) {
    HapticFeedback.heavyImpact();
    context.read<CrudBloc>().add(EditEvent(crudModel: crudModel));
    return fp.unit;
  }

  fp.Unit dataAdd(CrudModel crudModel) {
    HapticFeedback.heavyImpact();
    context.read<CrudBloc>().add(AddEvent(crudModel: crudModel));
    return fp.unit;
  }

  fp.Unit dataDelete(int id) {
    HapticFeedback.heavyImpact();
    context.read<CrudBloc>().add(DeleteEvent(id: id));
    return fp.unit;
  }
}
