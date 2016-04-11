pro radec2altaz, ra, dec, lst, lat, long

; Inputs should be in decimal form. If not, then apply ten().
if n_elements(lat) EQ 0 then lat = double(18.34417) 
; Default value for Arecibo Observatory (37.873199 degrees North at UCB).
if n_elements(long) EQ 0 then long = double(-66.75278) 
; Default at Arecibo (-122.257063 degrees West at UCB).
; timezone = UTC - 4
; hour angle ha + ra = LST

ra = double(ra)
dec = double(dec)
lst = double(lst)

alpha = double(ra * 15.0 * !dtor)
delta = double(dec * !dtor) 
lst_rad = double(lst * 15.0 * !dtor)
phi = double(lat * !dtor) ; Everything from degrees to radians.

x_0 = double(cos(delta) * cos(alpha))
x_1 = double(cos(delta) * sin(alpha))
x_2 = double(sin(delta))
x = [x_0, x_1, x_2]

; Rotation matrices.
transform1 = [[cos(lst_rad), sin(lst_rad), 0.0], [sin(lst_rad), -cos(lst_rad), 0.0], [0.0, 0.0, 1.0]]
transform2 = [[-sin(phi), 0.0, cos(phi)], [0.0, -1.0, 0.0], [cos(phi), 0.0, sin(phi)]]
transform = transform2 ## transform1 ## x

alt = double(asin(transform(2)) * !radeg)
az = double(atan(transform(1), transform(0)) * !radeg)

if az LT 0.0 then az = az + 360.0
if az GT 360.0 then az = az - 360.0

print, [alt, az]

end

pro hadec2altaz, ha, dec, lat, long

if n_elements(lat) EQ 0 then lat = double(18.34417) 
; Default value for Arecibo Observatory (37.873199 degrees North at UCB). 
if n_elements(long) EQ 0 then long = double(-66.75278)   
; Default at Arecibo (-122.257063 degrees West at UCB).

ha = double(ha * 15.0 * !dtor)
delta = double(dec * !dtor)
phi = double(lat * !dtor) ; Everything from degrees to radians.

;alpha = double(ra * 15.0 * !dtor)
;lst_rad = double(lst * 15.0 * !dtor)
;ha = lst_rad - alpha

x_0 = double(cos(delta) * cos(ha))
x_1 = double(cos(delta) * sin(ha))
x_2 = double(sin(delta))
x = [x_0, x_1, x_2]

transform2 = [[-sin(phi), 0.0, cos(phi)], [0.0, -1.0, 0.0], [cos(phi), 0.0, sin(phi)]]
transform = transform2 ## x

alt = double(asin(transform(2)) * !radeg)
az = double(atan(transform(1), transform(0)) * !radeg)

if az LT 0.0 then az = az + 360.0
if az GT 360.0 then az = az - 360.0

print, [alt, az]

end
