ledarray = {}
ledoutput = {}
for q=1,38 do
	ledarray[q] =0
end




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
PITCH_WHEEL_RETURN_SPEED = "B0 " .. PITCH_WHEEL_RETURN_SPEED_CTRL .. "06"

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



function implode(p)
  local newstr
  newstr=table.concat(p)
  return newstr
end

function SendArray(ledarray)
    --# assuming 38 length array
    --# need to split array into (6) 7bit chunks
    --# Individual LED control is sent to the aftertouch MIDI command and channels 14, 15 and 16.
    --# Each of the data bytes transmit 7 LED states.
--
				 
				 				 
    local bytes = {0,0,0,0,0,0}

	bytes[1] = ledarray[1] + bit.lshift(ledarray[2],1) + bit.lshift(ledarray[3],2) + bit.lshift(ledarray[4],3) + bit.lshift(ledarray[5],4) + bit.lshift(ledarray[6],5) + bit.lshift(ledarray[7],6)
    bytes[2] = ledarray[8] + bit.lshift(ledarray[9],1) + bit.lshift(ledarray[10],2) + bit.lshift(ledarray[11],3) + bit.lshift(ledarray[12],4) + bit.lshift(ledarray[13],5) + bit.lshift(ledarray[14],6)
    bytes[3] = ledarray[15] + bit.lshift(ledarray[16],1) + bit.lshift(ledarray[17],2) + bit.lshift(ledarray[18],3) + bit.lshift(ledarray[19],4) + bit.lshift(ledarray[20],5) + bit.lshift(ledarray[21],6)
    bytes[4] = ledarray[22] + bit.lshift(ledarray[23],1) + bit.lshift(ledarray[24],2) + bit.lshift(ledarray[25],3) + bit.lshift(ledarray[26],4) + bit.lshift(ledarray[27],5) + bit.lshift(ledarray[28],6)
    bytes[5] = ledarray[29] + bit.lshift(ledarray[30],1) + bit.lshift(ledarray[31],2) + bit.lshift(ledarray[32],3) + bit.lshift(ledarray[33],4) + bit.lshift(ledarray[34],5) + bit.lshift(ledarray[35],6)
    bytes[6] = ledarray[36] + bit.lshift(ledarray[37],1) + bit.lshift(ledarray[38],2)

	remote.trace(implode(ledarray))	
	return bytes[1],bytes[2],bytes[3],bytes[4],bytes[5],bytes[6]
end

function SetLEDArray(ledarray)
    --# assuming 38 length array
    --# need to split array into (6) 7bit chunks
    --# Individual LED control is sent to the aftertouch MIDI command and channels 14, 15 and 16.
    --# Each of the data bytes transmit 7 LED states.
	-- now returns events
		ledarray = {1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0}
			 
				 				 
    local bytes = {0,0,0,0,0,0}

	bytes[1] = ledarray[1] + bit.lshift(ledarray[2],1) + bit.lshift(ledarray[3],2) + bit.lshift(ledarray[4],3) + bit.lshift(ledarray[5],4) + bit.lshift(ledarray[6],5) + bit.lshift(ledarray[7],6)
    bytes[2] = ledarray[8] + bit.lshift(ledarray[9],1) + bit.lshift(ledarray[10],2) + bit.lshift(ledarray[11],3) + bit.lshift(ledarray[12],4) + bit.lshift(ledarray[13],5) + bit.lshift(ledarray[14],6)
    bytes[3] = ledarray[15] + bit.lshift(ledarray[16],1) + bit.lshift(ledarray[17],2) + bit.lshift(ledarray[18],3) + bit.lshift(ledarray[19],4) + bit.lshift(ledarray[20],5) + bit.lshift(ledarray[21],6)
    bytes[4] = ledarray[22] + bit.lshift(ledarray[23],1) + bit.lshift(ledarray[24],2) + bit.lshift(ledarray[25],3) + bit.lshift(ledarray[26],4) + bit.lshift(ledarray[27],5) + bit.lshift(ledarray[28],6)
    bytes[5] = ledarray[29] + bit.lshift(ledarray[30],1) + bit.lshift(ledarray[31],2) + bit.lshift(ledarray[32],3) + bit.lshift(ledarray[33],4) + bit.lshift(ledarray[34],5) + bit.lshift(ledarray[35],6)
    bytes[6] = ledarray[36] + bit.lshift(ledarray[37],1) + bit.lshift(ledarray[38],2)
