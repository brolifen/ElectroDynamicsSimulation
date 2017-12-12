import peasy.*; //<>//
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

import java.util.*;


Grid grid;
CurrentElement currentElement1;
CurrentElement currentElement2;
ConfigAdjuster configAdjuster;
TextDisplayer textDisplayer;
PeasyCam camera;

float magnetCurrent = 10.0;
float circuitCurrent = 1.0;
float forceMultiplier = 700.0;
float elementLength = 10;
float circuitWidth = 100;
float circuitHeight = 100; 
float textSize = 10;
float railWidth = 200;
float railHeight = 400;
float magnetLength = 20.0;
float magnetradius = circuitWidth;
int amountOfMagnets = 1;

//defining the colors
color circuitElementColor = color(200, 122, 23);
color tipColor = color(125, 0, 0);
color tailColor = color(0, 0, 255);
color forceLineColor = color(125, 255, 0);
color magnetElementColor = color(255, 0, 0);

void setup () {
  size(1000, 1000, P3D);
  camera = new PeasyCam(this, 500);
  grid = new Grid(100);

  //define the config variables
  configAdjuster = new ConfigAdjuster();
  configAdjuster.setForceMultiplier(forceMultiplier);
  configAdjuster.setElementLength(elementLength);
  configAdjuster.setColors(circuitElementColor, tipColor, tailColor, forceLineColor, magnetElementColor);
  configAdjuster.textSize = textSize;
}

void draw() {
  grid.showBackrgound();
  
  //create the magnets
  Magnet splitMagnet = new SplitCircularMagnet(new PVector(0, 0, 0), magnetradius, magnetCurrent, configAdjuster);
  //Magnet splitMagnet = new CircularMagnet(new PVector(0, 0, 0), magnetradius, magnetCurrent, configAdjuster);
  splitMagnet.showCurrentElements();
  ArrayList<Magnet> magnets = new ArrayList<Magnet>();
  magnets.add(splitMagnet);
  
  //create the movable current segment, calculate the forces on it and show it
  //CurrentSegment dynamiccurrentSegment = new LineSegment(new PVector(mouseX-width/2, 0, 0), new PVector(0, 0, 0), new PVector(circuitWidth*2, 0, 0), magnetCurrent, configAdjuster);
  //CurrentSegment dynamiccurrentSegment = new ArcSegment(new PVector(mouseX-width/2, 0, 0), new PVector(0, 0, 0), 110, 180, circuitCurrent, 90.0, configAdjuster);
  CurrentSegment dynamiccurrentSegment = new CurrentArc(new PVector(0, 0, 0), new PVector(0, 0, 0), 110, 180, circuitCurrent, 90.0, configAdjuster, null);
  dynamiccurrentSegment.calculateForce(magnets);
  dynamiccurrentSegment.showCurrentElements();
  dynamiccurrentSegment.showElementForces();
  
  CurrentSegment dynamiccurrentSegment2 = new CurrentLine(new PVector(0, 0, 0), new PVector(110, 0, 0), new PVector(2*110, 0, 0), circuitCurrent, configAdjuster, null);
  dynamiccurrentSegment2.calculateForce(magnets);
  dynamiccurrentSegment2.showCurrentElements();
  dynamiccurrentSegment2.showElementForces();
  
  CurrentSegment dynamiccurrentSegment3 = new CurrentLine(new PVector(0, 0, 0), new PVector(-2*110, 0, 0), new PVector(-110, 0, 0), circuitCurrent, configAdjuster, null);
  dynamiccurrentSegment3.calculateForce(magnets);
  dynamiccurrentSegment3.showCurrentElements();
  dynamiccurrentSegment3.showElementForces();
  
  CurrentSegment currentGrid = new CurrentGrid(new PVector(mouseX-width/2, mouseY-height/2, 0), 500, 10, "uniform", 0.1, 10.0, new PVector(0,1,0), configAdjuster, null);
  currentGrid.showCurrentElements();

  camera.beginHUD();
  //display the text on the screen
  textDisplayer = new TextDisplayer(new PVector(50, 50), 10.0, configAdjuster);
  textDisplayer.addLine("a/z: increase/decrease force multiplier: "+ configAdjuster.forceMult);
  textDisplayer.addLine("q/s: increase/decrease circuit width: "+circuitWidth);
  textDisplayer.addLine("w/x: increase/decrease circuit height: "+circuitHeight);
  textDisplayer.addLine("e/r: Change force Equation, currently showing: "+ configAdjuster.forceEquation);
  textDisplayer.addLine("d/f: increase/decrease element size: "+ configAdjuster.elementLength);
  textDisplayer.addLine("c/v: increase/decrease the length of the magnet: "+ magnetLength);
  textDisplayer.addLine("t/y: increase/decrease the amount Of Magnets: "+ amountOfMagnets);
  textDisplayer.addLine("space: reverse current direction");
  textDisplayer.addLine("MouseX, MouseY: "+ mouseX + ", " + mouseY);
  textDisplayer.show();
  camera.endHUD(); // always!
}

void keyPressed() {
  if (key == 'a') {
    forceMultiplier = forceMultiplier*2.0;
    configAdjuster.forceMult = forceMultiplier;
  }
  if (key == 'z') {
    forceMultiplier = forceMultiplier/2.0;
    configAdjuster.forceMult = forceMultiplier;
  }
  if (key == 'q') {
    circuitWidth += 50;
  }
  if (key == 's') {
    circuitWidth -= 50;
  }
  if (key == 'w') {
    circuitHeight += 50;
  }
  if (key == 'x') {
    circuitHeight -= 50;
  }
  if (key == 'e') {
    configAdjuster.forceEquation = "Ampere";
  }
  if (key == 'r') {
    configAdjuster.forceEquation = "Distinti";
  }
  if (key == ' ') {
    magnetCurrent *= -1;
  }
  if (key == 'd') {
    configAdjuster.elementLength *= 1.1;
  }
  if (key == 'f') {
    configAdjuster.elementLength /= 1.1;
  }
  if (key == 'c') {
    magnetLength += 10.0;
  }
  if (key == 'v') {
    magnetLength -= 10.0;
  }
  if (key == 't') {
    amountOfMagnets += 1;
  }
  if (key == 'y') {
    amountOfMagnets -= 1;
    if (amountOfMagnets <= 0) {
      amountOfMagnets = 1;
    }
  }
}