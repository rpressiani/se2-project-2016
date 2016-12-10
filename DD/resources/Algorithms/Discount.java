import java.util.Set;

public class Discount {

  private Rental rental;
  
  public Discount(Rental rental){
    this.rental=rental;
  }
  
  /**
   * @param atLeastTwoPassengersTime is calculated by the car 
   * and indicates the time during which at least two passengers
   * were present in rental's car
   */
  public double discountPassengers(int atLeastTwoPassengersTime){
    if(atLeastTwoPassengersTime<rental.getDuration()) return 0;
    else return rental.getAmountToPay()*0.1;
  }
  
  /**
   * we suppose that car's batteryLevel belongs to a range
   * between 0 and 100
   */
  public double discountBattery(){
    if(rental.getCar().getBatteryLevel()<=50) return 0;
    else return rental.getAmountToPay()*0.2;
  }
  
  /**
   * @param map is the set of safeAreas
   * @param charging is true if rental's car has been plugged
   *        to the power grid
   */
  public double discountCharging(
    Set<SafeArea> map,
    boolean charging
  ){
    if(charging==false) return 0;
    
    for(SafeArea a: map){
      if(
        a.getPosition().equals(rental.getCar().getPosition())==true &&
        a.isPowerGridPresence()==true
      ) return rental.getAmountToPay()*0.3;
    }
    
    return 0;
  }
  
  public void calculateDiscounts(
    int atLeastTwoPassengersTime,
    Set<SafeArea> map,
    boolean charging
  ){
    double totalDiscount=
      this.discountPassengers(atLeastTwoPassengersTime)+
      this.discountBattery()+
      this.discountCharging(map, charging);
    
    rental.setAmountToPay(rental.getAmountToPay()-totalDiscount);
  }
  
}
