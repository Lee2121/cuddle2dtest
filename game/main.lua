require "lib.cuddle2d.init"

local PS4_BTN_ID_X = 1
local PS4_BTN_ID_CIRCLE = 2
local PS4_BTN_ID_SQUARE = 3
local PS4_BTN_ID_Triangle = 4

local JOYSTICK_DEADZONE = .2

local InputContext_Test = {
	move = InputAction_Vector2({ xaxis = { InputDef_KeyboardKey('a'), InputDef_KeyboardKey("left"), InputDef_KeyboardKey('d', InputMod_Invert()), InputDef_KeyboardKey("right", InputMod_Invert()), InputDef_GamepadAxis("leftx" ) },
								 yaxis = { InputDef_KeyboardKey('w', InputMod_Invert()), InputDef_KeyboardKey("up", InputMod_Invert()), InputDef_KeyboardKey('s'), InputDef_KeyboardKey("down"), InputDef_GamepadAxis("lefty" ) },
								 xyaxis = { InputDef_Touch() } } ),

	jump = InputAction_Bool( { InputDef_KeyboardKey("space"), InputDef_GamepadButton(PS4_BTN_ID_SQUARE) } ),

	mouseMoved = InputAction_Vector2( { xyaxis = { InputDef_MousePosition() } } ),

	leftMouseClick = InputAction_Bool( { InputDef_MouseClicked(1), InputDef_KeyboardKey("return") } ),

	leftScreenTouch = InputAction_Vector2( { InputDef_Touch("left") } )
}

local demoLogic = {}

function demoLogic:onPlayerConnected(newPlayerInstance)

	self.playerInstance = newPlayerInstance

	newPlayerInstance.inputManager:pushInputContext(InputContext_Test)

	newPlayerInstance.inputManager:bindActionCallbacks(self, InputContext_Test.jump, self.onJumpStarted, self.onJumpEnded)
end

function demoLogic:onJumpStarted(value)
	print("jump action detected", value)
end

function demoLogic:onJumpEnded(value)
	print("jump action ended", value)
end

function love.load()
	local defaultConfig = { joystickDeadzone = JOYSTICK_DEADZONE}
	PlayerManager:init(defaultConfig)
	BindToCallback(PlayerManager.onPlayerConnectedCallbacks, demoLogic, demoLogic.onPlayerConnected)
end

function love.update()
	if demoLogic.playerInstance ~= nil then
		local jumpvalue = demoLogic.playerInstance.inputManager:getActionValue(InputContext_Test.jump)
		print("jump val: ", jumpvalue)
		
		local mousevalue = demoLogic.playerInstance.inputManager:getActionValue(InputContext_Test.mouseMoved)
		print("mouse pos: ", mousevalue[1], mousevalue[2])

		local moveValue = demoLogic.playerInstance.inputManager:getActionValue(InputContext_Test.move)
		print("move input", moveValue[1], moveValue[2])

		local touchValue = demoLogic.playerInstance.inputManager:getActionValue(InputContext_Test.leftScreenTouch)
		--print("move input", moveValue[1], moveValue[2])
	end
end

function love.draw()
end