--[[

	for q=1,6 do
			remote.trace(	bytes[q])
			remote.trace("\n")
		end		 
		ledoutput ="ad " .. bytes[1] .. " " .. bytes[2] .. "ae " .. bytes[3] .. " " .. bytes[4].. "af " .. bytes[5] .. " " .. bytes[6]
			remote.trace(ledoutput)
		for q=1,6 do
			remote.trace(	bytes[q])
			remote.trace("\n")
		end		 
				 --]]	
    local retEvents={
		remote.make_midi("ad yy zz",{ y = bytes[1], z = bytes[2], port=1 }),
		remote.make_midi("ae yy zz",{ y = bytes[3], z = bytes[4], port=1 }),
		remote.make_midi("af yy zz",{ y = bytes[5], z = bytes[6], port=1 }),
	}
	return retEvents
--	return bytes[1],bytes[2],bytes[3],bytes[4],bytes[5],bytes[6]
end

function DrawCursor(height)
  --  # clear the deque - set all LEDs to off
local led_array_deque = {}
  for q=1,38 do
	led_array_deque[q] =0
end
    local cursor_pos = math.floor((height / 127.0) * 38.0)
    if cursor_pos > 38 then
        cursor_pos = 38
	end
    led_array_deque[cursor_pos] = 1 --# turn on one LED
    --SendArray(led_array_deque, MidiOut)
    --SetLEDArray(led_array_deque)
--remote.trace(implode(led_array_deque))
return led_array_deque

	
	
end









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
	--		{name="Fader",            	input="value",	output="value",	min=0,	max=127},
			{name="Fader",            	input="value",	output="nooutput",	min=0,	max=127},
			{name="led1",            	input="noinput",	output="value",	min=0,	max=127},
			{name="led2",            	input="noinput",	output="value",	min=0,	max=127},
			{name="led3",            	input="noinput",	output="value",	min=0,	max=127},
		}
--[[
		remote.trace("yes")
--		remote.trace(ledarray)		 
		remote.trace("yes")
		remote.trace(bit.lshift(0,1))
		remote.trace("yes")
		ledarray = {1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0}
		for q=0,37 do
			remote.trace(	ledarray[q])
			remote.trace("\n")
		end	
SendArray(ledarray)
--]]		
	g_led_index=table.getn(items)
