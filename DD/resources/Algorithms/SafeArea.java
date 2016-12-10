public class SafeArea {

  private Position position;
  private boolean powerGridPresence;
  
  public SafeArea(Position position, boolean powerGridPresence){
    this.position=position;
    this.powerGridPresence=powerGridPresence;
  }
  
  public Position getPosition() {
    return position;
  }

  public boolean isPowerGridPresence() {
    return powerGridPresence;
  }
  
}
