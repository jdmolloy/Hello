pro radec2altaz, ra, dec, lst

; Inputs should be in decimal form. If not, then apply ten().
lat = double(18.34417) ; degrees North (37.873199 at UCB).
long = double(-66.75278) ; degrees West (-122.257063 at UCB).
; timezone = UTC - 4
; hour angle ha + ra = LST

ra = double(ra)
dec = double(dec)
lst = double(lst)

lst_rad = double(lst * 15.0 * !dtor)
alpha = double(ra * !dtor)
delta = double(dec * !dtor) 
phi = double(lat * !dtor) ; Everything from degrees to radians.

x_0 = cos(delta) * cos(alpha)
x_1 = cos(delta) * sin(alpha)
x_2 = sin(delta)
x = [x_0, x_1, x_2]

; Rotation matrices.
transform1 = [[cos(lst_rad), sin(lst_rad), 0.0], [sin(lst_rad), -cos(lst_rad), 0.0], [0.0, 0.0, 1.0]]
transform2 = [[-sin(phi), 0.0, cos(phi)], [0.0, -1.0, 0.0], [cos(phi), 0.0, sin(phi)]]
transform = transform2 ## transform1 ## x

alt = asin(transform(2)) * !radeg
alt = double(alt)
az = atan(transform(1), transform(0)) * !radeg
az = double(az)

if az LT 0.0 then az = az + 360.0
if az GT 360.0 then az = az - 360.0

print, [alt, az]

end

pro hadec2altaz, ra, dec, lst

lat = 37.8719 ;18.34417 ; degrees North (37.8719 at UCB).                    
long = -122.2585 ;-66.75278 ; degrees West (-122.2585 at UCB).  

lst_rad = lst * 15.0 * !dtor
alpha = ra * !dtor
delta = dec * !dtor
phi = lat * !dtor ; Everything from degrees to radians.                        

ha = lst_rad - alpha
x_0 = cos(delta) * cos(ha)
x_1 = cos(delta) * sin(ha)
x_2 = sin(delta)
x = [x_0, x_1, x_2]

transform2 = [[-sin(phi), 0.0, cos(phi)], [0.0, -1.0, 0.0], [cos(phi), 0.0, sin(phi)]]
transform = transform2 ## x

alt = asin(transform(2)) * !radeg
az = atan(transform(1), transform(0)) * !radeg

if az LT 0.0 then az = az + 360.0

print, [alt, az]

end
