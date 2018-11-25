---------------------------------------------------------------------------------
-- scs3d namespace
---------------------------------------------------------------------------------

scs3d = {}
scs3d.cache = {}
scs3d.off = 0
scs3d.on = 1
scs3d.red = 1
scs3d.blue = 2
scs3d.purple = 3
scs3d.page = {
	["fx"] = 1,
	["eq"] = 2,
	["loop"] = 3,
	["trig"] = 4,
	["vinyl"] = 5
}

-- led feedback

scs3d.leds = {
	["peak"] = {
		["values"] = { 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30, 
						0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38 },
		["fader1"] = 10,
		["fader2"] = 10,
		["fader3"] = 17,
		["fader4"] = 8,
		["fader5"] = 8,
		["fader6"] = 8
	},
	["spread"] = { 
		["values"] = { 0x3c, 0x3d, 0x3e, 0x3f, 0x40, 0x41, 0x42, 0x43, 0x44 },
		["fader1"] = 6,
		["fader2"] = 6,
		["fader3"] = 9,
		["fader4"] = 5,
		["fader5"] = 5,
		["fader6"] = 5
	},
	["boost"] = {
		["values"] = { 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 
						0x1d, 0x1e, 0x1f, 0x20, 0x21 },
		["fader1"] = 10,
		["fader2"] = 10,
		["fader3"] = 14,
		["fader4"] = 8,
		["fader5"] = 8,
		["fader6"] = 8
		
	},
	["trace"] = {
		["values"] = { 0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA,
						0xB, 0xC, 0xD, 0xE, 0xF, 0x10 },
		["fader1"] = 10,
		["fader2"] = 10,
		["fader3"] = 17,
		["fader4"] = 8,
		["fader5"] = 8,
		["fader6"] = 8
	},
	["fader3"] = {
		["values"] = { 0x5d, 0x5e, 0x5f, 0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66,
					0x67, 0x68, 0x69, 0x6a, 0x6b, 0x6c },
		["fader3"] = 16
	},
	["button"] = {
		{ 0x62, 0x63 },
		{ 0x61, 0x62 },
		{ 0x60, 0x5f },
		{ 0x5f, 0x5e },

		{ 0x63, 0x64, 0x65, 0x66 },
		{ 0x61, 0x68, 0x62, 0x67 },
		{ 0x60, 0x69, 0x5f, 0x6a },
		{ 0x6b, 0x6c, 0x5d, 0x5e },

		{ 0x66, 0x67 },
		{ 0x68, 0x67 },
		{ 0x69, 0x6a },
		{ 0x6a, 0x6b }
	}
}

-- func to return value needed based on fader mode

function scs3d.led_value(e, mode, v)
	return scs3d.leds[mode]["values"][math.abs(math.floor(v / 127 * scs3d.leds[mode][e] + 0.5)) + 1]
end


function scs3d.set_fader_mode(d, e, p, mode, turn_off_on_release)

	-- fader mode doesn't apply in button mode

	capture(d, e, ALL, p, function(d, e, v, p)
		if (e == "fader3" or e == "fader4" or e == "fader5") 
			and scs3d.cache[d]["mode"] == "button" then 
				return 
		end
		send(d, e, scs3d.led_value(e, mode, v))
	end)

	-- turn the light off in trace mode on release

	if turn_off_on_release ~= nil and turn_off_on_release == true then
		capture(d, e.."_press", ALL, p, function(d1, e1, v1, p1)
			if (e == "fader3" or e == "fader4" or e == "fader5") 
				and scs3d.cache[d]["mode"] == "button" then 
					return 
			end
			if v1 == 0 then
				send(d, e, scs3d.off)
			end
		end)
	end
end

-- change mode functions

function scs3d.set_mode(device, val)
	if val == "slider" then
		scs3d.slider_mode(device)
	elseif val == "button" then
		scs3d.button_mode(device)
	else
		scs3d.circle_mode(device)
	end
end

--
-- buttons + faders 5+6
-- F0 00 01 60 01 01 f7
--
-- faders 4,5 + buttons
-- F0 00 01 60 01 02 f7
--
-- circle mode
-- F0 00 01 60 01 00 f7
--

function scs3d.circle_mode(d)
	scs3d.cache[d]["mode"] = "circle"
	send_midi_raw(d, 240, 0, 1, 96, 1, 0, 247)
end

--
-- slider mode
-- F0 00 01 60 01 03 f7
--

function scs3d.slider_mode(d)
	scs3d.cache[d]["mode"] = "slider"
	send_midi_raw(d, 240, 0, 1, 96, 1, 3, 247)
end

--
-- button mode
-- F0 00 01 60 01 04 f7
--

function scs3d.button_mode(d)
	scs3d.cache[d]["mode"] = "button"
	send_midi_raw(d, 240, 0, 1, 96, 1, 4, 247)
end

-- 
-- select layer from one of fx, eq, loop, trig or vinyl and set
-- the mode for the main circular area
--

