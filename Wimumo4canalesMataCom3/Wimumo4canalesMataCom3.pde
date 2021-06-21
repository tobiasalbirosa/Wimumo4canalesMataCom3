//<>// //<>// //<>//

import controlP5.*;
import oscP5.*;
import netP5.*;

ControlP5 cp5;
OscP5 oscControl;
NetAddress myRemoteLocation;

int intervalTime = 83;
int prevTime = 0;

String ipInput = "10.0.12.202";
//String ipInput = "127.0.0.1";
int m;
int puertoInput = 12000;

int myColor1 = color(0, 0, 0);
int myColor2 = color(0, 0, 0);
int myColor3 = color(0, 0, 0);
int myColor4 = color(0, 0, 0);

int saturacion1 = 9000;
int saturacion2 = 9000;
int saturacion3 = 9000; 
int saturacion4 = 9000; 


float exp1;
float exp2;
float exp3;
float exp4;


float result1;
float result2;
float result3;
float result4;


float valor1 = .5;
float valor2 = .5;
float valor3 = .5;
float valor4 = .5;


float valor1Real = 0;
float valor2Real = 0;
float valor3Real = 0;
float valor4Real = 0;


String canal1_Input = "''/wimumo001/emg/ch1''";
String canal2_Input = "''/wimumo001/emg/ch2''";
String canal3_Input = "''/wimumo001/emg/ch3''";
String canal4_Input = "''/wimumo001/emg/ch4''";


String canal1_Output = "''1''";
String canal2_Output = "''2''";
String canal3_Output = "''3''";
String canal4_Output = "''4''";

boolean SEND1 = false;
boolean SEND2 = false;
boolean SEND3 = false;
boolean SEND4 = false;


boolean send1 = false;
boolean send2 = false;
boolean send3 = false;
boolean send4 = false;


boolean RECIEVE1 = false;
boolean RECIEVE2 = false;
boolean RECIEVE3 = false;
boolean RECIEVE4 = false;


Chart grafico1;
Chart grafico2;
Chart grafico3;
Chart grafico4;

Table table;
String sessionName;
String messageTime;

void setup() {


  int d = day();    // Values from 1 - 31
  int mo = month();  // Values from 1 - 12
  int y = year();   // 2003, 2004, 2005, etc.
  int s = second();  // Values from 0 - 59
  int m = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23

  sessionName = d+":"+mo+":"+y+"-"+h+":"+m+":"+s;

  table = new Table();
  table.addColumn("hora");
  table.addColumn("v1");
  table.addColumn("v2");
  table.addColumn("v3");
  table.addColumn("v4");

  size(980, 550);
  noStroke();
  frameRate(12);
  cp5 = new ControlP5(this);
  oscControl = new OscP5(this, 12000);
  //Aquí debajo seteamos el IP local(127.0.0.1) o web (192.168.0.244)
  myRemoteLocation = new NetAddress("127.0.0.1", puertoInput);
  ipInput = oscControl.ip();

  background(127);

  // INPUTS OSC CHANNEL

  //1
  cp5.addTextfield("canal1_Input")
    .setPosition(15, 125)
    .setSize(50, 10)
    .setAutoClear(false)
    ; 
  //2  
  cp5.addTextfield("canal2_Input")
    .setPosition(width/2+15, 125)
    .setSize(50, 10)
    .setAutoClear(false)
    ;
  //3
  cp5.addTextfield("canal3_Input")
    .setPosition(15, 330)
    .setSize(50, 10)
    .setAutoClear(false)
    ;
  //4
  cp5.addTextfield("canal4_Input")
    .setPosition(width/2+15, 330)
    .setSize(50, 10)
    .setAutoClear(false)
    ;

  // OUTPUT OSC CHANNEL
  //1
  cp5.addTextfield("canal1_Output")
    .setPosition(350, 118)
    .setSize(50, 10)
    .setAutoClear(false)
    ;
  //2
  cp5.addTextfield("canal2_Output")
    .setPosition(width/2+330, 125)
    .setSize(50, 10)
    .setAutoClear(false)
    ;
  //3
  cp5.addTextfield("canal3_Output")
    .setPosition(350, 330)
    .setSize(50, 10)
    .setAutoClear(false)
    ;
  //4
  cp5.addTextfield("canal4_Output")
    .setPosition(width/2+330, 330)
    .setSize(50, 10)
    .setAutoClear(false)
    ;


  // SATURACION
  //1
  cp5.addSlider("saturacion1")
    .setPosition(330, 270)
    .setRange(-9, saturacion1)
    ;
  //2
  cp5.addSlider("saturacion2")
    .setPosition(820, 270)
    .setRange(-9, saturacion2)
    ;
  //3
  cp5.addSlider("saturacion3")
    .setPosition(330, 270+205)
    .setRange(-9, saturacion3)
    ;
  //4
  cp5.addSlider("saturacion4")
    .setPosition(width/2+330, 350+120)
    .setRange(-9, saturacion4)
    ;

  // GRAFICO DE ENTRADA

  //1
  grafico1 = cp5.addChart("grafico1")
    .setPosition(15, 160)
    .setSize(465, 80)
    .setRange(-1, 1)
    .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
    .setStrokeWeight(3)
    .setColorCaptionLabel(color(216, 163, 252))
    ; 
  grafico1.addDataSet("saturacion1");
  grafico1.setData("saturacion1", new float[360]);

  //2
  grafico2 = cp5.addChart("grafico2")
    .setPosition(width/2+15, 160)
    .setSize(465, 80)
    .setRange(-1, 1)
    .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
    .setStrokeWeight(1.5)
    .setColorCaptionLabel(color(255, 247, 0));
  grafico2.addDataSet("saturacion2");
  grafico2.setData("saturacion2", new float[360]);

  //3
  grafico3 = cp5.addChart("grafico3")
    .setPosition(15, 250+120)
    .setSize(465, 80)
    .setRange(-1, 1)
    .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
    .setStrokeWeight(1.5)
    .setColorCaptionLabel(color(255, 55, 100));
  grafico3.addDataSet("saturacion3");
  grafico3.setData("saturacion3", new float[360]); 

  //4
  grafico4 = cp5.addChart("grafico4")
    .setPosition(width/2+15, 250+120)
    .setSize(465, 80)  
    .setRange(-1, 1)
    .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
    .setStrokeWeight(1.5)
    .setColorCaptionLabel(color(255, 142, 3));
  grafico4.addDataSet("saturacion4");
  grafico4.setData("saturacion4", new float[360]);


  //RECIEVES
  //1
  cp5.addToggle("RECIEVE1")
    .setPosition(110, 118)
    .setSize(50, 20)
    ;
  //2
  cp5.addToggle("RECIEVE2")
    .setPosition(610, 115)
    .setSize(50, 20)
    ;
  //3
  cp5.addToggle("RECIEVE3")
    .setPosition(110, 330)
    .setSize(50, 20)
    ;
  //4  
  cp5.addToggle("RECIEVE4")
    .setPosition(610, 330)
    .setSize(50, 20)
    ;

  // SWITCH DE ENVIO DE DATOS
  //1
  cp5.addToggle("SEND1")
    .setPosition(430, 118)
    .setSize(50, 20)
    ;
  //2
  cp5.addToggle("SEND2")
    .setPosition(width/2+410, 115)
    .setSize(50, 20)
    ;
  //3
  cp5.addToggle("SEND3")
    .setPosition(430, 200+130)
    .setSize(50, 20)
    ;
  //4
  cp5.addToggle("SEND4")
    .setPosition(width/2+410, 330)
    .setSize(50, 20)
    ;
  noStroke();
}


