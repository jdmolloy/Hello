pro radec2altaz, ra, dec, lst

; Inputs should be in decimal form. If not, then apply ten().
lat = 18.34417 ; degrees North
long = -66.75278 ; degrees West
; timezone = UTC - 4
; hour angle ha + ra = LST

lst_rad = lst * 15.0 * !dtor
alpha = ra * !dtor
delta = dec * !dtor 
phi = lat * !dtor ; Everything from degrees to radians.

x_0 = cos(delta) * cos(alpha)
x_1 = cos(delta) * sin(alpha)
x_2 = sin(delta)
x = [x_0, x_1, x_2]

; Rotation matrices.
transform1 = [[cos(lst_rad), sin(lst_rad), 0], [sin(lst_rad), -cos(lst_rad), 0], [0, 0, 1]]
transform2 = [[-sin(phi), 0, cos(phi)], [0, -1, 0], [cos(phi), 0, sin(phi)]]
transform = transform1 ## transform2 ## x

alt = asin(transform(2)) * !radeg
az = atan(transform(1), transform(0)) * !radeg

print, [alt, az]

end

pro hadec2altaz, ra, dec, lst

lat = 18.34417 ; degrees North                                                 
long = -66.75278 ; degrees West   

lst_rad = lst * 15.0 * !dtor
alpha = ra * !dtor
delta = dec * !dtor
phi = lat * !dtor ; Everything from degrees to radians.                        

x_0 = cos(delta) * cos(alpha)
x_1 = cos(delta) * sin(alpha)
x_2 = sin(delta)
x = [x_0, x_1, x_2]
ha = lst_rad - alpha

transform2 = [[-sin(phi), 0, cos(phi)], [0, -1, 0], [cos(phi), 0, sin(phi)]]
transform = transform2 ## x

alt = asin(transform(2)) * !radeg
az = atan(transform(1), transform(0)) * !radeg

print, [alt, az]

end
