import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:this_is_tayrd/controllers/get_name_customer_by.dart';
import 'package:this_is_tayrd/helper/api_my.dart';

part 'take_reading_state.dart';

class TakeReadingCubit extends Cubit<TakeReadingState> {
  TakeReadingCubit() : super(TakeReadingInitial());

  
   String ?qrCode;
  
  void takeQrcode({required String result})
{
  qrCode=result;

  emit(TakeReadingAfterQrcode(reslut: result));
}


void checkElectricity({required String electricityMetersID})
async{
 emit(TakeReadingLoadin());
   
   bool checkInternt= await Api().checkInternet();
   if(checkInternt)
   {

      getElectriciyData(electricityMetersID: electricityMetersID);
   }
   else
   {
    emit(TakeReadingNoInternt());
   }
}

void getElectriciyData({required String electricityMetersID})
async{
 
  
    
   try{
    dynamic data = await ClsGetnameByElectri().getnameCustomer(electricityMetersID: electricityMetersID);


    
     if(data['DataFound']==0)
    {
      emit(TakeReadingNoDataFound());
    }
    else if(data['DataFound']==1)
    {
      emit(TakeReadingNoPermission());
    }
      else if(data['DataFound']==2)
    {
      emit(TakeReadingHasBeenRead());
    }
       else if(data['DataFound']==3)
    {
      
      emit(TakeReadingSuccessfully(customerName: data['CustomerName'],currentReading:(data['CurrentReading']) ));
    }
   }catch(e){
    emit(TakeReadingerror(erroMessage: e.toString()));
   }
}

}
