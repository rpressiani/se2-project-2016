open util/boolean

abstract sig CarStatus{}
one sig Available extends CarStatus{}
one sig InUse extends CarStatus{}
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
} {
	IDCar > 0
	activeSeats > 0 && activeSeats <= 5
}

sig Position {
	latitude: Int,
	longitude: Int,
}

sig SafeArea {
	position: Position,
	powerGrid: Bool,
	nearToPowerGrid: Bool,	//boolean that indicates if there is at least one safe area with power grid
											// in 3km range from the considered safe area
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
	elapsedTime: Bool,	//True if it passed more than hour since the user booked the car
} {
	bookingID > 0
}

sig Rental {
	booking: Booking,
	ended: Bool,
} 

abstract sig Payment {}

sig PaymentRental extends Payment {
	rental: Rental,
}

sig PaymentFee extends Payment {
	booking: Booking,
}

sig RecoveryAlert {
	car: Car,
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

fact usersAreUnique {
	all u1, u2: User | (u1 != u2) => (u1.taxCode != u2.taxCode)
}

fact bookingsAreUnique {
	all b1, b2: Booking | (b1 != b2) => (b1.bookingID != b2.bookingID)
}

fact oneCarOneBooking {
	all b1, b2: Booking | (b1.ended = False && b2.ended = False && b1.car = b2.car) => (b1 = b2)
}

fact oneUserOneBooking {
	all b1, b2: Booking | (b1.ended = False && b2.ended = False && b1.user = b2.user) => (b1 = b2)
}

fact rentalIfNotElapsed {
	all r: Rental | r.booking.elapsedTime = False
}

fact oneBookingOneRental {
	all r1, r2: Rental | (r1 != r2) => r1.booking != r2.booking
}

fact feeIfElapsed {
	all p: PaymentFee | p.booking.elapsedTime = True
}

fact endBookingIfElapsed {
	all p: PaymentFee | p.booking.ended = True
}

fact paymentFeeAreUnique {
	all p1, p2: PaymentFee | (p1 != p2) => (p1.booking != p2.booking)
}

fact paymentRentalAreUnique {
	all p1, p2: PaymentRental | (p1 != p2) => (p1.rental != p2.rental)
}

fact payIfRentalEnded {
	all p: PaymentRental | p.rental.ended=True
}

fact endBookingIfEndRental {
	all r: Rental | (r.ended = True) => r.booking.ended = True
}

fact oneRentalOnePayment {
	all p1, p2: PaymentRental | (p1.rental = p2.rental) => p1=p2
}

fact endBookingIfUnavailable {
	all c: Car | some b: Booking | (b.car = c && c.status = Unavailable) => b.ended = True
}

fact endRentalIfUnavailable {
	all c: Car | some r: Rental | some b: Booking | (r.booking = b && b.car = c && c.status = Unavailable) => r.ended = True
}

fact alertIffUnavailable {
	all c: Car |	some a: RecoveryAlert | (c.status = Unavailable) <=> (a.car = c)
}

fact alertsAreUnique {
	all a1, a2: RecoveryAlert | (a1!=a2) => (a1.car!=a2.car)
}

fact carIsReserved {
	all c: Car | some b: Booking | (b.car = c && b.ended = False) <=> (c.status = Reserved)
}

fact carInUse{
	all c: Car | some r: Rental | some b: Booking | (r.booking=b && r.booking.car=c && r.ended=False) <=> (c.status = InUse)
}

fact carIsUnavailable {
	all c: Car | some s: SafeArea | (c.batteryLevel = BatteryLevelEmpty || c.componentsFailure = True || 
													 (c.position = s.position && s.powerGrid=False && c.batteryLevel = BatteryLevelLow &&
													  s.nearToPowerGrid = False)) <=> (c.status = Unavailable)
}

 
/* PREDS */

pred show {
	#Car > 1
	#Booking > 1
	#PaymentFee > 1
	#RecoveryAlert > 1
}

pred batteryLowInSafeAreaWithNoPowerGridHasAlert {
	some c: Car, s: SafeArea, r: RecoveryAlert | (c.batteryLevel = BatteryLevelLow && c.position = s.position && s.powerGrid = False && r.car = c && c.componentsFailure = False)
}

pred allRentalsHaveNonElapsedBooking {
	some r: Rental, b: Booking | (r.booking = b && b.elapsedTime = False)
}

pred bookingsElapsedHaveFeePayments {
	some b: Booking, p: PaymentFee | (b.elapsedTime = True && p.booking = b)
}

run allRentalsHaveNonElapsedBooking
run bookingsElapsedHaveFeePayments
run batteryLowInSafeAreaWithNoPowerGridHasAlert
run show

/* ASSERT */

assert noActiveBookingIfRentalEnded {
	all r: Rental | (r.ended=True) => no b: Booking | (r.booking=b && b.ended=False)
}

assert paymentIfRentalEnded {
	all p: PaymentRental | all r: Rental | (p.rental = r) =>  (r.ended = True)
}

assert noRentalActiveIfCarUnavailable {
	all c: Car | some r: Rental | some b: Booking | (c.status=Unavailable && r.booking=b && b.car=c) => (r.ended=True) 
}

assert singleAlertIfCarUnavailable {
	all c: Car | (c.status=Unavailable) => one r: RecoveryAlert | (r.car=c)
}

check noRentalActiveIfCarUnavailable
check paymentIfRentalEnded
check singleAlertIfCarUnavailable
check noActiveBookingIfRentalEnded
