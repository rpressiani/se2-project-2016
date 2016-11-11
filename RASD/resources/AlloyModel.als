open util/boolean

sig Position{
		latitude : Int,
		longitute : Int
}

abstract sig Status{}
sig Available extends Status{}
sig InUse extends Status{}
sig Reserved extends Status{}
sig Unavailable extends Status{}

sig Car{
		IDCar : Int,
		status : Status,
		batteryLevel : Int,
		engineLock : Bool, 
		engineStatus: Bool,
		doorsLock : Bool,
		doorsStatus : Bool,
		activeSeats : Int,
		componentsFailure : Bool,
		position : Position
}{
		IDCar>0
		batteryLevel >= 0 && batteryLevel <=100
		activeSeats>=0 && activeSeats<=5
}	

sig User{
		name : String,
		surname : String,
		IDCard : String,
		taxCode : String,
		drivingLicense : String,
		creditCard : String,
		email : String,
		password : String,
		PIN : String,
		position : Position
}

sig Booking{
		bookingID : Int,
		user : User,
		car : Car,
		passedTime : Bool	//can't handle time difference between booking and rental
}{
		bookingID>0
}

sig Rental{
		booking : Booking,
		durationTime : Int,
		amountToPay : Int
}

fact DifferentCars{
		all c1,c2: Car | (c1 != c2) => (c1.IDCar != c2.IDCar) && (c1.position != c2.position)		
		//car's id numbers are unique
		//two different cars can't stay in the same position
}

fact DifferentUsers{
	all u1,u2: User | (u1!=u2) => (u1.IDCard != u2.IDCard) && (u1.taxCode != u2.taxCode) &&
													 (u1.drivingLicense != u2.drivingLicense) && (u1.email != u2.email) &&
													 (u1.PIN != u2.PIN)
}

pred show{}
run show
