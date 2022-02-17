import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/social_cubit/social_cubit.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/social_register/social_register_cubit/social_register_cubit.dart';
import 'package:social_app/modules/social_register/social_register_cubit/social_register_states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class SocialRegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  int? value ;

  SocialRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialUserCreateSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              uId = CacheHelper.getData(key: 'uId');
              SocialCubit.get(context).getUserData().then((value) {
                navigateAndEnd(context, const SocialLayout());
              });
            });
          }
        },
        builder: (context, state) {
          var cubit = SocialRegisterCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blue,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register',
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        'All your imaginations is right there. Try it now',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      defaultFormField(
                          label: 'Name',
                          controller: nameController,
                          prefix: Icons.person,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'please enter your name';
                            }
                          },
                          type: TextInputType.name),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                          label: 'Email Address',
                          controller: emailController,
                          prefix: Icons.email_outlined,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'email address must not be empty';
                            }
                          },
                          type: TextInputType.emailAddress),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                          isPassword: cubit.isPassword,
                          label: 'Password',
                          controller: passwordController,
                          prefix: Icons.lock,
                          suffix: cubit.suffix,
                          suffixPressed: () {
                            cubit.changeSuffix();
                          },
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'password must not be empty';
                            }
                          },
                          type: TextInputType.visiblePassword),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                          label: 'Phone',
                          controller: phoneController,
                          prefix: Icons.phone,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'please enter your phone';
                            }
                          },
                          type: TextInputType.phone),
                      const SizedBox(
                        height: 15.0,
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: ListTile(
                      //         title: Text('Male',style: Theme.of(context).textTheme.subtitle2,),
                      //         leading: Radio(
                      //             value: "1",
                      //             groupValue: 'male',
                      //             onChanged: (value) {}),
                      //
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: ListTile(
                      //         title: Text('Male',style: Theme.of(context).textTheme.subtitle2,),
                      //         leading: Radio(
                      //             value: "1",
                      //             groupValue: 1,
                      //             onChanged: (value) {
                      //               value = value;
                      //             }),
                      //
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 15.0,
                      // ),
                      Conditional.single(
                        context: context,
                        fallbackBuilder: (BuildContext context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        conditionBuilder: (BuildContext context) =>
                            state is! SocialRegisterLoadingState,
                        widgetBuilder: (BuildContext context) => SizedBox(
                          height: 50.0,
                          width: double.infinity,
                          child: MaterialButton(
                            color: Colors.blue,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text);
                              }
                            },
                            child: Text(
                              "Register".toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