void draw() {
  background(255);
  m = millis()/1000;
  //PANEL DE ESTADO
  println("frameCount on draw: "+frameCount);
  println("seconds on draw: "+m);
  pushMatrix();
  fill(255);
  stroke(255);
  rect(0, 0, width, 100);
  fill(0);
  text("Frame rate: " + int(frameRate), 10, 20);
  text("IP:" + ipInput, 10, 40);
  text("Recibiendo de" + " " + myRemoteLocation, 10, 60); 
  text("Investigación FASCIA", 10, 80);
  popMatrix();

  // MODULOS OSC

  //1
  pushMatrix();
  fill(0);
  stroke(255);
  rect(0, 100, width/2, 200);
  fill(216, 163, 252);
  text(canal1_Input, 10, 115);
  text(canal1_Output, 260, 115);
  fill(0, 255, 0);


  grafico1.push("saturacion1", valor1);

  text("Receiving:", 50, 278);
  text(valor1Real, 50, 292);

  if (valor1 >= 0.1) {
    fill(0, 255, 0, 255);
    rect(15, 270, 20, 20);
  }  
  popMatrix();

  //2
  pushMatrix();
  fill(0);
  stroke(255);
  rect(width/2, 100, width/2, 200);
  fill(255, 247, 0);
  text(canal2_Input, width/2+10, 115);
  text(canal2_Output, width/2+260, 115);
  fill(0, 255, 0);


  grafico2.push("saturacion2", valor2);

  text("Receiving:", width/2+50, 275);
  text(valor2Real, width/2+50, 289);
  if (valor2 >= 0.1) {

    fill(0, 255, 0, 255);
    rect(width/2+15, 268, 20, 20);
  }  
  popMatrix();

  //3
  pushMatrix();
  fill(0);
  rect(0, 100+200, width/2, 200);
  fill(255, 55, 100);
  text(canal3_Input, 10, 200+120);
  text(canal3_Output, 260, 200+120);
  fill(0, 255, 0);

  grafico3.push("saturacion3", valor3);

  text("Receiving:", 50, 478);
  text(valor3Real, 50, 490);
  if (valor3 >= 0.1) {
    fill(0, 255, 0, 255);
    rect(15, 310+160, 20, 20);
  }  
  popMatrix();

  //4
  pushMatrix();
  fill(0);
  rect(width/2, 100+200, width/2, 200);
  fill(255, 142, 3);
  text(canal4_Input, width/2+10, 318);
  text(canal4_Output, width/2+260, 318);
  fill(0, 255, 0);  
  grafico4.push("saturacion4", valor4);
  text("Receiving:", width/2+50, 238+238);
  text(valor4Real, width/2+50, 245+245);
  if (valor4 >= 0.1) {
    fill(0, 255, 0, 255);
    rect(width/2+15, 235+235, 20, 20);
  }
  popMatrix();
  pushMatrix();
  fill(0, 0, 200);
  rect(0, height-40, width, 40);
  fill(200);
  text("Grabar sesión:", width/2, height-20);
  popMatrix();
  //save(an_array_of_strings, "filename", "xml");
}


