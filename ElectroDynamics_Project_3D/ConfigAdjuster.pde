public class ConfigAdjuster {
  float forceMult;
  float elementLength;
  float elementScaler;
  float textSize;
  String forceEquation;

  color lineColor;
  color tipColor;
  color tailColor;
  color forceLineColor;

  ConfigAdjuster() {
    this.elementScaler = 1.0;
    this.forceEquation = "Ampere";
  }

  void setForceMultiplier (float value) {
    this.forceMult = value;
  }

  void setElementLength (float value) {
    this.elementLength = value;
  }

  void setElementScaler (float value) {
    this.elementScaler = value;
  }

  void setElementScaler (String forceEquation) {
    this.forceEquation = forceEquation;
  }

  void setColors (color lineColor, color tipColor, color tailColor, color forceLineColor) {
    this.lineColor = lineColor;
    this.tipColor = tipColor;
    this.tailColor = tailColor;
    this.forceLineColor = forceLineColor;
  }
}