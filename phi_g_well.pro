;IDL final project on galaxy gravitational potential well.
;Milky Way Galaxy inputs = 10.0^12, 50000.0, 4.0*10.0^6

function bulge, mass, radius, blackhole

au = double(1.496*10.0^11)
G = double(6.674*10.0^(-11))
ly = double(9.461*10.0^15)
sun = double(1.989*10.0^30)
mass = double(mass * sun)
blackhole = double(blackhole * sun)
radius = double(radius * ly)
pi = !pi

  n = radius/(10.0 * ly)
  y = findgen(n)
  r = y * ly
  volume = pi*1000.0*ly * (radius^2 - (radius/10.0)^2) + 4.0*pi/3 * (radius/10.0)^3
  rho = (0.16*mass - blackhole) / volume
  
M = findgen(n)
M = rho*4.0*pi/3 * (r+ly)^3 + blackhole
y = -G*M / (r+ly)
M(0) = rho*4.0*pi/3 * au^3 + blackhole
min = -G * M(0) / au
phi = [min, y]

return, phi

end

pro region1, mass, radius, blackhole

;phi does not depend on r. 0 LT r LE 1 AU.

au = double(1.496*10.0^11)
c = double(2.9979*10.0^8)
G = double(6.674*10.0^(-11))
ly = double(9.461*10.0^15)
sun = double(1.989*10.0^30)
mass = double(mass * sun)
blackhole = double(blackhole * sun)
radius = double(radius * ly)
pi = !pi

  volume = pi*1000.0*ly * (radius^2 - (radius/10.0)^2) + 4.0*pi/3 * (radius/10.0)^3
  rho = (0.16*mass - blackhole) / volume
  constant = 0.84*mass / (4.0*pi*radius)
  DM = -G * 4.0*pi*constant
  M = rho*4.0*pi/3 * au^3 + blackhole
  phi1 = -G * M / au + DM

  if phi1 LE -c^2 then begin
     print, 'Error: |phi| cannot exceed the speed of light squared. Region 1 not valid. Extend boundary of region 2 to 1 ly.'
  endif else begin
     print, phi1
  endelse

end

pro region2, mass, radius, blackhole, r

;Find phi for a specific value of r in light years. 1 LY LE r LE radius/10.

au = double(1.496*10.0^11)
G = double(6.674*10.0^(-11))
ly = double(9.461*10.0^15)
sun = double(1.989*10.0^30)
mass = double(mass * sun)
blackhole = double(blackhole * sun)
radius = double(radius * ly)
pi = !pi

  constant = 0.84*mass / (4.0*pi*radius)
  DM = -G * 4.0*pi*constant
  volume = pi*1000.0*ly * (radius^2 - (radius/10.0)^2) + 4.0*pi/3 * (radius/10.0)^3
  rho = (0.16*mass - blackhole) / volume
  n = radius / (10.0*ly)
  mass = mass / sun
  blackhole = blackhole / sun
  radius = radius / ly

  phi2 = bulge(mass, radius, blackhole) + DM

print, phi2(r)

end

function disk, mass, radius, blackhole

au = double(1.496*10.0^11)
G = double(6.674*10.0^(-11))
ly = double(9.461*10.0^15)
sun = double(1.989*10.0^30)
mass = double(mass * sun)
blackhole = double(blackhole * sun)
radius = double(radius * ly)
pi = !pi

  nn = 9.0*radius / (10.0 * ly)
  yy = findgen(nn+1)
  r = yy * ly + radius/10.0
  volume = pi*1000.0*ly * (radius^2 - (radius/10.0)^2) + 4.0*pi/3 * (radius/10.0)^3
  rho = (0.16*mass - blackhole) / volume

M = findgen(nn)
Mbulge = rho*4.0*pi/3 * (radius/10.0)^3 + blackhole
M = rho*1000.0*ly*pi * (r^2 - (radius/10.0)^2) + Mbulge
phi = -G*M/r

return, phi

end

pro region3, mass, radius, blackhole, r

;Find phi for a specific value of r in light years. radius/10 LE r LE radius.

au = double(1.496*10.0^11)
G = double(6.674*10.0^(-11))
ly = double(9.461*10.0^15)
sun = double(1.989*10.0^30)
mass = double(mass * sun)
blackhole = double(blackhole * sun)
radius = double(radius * ly)
pi = !pi

  constant = 0.84*mass / (4.0*pi*radius)
  DM = -G * 4.0*pi*constant
  volume = pi*1000.0*ly * (radius^2 - (radius/10.0)^2) + 4.0*pi/3 * (radius/10.0)^3
  rho = (0.16*mass - blackhole) / volume
  nn = 9.0*radius / (10.0 * ly)
  mass = mass / sun
  blackhole = blackhole / sun
  radius = radius / ly
  r = r - radius/10.0
  phi3 = disk(mass, radius, blackhole) + DM

print, phi3(r)

end

function infinity, mass, radius, blackhole

au = double(1.496*10.0^11)
G = double(6.674*10.0^(-11))
ly = double(9.461*10.0^15)
sun = double(1.989*10.0^30)
mass = double(mass * sun)
blackhole = double(blackhole * sun)
radius = double(radius * ly)
pi = !pi

  yyy = findgen(3*radius/ly)
  r = yyy * ly + radius
  phi = -G*mass/r

return, phi

end

