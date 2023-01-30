minetest.register_chatcommand("openinv", {
    params = "<player>",
    description = "Open another player's inventory",
func = function(name, param)
    if not minetest.check_player_privs(name, {kick=true}) then
        return false, "You don't have the 'kick' priv."
    end
local target = param
    if target == "" then
    return false, "No player name given"
end
    local target_player = minetest.get_player_by_name(target)
    if target_player == nil then
return false, "Player not found: " .. target
end
local target_player = minetest.get_player_by_name(target)
if target_player == nil then
return false, "Player not found: " .. target
end
local inv = target_player:get_inventory()
local formspec = "size[8,9]"
formspec = formspec .. "label[2.75,-0.35;Inventory of " .. target .. "]"
for i=1,32 do
local stack = inv:get_stack("main", i)
local itemname = stack:get_name()
local itemcount = stack:get_count()
formspec = formspec .. "item_image_button[" .. (i-1)%8 .. "," .. math.floor((i-1)/8) .. ";1,1;" .. itemname .. " " .. itemcount .. ";inv" .. i .. ";]"
end
local privs = minetest.get_player_privs(target)
local privs_string = ""
local count = 0
for priv, value in pairs(privs) do
if value then
privs_string = privs_string .. priv .. ", "
count = count + 1
if count == 7 then
privs_string = privs_string .. "\n"
end
if count == 14 then
privs_string = privs_string .. "\n"
end
end
end
privs_string = privs_string:sub(1, -3)

local pos = target_player:get_pos()
local rounded_x = math.ceil(pos.x)
local rounded_y = math.ceil(pos.y)
local rounded_z = math.ceil(pos.z)
local node = minetest.get_node({x=rounded_x, y=rounded_y-1, z=rounded_z})
local node_name = node.name
formspec = formspec .. "label[0,4.5;Block: " .. node_name .. "]" .. "label[0,5.5;Coords: " .. rounded_x .. ", " .. rounded_y .. ", " .. rounded_z .. "]" .. "label[0,6;Privs: " .. privs_string .. "]" .. "label[0,5.0;IP: " .. minetest.get_player_ip(target) .. "]" .. "label[0,7.5;Player: " .. target .. "]" .. "button[0.15,8;2,1;tp;Teleport]" .. "button[2.15,8;2,1;kick;Kick]" .. "button[4.15,8;2,1;quit;Quit]" .. "button[6.15,8;2,1;refresh;Refresh]"
minetest.show_formspec(name, "openinv:" .. target, formspec)
end,
})
minetest.register_on_player_receive_fields(function(player, formname, fields)
if formname:sub(0, 8) ~= "openinv:" then
return
end
----------------------------------------------------------------------------------------------------------------------------
if fields.tp then
local player_name = player:get_player_name()
local target_name = formname:sub(9)
local target_player = minetest.get_player_by_name(target_name)
minetest.get_player_by_name(player_name):setpos({x=math.ceil(target_player:getpos().x), y=math.ceil(target_player:getpos().y), z=math.ceil(target_player:getpos().z)})
end
----------------------------------------------------------------------------------------------------------------------------
if fields.interact then
local player_name = player:get_player_name()
local target_name = formname:sub(9)
local target_player = minetest.get_player_by_name(target_name)
local target_inv = target_player:get_inventory()

-- Code for moving or destroying items in the target player's inventory goes here
end
if fields.quit then
minetest.close_formspec(player:get_player_name(), "openinv:" .. formname:sub(9))
end
----------------------------------------------------------------------------------------------------------------------------
if fields.refresh then
local target_name = formname:sub(9)
local target_player = minetest.get_player_by_name(target_name)
local inv = target_player:get_inventory()
local pos = target_player:get_pos()
local node_under_player = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
local privs = minetest.get_player_privs(target_name)
local privs_string = ""
local count = 0
for priv, value in pairs(privs) do
if value then
privs_string = privs_string .. priv .. ", "
count = count + 1
if count == 7 then
privs_string = privs_string .. "\n"
end
if count == 14 then
privs_string = privs_string .. "\n"
end
end
end
privs_string = privs_string:sub(1, -3)

local player_ip = minetest.get_player_ip(target_name)
local pos = target_player:get_pos()
local rounded_x = math.ceil(pos.x)
local rounded_y = math.ceil(pos.y)
local rounded_z = math.ceil(pos.z)
local formspec = "size[8,9]"
formspec = formspec .. "label[2.75,-0.35;Inventory of " .. target_name .. "]"
formspec = formspec .. "label[0,7.5;Player: " .. target_name .. "]"
formspec = formspec .. "label[0,4.5;Block: " .. node_under_player .. "]"
formspec = formspec .. "label[0,6;Privs: " .. privs_string .. "]"
formspec = formspec .. "label[0,5.0;IP: " .. player_ip .. "]"
formspec = formspec .. "label[0,5.5;Coords: "  .. rounded_x .. ", " .. rounded_y .. ", " .. rounded_z .. "]"

formspec = formspec .. "button[4.15,8;2,1;quit;Quit]"
formspec = formspec .. "button[2.15,8;2,1;kick;Kick]"
formspec = formspec .. "button[6.15,8;2,1;refresh;Refresh]"
formspec = formspec .. "button[0.15,8;2,1;tp;Teleport]"

for i=1,32 do
local stack = inv:get_stack("main", i)
local itemname = stack:get_name()
local itemcount = stack:get_count()
formspec = formspec .. "item_image_button[" .. (i-1)%8 .. "," .. math.floor((i-1)/8) .. ";1,1;" .. itemname .. " " .. itemcount .. ";inv" .. i .. ";]"
end

minetest.show_formspec(player:get_player_name(), formname, formspec)
end

if fields.kick then
local target_name = formname:sub(9)
minetest.kick_player(target_name, "You have been kicked.")
end
end)


