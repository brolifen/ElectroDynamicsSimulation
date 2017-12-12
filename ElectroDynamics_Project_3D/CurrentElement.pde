public class CurrentElement { //<>//
  Object rootReference;
  PVector position;
  PVector currentDirection;
  PVector Force;
  float ds;
  float current;

  ConfigAdjuster configAdjuster;

  CurrentElement(PVector position, PVector currentDirection, float current, ConfigAdjuster configAdjuster, Object rootReference) {
    this.position = position;
    this.currentDirection = currentDirection;
    this.currentDirection.normalize();
    this.current = current;
    this.rootReference = rootReference;

    this.Force = new PVector(0, 0, 0);
    this.ds = 30;
    this.configAdjuster = configAdjuster;
  }

  void show() {
    PVector startSegment = PVector.add(PVector.mult(this.currentDirection, (configAdjuster.elementLength/2)*configAdjuster.elementScaler), this.position);
    PVector endSegment = PVector.add(PVector.mult(this.currentDirection, (-configAdjuster.elementLength/2)*configAdjuster.elementScaler), this.position);

    startSegment = toScreenCoords(startSegment);
    endSegment = toScreenCoords(endSegment);

    if (this.rootReference instanceof Magnet ) {
      drawArrow(startSegment, endSegment, configAdjuster.magnetColor);
    } else {
      drawArrow(startSegment, endSegment, configAdjuster.circuitColor);
    }
  }

  void drawArrow(PVector start, PVector end, color arrowColor) {
    stroke(arrowColor);
    strokeWeight(4);
    float a = 2;
    pushMatrix();
    translate(end.x, end.y, end.z);
    rotate(atan2(end.y - start.y, end.x - start.x));
    triangle(- a * 2, - a, 0, 0, - a * 2, a);
    popMatrix();
    strokeWeight(3);
    line(start.x, start.y, start.z, end.x, end.y, end.z);
  }

  void calculateForceAmpere(CurrentSegment currentSegment) {
    PVector forcenew = new PVector(0, 0, 0);
    for (CurrentElement currentElementSource : currentSegment.getCurrentElements()) {
      PVector r12 = PVector.sub(currentElementSource.position, this.position);
      float r12_mag = r12.mag();
      PVector r12_unit = PVector.sub(currentElementSource.position, this.position).normalize();
      float scalar = abs(this.current*currentElementSource.current)*(3.0*(PVector.dot(this.currentDirection, r12_unit)*PVector.dot(currentElementSource.currentDirection, r12_unit)) - 2.0*PVector.dot(currentElementSource.currentDirection, this.currentDirection)) /(r12_mag*r12_mag);
      forcenew.add(r12_unit.mult(-scalar*this.configAdjuster.forceMult));
    }
    this.Force.add(forcenew);
  }

  void calculateForceDistinti(CurrentSegment currentSegment) {
    PVector forcenew = new PVector(0, 0, 0);
    for (CurrentElement currentElementSource : currentSegment.getCurrentElements()) {
      PVector r12 = PVector.sub(currentElementSource.position, this.position);
      float r12_mag = r12.mag();
      PVector r12_unit = PVector.sub(currentElementSource.position, this.position).normalize();
      PVector dLt = PVector.mult(this.currentDirection, configAdjuster.elementLength);
      PVector dLs = PVector.mult(currentElementSource.currentDirection, configAdjuster.elementLength);
      PVector firstterm = PVector.mult(dLs.copy(), -1.0*PVector.dot(dLt, r12_unit));
      PVector thirdterm = PVector.mult(r12_unit.copy(), PVector.dot(dLt, dLs));
      PVector vectorTerm = PVector.add(firstterm, thirdterm);
      vectorTerm.mult(abs(this.current*currentElementSource.current)*this.configAdjuster.forceMult*0.01/(r12_mag*r12_mag));

      forcenew.add(vectorTerm);
    }
    this.Force.add(forcenew);
  }

  void calculateForceDistinti2(CurrentSegment currentSegment) {
    PVector forcenew = new PVector(0, 0, 0);
    for (CurrentElement currentElementSource : currentSegment.getCurrentElements()) {
      PVector r12 = PVector.sub(currentElementSource.position, this.position);
      float r12_mag = r12.mag();
      PVector r12_unit = PVector.sub(currentElementSource.position, this.position).normalize();
      PVector dLt = PVector.mult(this.currentDirection, configAdjuster.elementLength);
      PVector dLs = PVector.mult(currentElementSource.currentDirection, configAdjuster.elementLength);
      PVector firstterm = PVector.mult(dLs.copy(), PVector.dot(dLt, r12_unit));
      PVector secondterm = PVector.mult(dLs.copy(), -1.0*PVector.dot(dLs, r12_unit));
      PVector thirdterm = PVector.mult(r12_unit.copy(), -1.0*PVector.dot(dLt, dLs));
      PVector vectorTerm = PVector.add(firstterm, secondterm).add(thirdterm);
      vectorTerm.mult(-abs(this.current*currentElementSource.current)*this.configAdjuster.forceMult*0.01/(r12_mag*r12_mag));

      forcenew.add(vectorTerm);
    }
    this.Force.add(forcenew);
  }

  void calculateForce(CurrentSegment currentSegment) {
    switch(this.configAdjuster.forceEquation) {
    case "Ampere":
      calculateForceAmpere(currentSegment);
      break;
    case "Distinti": 
      calculateForceDistinti2(currentSegment);
      break;
    }
  }

  void calculateForce(Magnet magnet) {
    for (CurrentSegment currentSegment : magnet.getCurrentSegments()) {
      switch(this.configAdjuster.forceEquation) {
      case "Ampere":
        calculateForceAmpere(currentSegment);
        break;
      case "Distinti": 
        calculateForceDistinti2(currentSegment);
        break;
      }
    }
  }

  void showForce() {
    PVector startSegment = this.position.copy();
    PVector endSegment = PVector.add(this.Force, this.position).copy();

    startSegment = toScreenCoords(startSegment);
    endSegment = toScreenCoords(endSegment);

    drawArrow(startSegment, endSegment, configAdjuster.forceLineColor);
  }

  void setScreenPosition(PVector newPosition) {
    this.position = toWorldCoords(newPosition);
  }

  void setPosition(PVector newPosition) {
    this.position = newPosition;
  }

  PVector toScreenCoords (PVector coords) {
    //coords.y *= -1.0;
    //coords.add(width/2, height/2);
    return coords;
  }

  PVector toWorldCoords (PVector coords) {
    //coords.y *= -1.0;
    //coords.add(-width/2, height/2);
    return coords;
  }

  void rotateCurrentDirection (float degrees) {
    this.currentDirection.rotate(radians(degrees));
  }

  void translatePosition(PVector newPosition) {
    this.position = newPosition;
  }
}