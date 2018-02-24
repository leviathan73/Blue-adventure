pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
 -- ball screen cords
	x=60
	y=90
	
	-- ball map cords
 mx=flr(x/8)
 my=flr(y/8)
	 
 -- ball movment vector
	dx=1
	dy=-1
	
	-- aiming cord
	aim_x = 0
	aim_y = 0
	
 -- player cord
	xpa=6*8
	ypa=15*8 
	
	-- prepare first level
 level = 0
 prep_lev(level)
 
 --aiming limit
 alim = 8
 
 --set transparency
 palt(0, true)


 --tno
 tno = 0  
end

mtime = 0
hflip = false

function _update60()
--number of loops
tno+=1

player_col()
map_col()
levelman()



if not btn(➡️) and not btn(⬅️) then  
hanim = 0
mtime = 0
end

if btn(⬅️) then 
  mtime+=1
--	if mtime%2 == 1 then
		hanim+=1
		hflip = true
		if(hanim>=14) hanim=0

--	end

	if xpa>5 then 
		xpa-=2 
	end
end

if btn(➡️) then 
	mtime+=1
--	if mtime%2 == 1 then
		hanim+=1
		hflip = false
		if(hanim>=14) hanim=0
--	end
	if xpa<102 then 
		xpa+=2 
	end
end

if btnp(❎) then 
	if y<alim*10 then
		aim_x = x
		aim_y = y
		sfx(5)
	else
		sfx(4)
	end
end

if btnp(4) then 
	sfx(1)
 level+=1
 prep_lev(level)
end


--przesuwamy pilke
x+=dx
y+=dy

end

zam = false
function _draw()
	-- redraw background
	cls(0)
	map(0,0)
	
	--redraw tiles
	map(0,16)	
	rect(0,0,127,127,2)
	
	-- calculate ball map cords
 mx=flr(x/8)
 my=flr(y/8)

--draw ball 
  draw_ball()

--draw player 
  draw_pla()
 
-- draw aiming cursor
 if aim_x*aim_y != 0 then
	 spr(17,aim_x,aim_y)
 end
 


-- debud informations
debug()
end

-->8
board = {}
board.maxx = 13
board.maxy = 8
board.tiles = 0

function prep_lev(level)
board.tiles = 0
map(0,0)
for a=0,board.maxx do
	for b=0,board.maxy do
		level_mx = 16+(level%8)*14+a 
		level_my = flr(level/8)*9+b
		level_sprite = mget(level_mx, level_my)
		level_sprite_flag = fget(level_sprite,0)
		  if level_sprite_flag then		
					mset(a+1,b+17,level_sprite)
					board.tiles+=1
				else
					mset(a+1,b+17,0)
				end
				
		end 
	end
	
end

function remtit(x,y)

 mx=flr(x/8)
 my=flr(y/8)
 
 s_no = mget(mx,my+16)
 s_flag_0 = fget(s_no,0)
 s_flag_6 = fget(s_no,6)
 s_flag_7 = fget(s_no,7)

 if s_flag_0 then
  sfx(1)
  mset(mx,my+16,0)
  board.tiles-=1
  
  if s_flag_6 then 
  		mx+=1
    board.tiles-=1
   end
  if s_flag_7 then 
  	mx-=1
  	board.tiles-=1
  end

  mset(mx,my+16,0)
 	map(0,16)
 end
end

function levelman()
 if board.tiles <= 0 then
	 level+=1
  level = min (level,14)
 	prep_lev(level)
 end
end
-->8
function debug()
	cursor(0,0)
	color(7)
	print("aim !")
	print("mem:" .. stat(0))
	print("cpu:" .. stat(1))
	print("mtime:" .. mtime%50)
	print("mtime:" .. mtime)
	print("time:" .. time())

end

