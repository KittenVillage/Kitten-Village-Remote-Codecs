-- Velocity preset
Vel = "7F"

-- Midi control nums for outgoing items, hex
MAIN_PARAM_CTRL = "77"
ECHO_CTRL = "76"
CHANGE_MIDI_CHAN_CTRL = "75"
CHANGE_POS_OUT_CTRL = "74"
CHANGE_ON_OFF_OUT_CTRL = "73"
CHANGE_PRES_OUT_CTRL = "72"
CHANGE_LIGHT_IN_CTRL = "71"
CHANGE_BRIGHT_IN_CTRL = "70"
CHANGE_NOTEOUT_NUMBER_CTRL = "6F"
CHANGE_NOTEOUT_VEL_CTRL = "6E"
VERSION_OUTPUT_CTRL = "6D"
SENSITIVITY_CTRL = "6C"
PITCH_WHEEL_RETURN_SPEED_CTRL = "6B"

--Undocumented by vmeter instructions, low numbers best
PITCH_WHEEL_RETURN_SPEED = "B0 " .. PITCH_WHEEL_RETURN_SPEED_CTRL .. "00"

--Chan 1 
Ch1Main  = "B0 "..	MAIN_PARAM_CTRL	
SetVel = "B0 " .. CHANGE_NOTEOUT_VEL_CTRL .. " " .. Vel


-- Ctrl 119 (77h) Parameter items, all caps coz they are from the firmware.
--UPGRADE_FIRM = Ch1Main ..	"7F"
UPSIDE_DOWN_OFF = Ch1Main ..	"7E"
UPSIDE_DOWN_ON = Ch1Main ..	"7D"
TOUCH_POS_OUT_ENABLE = Ch1Main ..	"7C"
TOUCH_POS_OUT_DISABLE = Ch1Main ..	"7B"
PRES_OUT_ENABLE = Ch1Main ..	"7A"
PRES_OUT_DISABLE = Ch1Main ..	"79"
ON_OFF_OUT_ENABLE = Ch1Main ..	"78"
ON_OFF_OUT_DISABLE = Ch1Main ..	"77"
--STORE_SETTINGS = Ch1Main ..	"76"
NOTE_OUT_ENABLE = Ch1Main ..	"75"
NOTE_OUT_DISABLE = Ch1Main ..	"74"
PITCH_WHEEL_ENABLE = Ch1Main ..	"73"
PITCH_WHEEL_DISABLE = Ch1Main ..	"72"
READ_SETTINGS = Ch1Main ..	"71"
RECALIBRATE = Ch1Main ..	"70"
NOTEOUT_VEL_FROM_POS = Ch1Main ..	"6F"
NOTEOUT_VEL_FROM_PRESET = Ch1Main ..	"6E"
NOTEOUT_PITCH_FROM_POS = Ch1Main ..	"6D"
NOTEOUT_PITCH_FROM_PRESET = Ch1Main ..	"6C"
LEDS_IGNORE_TOUCH = Ch1Main ..	"6B"
LEDS_DONT_IGNORE_TOUCH = Ch1Main ..	"6A"

CROSS_FADE_ENABLE = Ch1Main ..	"69"
CROSS_FADE_DISABLE = Ch1Main ..	"68"
GET_VERSION = Ch1Main ..	"67"

FILTER_ENABLE = Ch1Main ..	"66"
FILTER_DISABLE = Ch1Main ..	"65"






-- Midi control nums for incoming items, hex 
MIDI_POS_OUT_CTRL = "14"
MIDI_TOUCH_ON_OFF_CTRL = "11"
MIDI_PRES_OUT_CTRL = "12"
MIDI_COL_HEIGHT_CTRL = "14"
MIDI_BRIGHTNESS_CTRL = "15"
UPSIDE_DOWN_MODE_CTRL = "1E"
--RECALIBRATE_TOUCH_SENSOR_CTRL = "1F"
EN_TOUCH_POS_OUTPUT_CTRL = "22"
EN_ON_OFF_OUTPUT_CTRL = "23"
EN_PRES_OUTPUT_CTRL = "24"
--UPGRADE_FIRMWARE_NOTE = "3C"
--STORE_SETTINGS_NOTE = "43"