function scs3d.select_layer(d, e)
	if scs3d.cache[d]["layer"] == "vinyl" then
		send(d, "fader3", 0)
	end

	send(d, scs3d.cache[d]["layer"], scs3d.blue)
	send(d, e, scs3d.red) 
	scs3d.cache[d]["layer"] = e
	--if scs3d.page[e] ~= nil then set_page(d, scs3d.page[e]) end
end

--
-- set the mode for each layer
--

function scs3d.set_layer_mode(d, e, mode)
	capture(d, e, ALL, 0, function(d, e, v, p)
		if v > 0 then
			scs3d.set_mode(d, mode)
			scs3d.select_layer(d, e)
		end
	end)
end

function scs3d.deck_select(d)
	send(d, "fader3", 0)

	if get(d, "deck") == 0 then
		send(d, "deck_b", scs3d.off)
		send(d, "deck_a", scs3d.on)
	else
		send(d, "deck_b", scs3d.on)
		send(d, "deck_a", scs3d.off)
	end
end

--
-- set up the required callbacks and defaults
--

function scs3d.init(d, add_layer_controls)
	scs3d.set_layer_mode(d, "fx", "slider")
	scs3d.set_layer_mode(d, "eq", "slider")
	scs3d.set_layer_mode(d, "loop", "button")
	scs3d.set_layer_mode(d, "trig", "button")
	scs3d.set_layer_mode(d, "vinyl", "circle")

	-- init vars

	scs3d.cache[d] = {}
	scs3d.cache[d]["layer"] = "vinyl"
	scs3d.cache[d]["mode"] = "slider"
	scs3d.cache[d]["beat_phase_a"] = 0
	scs3d.cache[d]["beat_phase_b"] = 0
	scs3d.cache[d]["circle_pos_a"] = 0
	scs3d.cache[d]["circle_pos_b"] = 0

	-- init leds

	send(d, "vinyl", scs3d.red)
	send(d, "fx", scs3d.blue)
	send(d, "eq", scs3d.blue)
	send(d, "loop", scs3d.blue)
	send(d, "trig", scs3d.blue)
	send(d, "btn1", scs3d.blue)
	send(d, "btn2", scs3d.blue)
	send(d, "btn3", scs3d.blue)
	send(d, "btn4", scs3d.blue)

	-- default layer

	scs3d.select_layer(d, "vinyl")
	scs3d.circle_mode(d)

	-- deck a/b button

	toggle_modifier(d, "deck", 0, scs3d.blue, scs3d.red, nil, scs3d.deck_select)
	send(d, "deck_b", scs3d.off)
	send(d, "deck_a", scs3d.on)

	-- create 2 hold modifiers and 2 toggle ones

	toggle_modifier(d, "btn1", 0, scs3d.red, scs3d.blue)
	toggle_modifier(d, "btn2", 0, scs3d.red, scs3d.blue)
	hold_modifier(d, "btn3", 0, scs3d.red, scs3d.blue)
	hold_modifier(d, "btn4", 0, scs3d.red, scs3d.blue)

	--
	-- emulate 4 buttons from central fader when in button mode
	--

	scs3d.cache[d]["fader5"] = 0
	scs3d.cache[d]["fader5_pressed"] = 0

	-- capture the fader5 value

	capture(d, "fader5", ALL, 0, function(d, e, v, p)
		scs3d.cache[d]["fader5"] = v
	end)

	-- send out button press events based on the fader5 value
	-- so in button mode we have a 3x4 grid of buttons we can map
	-- we get the fader5_press event before the actual value from fader5
	-- so we only use the fader5_press event to identify that a button has been
	-- pressed but send out the data on the fader5 event (ass)
	-- we can however send out a note off on release from fader5_press

	capture(d, "fader5_press", ALL, 0, function(d, e, v, p)

		if scs3d.cache[d]["mode"] ~= "button" then return end

		if v > 0 then
			scs3d.cache[d]["fader5_pressed"] = 1
		else
			btn = scs3d.fader5_button(scs3d.cache[d]["fader5"])
			create(d, btn, 0)
			scs3d.cache[d]["fader5_pressed"] = 0
		end
	end)

	capture(d, "fader5", ALL, 0, function(d, e, v, p)
	
		if scs3d.cache[d]["fader5_pressed"] == 0 then return end
		if scs3d.cache[d]["mode"] ~= "button" then return end

		scs3d.cache[d]["fader5_pressed"] = 0
		btn = scs3d.fader5_button(v)
		create(d, btn, v)
	end)

	-- led feedback for button mode

	for i = 1,12 do
		capture(d, "loop"..i, ALL, 0, function(d, e, v, p)
			local btn = i
			send(d, "fader3", 0, scs3d.off)
			if v > 0 then
				for i1,v2 in ipairs(scs3d.leds["button"][btn]) do
					send_midi(d, 1, MIDI_NOTE_ON, v2, scs3d.on)
				end
			end
		end)
	end

	for i = 1,12 do
		capture(d, "trig"..i, ALL, 0, function(d, e, v, p)
			local btn = i
			send(d, "fader3", 0, scs3d.off)
			if v > 0 then
				for i1,v2 in ipairs(scs3d.leds["button"][btn]) do
					send_midi(d, 1, MIDI_NOTE_ON, v2, scs3d.on)
				end
			end
		end)
	end

	-- optionally add extra events

	if add_layer_controls == nil or add_layer_controls == true then
		scs3d.add_layer_controls(d)
	end
