import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();

  String _barcodeData = "1234567890";
  int _selectedBarcodeIndex=0;
  final List<BarcodeOption> _barcodeTypes=[
    BarcodeOption("Code128",Barcode.code128()),
    BarcodeOption("Code39",Barcode.code39()),
    BarcodeOption("Code93",Barcode.code93()),
    BarcodeOption("EAN13",Barcode.ean13()),
    BarcodeOption("EAN8",Barcode.ean8()),
    BarcodeOption("UPC-E",Barcode.itf()),
    BarcodeOption("QR Code",Barcode.qrCode()),
    BarcodeOption("Data Matrix",Barcode.dataMatrix()),
    BarcodeOption("PDF417",Barcode.pdf417()),
  ];

  Barcode get _selectedBarcodeType =>
      _barcodeTypes[_selectedBarcodeIndex].barcode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController.text = _barcodeData;
  }

  void _generateBarcode(){
    setState(() {
      _barcodeData = _textController.text.isEmpty
      ? "1234567890"
      :_textController.text;
    });
  }

  void _copyToClipboard(){
    Clipboard.setData(ClipboardData(text: _barcodeData));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("BarCode Copied to clipboard"),
      ),
    );
  }

  Widget _buildBarcodeWidget(){
    try{
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0,3),
            )
          ]
        ),
        child: BarcodeWidget(
            data: _barcodeData,
            barcode: _selectedBarcodeType,
            width: 320,
            height: 170,
            style: TextStyle(fontSize: 12),
            errorBuilder: (context,error){
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.redAccent,
                      size: 48,
                    ),
                    SizedBox(height: 9),
                    Text("Invalid data for selected Barcode Type",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4,),
                    Text(error.toString(),
                      style: TextStyle( color: Colors.redAccent.shade700,fontSize: 12),
                      textAlign: TextAlign.center,
                    )],
                ),
              );
            },
        ),
      );
    }
    catch(e){
      return Container();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcode Generator"),
        elevation: 0,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Container(
        height:double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.blue.shade50,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white,
                elevation: 4,
                child: Padding(padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Enter Product Data:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),),
                        SizedBox(height: 16,),
                        TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText: "Barcode Data",
                            hintText: "Enter Product Data,SKU or Code",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefix: Icon(Icons.qr_code),
                            suffixIcon: IconButton(onPressed: (){
                              setState(() {
                                _textController.clear();
                              });
                            }, icon: Icon(Icons.clear),

                            ),

                          ),
                          onChanged: (value)=> _generateBarcode(),
                          ),
                        SizedBox(height: 16),
                        Text(
                          "Barcode Type",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  isExpanded: true,
                                  value: _selectedBarcodeIndex,
                                  icon: Icon(Icons.arrow_drop_down),
                                  items: _barcodeTypes.asMap().entries.map((entry){
                                    return DropdownMenuItem<int>(
                                        value:entry.key,
                                        child: Text(entry.value.name),
                                    );
                                  }).toList(),
                                  onChanged:(int? newValue){
                                    if(newValue!=null){
                                      setState(() {
                                        _selectedBarcodeIndex=newValue;
                                      });
                                    }
                                  }
                              )
                          ),
                        ),
                      ],

                    )),

              ),
              SizedBox(height: 24),
              Card(
                color: Colors.white,
                elevation: 4,
                child: Padding(padding: EdgeInsets.all(16),
                child:
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Generated Bar Code",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),),
                          IconButton(onPressed: _copyToClipboard, icon: Icon(Icons.copy),),
                        ],),
                      SizedBox(height: 16),
                      _buildBarcodeWidget(),
                      SizedBox(height:16),
                    ],
                  ),),
              )
            ]

          ),
        ),
    ));
  }
}
class BarcodeOption{
  final String name;
  final Barcode barcode;
  BarcodeOption(this.name,this.barcode);
}