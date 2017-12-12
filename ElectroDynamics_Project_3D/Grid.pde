public class Grid {
  int gridSize;
  color lineColor;
  color backgroundColor;


  Grid(int gridSize) {
    this.gridSize = gridSize;
    this.lineColor = color(255, 255, 255);
    this.backgroundColor = color(50);
  }

  void show() {
    background(backgroundColor);
    int verticalLines = width/gridSize;
    int horizontalLines = height/gridSize;

    pushMatrix();
    for (int i=0; i < verticalLines-1; i++) {
      translate(gridSize, 0);
      strokeWeight(2);
      stroke(lineColor);
      line(0, 0, 0, height);
    }
    popMatrix();

    pushMatrix();
    for (int i=0; i < horizontalLines-1; i++) {
      translate(0, gridSize);
      strokeWeight(2);
      stroke(lineColor);
      line(0, 0, width, 0);
    }
    popMatrix();
  }
  
  void showBackrgound() {
    background(backgroundColor);
  }
}