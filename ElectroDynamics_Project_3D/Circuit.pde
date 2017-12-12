public interface Magnet {
  void show();
  void showElementForces();
  void updateScreenPosition(PVector newPosition);
  void updateCurrentSegments();
  ArrayList<CurrentSegment> getCurrentSegments();
  void showTotalForce();
  void showCurrentElements();
  PVector getTotalForce();
}


public class RectangularMagnet implements Magnet {
  ArrayList<CurrentSegment> currentSegments;
  PVector position;
  PVector totalforce;
  float circuitWidth;
  float circuitHeight;
  float forceMultiplier;
  float current;


  RectangularMagnet(PVector position, float circuitWidth, float circuitHeight, float current, ConfigAdjuster configAdjuster) {
    this.position = position;
    this.circuitWidth = circuitWidth;
    this.circuitHeight = circuitHeight;
    this.forceMultiplier = configAdjuster.forceMult;
    this.current = current;

    createCurrentSegments(position);
  }

  void createCurrentSegments(PVector position) {
    this.totalforce = new PVector(0, 0, 0);
    this.currentSegments = new ArrayList<CurrentSegment>();

    CurrentSegment currentSegment1 = new CurrentLine(position, new PVector(-circuitWidth/2, circuitHeight/2, 0), new PVector(circuitWidth/2, circuitHeight/2, 0), this.current, configAdjuster, this);
    CurrentSegment currentSegment2 = new CurrentLine(position, new PVector(circuitWidth/2, circuitHeight/2, 0), new PVector(circuitWidth/2, -circuitHeight/2, 0), this.current, configAdjuster, this);
    CurrentSegment currentSegment3 = new CurrentLine(position, new PVector(circuitWidth/2, -circuitHeight/2, 0), new PVector(-circuitWidth/2, -circuitHeight/2, 0), this.current, configAdjuster, this);
    CurrentSegment currentSegment4 = new CurrentLine(position, new PVector(-circuitWidth/2, -circuitHeight/2, 0), new PVector(-circuitWidth/2, circuitHeight/2, 0), this.current, configAdjuster, this);


    addCurrentSegment(currentSegment1);
    //addCurrentSegment(currentSegment2);
    //addCurrentSegment(currentSegment3);
    //addCurrentSegment(currentSegment4);
  }

  void show() {
    for (CurrentSegment currentSegment : this.currentSegments) {
      currentSegment.show();
    }
  }

  void showCurrentElements() {
    for (CurrentSegment currentSegment : this.currentSegments) {
      currentSegment.showCurrentElements();
    }
  }

  void showTotalForce() {
    PVector startSegment = this.position.copy();
    PVector endSegment = PVector.add(this.totalforce.copy(), this.position).copy();

    startSegment = toScreenCoords(startSegment);
    endSegment = toScreenCoords(endSegment);

    //draw the line
    strokeWeight(2);
    stroke(configAdjuster.forceLineColor);
    line(startSegment.x, startSegment.y, endSegment.x, endSegment.y);

    //draw the point
    strokeWeight(5);
    stroke(configAdjuster.forceLineColor);
    point(endSegment.x, endSegment.y);
  }

  void showElementForces() {
    for (CurrentSegment currentSegment : this.currentSegments) {
      currentSegment.showElementForces();
    }
  }

  void addCurrentSegment(CurrentSegment currentSegment) {
    currentSegments.add(currentSegment);
  }

  void updateScreenPosition(PVector newPosition) {
    //this.position = toWorldCoords(newPosition);
    this.position = newPosition;
    createCurrentSegments(this.position);
  }

  PVector toWorldCoords (PVector coords) {
    //coords.y *= -1.0;
    coords.add(-width/2, -height/2, 0.0);
    return coords;
  }

  void updateCurrentSegments () {
    for (CurrentSegment currentSegment : this.currentSegments) {
      currentSegment.showElementForces();
    }
  }

