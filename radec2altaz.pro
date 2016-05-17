pro radec2altaz, ra, dec, lst, lat, long

n = n_elements(ra)
alt = transpose(dblarr(n))
az = transpose(dblarr(n))

; Inputs should be in decimal form. If not, then apply ten().
;Please stick with one pair of (latitude, longitude) at a time.
if n_elements(lat) EQ 0 then lat = double(18.3538056) 
; Default value for Arecibo Observatory (37.873199 degrees North at UCB).
if n_elements(long) EQ 0 then long = double(-66.7552222) 
; Default at Arecibo (-122.257063 degrees West at UCB).
; timezone = UTC - 4
; hour angle ha + ra = LST

for i = 0, n-1 do begin

ra = double(ra)
dec = double(dec)
lst = double(lst)

alpha = double(ra[i] * 15.0 * !dtor)
delta = double(dec[i] * !dtor) 
lst_rad = double(lst[i] * 15.0 * !dtor)
phi = double(lat * !dtor) ; Everything from degrees to radians.

x_0 = double(cos(delta) * cos(alpha))
x_1 = double(cos(delta) * sin(alpha))
x_2 = double(sin(delta))
x = [x_0, x_1, x_2]

; Rotation matrices.
transform1 = [[cos(lst_rad), sin(lst_rad), 0.0], [sin(lst_rad), -cos(lst_rad), 0.0], [0.0, 0.0, 1.0]]
transform2 = [[-sin(phi), 0.0, cos(phi)], [0.0, -1.0, 0.0], [cos(phi), 0.0, sin(phi)]]
transform = transform2 ## transform1 ## x

alt[i] = double(asin(transform(2)) * !radeg)
az[i] = double(atan(transform(1), transform(0)) * !radeg)

if az[i] LT 0.0 then az[i] = az[i] + 360.0
if az[i] GT 360.0 then az[i] = az[i] - 360.0

endfor

print, [alt, az]

end

pro hadec2altaz, ha, dec, lat, long

n = n_elements(ha)
alt = transpose(dblarr(n))
az = transpose(dblarr(n))

if n_elements(lat) EQ 0 then lat = double(18.3538056)
; Default value for Arecibo Observatory (37.873199 degrees North at UCB).  
if n_elements(long) EQ 0 then long = double(-66.7552222)
; Default at Arecibo (-122.257063 degrees West at UCB).

for i = 0, n-1 do begin

haha = double(ha[i] * 15.0 * !dtor)
delta = double(dec[i] * !dtor)
phi = double(lat * !dtor) ; Everything from degrees to radians.   

;alpha = double(ra * 15.0 * !dtor)
;lst_rad = double(lst * 15.0 * !dtor)
;ha = lst_rad - alpha                        

x_0 = double(cos(delta) * cos(haha))
x_1 = double(cos(delta) * sin(haha))
x_2 = double(sin(delta))
x = [x_0, x_1, x_2]

transform2 = [[-sin(phi), 0.0, cos(phi)], [0.0, -1.0, 0.0], [cos(phi), 0.0, sin(phi)]]
transform = transform2 ## x

alt[i] = double(asin(transform(2)) * !radeg)
az[i] = double(atan(transform(1), transform(0)) * !radeg)

if az[i] LT 0.0 then az[i] = az[i] + 360.0
if az[i] GT 360.0 then az[i] = az[i] - 360.0

endfor

print, [alt, az]

end
