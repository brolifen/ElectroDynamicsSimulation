public interface CurrentSegment { //<>//
  void createCurrentElements();
  void show();
  void showCurrentElements();
  void showElementForces();
  void calculateForce(ArrayList<Magnet> objects);
  void updateScreenPosition(PVector vector);
  ArrayList<CurrentElement> getCurrentElements();
}

public class CurrentLine implements CurrentSegment {
  ArrayList<CurrentElement> currentElements;
  PVector startPosition;
  PVector endPosition;
  PVector currentDirection;
  ConfigAdjuster configAdjuster;
  float current;
  Object rootReference;

  CurrentLine(PVector translateVector, PVector startPosition, PVector endPosition, float current, ConfigAdjuster configAdjuster, Object rootReference) {
    this.startPosition = startPosition.add(translateVector);
    this.endPosition = endPosition.add(translateVector);

    this.current = current;
    this.configAdjuster = configAdjuster;
    this.currentElements = new ArrayList<CurrentElement>();
    this.currentDirection = new PVector();
    this.rootReference = rootReference;
    createCurrentElements();
  }

  void createCurrentElements() {
    PVector lengthVector = PVector.sub(endPosition, startPosition);
    this.currentDirection = lengthVector.copy().normalize();
    float vecMag = lengthVector.mag();
    float ammountOfElementsReal = vecMag/configAdjuster.elementLength;
    int ammountOfElements = int(ammountOfElementsReal);
    float distanceBetweenElements = vecMag/ammountOfElements;

    for (int i=1; i < ammountOfElements+1; i++) {
      PVector elementPosition = PVector.add(startPosition, PVector.mult(this.currentDirection, (i*distanceBetweenElements)-distanceBetweenElements/2));
      CurrentElement currentElement = new CurrentElement(elementPosition, this.currentDirection.copy().mult((sign(this.current))), this.current, this.configAdjuster, this.rootReference);
      currentElements.add(currentElement);
    }
  }

  ArrayList<CurrentElement> getCurrentElements() {
    return this.currentElements;
  }

  void showCurrentElements() {
    for (CurrentElement currentElement : this.currentElements) {
      currentElement.show();
    }
  }

  void show() {
    PVector startSegment = toScreenCoords(this.startPosition.copy());
    PVector endSegment = toScreenCoords(this.endPosition.copy());

    //draw the line
    strokeWeight(3);
    stroke(configAdjuster.circuitColor);
    line(startSegment.x, startSegment.y, startSegment.z, endSegment.x, endSegment.y, endSegment.z);

    //draw the arrow tip point
    strokeWeight(10);
    stroke(configAdjuster.tipColor);
    point(startSegment.x, startSegment.y, startSegment.z);

    //draw the arrow tail point
    strokeWeight(7);
    stroke(configAdjuster.tailColor);
    point(endSegment.x, endSegment.y, endSegment.z);
  }

  void showElementForces() {
    for (CurrentElement currentElement : this.currentElements) {
      currentElement.showForce();
    }
  }

  void calculateForce(ArrayList<Magnet> externalMagnets) {
    for (Magnet externalMagnet : externalMagnets) {
      for (CurrentElement CurrentElement : this.getCurrentElements()) {
        CurrentElement.calculateForce(externalMagnet);
      }
    }
  }

  PVector toScreenCoords (PVector coords) {
    coords.y *= -1.0;
    coords.add(width/2, height/2);
    return coords;
  }

  float sign(float value) {
    return value/abs(value);
  }

  void updateScreenPosition(PVector newPosition) {
    this.startPosition = endPosition.add(newPosition);
    this.endPosition = startPosition.add(newPosition);
  }
}

public class CurrentGrid implements CurrentSegment {
  ArrayList<CurrentElement> currentElements;
  PVector translateVector;
  int gridsize;
  int gridSpacing ;
  String type;
  float currentScaler;
  float current;
  PVector currentDirection;
  ConfigAdjuster configAdjuster;
  Object rootReference;

  CurrentGrid(PVector translateVector, int gridsize, int gridSpacing, String type, float currentScaler, float current, PVector currentDirection, ConfigAdjuster configAdjuster,Object rootReference) { 
    this.translateVector = translateVector;
    this.gridsize = gridsize;
    this.gridSpacing = gridSpacing;
    this.type = type;
    this.currentScaler = currentScaler;
    this.current = current;
    this.currentDirection = currentDirection;
    this.configAdjuster = configAdjuster;
    this.currentElements = new ArrayList<CurrentElement>();
    this.rootReference = rootReference;
    createCurrentElements();
  }

