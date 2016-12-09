package sw2;

public class Car {
	
	/**
	 * batteryLevel and position of the car
	 * are calculated after the end of the rental
	 */
	private int batteryLevel;
	private Position position;
	
	public int getBatteryLevel() {
		return batteryLevel;
	}

	public void setBatteryLevel(int batteryLevel) {
		this.batteryLevel = batteryLevel;
	}

	public Position getPosition() {
		return position;
	}

	public void setPosition(Position position) {
		this.position = position;
	}
	
}