  ArrayList<CurrentSegment> getCurrentSegments() {
    return this.currentSegments;
  }

  void calculateTotalForce() {
    for (CurrentSegment currentSegmentOfCircuit : this.currentSegments) {
      for (CurrentElement currentElement : currentSegmentOfCircuit.getCurrentElements()) {
        this.totalforce.add(currentElement.Force);
      }
    }
  }

  PVector toScreenCoords (PVector coords) {
    //coords.y *= -1.0;
    //coords.add(width/2, height/2);
    return coords;
  }

  PVector getTotalForce() {
    return this.totalforce;
  }
}

public class SplitCircularMagnet implements Magnet {
  ArrayList<CurrentSegment> currentSegments;
  PVector position;
  PVector totalforce;
  float radius;
  float forceMultiplier;
  float current;


  SplitCircularMagnet(PVector position, float radius, float current, ConfigAdjuster configAdjuster) {
    this.position = position;
    this.radius = radius;
    this.forceMultiplier = configAdjuster.forceMult;
    this.current = current;

    createCurrentSegments(position);
  }

  void createCurrentSegments(PVector translationVector) {
    this.totalforce = new PVector(0, 0, 0);
    this.currentSegments = new ArrayList<CurrentSegment>();

    CurrentSegment magnetSegmennt1 = new CurrentArc(translationVector, new PVector(0, 0, 0), this.radius, 180, current, 0,configAdjuster, this);
    CurrentSegment magnetSegmennt2 = new CurrentArc(translationVector, new PVector(0, 0, 0), this.radius, -180, -current, 0,configAdjuster, this);
    CurrentSegment magnetSegmennt3 = new CurrentLine(translationVector, new PVector(0, -magnetradius, 0), new PVector(0, magnetradius, 0), -current, configAdjuster, this);
    CurrentSegment magnetSegmennt4 = new CurrentLine(translationVector, new PVector(0, -magnetradius, 0), new PVector(0, magnetradius, 0), -current, configAdjuster, this);
    currentSegments.add(magnetSegmennt1);
    currentSegments.add(magnetSegmennt2);
    currentSegments.add(magnetSegmennt3);
    currentSegments.add(magnetSegmennt4);
  }

  void show() {
    for (CurrentSegment currentSegment : this.currentSegments) {
      currentSegment.show();
    }
  }

  void showCurrentElements() {
    for (CurrentSegment currentSegment : this.currentSegments) {
      currentSegment.showCurrentElements();
    }
  }

  void showTotalForce() {
    PVector startSegment = this.position.copy();
    PVector endSegment = PVector.add(this.totalforce.copy(), this.position).copy();

    startSegment = toScreenCoords(startSegment);
    endSegment = toScreenCoords(endSegment);

    //draw the line
    strokeWeight(2);
    stroke(configAdjuster.forceLineColor);
    line(startSegment.x, startSegment.y, endSegment.x, endSegment.y);

    //draw the point
    strokeWeight(5);
    stroke(configAdjuster.forceLineColor);
    point(endSegment.x, endSegment.y);
  }

  void showElementForces() {
    for (CurrentSegment currentSegment : this.currentSegments) {
      currentSegment.showElementForces();
    }
    CurrentSegment testcurrentSegment = this.currentSegments.get(0);
    CurrentElement testcurrentElement =  testcurrentSegment.getCurrentElements().get(0);
  }

  void addCurrentSegment(CurrentSegment currentSegment) {
    currentSegments.add(currentSegment);
  }

  void updateScreenPosition(PVector newPosition) {
    //this.position = toWorldCoords(newPosition);
    this.position = newPosition;
    createCurrentSegments(this.position);
  }

  PVector toWorldCoords (PVector coords) {
    //coords.y *= -1.0;
    coords.add(-width/2, -height/2, 0.0);
    return coords;
  }

  void updateCurrentSegments () {
    for (CurrentSegment currentSegment : this.currentSegments) {
      currentSegment.showElementForces();
    }
  }