-->8
hanim = 0
function draw_pla()
	if(xpa<1*8) then xpa=1*8 end
 if(xpa>12*8) then xpa=12*8 end

 local shift = {0,0,1,1,2,2,3,3,3,2,2,1,1,0,0}
	
 	for g=0,24 do
 		local oy = 0
 		local sx = flr(x-(xpa+g)+5)
 		
 		if(sx > 0 and 
 					sx<#shift and 
 					ypa-y < 8) then 
 						oy = shift[sx] 
 	 			end
	 					pset(xpa+g,ypa+oy,11)
			 			if (g>2 and g<22) then 
	 		 			pset(xpa+g,ypa+1+oy,11)
 	 				end

	end
	spr(80,xpa-4,ypa,4,1)
	if mtime == 0 then
			spr(64+hanim%8,xpa-4,ypa-1,1,1,true)	
			spr(64+hanim%8,xpa+20,ypa-1,1,1,false)
	else
		if(hanim<=7) then
			spr(64+hanim%8,xpa+20,ypa-1,1,1,hflip)
		else
			spr(64+hanim%8,xpa-4,ypa-1,1,1,hflip)
			end
	end
	
end

function draw_ball()
 if y>alim*10 then
 	spr(1,x,y)
 else
	 spr(2,x,y)
 end
end

function mcol(lx,ly)
	return (mget(lx/8,16+ly/8) != 0)
end

function map_col()
 
 if dx>0 and mcol(x+4,y+2) then
   	dx*=-1
   	sfx(0)
   	remtit(x+4,y+2)
 end
  
 if dx<0 and mcol(x-1,y+2) then
  	dx*=-1
  	sfx(0)
  	remtit(x-1,y+2)
 end
 
 if dy>0 and mcol(x+2,y+4) then
  	dy*=-1
  	sfx(0)
  	remtit(x+2,y+4)
 end

 if dy<0 and mcol(x+2,y-1) then
  	dy*=-1
  	sfx(0) 	
  	remtit(x+2,y-1)
 end
 
end

sqrt2 = sqrt(2)
function player_col()
	if (dy>0 and 
					y+6>ypa and 
					x>=xpa and 
					x<=xpa+24) then

  			dy*=-1 
  			sfx(3) 
     
					if(aim_x * aim_x > 0)then
      --calc new movment vector
 					local vx = aim_x - x 			
      local vy = aim_y - y
      
      vfactor = vx/vy
      vfactor=vfactor/abs(vfactor)
      									*max(abs(vfactor),0.1)
      
      dx = -vfactor*1
      dy = -1
  
   			-- turn off aiming 
   			aim_x=0
   			aim_y=0
   		else
	   		dx = dx/abs(dx)	
    		dy = dy/abs(dy)
  			end
	else

	end
