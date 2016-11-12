open util/boolean

abstract sig CarStatus{}
one sig Available extends CarStatus{}
//one sig InUse extends CarStatus{}
one sig Reserved extends CarStatus{}
one sig Unavailable extends CarStatus{}

abstract sig BatteryLevel{}
one sig BatteryLevelHigh extends BatteryLevel{}			//	100% -> 50%
one sig BatteryLevelMid extends BatteryLevel{}			//	49% -> 20%
one sig BatteryLevelLow extends BatteryLevel{}			//	19% -> 1%
one sig BatteryLevelEmpty extends BatteryLevel{}		//	0%

sig Car {
	IDCar : Int,
	activeSeats : Int,
	position : Position,
	status : CarStatus,
	batteryLevel : BatteryLevel,
	componentsFailure : Bool,
	/*engineLock : Bool, 
	engineStatus: Bool,
	doorsLock : Bool,
	doorsStatus : Bool,*/
} {
	IDCar > 0
	activeSeats > 0
	activeSeats <= 5
}

sig Position {
	latitude: Int,
	longitude: Int,
}

sig SafeArea {
	position: Position,
	powerGrid: Bool,	
}

sig TaxCode {}

sig User {
	taxCode: TaxCode,
	position: Position,
}

sig Booking {
	bookingID: Int,
	user: User,
	car: Car,
	ended: Bool,
	//elapsedTime: Bool,
} {
	bookingID > 0
}

/* FACTS */

fact carsAreUnique {
	all c1, c2: Car | (c1 != c2) => c1.IDCar != c2.IDCar
}

fact positionsAreUnique {
	all p1, p2: Position | (p1 != p2) => (p1.latitude != p2.latitude) || (p1.longitude != p2.longitude)
}

fact carsCannotBeInTheSamePlace {
	all c1, c2: Car | (c1 != c2) => (c1.position != c2.position)
}

fact safeAreaAreUnique {
	all s1, s2: SafeArea | (s1 != s2) => (s1.position != s2.position)
}

fact carIsUnavailable {
	all c: Car | some s: SafeArea | (c.batteryLevel = BatteryLevelEmpty || c.componentsFailure = True || (c.position = s.position && c.batteryLevel = BatteryLevelLow)) iff (c.status = Unavailable)
}

fact usersAreUnique {
	all u1, u2: User | (u1 != u2) => (u1.taxCode != u2.taxCode)
}

fact bookingsAreUnique {
	all b1, b2: Booking | (b1 != b2) => (b1.bookingID != b2.bookingID)
}

fact carIsReserved {
	all c: Car | some b: Booking | (b.car = c && b.ended = False) iff (c.status = Reserved)
}

fact oneCarOneBooking {
	all b1, b2: Booking | (b1.ended = False && b2.ended = False && b1.car = b2.car) => (b1 = b2)
}

fact oneUserOneBooking {
	all b1, b2: Booking | (b1.ended = False && b2.ended = False && b1.user = b2.user) => (b1 = b2)
}

/* PREDS */

pred show {
	//some c: Car, s: SafeArea | (c.batteryLevel = BatteryLevelLow && c.position = s.position)
	//some c: Car, b: Booking | (b.car != c)
	//	all c: Car | c.status = Unavailable && c.batteryLevel != BatteryLevelEmpty && c.componentsFailure != True
	//#SafeArea > 1
}
run show

/* ASSERT */

/*assert test {

}

check test*/
