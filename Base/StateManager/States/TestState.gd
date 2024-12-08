extends BaseState

var counter = 0
var direction = -1

func switch():
	counter = 10
	direction *= -1
	
func Enter():
	switch()

func Update():
	
