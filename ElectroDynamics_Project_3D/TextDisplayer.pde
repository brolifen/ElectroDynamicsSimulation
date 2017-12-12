public class TextDisplayer {
  ArrayList<String> textList;
  PVector position;
  float newLineSpacing;
  float textSize;
  ConfigAdjuster configAdjuster;

  TextDisplayer(PVector textPosition, float newLineSpacing, ConfigAdjuster configAdjuster) {
    this.position = textPosition;
    this.textList = new ArrayList<String>();
    this.newLineSpacing = newLineSpacing;
    this.textSize = configAdjuster.textSize;
  }

  void addLine(String text) {
    textList.add(text);
  }

  void show() {
    textSize(textSize);
    float y = position.y;
    for (String line : textList) {
      text(line,position.x,y);
      y += textSize + newLineSpacing;
    }
  }
}