void oscEvent(OscMessage theOscMessage) {
  int d = day();    // Values from 1 - 31
  int mo = month();  // Values from 1 - 12
  int y = year();   // 2003, 2004, 2005, etc.
  int s = second();  // Values from 0 - 59
  int m = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23

  messageTime = d+":"+mo+":"+y+"/"+h+":"+m+":"+s;

  if (millis() > prevTime + intervalTime)
  {
    //send the OSC message
    prevTime = millis();


    println("-----> frameCount on OscMessage: "+frameCount);
    println("-----> secods on OscMessage: "+m);
    //1 
    if (theOscMessage.checkAddrPattern(canal1_Input) == true && RECIEVE1 == true) {
      m = millis()/1000;

      println("-> frameCount on OscMessage n1: "+frameCount);
      println("-> millis on OscMessage n1: "+m);
      //  println(theOscMessage.get(1).floatValue());

      valor1 = theOscMessage.get(0).floatValue();
      valor1Real = valor1;
      result1 = saturacion1;
      if (valor1>result1) {
        valor1 = result1;
      }
      valor1 = valor1/result1;
      if (SEND1 == true) {
        println(theOscMessage.get(0).floatValue());

        OscMessage mensaje1 = new OscMessage(canal1_Output);
        mensaje1.add(valor1);
        oscControl.send(mensaje1, myRemoteLocation);
      }
    }
    //2
    if (theOscMessage.checkAddrPattern(canal2_Input)== true  && RECIEVE2 == true) {
      valor2 = theOscMessage.get(1).floatValue();
      valor2Real = valor2;
      /*
    exp2 = float(saturacion2)/18.864;
       result2 = pow(10, exp2);
       */
      result2 = saturacion2;
      if (valor2>result2) {
        valor2 = result2;
      }
      valor2 = valor2/result2;
      if (SEND2 == true) {
        OscMessage mensaje2 = new OscMessage(canal2_Output);
        mensaje2.add(valor2); 
        oscControl.send(mensaje2, myRemoteLocation);
      }
    }

    //3
    if (theOscMessage.checkAddrPattern(canal3_Input)== true  && RECIEVE3 == true) {
      valor3 = theOscMessage.get(2).floatValue();
      valor3Real = valor3;
      result3 = saturacion3;
      if (valor3>result3) {
        valor3 = result3;
      }

      valor3 = valor3/result3;
      if (SEND3 == true) {
        OscMessage mensaje3 = new OscMessage(canal3_Output);
        mensaje3.add(valor3); 
        oscControl.send(mensaje3, myRemoteLocation);
      }
    }
    //4
    if (theOscMessage.checkAddrPattern(canal4_Input)== true  && RECIEVE4 == true) {
      valor4 = theOscMessage.get(3).floatValue();
      valor4Real = valor4;
      result4 = saturacion4;
      if (valor4>result4) {
        valor4 = result4;
      }
      valor4 = valor4/result4;
      if (SEND4 == true) {
        OscMessage mensaje4 = new OscMessage(canal4_Output);
        mensaje4.add(valor4); 
        oscControl.send(mensaje4, myRemoteLocation);
      }
    }
  }
  guardarData();
}
void guardarData() {
  TableRow newRow = table.addRow();
  newRow.setString("hora", messageTime);
  newRow.setFloat("v1", valor1Real);
  newRow.setFloat("v2", valor2Real);
  newRow.setFloat("v3", valor3Real);
  newRow.setFloat("v4", valor4Real);
  saveTable(table, "data/sesiones/"+sessionName+".csv");
}
void mouseMoved() {
}
void mousePressed() {
  if (SEND1 == false) {
    OscMessage mensaje1 = new OscMessage(canal1_Output);
    mensaje1.add(valor1*0); 
    oscControl.send(mensaje1, myRemoteLocation);
  }
  if (SEND2 == false) {
    OscMessage mensaje2 = new OscMessage(canal2_Output);
    mensaje2.add(valor2*0); 
    oscControl.send(mensaje2, myRemoteLocation);
  }
  if (SEND3 == false) {
    OscMessage mensaje3 = new OscMessage(canal3_Output);
    mensaje3.add(valor3*0); 
    oscControl.send(mensaje3, myRemoteLocation);
  }
  if (SEND4 == false) {
    OscMessage mensaje4 = new OscMessage(canal4_Output);
    mensaje4.add(valor4*0); 
    oscControl.send(mensaje4, myRemoteLocation);
  }
}
