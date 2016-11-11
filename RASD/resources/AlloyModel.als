open util/boolean

sig Position{
		latitude : Int,
		longitute : Int
}

sig Car{
		IDCar : Int,
		status : String,
		batteryLevel : Int,
		engineLock : Bool, 
		engineStatus: Bool,
		doorsLock : Bool,
		doorsStatus : Bool,
		activeSeats : int,
		componentsFailure : Bool,
		position : Position
}


pred show{}
run show
