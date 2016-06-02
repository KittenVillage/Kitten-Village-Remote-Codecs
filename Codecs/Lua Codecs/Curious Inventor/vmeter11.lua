-- set some globals
g_ledarray = {}
for q=1,38 do
	g_ledarray[q] =0
end
g_current_state=-1
g_last_state_delivered=-1
g_led_state=table.concat(g_ledarray)
g_delivered_led_state=table.concat(g_ledarray)
g_thismodel = ""
g_last_noteonoff = -1
g_current_noteonoff = -1
	thisledarray = {1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0,1,0,
                 1,0,1,0,1,0,1,0}

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
PITCH_WHEEL_RETURN_SPEED = "B0 " .. PITCH_WHEEL_RETURN_SPEED_CTRL .. " 02"

--Chan 1 
Ch1Main  = "B0 "..	MAIN_PARAM_CTRL	
SetVel = "B0 " .. CHANGE_NOTEOUT_VEL_CTRL .. " " .. Vel
ClearLED ="B0 14 00"

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
--RECALIBRATE = Ch1Main ..	"70"
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



-- Thanks, Livid
--for some Reason (pun intended) I need to define a modulo function. just using the % operator was throwing errors :(
function modulo(a,b)
	local mo = a-math.floor(a/b)*b
	return mo
end








function SetLEDArray(ledarray)
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

--	remote.trace(table.concat(ledarray))	
	return bytes[1],bytes[2],bytes[3],bytes[4],bytes[5],bytes[6]
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
--   if cursor_pos < 1 then
--        cursor_pos = 1
--	end
    led_array_deque[cursor_pos] = 1 --# turn on one LED
    --SetLEDArray(led_array_deque)
--remote.trace(table.concat(led_array_deque))
return led_array_deque	
end



--# draws a bar centered at height position with a given size.
--# Kinda like a fat cursor.
function DrawBar(height,size)
  --  # clear the deque - set all LEDs to off
	local led_array_deque = {}
	for q=1,38 do
		led_array_deque[q] =0
	end

    local cursor_pos = math.floor((height / 127.0) * 38.0)

    local lower_limit = cursor_pos - math.floor(size / 2)
   if lower_limit < 1 then
        lower_limit = 1
		end
    local upper_limit = cursor_pos + math.floor(size / 2)
    if upper_limit > 38 then
        upper_limit = 38
	end
    local i = lower_limit
    while i <= upper_limit do
        led_array_deque[i] = 1
        i = i + 1
	end
    return led_array_deque
end

--[[
# A Game of Life simulation is usually performed on a 2D matrix, but here
# we apply similar rules to the 1D VMeter array of LEDs.
# Each cycle, a given LED is turned on or off based on how many of its neighbors
# are on or off.
# Different starting configurations will result in different patterns,
# some die off, some enter into a repeating cycle, and others continue to
# evolve.
# Touching the VMeter will cause the LEDs touched to switch states, which can restart
# a simulation that has died off.
function GameOfLife(pos)
    led_array = {1,1,1,1,1,1,1,0,0,0,
                 0,0,0,0,0,0,1,1,1,1,
                 0,1,1,0,0,1,1,1,0,0,
                 0,0,0,1,0,0,0,0}
#    led_array = {1,0,1,1,1,1,1,0,0,0,
#                 0,0,0,0,0,0,1,1,1,1,
#                 0,1,1,0,0,1,1,1,0,0,
#                 0,0,0,1,0,0,1,0}
#    led_array = {1,0,0,0,0,0,0,0,0,0,
#                 0,0,0,0,0,0,1,0,1,0,
#                 0,1,0,0,0,1,0,0,0,0,
#                 0,0,0,1,0,0,0,0}
    last_cycle_time = 0
    local i = 0
 --   while True:
 --       while MidiIn.Poll(): # invert LEDs where touched
 --           MidiData = MidiIn.Read(1)
 --           if MidiData[0][0][0] == 0xB0:
 --               if MidiData[0][0][1] == 20:
 --                   pos = MidiData[0][0][2]
 --                   index_pos = int(float(pos) / 127.0 * 37.0)
 
    local index_pos = math.floor((height / 127.0) * 38.0)
--#                    print "index pos: ", index_pos
	if led_array[index_pos] == 1 then
		led_array[index_pos] = 0
	else
		led_array[index_pos] = 1
	end
	if remote.get_time_ms() - last_cycle_time > 100 then
		last_cycle_time = remote.get_time_ms()
 --           index_array = range(3,36)
	index_array = {}
	for i=3, 36 do
	  index_array[i] = 0
	end
			
	new_array = led_array
	# copy over 4 edge LEDs since they don't have 4 neighbors.
	new_array[1] = led_array[1]
	new_array[2] = led_array[2]
	new_array[37] = led_array[37]
	new_array[38] = led_array[38]
			
--            for i in index_array do
	for i,v in ipairs(index_array) do
 --todo:
	   sum =led_array[i-2]+led_array[i-1]+led_array[i+1]+led_array[i+2]
		if led_array[i] == 1 then -- # live cell
			if sum < 1 then
				new_array[i] = 0 --# under population
			elseif sum < 3 then
				new_array[i] = 1 --# just right
			else 
				new_array[i] = 0 --# overcrowding
			end
		else --# dead cell
			if sum == 2 or sum == 3 then
				new_array[i] = 1
			else
				new_array[i] = 0
			end
		end
	end    
	led_array = new_array            
	return led_array
end 

			
--]] 


function DrawNote(note)
  --  # clear the deque - set all LEDs to off
	local led_array_deque = {}
	for q=1,39 do
		led_array_deque[q] =0
		if modulo(q,3) == 0 then -- Give me some targets for the notes.
			led_array_deque[q - 1] =1
		end
		
	end
--	if (height > 9) and (height < 118) then -- 3 leds per note \ 0-9 and 118-127 blank
--		local note = math.ceil((height-9) / 9) -- returns 1 to 12 \ 1 and 38 blank

	if g_current_noteonoff == 1 then
        led_array_deque[(note*3)-1] = 1
        led_array_deque[(note*3)]   = 1
        led_array_deque[(note*3)+1] = 1
	end

    return led_array_deque
end






function remote_init(manufacturer, model)

	g_thismodel = model

	if model == "VMeter Fader" then
		local items={
			{name="Fader", input="value",	output="value",	min=0,	max=127},
		}
		g_led_index=table.getn(items)
		remote.define_items(items)
		local inputs={
			{pattern="b0 14 xx",     	name="Fader"},
		}
		remote.define_auto_inputs(inputs)

		local outputs={
		{name="Fader"          ,	pattern="b0 14 xx"},
		}
		remote.define_auto_outputs(outputs)
		
	elseif model == "VMeter Fader Fat Cursor" then
		local items={
			{name="Fader", input="value",	output="value",	min=0,	max=127},
		}
		g_led_index=table.getn(items)
		remote.define_items(items)
		local inputs={
			{pattern="b0 14 xx",     	name="Fader"},
		}
		remote.define_auto_inputs(inputs)

		local outputs={
		{name="Fader"          ,	pattern="b0 16 xx"},
		}
		remote.define_auto_outputs(outputs)
		
	elseif model == "VMeter Fader Single Cursor" then
		local items={
			{name="Fader", input="value",	output="value",	min=0,	max=127},
		}
		g_led_index=table.getn(items)
		remote.define_items(items)
		local inputs={
			{pattern="b0 14 xx",     	name="Fader"},
		}
		remote.define_auto_inputs(inputs)

		local outputs={
		{name="Fader"          ,	pattern="b0 16 xx"},
		}
		remote.define_auto_outputs(outputs)
		
	elseif model == "VMeter Fader Gravity" then
		local items={
			{name="Fader", input="value",	output="value",	min=0,	max=127},
		}
		g_led_index=table.getn(items)
		remote.define_items(items)
		local inputs={
			{pattern="b0 14 xx",     	name="Fader"},
		}
		remote.define_auto_inputs(inputs)

		local outputs={
		{name="Fader"          ,	pattern="b0 16 xx"},
		}
		remote.define_auto_outputs(outputs)
		
	elseif model == "VMeter Game of Life Demo" then
		local items={
			{name="Fader", input="value",	output="value",	min=0,	max=127},
		}
		g_led_index=table.getn(items)
		remote.define_items(items)
		local inputs={
			{pattern="b0 14 xx",     	name="Fader"},
		}
		remote.define_auto_inputs(inputs)

		local outputs={
		{name="Fader"          ,	pattern="b0 16 xx"},
		}
		remote.define_auto_outputs(outputs)
		
		
	
	elseif model == "VMeter Notes" then
		local items=
		{
		{name="Keyboard",          	input="keyboard"},
	--	{name="Channel Aftertouch",	input="value",	               	min=0,	max=127},
		}
		g_led_index=table.getn(items)
		remote.define_items(items)
		
		local inputs={

		
			{pattern="<100x>0 yy zz",	name="Keyboard"},
	--		{pattern="b0 12 xx",        	name="Channel Aftertouch"},

		}
		remote.define_auto_inputs(inputs)

		local outputs={
		}
		remote.define_auto_outputs(outputs)
		

	elseif model == "VMeter Pitch Wheel" then
		local items=
		{
			{name="Pitch Bend Wheel",  	input="value",	               	min=0,	max=16383},
		}
		g_led_index=table.getn(items)
		remote.define_items(items)
		
		local inputs={
			{pattern="e0 xx yy",     	name="Pitch Bend Wheel", value="y * 128 + x"},
		}
		remote.define_auto_inputs(inputs)

		local outputs={
		}
		remote.define_auto_outputs(outputs)


	elseif model == "VMeter Modulation Wheel" then
		local items=
		{
			{name="Modulation Wheel",  	input="value",	output="value",	min=0,	max=127},
		}
		g_led_index=table.getn(items)
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
		g_led_index=table.getn(items)
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
		g_led_index=table.getn(items)
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
		
		g_led_index=table.getn(items)
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
		
		g_led_index=table.getn(items)
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

	if item_index==1 then

		g_last_input_time=remote.get_time_ms()

		g_last_input_item=item_index

	end

end






function remote_process_midi(event)
	-- local ret = nil
	if ((g_thismodel == "VMeter Fader Fat Cursor") or (g_thismodel == "VMeter Fader Single Cursor")) then
		ret=remote.match_midi("b0 "..MIDI_POS_OUT_CTRL.." xx",event)
		if ret~=nil then
			local new_state=ret.x
			if g_last_state_delivered~=new_state then
				g_current_state=new_state
			end
			--return true
		end
	elseif g_thismodel == "VMeter Notes" then
		ret = remote.match_midi("<100x>? yy zz",event) --find a note on or off
		if ret~=nil then
			local new_noteonoff = ret.x
			local new_notein=ret.y
			local new_notevel = ret.z 
--			remote.trace("new_notein "..tostring(new_notein))
			if (new_notein > 9) and (new_notein < 118) then -- 3 leds per note \ 0-9 and 118-127 blank
				local new_state = math.ceil((new_notein - 9) / 9) -- returns 1 to 12 \ 1 and 38 blank
				local new_noteout = new_state + 35  -- Middle octave
				local msg={ time_stamp = event.time_stamp, item=1, value = new_noteonoff, note = new_noteout,velocity = new_notevel }
				remote.handle_input(msg)
				if (g_last_state_delivered~=new_state) then -- draw new note
					g_current_state=new_state
					g_current_noteonoff = new_noteonoff
				elseif g_last_noteonoff~=new_noteonoff then
					g_current_noteonoff = new_noteonoff
				end
				return true -- changed
			else -- note out of range
				return true -- out of range, should stop input 
			end
			--return true 
		end
	end -- g_thismodel check
	return false --false because we detect, not change the input
end


function remote_set_state(changed_items)

	for i,item_index in ipairs(changed_items) do

		if item_index==g_led_index then
			local new_state=remote.get_item_value(item_index)
			if g_last_state_delivered~=new_state then
				g_current_state=new_state
			end
		end
	end
--[[
-- All this removed because we want immediate output

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
	local ret_events={}
	local new_state=g_current_state
	local new_noteonoff=g_current_noteonoff
--These are only set in an led array function
	if (g_last_state_delivered~=new_state) or (g_last_noteonoff~=new_noteonoff) then
	
-- other led functions go here depending on type.  
		--g_ledarray=DrawCursor(new_state)
		--g_ledarray=DrawCursor(new_state)
		local ledoutput = {}
		--ledoutput ={SetLEDArray(g_ledarray)}
		
		if g_thismodel == "VMeter Fader Single Cursor" then
			ledoutput ={SetLEDArray(DrawCursor(new_state))}
		elseif g_thismodel == "VMeter Fader Fat Cursor" then
			ledoutput ={SetLEDArray(DrawBar(new_state, 5))}
		elseif g_thismodel == "VMeter Notes" then
			ledoutput ={SetLEDArray(DrawNote(new_state))}
		end
		ledoutput ={SetLEDArray(DrawNote(new_state))}
		ret_events={
			remote.make_midi("ad xx yy",{ x = ledoutput[1], y = ledoutput[2], port=1 }),
			remote.make_midi("ae xx yy",{ x = ledoutput[3], y = ledoutput[4], port=1 }),
			remote.make_midi("af xx yy",{ x = ledoutput[5], y = ledoutput[6], port=1 }),
		}	
		g_last_state_delivered = new_state
		g_last_noteonoff = new_noteonoff
	end
	return ret_events
end


function remote_prepare_for_use()

	if g_thismodel == "VMeter Fader" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents

	elseif g_thismodel == "VMeter Fader Single Cursor" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents

	elseif g_thismodel == "VMeter Fader Fat Cursor" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents

	elseif g_thismodel == "VMeter Fader Gravity" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents

	elseif g_thismodel == "VMeter Game of Life Demo" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_DISABLE, { port=1 } ),
		}
		return retEvents



	elseif g_thismodel == "VMeter Notes" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
			remote.make_midi(SetVel, { port=1 } ),
			remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
			--remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(LEDS_IGNORE_TOUCH, { port=1 } ),
			remote.make_midi(PITCH_WHEEL_DISABLE, { port=1 } ),
			remote.make_midi(TOUCH_POS_OUT_DISABLE, { port=1 } ),
			remote.make_midi(PRES_OUT_DISABLE, { port=1 } ),
			remote.make_midi(ON_OFF_OUT_DISABLE, { port=1 } ),
			remote.make_midi(NOTE_OUT_ENABLE, { port=1 } ),
			remote.make_midi(NOTEOUT_VEL_FROM_PRESET, { port=1 } ),
			remote.make_midi(NOTEOUT_PITCH_FROM_POS, { port=1 } ),
		}
		return retEvents

	elseif g_thismodel == "VMeter Pitch Wheel" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
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
	elseif g_thismodel == "VMeter Modulation Wheel" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
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

		
	elseif g_thismodel == "VMeter Crossfader" then
		local retEvents={
			remote.make_midi(ClearLED, { port=1 } ),
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
		
	elseif g_thismodel == "VMeter Button" then
		local retEvents={
			remote.make_midi(SetVel, { port=1 } ),
			
		}
		return retEvents
		
	elseif g_thismodel == "VMeter Delta" then
		local retEvents={
			remote.make_midi(SetVel, { port=1 } ),
			
		}
		return retEvents
		
	elseif g_thismodel == "VMeter Meter" then
		local retEvents={
			remote.make_midi(SetVel, { port=1 } ),
			
		}
		return retEvents
		
	end --if
end
	



function remote_release_from_use()
	local retEvents={
		remote.make_midi(UPSIDE_DOWN_OFF, { port=1 } ),
		remote.make_midi(TOUCH_POS_OUT_ENABLE, { port=1 } ), 
		remote.make_midi(LEDS_DONT_IGNORE_TOUCH, { port=1 } ),
		remote.make_midi(ClearLED, { port=1 } ),
	}
	return retEvents
end
