import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:this_is_tayrd/Widgets/qr_code_scanner.dart';
import 'package:this_is_tayrd/cubit/home_cubit/home_cubit.dart';
import 'package:this_is_tayrd/cubit/take_reading/take_reading_cubit.dart';

import '../../Widgets/cusotm_text_form_in_tack_new_reanding.dart';
import '../../Widgets/custom_button.dart';
import '../../helper/constans.dart';
import '../../helper/my_snackbar.dart';

//this

class TakeReadingScreen extends StatefulWidget {
  const TakeReadingScreen({
    super.key, this.qrCode,
  });
  final String? qrCode ;

  static String id = 'ReadingScreen';

  @override
  State<TakeReadingScreen> createState() => _TakeReadingScreenState();
}

class _TakeReadingScreenState extends State<TakeReadingScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;
  TextEditingController qrCode = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController reading = TextEditingController();
  @override
  void initState() {
 if (widget.qrCode?.isNotEmpty ?? false)
    {
       qrCode.text=widget.qrCode!;
         name.text=BlocProvider.of<HomeCubit>(context).customers.firstWhere((customer)=>customer.electronicMeterID == int.parse(qrCode.text)).customerName;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TakeReadingCubit, TakeReadingState>(
      listener: (context, state) {
     if(state is TakeReadingAfterQrcode)
     { 
      
      qrCode.text=BlocProvider.of<TakeReadingCubit>(context).qrCode!;
      BlocProvider.of<TakeReadingCubit>(context).checkElectricity(electricityMetersID: qrCode.text);
     
     }
       if (state is TakeReadingNoDataFound)
       {
           Mysnackbar().showSnackbarError(
                  title: "خطاء ",
                  context: context,
                  message: "  خطاء في رقم عداد الكهرباء ",
                  contentType: ContentType.failure);
                  name.clear();
       }
        else if (state is TakeReadingNoPermission)
       {
           Mysnackbar().showSnackbarError(
                  title: " ملاحظة ",
                  context: context,
                  message: "  هذا العداد ليس ضمن منطقتك ",
                  contentType: ContentType.warning);
                   name.clear();
       }

          else if (state is TakeReadingHasBeenRead)
       {
           Mysnackbar().showSnackbarError(
                  title: " ملاحظة ",
                  context: context,
                  message: " لقد تم قراءة هذا العداد مسبقا",
                  contentType: ContentType.warning);
                   name.clear();
                
       }
          else if (state is TakeReadingSuccessfully)
       {
         name.text=state.customerName;
       }
            else if (state is TakeReadingNoInternt)
       {
           Mysnackbar().showSnackbarError(
                  title: " خطاء ",
                  context: context,
                  message:'لا يوجد انترنت يوجاء التاكد من الانترنت',
                  contentType: ContentType.failure);
                   name.clear();
                    
       }
            else if (state is TakeReadingerror)
       {   
           Mysnackbar().showSnackbarError(
                  title: " error ",
                  context: context,
                  message:state.erroMessage,
                  contentType: ContentType.failure);
                   name.clear();
                
       }
        

       
       
      },
     builder: (context, state) {
      return 
       Scaffold(
        appBar: AppBar(
          title: const Text(
            'أخذ قراءة جديدة ⚡',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: kColorPrimer, // تغيير هنا
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: AnimationLimiter(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            Lottie.asset(
                              'asset/animations/electric.json',
                              width: 150,
                              repeat: true,
                            ),
                            const SizedBox(height: 30),
                            Cusotmtextformintacknewreanding(

                              onChanged: (value)
                              {
                                if(value.length==12)
                                {
                                  BlocProvider.of<TakeReadingCubit>(context).checkElectricity(electricityMetersID: qrCode.text);
                                }
                              },
                              isEnable: state is TakeReadingLoadin,
                              maxLength: 12,
                              label: 'رقم العداد',
                              icon: Icons.electric_meter_outlined,
                              text: qrCode,
                              textInputType: TextInputType.number,
                              suffix: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, QrCodeScanner.qrcodeScreenId);
                                },
                                child: const Icon(
                                  Icons.qr_code,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Cusotmtextformintacknewreanding(
                              suffix:  state is TakeReadingLoadin?const SizedBox(
                                height: 10,
                                width: 10,
                                child:  CircularProgressIndicator(color: Colors.white,)):null,
                              label: 'اسم العميل',
                              icon: Icons.person_outline,
                              validator: (v) =>
                                  v!.isEmpty ? ' اسم العميل مطلوب' : null,
                              text: name,
                              isEnable: true,
                            ),
                            const SizedBox(height: 25),
                            Cusotmtextformintacknewreanding(
                              label: 'القراءة الحالية',
                              icon: Icons.speed_outlined,
                              textInputType: TextInputType.number,
                              validator: (v) =>
                                  v!.isEmpty ? 'أدخل القراءة' : null,
                              text: reading,
                              suffix: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, QrCodeScanner.qrcodeScreenId);
    
                                  reading.text =
                                      BlocProvider.of<HomeCubit>(context)
                                              .electronicMeterID ??
                                          '';
                                },
                                child: const Icon(
                                  Icons.photo_camera,
                                  color: Colors.white,
                                ),
                              ),
                              isEnable: true,
                            ),
                            const SizedBox(height: 40),
                            Custombutton(
                              isLoading: _isSending,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isSending = true);
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    setState(() => _isSending = false);
                                  });
                                }
                              },
                              lable: "ارسال القراءة",
                              color: kColorSecond,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }
    );
  }
}