--remote.trace(g_led_index)		
		remote.define_items(items)
		
		local inputs={

		
			{pattern="b0 14 xx",     	name="Fader"},

		}
		remote.define_auto_inputs(inputs)

		local outputs={
	--		{name="Fader"          ,	pattern="b0 14 xx"},
			{name="led1",	pattern="ad xx yy"},
			{name="led2",	pattern="ae xx yy"},
			{name="led3",	pattern="af xx yy"},
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
			{name="Modulation Wheel",  	input="value",	output="value",	min=0,	max=127},
		}
		remote.define_items(items)
		
		local inputs={

		
			{pattern="b0 14 xx",     	name="Modulation Wheel"},

		}
		remote.define_auto_inputs(inputs)

		local outputs={
			{name="Modulation Wheel",	pattern="b0 14 xx"},
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




	--g_led_index=1
 
function remote_probe()
	return {
	}
end

g_last_input_time=-2000

g_last_input_item=nil


function remote_on_auto_input(item_index)

	--if item_index>3 then

		g_last_input_time=remote.get_time_ms()

		g_last_input_item=item_index

	--end

end



g_last_input_x=-1

--[[
--]]

function remote_process_midi(event)
	ret=remote.match_midi("b0 14 xx",event)

	if ret~=nil then

		if g_last_input_x~=ret.x then
			ledarray=DrawCursor(ret.x)
			ledoutput ={SendArray(ledarray)}
		processed_events={
			remote.make_midi("ad xx yy",{ x = ledoutput[1], y = ledoutput[2], port=1 }),
			remote.make_midi("ae xx yy",{ x = ledoutput[3], y = ledoutput[4], port=1 }),
			remote.make_midi("af xx yy",{ x = ledoutput[5], y = ledoutput[6], port=1 }),
		}	
		--[[
			--local msg={ time_stamp=event.time_stamp, item=g_input_x_index, value=ret.x }
			remote.handle_input({ time_stamp=event.time_stamp, item=2, note=ledoutput[1],value=ledoutput[2] })
			remote.handle_input({ time_stamp=event.time_stamp, item=3, note=ledoutput[3],value=ledoutput[4] })
			remote.handle_input({ time_stamp=event.time_stamp, item=4, note=ledoutput[5],value=ledoutput[6] })

			--remote.handle_input(msg)
--]]
			

			g_led_state=implode(ledarray)
			
			

			g_last_input_x=ret.x

			--remote_on_auto_input(g_input_x_index)

		end


		return true

	end

	return false

end

g_is_led_enabled=false

--g_led_state=string.format("%-16.16s"," ")

--g_delivered_led_state=string.format("%-16.16s","#")


g_led_state=implode(ledarray)

g_delivered_led_state=implode(ledarray)

--remote.trace(g_led_state)

g_feedback_enabled=false


function remote_set_state(changed_items)
--[[
			remote.trace(changed_items[1])

	for i,item_index in ipairs(changed_items) do

		if item_index==g_led_index then

			g_is_led_enabled=remote.is_item_enabled(item_index)
			remote.trace("set state")

			ledarray=DrawCursor(remote.get_item_text_value(item_index))

			g_led_state=implode(ledarray)
			
			--remote.trace(g_led_state)

		end

	end



	local now_ms = remote.get_time_ms()

	if (now_ms-g_last_input_time) < 1000 then

		if remote.is_item_enabled(g_last_input_item) then

			local feedback_text=remote.get_item_name_and_value(g_last_input_item)

			if string.len(feedback_text)>0 then

				g_feedback_enabled=true

				g_led_state=string.format("%-16.16s",feedback_text)

			end

		end

	elseif g_feedback_enabled then

		g_feedback_enabled=false

		if g_is_led_enabled then

			old_text=remote.get_item_text_value(g_led_index)

		else

			old_text=" "

		end

		g_led_state=string.format("%-16.16s",old_text)

	end
--]]

end





function remote_deliver_midi(max_bytes,port)
--	if(port==1) then
	local ret_events={}
	local new_state=g_led_state

	thisledarray = {1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0}
	--	for q=1,6 do
	--		remote.trace(	ledoutput[q])
	--		remote.trace("<<\n")
	--	end		 
	if g_delivered_led_state~=new_state then
--[[
remote.trace(g_led_state)
remote.trace("----\n")

		ledoutput ={SendArray(ledarray)}
		
		local ret_events={
			remote.make_midi("ad xx yy",{ x = ledoutput[1], y = ledoutput[2], port=1 }),
			remote.make_midi("ae xx yy",{ x = ledoutput[3], y = ledoutput[4], port=1 }),
			remote.make_midi("af xx yy",{ x = ledoutput[5], y = ledoutput[6], port=1 }),
		}	
		g_delivered_led_state=new_state
--]]
ret_events=processed_events
	end
	return ret_events
		


	
	
	
	
--	end --end port==1
--[[
	
	if(port==2) then
		local retLevels=remote.make_midi("b0 14 yy", { x=mode, y=value, port=2 })
		return retLevels
	end
--]]	

end


function remote_prepare_for_use()

	if Thismodel == "VMeter Fader" then
		local retEvents={
			remote.make_midi(SetVel, { port=1 } ),

			remote.make_midi(UPSIDE_DOWN_ON, { port=1 } ),

			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),

			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),

			remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ),

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
