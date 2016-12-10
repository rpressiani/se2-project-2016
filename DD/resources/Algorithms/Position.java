public class Position {
  private float latitude;
  private float longitude;
  
  public Position(int x, int y){
    this.latitude=x;
    this.longitude=y;
  }
  
  public float getLatitude() {
    return latitude;
  }
  
  public float getLongitude() {
    return longitude;
  }

  @Override
  public boolean equals(Object obj) {
    if (this == obj)
      return true;
    if (obj == null)
      return false;
    if (getClass() != obj.getClass())
      return false;
    Position other = (Position) obj;
    if (
      Float.floatToIntBits(latitude) !=
      Float.floatToIntBits(other.latitude)
      )
      return false;
    if (
      Float.floatToIntBits(longitude) !=
      Float.floatToIntBits(other.longitude)
      )
      return false;
    return true;
  }
  
  
}