end

function scs3d.fader5_button(val)
	if val < 24 then return "3,1"
	elseif val < 64 then return "2,1"
	elseif val < 103 then return "1,1"
	else return "0,1" end
end

function scs3d.spinning_jog(d, deck, mode)

	local deck_id

	if deck == "a" then	
		deck_id = 0
	elseif deck == "b" then
		deck_id = 1
	else
		print("scs3d.spinning_platter(device, deck, mode) ERROR: deck must be \"a\" or \"b\"")
		return
	end

	if mode == nil then
		mode = "vinyl"
	end

	-- cdj style spinning led's, assume it's for traktor
	-- tsi ranges from 0 to 16 roughly twice a second (at 120bpm)
	-- need to make it feel more like a 33rpm record
	-- the +10/-10 code is to make a guess as to whether the beat phase has reset 
	-- or if the platter is being spun backwards

	capture("traktor", "beat_phase_monitor_"..deck, ALL, 0, function(td, e, v, p)

		if v ~= scs3d.cache[d]["beat_phase_"..deck] then

			diff = v - scs3d.cache[d]["beat_phase_"..deck]

			if diff < -10 then 
				diff = diff + 16
			elseif diff > 10 then 
				diff = diff - 16
			end

			scs3d.cache[d]["circle_pos_"..deck] = scs3d.cache[d]["circle_pos_"..deck] + diff
			scs3d.cache[d]["beat_phase_"..deck] = v

			if scs3d.cache[d]["circle_pos_"..deck] >= 64 then
				scs3d.cache[d]["circle_pos_"..deck] = scs3d.cache[d]["circle_pos_"..deck] - 64
			elseif scs3d.cache[d]["circle_pos_"..deck] < 0 then
				scs3d.cache[d]["circle_pos_"..deck] = scs3d.cache[d]["circle_pos_"..deck] + 64
			end

			if get(d, "deck") == deck_id and scs3d.cache[d]["layer"] == mode then
				send(d, "fader3", scs3d.cache[d]["circle_pos_"..deck] / 4 + 1)
			end
		end
	end)
end

--
-- add some extra events depending on the current layer/page/mode
--

function scs3d.add_layer_control(d, layer, map)
	if type(map) == "table" then
		for e,ne in pairs(map) do
			capture(d, e, ALL, 0, function(d, e, v, p)
				if scs3d.cache[d]["layer"] == layer then
					create(d, ne, v)
				end
			end)
			capture(d, e .. "_relative", ALL, 0, function(d, e, v, p)
				if scs3d.cache[d]["layer"] == layer then
					create(d, ne .. "_relative", v)
				end
			end)
			capture(d, e .. "_press", ALL, 0, function(d, e, v, p)
				if scs3d.cache[d]["layer"] == layer then
					create(d, ne .. "_press", v)
				end
			end)
		end
	end
end

--
-- add alternative set of events depending on what mode the unit is in
--

function scs3d.add_layer_controls(d)

	scs3d.add_layer_control(d, "vinyl", {
		["fader3"] = "jog_wheel",
		["fader5"] = "jog_scratch"
	})

	scs3d.add_layer_control(d, "fx", {
		["fader4"] = "fx_fader1",
		["fader5"] = "fx_fader2",
		["fader6"] = "fx_fader3"
	})

	scs3d.add_layer_control(d, "eq", {
		["fader4"] = "eq_fader1",
		["fader5"] = "eq_fader2",
		["fader6"] = "eq_fader3"
	})

	scs3d.add_layer_control(d, "loop", {
		["fader5"] = "loop_fader",
		["0,0"] = "loop1",
		["1,0"] = "loop2",
		["2,0"] = "loop3",
		["3,0"] = "loop4",
		["0,1"] = "loop5",
		["1,1"] = "loop6",
		["2,1"] = "loop7",
		["3,1"] = "loop8",
		["0,2"] = "loop9",
		["1,2"] = "loop10",
		["2,2"] = "loop11",
		["3,2"] = "loop12"
	})

	scs3d.add_layer_control(d, "trig", {
		["fader5"] = "trig_fader",
		["0,0"] = "trig1",
		["1,0"] = "trig2",
		["2,0"] = "trig3",
		["3,0"] = "trig4",
		["0,1"] = "trig5",
		["1,1"] = "trig6",
		["2,1"] = "trig7",
		["3,1"] = "trig8",
		["0,2"] = "trig9",
		["1,2"] = "trig10",
		["2,2"] = "trig11",
		["3,2"] = "trig12"
	})
end