  ArrayList<CurrentSegment> getCurrentSegments() {
    return this.currentSegments;
  }

  void calculateTotalForce() {
    for (CurrentSegment currentSegmentOfCircuit : this.currentSegments) {
      for (CurrentElement currentElement : currentSegmentOfCircuit.getCurrentElements()) {
        this.totalforce.add(currentElement.Force);
      }
    }
  }

  PVector toScreenCoords (PVector coords) {
    //coords.y *= -1.0;
    //coords.add(width/2, height/2);
    return coords;
  }

  PVector getTotalForce() {
    return this.totalforce;
  }
}

public class CircularMagnet implements Magnet {
  ArrayList<CurrentSegment> currentSegments;
  PVector position;
  PVector totalforce;
  float radius;
  float forceMultiplier;
  float current;


  CircularMagnet(PVector position, float radius, float current, ConfigAdjuster configAdjuster) {
    this.position = position;
    this.radius = radius;
    this.forceMultiplier = configAdjuster.forceMult;
    this.current = current;

    createCurrentSegments(position);
  }

  void createCurrentSegments(PVector translationVector) {
    this.totalforce = new PVector(0, 0, 0);
    this.currentSegments = new ArrayList<CurrentSegment>();

    CurrentSegment magnetSegmennt1 = new CurrentArc(translationVector, new PVector(0, 0, 0), this.radius, 360, current, 0, configAdjuster, this);

    currentSegments.add(magnetSegmennt1);
  }

  void show() {
    for (CurrentSegment currentSegment : this.currentSegments) {
      currentSegment.show();
    }
  }

  void showCurrentElements() {
    for (CurrentSegment currentSegment : this.currentSegments) {
      currentSegment.showCurrentElements();
    }
  }

  void showTotalForce() {
    PVector startSegment = this.position.copy();
    PVector endSegment = PVector.add(this.totalforce.copy(), this.position).copy();

    startSegment = toScreenCoords(startSegment);
    endSegment = toScreenCoords(endSegment);

    //draw the line
    strokeWeight(2);
    stroke(configAdjuster.forceLineColor);
    line(startSegment.x, startSegment.y, endSegment.x, endSegment.y);

    //draw the point
    strokeWeight(5);
    stroke(configAdjuster.forceLineColor);
    point(endSegment.x, endSegment.y);
  }

  void showElementForces() {
    for (CurrentSegment currentSegment : this.currentSegments) {
      currentSegment.showElementForces();
    }
    CurrentSegment testcurrentSegment = this.currentSegments.get(0);
    CurrentElement testcurrentElement =  testcurrentSegment.getCurrentElements().get(0);
  }

  void addCurrentSegment(CurrentSegment currentSegment) {
    currentSegments.add(currentSegment);
  }

  void updateScreenPosition(PVector newPosition) {
    //this.position = toWorldCoords(newPosition);
    this.position = newPosition;
    createCurrentSegments(this.position);
  }

  PVector toWorldCoords (PVector coords) {
    //coords.y *= -1.0;
    coords.add(-width/2, -height/2, 0.0);
    return coords;
  }

  void updateCurrentSegments () {
    for (CurrentSegment currentSegment : this.currentSegments) {
      currentSegment.showElementForces();
    }
  }

  ArrayList<CurrentSegment> getCurrentSegments() {
    return this.currentSegments;
  }

  void calculateTotalForce() {
    for (CurrentSegment currentSegmentOfCircuit : this.currentSegments) {
      for (CurrentElement currentElement : currentSegmentOfCircuit.getCurrentElements()) {
        this.totalforce.add(currentElement.Force);
      }
    }
  }

  PVector toScreenCoords (PVector coords) {
    //coords.y *= -1.0;
    //coords.add(width/2, height/2);
    return coords;
  }

  PVector getTotalForce() {
    return this.totalforce;
  }
}