  void createCurrentElements() {

    int ammountOfElements = int(this.gridsize/this.gridSpacing);

    if (this.type == "rotational") {
    } else if (this.type == "uniform") {
      for (int i=1; i < ammountOfElements+1; i++) {
        int xPosition = -this.gridsize/2 + this.gridSpacing * i;
        for (int j=1; j < ammountOfElements+1; j++) {
          int yPosition = this.gridsize/2 - this.gridSpacing * j;
          PVector elementPosition = new PVector(xPosition, yPosition,0);
          elementPosition.add(this.translateVector);
          CurrentElement currentElement = new CurrentElement(elementPosition, this.currentDirection.mult(currentScaler), this.current, this.configAdjuster,this.rootReference);
          currentElements.add(currentElement);
        }
      }
    }
  }


  ArrayList<CurrentElement> getCurrentElements() {
    return this.currentElements;
  }

  void showCurrentElements() {
    for (CurrentElement currentElement : this.currentElements) {
      currentElement.show();
    }
  }

  void show() {
  }

  void showElementForces() {
    for (CurrentElement currentElement : this.currentElements) {
      currentElement.showForce();
    }
  }

  void calculateForce(ArrayList<Magnet> externalMagnets) {
    for (Magnet externalMagnet : externalMagnets) {
      for (CurrentElement CurrentElement : this.getCurrentElements()) {
        CurrentElement.calculateForce(externalMagnet);
      }
    }
  }

  PVector toScreenCoords (PVector coords) {
    //coords.y *= -1.0;
    //coords.add(width/2, height/2);
    return coords;
  }

  float sign(float value) {
    return value/abs(value);
  }

  void updateScreenPosition(PVector newPosition) {
  }
}


public class CurrentArc implements CurrentSegment {
  ArrayList<CurrentElement> currentElements;
  PVector center;
  float radius;
  float degrees;
  float shift;
  PVector currentDirection;
  ConfigAdjuster configAdjuster;
  float current;
  Object rootReference;

  CurrentArc(PVector translateVector, PVector center, float radius, float degrees, float current, float shift, ConfigAdjuster configAdjuster, Object rootReference) {
    if (current >=0) {
      this.center = center.add(translateVector);
    } else if (current < 0) {
      this.center = center.add(translateVector);
    }

    this.current = current;
    this.radius = radius;
    this.degrees = degrees;
    this.shift = radians(shift);
    this.configAdjuster = configAdjuster;
    this.currentElements = new ArrayList<CurrentElement>();
    this.currentDirection = new PVector();
    this.rootReference = rootReference;
    createCurrentElements();
  }

  void createCurrentElements() {
    float circumference = radians(this.degrees)*this.radius;
    float ammountOfElementsReal = abs(circumference/configAdjuster.elementLength);
    int ammountOfElements = int(ammountOfElementsReal);
    float distanceBetweenElements = circumference/ammountOfElements;

    float unitAngle = distanceBetweenElements/this.radius;

    for (int i=1; i < ammountOfElements+1; i++) {
      PVector radialPosition = new PVector (radius*sin((unitAngle*i)-unitAngle/2+this.shift), radius*cos(((unitAngle*i)-unitAngle/2)+this.shift));

      PVector tangentVector = radialPosition.copy().rotate(HALF_PI).normalize();
      this.currentDirection = tangentVector.mult(sign(this.current));
      this.currentDirection.z = 0.0;

      PVector elementPosition = PVector.add(this.center, radialPosition);

      CurrentElement currentElement = new CurrentElement(elementPosition, this.currentDirection, this.current, this.configAdjuster, this.rootReference);
      currentElements.add(currentElement);
    }
  }

  ArrayList<CurrentElement> getCurrentElements() {
    return this.currentElements;
  }

  void showCurrentElements() {
    for (CurrentElement currentElement : this.currentElements) {
      currentElement.show();
    }
  }

  void show() {
    PVector startSegment = toScreenCoords(this.center.copy());
    PVector endSegment = toScreenCoords(this.center.copy());

    //draw the line
    strokeWeight(3);
    stroke(configAdjuster.circuitColor);
    line(startSegment.x, startSegment.y, endSegment.x, endSegment.y);

    //draw the arrow tip point
    strokeWeight(10);
    stroke(configAdjuster.tipColor);
    point(startSegment.x, startSegment.y);

    //draw the arrow tail point
    strokeWeight(7);
    stroke(configAdjuster.tailColor);
    point(endSegment.x, endSegment.y);
  }

  void showElementForces() {
    for (CurrentElement currentElement : this.currentElements) {
      currentElement.showForce();
    }
  }

  void calculateForce(ArrayList<Magnet> externalMagnets) {
    for (Magnet externalMagnet : externalMagnets) {
      for (CurrentElement CurrentElement : this.getCurrentElements()) {
        CurrentElement.calculateForce(externalMagnet);
      }
    }
  }

  PVector toScreenCoords (PVector coords) {
    //coords.y *= -1.0;
    //coords.add(width/2, height/2);
    return coords;
  }

  float sign(float value) {
    return value/abs(value);
  }

  void updateScreenPosition(PVector newPosition) {
    this.center = center.add(newPosition);
  }
}