end
__gfx__
00000000077700000777000000000000000000000000000000000000000000000077777777777700077777700777777777777770077777777777777007777770
000000007ccc70007a9a7000000000999000000000000000999000000000000007eeeeeeeeeeee7078887ee67888887787787786788888888888888678888886
007007007ccc70007999700000000009000000000077000009000000000000007e7eeeeeeeeee7867887ee767888877877877886787788888888888678778886
000770007ccc70007a9a700000000000900077000700000090000000000000007ee7777777777886787ee78678887787787788867878888888888e8678788e86
00077000077700000777000000000000099000700077709900000000000000007e7888888888868677ee78867887787787788886788888888888ee867888ee86
007007000000000000000000000000000007770007cc7700000000000000000007888888888888607ee788867877877877888886788888888888888678888886
000000000000000000000000000000000077cc7007ccc70000000000000000000066666666666600066666600666666666666660066666666666666006666660
00000000000000000000000000000000007ccc7007ccc70000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000010000000000000000000000000000000000000bbb3bb3b0077777777777700077777700777777777777770077777777777777007777770
0000000000a000000000001000000000000000000000000000000000b33b3b3b07666666666666707ccc76667ccccc77c77c77c67cccccccccccccc67cccccc6
0000000000000000001000000000000000000000000000000000000033b3bbb376766666666667c67cc766767cccc77c77c77cc67c77ccccccccccc67c77ccc6
00000000a0a0a0001000100000000000000000000000000000000000b33b3bbb7667777777777cc67c7667c67ccc77c77c77ccc67c7cccccccccc6c67c7cc6c6
00000000000000000000001000000000000000000006060000000000bb3bbbb3767cccccccccc6c677667cc67cc77c77c77cccc67ccccccccccc66c67ccc66c6
0000000000a00000000100000000000000606000006d6d60000060603b3bb33b07cccccccccccc607667ccc67c77c77c77ccccc67cccccccccccccc67cccccc6
0000000000000000000000000606000006d6d600006d6d600006d6d6bbb333b30066666666666600066666600666666666666660066666666666666006666660
0000000000000000010000016d6d600006d6d600006d6d600006d6d63bbbb33b0000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbb3bb3bbbb3bb3b05030500bbb3bb3bbbb3bb3b511511510077777777777700077777700777777777777770077777777777777007777770
0000000000000000b33b3b3bb33b3b3b00003500b33b3b3bb33b3b3b1555515107ffffffffffff7079997ff67999997797797796799999999999999679999996
000000000000000033b3bbb333b3bbb33000000033b3bbb333b3bbb3551515557f7ffffffffff7967997ff767999977977977996797799999999999679779996
0000000000000000b33b3bbbb33b3bbb00000000b33b3bbbb33b3bbb155151117ff7777777777996797ff79679997797797799967979999999999f9679799f96
0000000000000000bb3bbbb3bb3bbbb305003050bb3bbbb3bb3bbbb3115115157f7999999999969677ff79967997797797799996799999999999ff967999ff96
00000000000000003b3bb33b3b3bb33b000000003b3bb33b3b3bb33b5155155107999999999999607ff799967977977977999996799999999999999679999996
0000000000000000bbb333b3bbb333b300500300bbb333b3bbb333b3151555150066666666666600066666600666666666666660066666666666666006666660
00000000000000003bbbb33b3bbbb33b300000003bbbb33b3bbbb33b515115510000000000000000000000000000000000000000000000000000000000000000
88888880000000003000030030000300000000003000030030000300300003000077777777777700077777700777777777777770077777777777777007777770
888888800000000030033030300330300000000030033030300330303003303007666666666666707bbb76667bbbbb77b77b77b67bbbbbbbbbbbbbb67bbbbbb6
888888800000000003330300033303003000005003330300033303000333030076766666666667b67bb766767bbbb77b77b77bb67b77bbbbbbbbbbb67b77bbb6
88888880000000000003303000033030000530030003303000033030000330307667777777777bb67b7667b67bbb77b77b77bbb67b7bbbbbbbbbb6b67b7bb6b6
8888888000000000030030000300300005000000030030000300300003003000767bbbbbbbbbb6b677667bb67bb77b77b77bbbb67bbbbbbbbbbb66b67bbb66b6
888888800000000030303003303030033000503030303003303030033030300307bbbbbbbbbbbb607667bbb67b77b77b77bbbbb67bbbbbbbbbbbbbb67bbbbbb6
88888880000000000300033303000333302000500300033303000333030003330066666666666600066666600666666666666660066666666666666006666660
00000000000000003030000330300003000030003030000330300003303000030000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000006060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000606000006d6d6000006060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606000006d6d600006d6d600006d6d6000060600006060000606000060600000000000000000000000000000000000000000000000000000000000000000000
6d6d600006d6d600006d6d600006d6d60006d6d6006d6d6006d6d6006d6d60000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000099900000000000000099900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000009000000000077000009000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000900077000700000090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099000700077709900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000007770007cc770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000077cc7007ccc70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007ccc7007ccc70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888ffffff882222228888888888888888888888888888888888888888888888888888888888888888228228888ff88ff888222822888888822888888228888
88888f8888f882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888222822888882282888888222888
88888ffffff882888828888888888888888888888888888888888888888888888888888888888888882288822888f8ff8f888222888888228882888888288888
88888888888882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888888222888228882888822288888
88888f8f8f88828888288888888888888888888888888888888888888888888888888888888888888822888228888ffff8888228222888882282888222288888
888888f8f8f8822222288888888888888888888888888888888888888888888888888888888888888882282288888f88f8888228222888888822888222888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550000000000000000000000000000000000000000005555555
55555550000000007777777777777777777777777777777777777777777777770000000005555550000000000011111111112222222222333333333305555555
55555550000000007777777777777777777777777777777777777777777777770000000005555550000000000011111111112222222222333333333305555555
55555550000000007777777777777777777777777777777777777777777777770000000005555550000000000011111111112222222222333333333305555555
55555550000000007777777777777777777777777777777777777777777777770000000005555550000000000011111111112222222222333333333305555555
55555550000000007777777777777777777777777777777777777777777777770000000005555550000000000011111111112222222222333333333305555555
55555550000000007777777777777777777777777777777777777777777777770000000005555550000000000011111111112222222222333333333305555555
55555550000000007777777777777777777777777777777777777777777777770000000005555550000000000011111111112222222222333333333305555555
55555550000000007777777777777777777777777777777777777777777777770000000005555550000000000011111111112222222222333333333305555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555550000000000011111111112222222227777777777775555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555550444444444455555555556666666667000000000075555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555550444444444455555555556666666667077777777075555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555550444444444455555555556666666667077777777075555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555550444444444455555555556666666667077777777075555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555550444444444455555555556666666667077777777075555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555550444444444455555555556666666667077777777075555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555550444444444455555555556666666667077777777075555555
5555555077777777cccccccc7777777777777777cccccccccccccccccccccccc6666666605555550444444444455555555556666666667077777777075555555
5555555077777777cccccccc7777777777777777cccccccccccccccccccccccc6666666605555550444444444455555555556666666667000000000075555555
5555555077777777cccccccc7777777777777777cccccccccccccccccccccccc666666660555555088888888889999999999aaaaaaaaa7777777777775555555
5555555077777777cccccccc7777777777777777cccccccccccccccccccccccc666666660555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777cccccccc7777777777777777cccccccccccccccccccccccc666666660555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777cccccccc7777777777777777cccccccccccccccccccccccc666666660555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777cccccccc7777777777777777cccccccccccccccccccccccc666666660555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777cccccccc7777777777777777cccccccccccccccccccccccc666666660555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777cccccccc77777777cccccccccccccccc66666666cccccccc666666660555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777cccccccc77777777cccccccccccccccc66666666cccccccc666666660555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777cccccccc77777777cccccccccccccccc66666666cccccccc666666660555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777cccccccc77777777cccccccccccccccc66666666cccccccc6666666605555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
5555555077777777cccccccc77777777cccccccccccccccc66666666cccccccc6666666605555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
5555555077777777cccccccc77777777cccccccccccccccc66666666cccccccc6666666605555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
5555555077777777cccccccc77777777cccccccccccccccc66666666cccccccc6666666605555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
5555555077777777cccccccc77777777cccccccccccccccc66666666cccccccc6666666605555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
5555555077777777cccccccccccccccccccccccc6666666666666666cccccccc6666666605555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
5555555077777777cccccccccccccccccccccccc6666666666666666cccccccc6666666605555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
5555555077777777cccccccccccccccccccccccc6666666666666666cccccccc6666666605555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
5555555077777777cccccccccccccccccccccccc6666666666666666cccccccc6666666605555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
5555555077777777cccccccccccccccccccccccc6666666666666666cccccccc6666666605555550000000000000000000000000000000000000000005555555
5555555077777777cccccccccccccccccccccccc6666666666666666cccccccc6666666605555555555555555555555555555555555555555555555555555555
5555555077777777cccccccccccccccccccccccc6666666666666666cccccccc6666666605555555555555555555555555555555555555555555555555555555
5555555077777777cccccccccccccccccccccccc6666666666666666cccccccc6666666605555555555555555555555555555555555555555555555555555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555550000000555556667655555555555555555555555555555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555550000000555555666555555555555555555555555555555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc666666660555555000000055555556dddddddddddddddddddddddd5555555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc66666666055555500070005555555655555555555555555555555d5555555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555550000000555555576666666d6666666d666666655555555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555550000000555555555555555555555555555555555555555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555550000000555555555555555555555555555555555555555555
5555555077777777cccccccccccccccccccccccccccccccccccccccccccccccc6666666605555555555555555555555555555555555555555555555555555555
55555550000000006666666666666666666666666666666666666666666666660000000005555555555555555555555555555555555555555555555555555555
55555550000000006666666666666666666666666666666666666666666666660000000005555556665666555556667655555555555555555555555555555555
55555550000000006666666666666666666666666666666666666666666666660000000005555556555556555555666555555555555555555555555555555555
5555555000000000666666666666666666666666666666666666666666666666000000000555555555555555555556dddddddddddddddddddddddd5555555555
555555500000000066666666666666666666666666666666666666666666666600000000055555565555565555555655555555555555555555555d5555555555
55555550000000006666666666666666666666666666666666666666666666660000000005555556665666555555576666666d6666666d666666655555555555
55555550000000006666666666666666666666666666666666666666666666660000000005555555555555555555555555555555555555555555555555555555
55555550000000006666666666666666666666666666666666666666666666660000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550005550005550005550005550005550005550005550005555
555555500000000000000000000000000000000000000000000000000000000000000000055555011d05011d05011d05011d05011d05011d05011d05011d0555
55555550000000000000000000000000000000000000000000000000000000000000000005555501110501110501110501110501110501110501110501110555
55555550000000000000000000000000000000000000000000000000000000000000000005555501110501110501110501110501110501110501110501110555
55555550000000000000000000000000000000000000000000000000000000000000000005555550005550005550005550005550005550005550005550005555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555515555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555171555
55555555555555555555555555555555555555555555555555555555555555555555550777777055555555555555555555555555555555555555555555177155
55555555555555555555555557555555ddd5555d5d5d5d5555d5d55555555d555555557cccccc656666666666666555557777755555555555555555555177715
55555555555555555555555577755555ddd555555555555555d5d5d5555555d55555557c77ccc656ddd6ddd6dd66555577ddd775566666555666665556177771
55555555555555555555555777775555ddd5555d55555d5555d5d5d55555555d5555557c7cc6c656d6d666d66d66555577d7d77566dd666566ddd66566177115
55555555555555555555557777755555ddd555555555555555ddddd555ddddddd555557ccc66c656d6d66dd66d66555577d7d775666d66656666d66566611715
555555555555555555555757775555ddddddd55d55555d55d5ddddd55d5ddddd5555557cccccc656d6d666d66d66555577ddd775666d666566d666656666d665
555555555555555555555755755555d55555d555555555555dddddd55d55ddd55555550666666056ddd6ddd6ddd655557777777566ddd66566ddd66566ddd665
555555555555555555555777555555ddddddd55d5d5d5d55555ddd555d555d555555550000000056666666666666555577777775666666656666666566666665
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555566666665ddddddd5ddddddd5ddddddd5
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077000001111111111111111111111110000000000000000000000000077777777777700077777700777777777777770077777777777777007777770
000000007cc7000011111111111111111111111100000000000000000000000007eeeeeeeeeeee7078887ee67888887787787786788888888888888678888886
007007007cc700001111111111111111111111110000000000000000000000007e7eeeeeeeeee7867887ee767888877877877886787788888888888678778886
00077000077000001111111111111111111111110000000000000000000000007ee7777777777886787ee78678887787787788867878888888888e8678788e86
00077000000000001111111111111111111111110000000000000000000000007e7888888888868677ee78867887787787788886788888888888ee867888ee86
007007000000000011111111111111111111111100000000000000000000000007888888888888607ee788867877877877888886788888888888888678888886
00000000000000001111111111111111111111110000000000000000000000000066666666666600066666600666666666666660066666666666660000000000
00000000000000001111111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000777777777
00000000000000001111111111111111111111110000000000000000000000000077777777777700077777700777777777777770077777777777770707777770
000000000000000011111111111111111111111100000000000000000000000007666666666666707ccc76667ccccc77c77c77c67ccccccccccccc077cccccc6
000000000000000011111111111111111111111100000000000000000000000076766666666667c67cc766767cccc77c77c77cc67c77cccccccccc077c77ccc6
00000000000000001111111111111111111111110000000000000000000000007667777777777cc67c7667c67ccc77c77c77ccc67c7cccccccccc6077c7cc6c6
0000000000000000111111111111111111111111000000000000000000000000767cccccccccc6c677667cc67cc77c77c77cccc67ccccccccccc66077ccc66c6
000000000000000011111111111111111111111100000000000000000000000007cccccccccccc607667ccc67c77c77c77ccccc67ccccccccccccc077cccccc6
00000000000000001111111111111111111111110000000000000000000000000066666666666600066666600666666666666660066666666666660706666660
00000000000000001111111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000700000000
00000000000000001111111111111111111111110000000000000000000000000077777777777700077777700777777777777770077777777777770777777777
000000000000000011111111111111111111111100000000000000000000000007ffffffffffff7079997ff67999997797797796799999999999990000000000
00000000000000001111111111111111111111110000000000000000000000007f7ffffffffff7967997ff767999977977977996797799999999999679779996
00000000000000001111111111111111111111110000000000000000000000007ff7777777777996797ff79679997797797799967979999999999f9679799f96
00000000000000001111111111111111111111110000000000000000000000007f7999999999969677ff79967997797797799996799999999999ff967999ff96
000000000000000011111111111111111111111100000000000000000000000007999999999999607ff799967977977977999996799999999999999679999996
00000000000000001111111111111111111111110000000000000000000000000066666666666600066666600666666666666660066666666666666006666660
00000000000000001111111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000077777777777700077777700777777777777770077777777777777007777770
000000000000000000000000000000000000000000000000000000000000000007666666666666707bbb76667bbbbb77b77b77b67bbbbbbbbbbbbbb67bbbbbb6
000000000000000000000000000000000000000000000000000000000000000076766666666667b67bb766767bbbb77b77b77bb67b77bbbbbbbbbbb67b77bbb6
00000000000000000000000000000000000000000000000000000000000000007667777777777bb67b7667b67bbb77b77b77bbb67b7bbbbbbbbbb6b67b7bb6b6
0000000000000000000000000000000000000000000000000000000000000000767bbbbbbbbbb6b677667bb67bb77b77b77bbbb67bbbbbbbbbbb66b67bbb66b6
000000000000000000000000000000000000000000000000000000000000000007bbbbbbbbbbbb607667bbb67b77b77b77bbbbb67bbbbbbbbbbbbbb67bbbbbb6
00000000000000000000000000000000000000000000000000000000000000000066666666666600066666600666666666666660066666666666666006666660
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
00000000000000004181014181418101000100000000000041810141814181010001000000000000418101418141810100000000000000004181014181418101000000000000000000000101010100000000000000ffff0000000101010100000000000000000041810001010101000000000000000000418100010101010000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
000000000000000000000000000000003000000000000000000000001f30300a000000000000000000000a31300a000000000000000000000a31300a000000000000000000000a31300a000000000000000000000a31300a000000000000000000000a31300a000000000000000000000a31300a000000000000000000000a31
00121200120012000000120000120000000000000000000000000000001f0b0c080908090a0a080908090b0c0b0c080908090a0a080908090b0c0b0c080908090a0a080908090b0c0b0c080908090a0a080908090b0c0b0c080908090a0a080908090b0c0b0c080908090a0a080908090b0c0b0c080908090a0a080908090b0c
00000000000000000000001200120000000000000000000000000000000000000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c0000000000
0000001212000000001200000000000000000000000000000000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a000000000000
0012000000000012120000001200000000000000000000000000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a000000000000
000000000000000000120000001200000000000000000000000000000000000f000500000000000000000f00000f000500000000000000000f00000f000500000000000000000f00000f000500000000000000000f00000f000500000000000000000f00000f000500000000000000000f00000f000500000000000000000f00
00001212000012000000000000000000000000000000000000000000000000000d0e00000d0e00000d0e000000000d0e00000d0e00000d0e000000000d0e00000d0e00000d0e000000000d0e00000d0e00000d0e000000000d0e00000d0e00000d0e000000000d0e00000d0e00000d0e000000000d0e00000d0e00000d0e0000
000000000000000000001200001200001f0000000000000000000000001f0f0000000000000000000000000f0f0000000000000000000000000f0f0000000000000000000000000f0f0000000000000000000000000f0f0000000000000000000000000f0f0000000000000000000000000f0f0000000000000000000000000f
00000000000000000000000000120000301f000000000000000000001f30300f000000000000000000000f31300f000000000000000000000f31300f000000000000000000000f31300f000000000000000000000f31300f000000000000000000000f31300f000000000000000000000f31300f000000000000000000000f31
00120012001200000000000012000000301f1f1f1f1f1f1f1f1f1f1f1f31300f0f0f0f0f0f0f0f0f0f0f0f31300000000000000000000000003130000000000000000000000000313000000000000000000000000031300000000000000000000000003130000000000000000000000000313000000000000000000000000031
001200000000000012000000000000001f1f1f1f1f1f1f1f1f1f1f1f1f1f0d0e0d0e0d0e0d0e0d0e0d0e0d0e0000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a000000000000
000000001212000000000012120000001f1f1f1f1f1f1f1f1f1f1f1f1f1f0d0e0d0e0d0e0d0e0d0e0d0e0d0e00000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c0000000000
000000000012000000000000000000001f1f1f1f1f1f1f1f1f1f1f1f1f1f0d0e0d0e0d0e0d0e0d0e0d0e0d0e0000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a000000000000
000012000012000000001200000000001f1f1f1f1f1f1f1f1f1f1f1f1f1f0d0e0d0e0d0e0d0e0d0e0d0e0d0e0000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a000000000000
000000000012000000120000000012001f1f1f1f1f1f1f1f1f1f1f1f1f1f0d0e0d0e0d0e0d0e0d0e0d0e0d0e003f000500000000000000003f00003f000500000000000000003f00003f000500000000000000003f00003f000500000000000000003f00003f000500000000000000003f00003f000500000000000000003f00
000000000000000000000000000000001f1f1f1f1f1f1f1f1f1f1f1f1f1f0d0e0d0e0d0e0d0e0d0e0d0e0d0e00003d3e00003d3e00003d3e000000003d3e00003d3e00003d3e000000003d3e00003d3e00003d3e000000003d3e00003d3e00003d3e000000003d3e00003d3e00003d3e000000003d3e00003d3e00003d3e0000
242424242424242424242424242424241f1f1f1f1f1f1f1f1f1f1f1f1f1f0d0e0d0e0d0e0d0e0d0e0d0e0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
24000000000000000000000000000024301f1f1f1f1f1f1f1f1f1f1f1f31300f0f0f0f0f0f0f0f0f0f0f0f31300000000000000000000000003130000000000000000000000000313000000000000000000000000031300000000000000000000000003130000000000000000000000000313000000000000000000000000031
2400000000000000000000000000002430000000000000000000000000313000000000000000000000000031300000000000000000000000003130000000000000000000000000313000000000000000000000000031300000000000000000000000003130000000000000000000000000313000000000000000000000000031
240000000000000000000000000000240000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a000000000000
2400000000000000000000000000002400000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c000000000000000000000b0c0b0c0000000000
240000000000000000000000000000240000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a000000000000
240000000000000000000000000000240000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a0000000000000000000000000a0a000000000000
24000000000000000000000000000024003f000500000000000000003f00003f000500000000000000003f00003f000500000000000000003f00003f000500000000000000003f00003f000500000000000000003f00003f000500000000000000003f00003f000500000000000000003f00003f000500000000000000003f00
2400000000000000000000000000002400003d3e00003d3e00003d3e000000003d3e00003d3e00003d3e000000003d3e00003d3e00003d3e000000003d3e00003d3e00003d3e000000003d3e00003d3e00003d3e000000003d3e00003d3e00003d3e000000003d3e00003d3e00003d3e000000003d3e00003d3e00003d3e0000
2400000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000002430000000000000000000000000313000000000000000000000000031300000000000000000000000003130000000000000000000000000313000000000000000000000000031300000000000000000000000003130000000000000000000000000313000000000000000000000000031
2400000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2434343434343434343434343434342400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001002010020100201002010020100201c00023000230002b0002d000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000280202a0002c0002f0003200036000380000e0000e0000f000300000f0000f0000f0000f0000f0000f0000f0000f0000f0000f0000f0000f0000f0000f0000f0000f000130001b00022000270002b000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300000f050080500405004050070500a060090000c0000b0000d00027000200001c00018000170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300001303011030100300d0300b030090300603004030030300103000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200002005022050240502705002000210002500027000180001900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