pro region4, mass, radius, blackhole, r

;Find phi for a specific value of r in light years. r GE radius.

au = double(1.496*10.0^11)
G = double(6.674*10.0^(-11))
ly = double(9.461*10.0^15)
sun = double(1.989*10.0^30)
mass = double(mass * sun)
blackhole = double(blackhole * sun)
radius = double(radius * ly)
pi = !pi

  constant = 0.84*mass / (4.0*pi*radius)
  DM = -G * 4.0*pi*constant
  volume = pi*1000.0*ly * (radius^2 - (radius/10.0)^2) + 4.0*pi/3 * (radius/10.0)^3
  rho = (0.16*mass - blackhole) / volume
  mass = mass / sun
  blackhole = blackhole / sun
  radius = radius / ly
  r = r - radius
  phi4 = infinity(mass, radius, blackhole)

print, phi4(r)

end

pro spiral, mass, radius, blackhole

;Plot phi per unit mass as a function of r. Phi = -G*M(r) / r
;Include an option for elliptical (1 less region, spherical)
;Find M(r) in all 4 regions. Given in M_sun, but use kg.
;Radius is given in light years, but use meters.
;Use functions to call.
;Use double for large numbers.
;Let's start by checking the datatype.

errormass = size(mass)
  if errormass(1) NE 4 then begin
     print, 'Error: Input datatype must be a float. Mass is given in solar masses. Yes, this is true for each function/procedure. No, this error will not remind you elsewhere.'
  endif

errorradius = size(radius)
  if errorradius(1) NE 4 then begin
     print, 'Error: Input datatype must be a float. Radius is given in light years. Yes, this is true for each function/procedure. No, this error will not remind you elsewhere.'
  endif

errorblackhole = size(blackhole)
  if errorblackhole(1) NE 4 then begin
     print, 'Error: Input datatype must be a float. Blackhole is given in solar masses. Yes, this is true for each function/procedure. No, this error will not remind you elsewhere.'
  endif

au = double(1.496*10.0^11)
c = double(2.9979*10.0^8)
G = double(6.674*10.0^(-11))
ly = double(9.461*10.0^15)
sun = double(1.989*10.0^30)
mass = double(mass * sun)
blackhole = double(blackhole * sun)
radius = double(radius * ly)
pi = !pi

;Dark Matter density goes as constant / r^2. Find constant.
constant = 0.84*mass / (4.0*pi*radius)
;Mass as a function of r = 4*pi*c*r. r cancels in phi.
DM = -G * 4.0*pi*constant

;Baryonic Matter = mass - dark matter.
;Exclude blackhole and divide by volume to find density.
volume = pi*1000.0*ly * (radius^2 - (radius/10.0)^2) + 4.0*pi/3 * (radius/10.0)^3
rho = (0.16*mass - blackhole) / volume

  mass = mass / sun
  blackhole = blackhole / sun
  radius = radius / ly
  n = radius / 10.0
  r = findgen(n+1)
  y = bulge(mass, radius, blackhole) + DM
  min = 2*y(1)

  mass = mass / sun
  blackhole = blackhole / sun
  radius = radius / ly
  rr = findgen(9*n+1) + radius/10.0
  yy = disk(mass, radius, blackhole) + DM

  mass = mass / sun
  blackhole = blackhole / sun
  radius = radius / ly
  rrr = findgen(3*radius) + radius
  yyy = infinity(mass, radius, blackhole)
  max = yyy(2*radius/ly)

allofit = findgen(40*n)
plot, allofit, y, YRANGE = [min, max], title= 'Galaxy Gravity Well', xtitle= 'radius in ly', ytitle= 'specific potential energy', charsize= 2, /NODATA, color= !white, background= !black
oplot, r, y, color= !red
oplot, rr, yy, color= !blue
oplot, rrr, yyy, color= !yellow

!except = 0

end

pro elliptical, mass, radius, blackhole

au = double(1.496*10.0^11)
c = double(2.9979*10.0^8)
G = double(6.674*10.0^(-11))
ly = double(9.461*10.0^15)
sun = double(1.989*10.0^30)
mass = double(mass * sun)
blackhole = double(blackhole * sun)
radius = double(radius * ly)
pi = !pi

constant = 0.84*mass / (4.0*pi*radius)
DM = -G * 4.0*pi*constant

volume = 4.0*pi/3 * radius^3
rho = (0.16*mass - blackhole) / volume

  n = radius/ly
  y = findgen(n)
  r = y * ly
  M = findgen(n)
  M = rho*4.0*pi/3 * (r+ly)^3 + blackhole
  y = -G*M / (r+ly)
  M(0) = rho*4.0*pi/3 * au^3 + blackhole
  minimum = -G*M(0)/au
  y = [minimum, y] + DM
  min = 2*y(1)
  r = r/ly

  mass = mass / sun
  blackhole = blackhole / sun
  radius = radius / ly
  rrr = findgen(3*radius) + radius
  yyy = infinity(mass, radius, blackhole)
  max = yyy(2*radius/ly)

allofit = findgen(4*n)
plot, allofit, y, YRANGE = [min, max], title= 'Galaxy Gravity Well', xtitle= 'radius in ly', ytitle= 'specific potential energy', charsize= 2, /NODATA, color= !white, background= !black
oplot, r, y, color= !red
oplot, rrr, yyy, color= !blue
!except = 0

end
