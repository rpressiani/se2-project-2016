public class Rental {
  
  private Car car;
  private int duration;
  private double amountToPay;
  
  public Rental(Car car, int n, double p){
    this.car=car;
    this.duration=n;
    this.amountToPay=p;
  }
  
  public Car getCar() {
    return car;
  }
  
  public int getDuration() {
    return duration;
  }
  
  public double getAmountToPay() {
    return amountToPay;
  }
  
  public void setAmountToPay(double amountToPay) {
    this.amountToPay=amountToPay;
  }
}