Thismodel = ""





function remote_init(manufacturer, model)
--[[
	if model == "VMeter Fader" then
		setupStr="1"
	elseif model == "VMeter Notes" then
		setupStr="2"
	elseif model == "VMeter Pitch Wheel" then
		setupStr="3"
	elseif model == "VMeter Crossfader" then
		setupStr="4"
	elseif model == "VMeter Button" then
		setupStr="5"
	elseif model == "VMeter Delta" then
		setupStr="6"
	elseif model == "VMeter Meter" then
		setupStr="7"
	end --if
--]]

	Thismodel = model





	if model == "VMeter Fader" then
		local items=
		{
	--		{name="Keyboard",          	input="keyboard"},
	--		{name="Pitch Bend Wheel",  	input="value",	               	min=0,	max=16383},
	--		{name="Channel Aftertouch",	input="value",	               	min=0,	max=127},
	--		{name="Modulation Wheel",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Sustain Pedal",     	input="value",	output="value",	min=0,	max=127},
	--		{name="Expression Pedal",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Breath",            	input="value",	output="value",	min=0,	max=127},
			{name="Fader",            	input="value",	output="value",	min=0,	max=127},
		}
		remote.trace("yes")
		remote.define_items(items)
		
		local inputs={

		
	--		{pattern="<100x>0 yy zz",	name="Keyboard"},
	--		{pattern="90 xx 00",     	name="Keyboard",         value="0", note="x", velocity="64"},
	--		{pattern="e0 xx yy",     	name="Pitch Bend Wheel", value="y * 128 + x"},
	--		{pattern="b0 11 xx",        	name="Channel Aftertouch"},
	--		{pattern="b0 01 xx",     	name="Modulation Wheel"},
	--		{pattern="b0 02 xx",     	name="Breath"},
	--		{pattern="b0 0B xx",     	name="Expression Pedal"},
	--		{pattern="b0 40 xx",     	name="Sustain Pedal"},
			{pattern="b0 14 xx",     	name="Fader"},

		}
		remote.define_auto_inputs(inputs)

		local outputs={
	--		{name="CC 00"           ,	pattern="b0 00 xx"},
	--		{name="Modulation Wheel",	pattern="b0 01 xx"},
	--		{name="Breath"          ,	pattern="b0 02 xx"},
	--		{name="Expression Pedal",	pattern="b0 0B xx"},
	--		{name="Sustain Pedal"   ,	pattern="b0 40 xx"},
	--		{name="CC 127"          ,	pattern="b0 7F xx"},
			{name="Fader"          ,	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		
		
		
		
		
		
		
		
		
		
		
		
	elseif model == "VMeter Notes" then
		local items=
		{
		{name="Keyboard",          	input="keyboard"},
	--		{name="Pitch Bend Wheel",  	input="value",	               	min=0,	max=16383},
			{name="Channel Aftertouch",	input="value",	               	min=0,	max=127},
	--		{name="Modulation Wheel",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Sustain Pedal",     	input="value",	output="value",	min=0,	max=127},
	--		{name="Expression Pedal",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Breath",            	input="value",	output="value",	min=0,	max=127},
	--		{name="TouchPos",            	input="value",	output="value",	min=0,	max=127},
		}
		remote.define_items(items)
		
		local inputs={

		
			{pattern="<100x>0 yy zz",	name="Keyboard"},
	--		{pattern="b0 12 zz",     	name="Keyboard",         velocity="z"},
	--		{pattern="90 xx 00",     	name="Keyboard",         value="0", note="x", velocity="64"},
	--		{pattern="e0 xx yy",     	name="Pitch Bend Wheel", value="y * 128 + x"},
			{pattern="b0 12 xx",        	name="Channel Aftertouch"},
	--		{pattern="b0 01 xx",     	name="Modulation Wheel"},
	--		{pattern="b0 02 xx",     	name="Breath"},
	--		{pattern="b0 0B xx",     	name="Expression Pedal"},
	--		{pattern="b0 40 xx",     	name="Sustain Pedal"},
	--		{pattern="b0 14 xx",     	name="TouchPos"},

		}
		remote.define_auto_inputs(inputs)

		local outputs={
	--		{name="CC 00"           ,	pattern="b0 00 xx"},
	--		{name="Modulation Wheel",	pattern="b0 01 xx"},
	--		{name="Breath"          ,	pattern="b0 02 xx"},
	--		{name="Expression Pedal",	pattern="b0 0B xx"},
	--		{name="Sustain Pedal"   ,	pattern="b0 40 xx"},
	--		{name="CC 127"          ,	pattern="b0 7F xx"},
	--		{name="TouchPos"          ,	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	elseif model == "VMeter Pitch Wheel" then
		local items=
		{
	--		{name="Keyboard",          	input="keyboard"},
			{name="Pitch Bend Wheel",  	input="value",	               	min=0,	max=16383},
	--		{name="Channel Aftertouch",	input="value",	               	min=0,	max=127},
	--		{name="Modulation Wheel",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Sustain Pedal",     	input="value",	output="value",	min=0,	max=127},
	--		{name="Expression Pedal",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Breath",            	input="value",	output="value",	min=0,	max=127},
	--		{name="TouchPos",            	input="value",	output="value",	min=0,	max=127},
		}
		remote.define_items(items)
		
		local inputs={

		
	--		{pattern="<100x>0 yy zz",	name="Keyboard"},
	--		{pattern="90 xx 00",     	name="Keyboard",         value="0", note="x", velocity="64"},
			{pattern="e0 xx yy",     	name="Pitch Bend Wheel", value="y * 128 + x"},
	--		{pattern="b0 11 xx",        	name="Channel Aftertouch"},
	--		{pattern="b0 01 xx",     	name="Modulation Wheel"},
	--		{pattern="b0 02 xx",     	name="Breath"},
	--		{pattern="b0 0B xx",     	name="Expression Pedal"},
	--		{pattern="b0 40 xx",     	name="Sustain Pedal"},
	--		{pattern="b0 14 xx",     	name="TouchPos"},

		}
		remote.define_auto_inputs(inputs)

		local outputs={
	--		{name="CC 00"           ,	pattern="b0 00 xx"},
	--		{name="Modulation Wheel",	pattern="b0 01 xx"},
	--		{name="Breath"          ,	pattern="b0 02 xx"},
	--		{name="Expression Pedal",	pattern="b0 0B xx"},
	--		{name="Sustain Pedal"   ,	pattern="b0 40 xx"},
	--		{name="CC 127"          ,	pattern="b0 7F xx"},
	--		{name="TouchPos"          ,	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		
		
		
		
	elseif model == "VMeter Modulation Wheel" then
		local items=
		{
	--		{name="Keyboard",          	input="keyboard"},
	--		{name="Pitch Bend Wheel",  	input="value",	               	min=0,	max=16383},
	--		{name="Channel Aftertouch",	input="value",	               	min=0,	max=127},
			{name="Modulation Wheel",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Sustain Pedal",     	input="value",	output="value",	min=0,	max=127},
	--		{name="Expression Pedal",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Breath",            	input="value",	output="value",	min=0,	max=127},
	--		{name="TouchPos",            	input="value",	output="value",	min=0,	max=127},
		}
		remote.define_items(items)
		
		local inputs={

		
	--		{pattern="<100x>0 yy zz",	name="Keyboard"},
	--		{pattern="90 xx 00",     	name="Keyboard",         value="0", note="x", velocity="64"},
	--		{pattern="e0 xx yy",     	name="Pitch Bend Wheel", value="y * 128 + x"},
	--		{pattern="b0 11 xx",        	name="Channel Aftertouch"},
			{pattern="e0 xx yy",     	name="Modulation Wheel", value="y * 128 + x"},
	--		{pattern="b0 02 xx",     	name="Breath"},
	--		{pattern="b0 0B xx",     	name="Expression Pedal"},
	--		{pattern="b0 40 xx",     	name="Sustain Pedal"},
	--		{pattern="b0 14 xx",     	name="TouchPos"},

		}
		remote.define_auto_inputs(inputs)

		local outputs={
	--		{name="CC 00"           ,	pattern="b0 00 xx"},
	--		{name="Modulation Wheel",	pattern="b0 01 xx"},
	--		{name="Breath"          ,	pattern="b0 02 xx"},
	--		{name="Expression Pedal",	pattern="b0 0B xx"},
	--		{name="Sustain Pedal"   ,	pattern="b0 40 xx"},
	--		{name="CC 127"          ,	pattern="b0 7F xx"},
	--		{name="TouchPos"          ,	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		
		
		
		
		
		
		
		
	elseif model == "VMeter Crossfader" then
		local items=
		{
	--		{name="Keyboard",          	input="keyboard"},
	--		{name="Pitch Bend Wheel",  	input="value",	               	min=0,	max=16383},
	--		{name="Channel Aftertouch",	input="value",	               	min=0,	max=127},
	--		{name="Modulation Wheel",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Sustain Pedal",     	input="value",	output="value",	min=0,	max=127},
	--		{name="Expression Pedal",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Breath",            	input="value",	output="value",	min=0,	max=127},
			{name="TouchPos",            	input="value",	output="value",	min=0,	max=127},
		}
		remote.define_items(items)
		
		local inputs={

		
	--		{pattern="<100x>0 yy zz",	name="Keyboard"},
	--		{pattern="90 xx 00",     	name="Keyboard",         value="0", note="x", velocity="64"},
	--		{pattern="e0 xx yy",     	name="Pitch Bend Wheel", value="y * 128 + x"},
	--		{pattern="b0 11 xx",        	name="Channel Aftertouch"},
	--		{pattern="b0 01 xx",     	name="Modulation Wheel"},
	--		{pattern="b0 02 xx",     	name="Breath"},
	--		{pattern="b0 0B xx",     	name="Expression Pedal"},
	--		{pattern="b0 40 xx",     	name="Sustain Pedal"},
			{pattern="b0 14 xx",     	name="TouchPos"},

		}
		remote.define_auto_inputs(inputs)

		local outputs={
	--		{name="CC 00"           ,	pattern="b0 00 xx"},
	--		{name="Modulation Wheel",	pattern="b0 01 xx"},
	--		{name="Breath"          ,	pattern="b0 02 xx"},
	--		{name="Expression Pedal",	pattern="b0 0B xx"},
	--		{name="Sustain Pedal"   ,	pattern="b0 40 xx"},
	--		{name="CC 127"          ,	pattern="b0 7F xx"},
			{name="TouchPos"          ,	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		
		
		
		
		
		
		
		
		
		
		
		
	elseif model == "VMeter Button" then
		local items=
		{
	--		{name="Keyboard",          	input="keyboard"},
	--		{name="Pitch Bend Wheel",  	input="value",	               	min=0,	max=16383},
	--		{name="Channel Aftertouch",	input="value",	               	min=0,	max=127},
	--		{name="Modulation Wheel",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Sustain Pedal",     	input="value",	output="value",	min=0,	max=127},
	--		{name="Expression Pedal",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Breath",            	input="value",	output="value",	min=0,	max=127},
			{name="TouchPos",            	input="value",	output="value",	min=0,	max=127},
		}
		remote.define_items(items)
		
		local inputs={

		
	--		{pattern="<100x>0 yy zz",	name="Keyboard"},
	--		{pattern="90 xx 00",     	name="Keyboard",         value="0", note="x", velocity="64"},
	--		{pattern="e0 xx yy",     	name="Pitch Bend Wheel", value="y * 128 + x"},
	--		{pattern="b0 11 xx",        	name="Channel Aftertouch"},
	--		{pattern="b0 01 xx",     	name="Modulation Wheel"},
	--		{pattern="b0 02 xx",     	name="Breath"},
	--		{pattern="b0 0B xx",     	name="Expression Pedal"},
	--		{pattern="b0 40 xx",     	name="Sustain Pedal"},
			{pattern="b0 14 xx",     	name="TouchPos"},

		}
		remote.define_auto_inputs(inputs)

		local outputs={
	--		{name="CC 00"           ,	pattern="b0 00 xx"},
	--		{name="Modulation Wheel",	pattern="b0 01 xx"},
	--		{name="Breath"          ,	pattern="b0 02 xx"},
	--		{name="Expression Pedal",	pattern="b0 0B xx"},
	--		{name="Sustain Pedal"   ,	pattern="b0 40 xx"},
	--		{name="CC 127"          ,	pattern="b0 7F xx"},
			{name="TouchPos"          ,	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	elseif model == "VMeter Delta" then
		local items=
		{
	--		{name="Keyboard",          	input="keyboard"},
	--		{name="Pitch Bend Wheel",  	input="value",	               	min=0,	max=16383},
	--		{name="Channel Aftertouch",	input="value",	               	min=0,	max=127},
	--		{name="Modulation Wheel",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Sustain Pedal",     	input="value",	output="value",	min=0,	max=127},
	--		{name="Expression Pedal",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Breath",            	input="value",	output="value",	min=0,	max=127},
			{name="TouchPos",            	input="value",	output="value",	min=0,	max=127},
		}
		
		remote.define_items(items)
		
		local inputs={

		
	--		{pattern="<100x>0 yy zz",	name="Keyboard"},
	--		{pattern="90 xx 00",     	name="Keyboard",         value="0", note="x", velocity="64"},
	--		{pattern="e0 xx yy",     	name="Pitch Bend Wheel", value="y * 128 + x"},
	--		{pattern="b0 11 xx",        	name="Channel Aftertouch"},
	--		{pattern="b0 01 xx",     	name="Modulation Wheel"},
	--		{pattern="b0 02 xx",     	name="Breath"},
	--		{pattern="b0 0B xx",     	name="Expression Pedal"},
	--		{pattern="b0 40 xx",     	name="Sustain Pedal"},
			{pattern="b0 14 xx",     	name="TouchPos"},

		}
		remote.define_auto_inputs(inputs)

		local outputs={
	--		{name="CC 00"           ,	pattern="b0 00 xx"},
	--		{name="Modulation Wheel",	pattern="b0 01 xx"},
	--		{name="Breath"          ,	pattern="b0 02 xx"},
	--		{name="Expression Pedal",	pattern="b0 0B xx"},
	--		{name="Sustain Pedal"   ,	pattern="b0 40 xx"},
	--		{name="CC 127"          ,	pattern="b0 7F xx"},
			{name="TouchPos"          ,	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		
		
		
		
		
		
		
		
		
	elseif model == "VMeter Meter" then
		local items=
		{
	--		{name="Keyboard",          	input="keyboard"},
	--		{name="Pitch Bend Wheel",  	input="value",	               	min=0,	max=16383},
	--		{name="Channel Aftertouch",	input="value",	               	min=0,	max=127},
	--		{name="Modulation Wheel",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Sustain Pedal",     	input="value",	output="value",	min=0,	max=127},
	--		{name="Expression Pedal",  	input="value",	output="value",	min=0,	max=127},
	--		{name="Breath",            	input="value",	output="value",	min=0,	max=127},
			{name="TouchPos",            	input="value",	output="value",	min=0,	max=127},
		}
		remote.define_items(items)
		
		local inputs={

		
	--		{pattern="<100x>0 yy zz",	name="Keyboard"},
	--		{pattern="90 xx 00",     	name="Keyboard",         value="0", note="x", velocity="64"},
	--		{pattern="e0 xx yy",     	name="Pitch Bend Wheel", value="y * 128 + x"},
	--		{pattern="b0 11 xx",        	name="Channel Aftertouch"},
	--		{pattern="b0 01 xx",     	name="Modulation Wheel"},
	--		{pattern="b0 02 xx",     	name="Breath"},
	--		{pattern="b0 0B xx",     	name="Expression Pedal"},
	--		{pattern="b0 40 xx",     	name="Sustain Pedal"},
			{pattern="b0 14 xx",     	name="TouchPos"},

		}
		remote.define_auto_inputs(inputs)

		local outputs={
	--		{name="CC 00"           ,	pattern="b0 00 xx"},
	--		{name="Modulation Wheel",	pattern="b0 01 xx"},
	--		{name="Breath"          ,	pattern="b0 02 xx"},
	--		{name="Expression Pedal",	pattern="b0 0B xx"},
	--		{name="Sustain Pedal"   ,	pattern="b0 40 xx"},
	--		{name="CC 127"          ,	pattern="b0 7F xx"},
			{name="TouchPos"          ,	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	end --if


	
end





function remote_probe()
	return {
	}
end






function remote_prepare_for_use()

	if Thismodel == "VMeter Fader" then
		local retEvents={
			remote.make_midi(SetVel, { port=1 } ),

			remote.make_midi(UPSIDE_DOWN_ON, { port=1 } ),

			remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),

			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),

			remote.make_midi(TOUCH_POS_OUT_DISABLE, { port=1 } ),

			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),

			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),

			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents


	elseif Thismodel == "VMeter Notes" then
		local retEvents={
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_ON, { port=1 } ),

			remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),

			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),



			remote.make_midi(TOUCH_POS_OUT_DISABLE, { port=1 } ),

			remote.make_midi(PRES_OUT_ENABLE, { port=1 } ),

			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_ENABLE, { port=1 } ),


			remote.make_midi(NOTEOUT_VEL_FROM_PRESET, { port=1 } ),
			remote.make_midi(NOTEOUT_PITCH_FROM_POS, { port=1 } ),

		}
		return retEvents

	elseif Thismodel == "VMeter Pitch Wheel" then
		local retEvents={
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_RETURN_SPEED, { port=1 } ),


			remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_ENABLE, { port=1 } ),


			remote.make_midi(CROSS_FADE_DISABLE, { port=1 } ),

			remote.make_midi(TOUCH_POS_OUT_DISABLE, { port=1 } ),

			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),

			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),

			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents
	elseif Thismodel == "VMeter Modulation Wheel" then
		local retEvents={
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_RETURN_SPEED, { port=1 } ),


			remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_ENABLE, { port=1 } ),


			remote.make_midi(CROSS_FADE_DISABLE, { port=1 } ),

			remote.make_midi(TOUCH_POS_OUT_DISABLE, { port=1 } ),

			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),

			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),

			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents


		
		
	elseif Thismodel == "VMeter Crossfader" then
		local retEvents={
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),


			remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),


			remote.make_midi(CROSS_FADE_ENABLE, { port=1 } ),

			remote.make_midi(TOUCH_POS_OUT_DISABLE, { port=1 } ),

			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),

			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),

			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents
		
	elseif Thismodel == "VMeter Button" then
		local retEvents={
			remote.make_midi(SetVel, { port=1 } ),
			
		}
		return retEvents
		
	elseif Thismodel == "VMeter Delta" then
		local retEvents={
			remote.make_midi(SetVel, { port=1 } ),
			
		}
		return retEvents
		
	elseif Thismodel == "VMeter Meter" then
		local retEvents={
			remote.make_midi(SetVel, { port=1 } ),
			
		}
		return retEvents
		
	end --if
	
end
	



function remote_release_from_use()


	local retEvents={
		remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ), --Upside Down mode

--		remote.make_midi("f0 66 66 66 14 0a 02 f7", { port=1 } ),
--		remote.make_midi("f0 66 66 66 14 0a 02 f7", { port=2 } ),
	}
	return retEvents


end



function remote_deliver_midi(max_bytes,port)
	if(port==1) then
		local retEvents={
--			rtevent = remote.make_midi("b0 14 "..c_two)
		}
		return retEvents
	
	
	
	end --end port==1
--[[
	
	if(port==2) then
		local retLevels=remote.make_midi("b0 14 yy", { x=mode, y=value, port=2 })
		return retLevels
	end
--]]	

end
