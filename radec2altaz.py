import numpy as np
import pylab
import scipy as sp

# Still needs default values for latitude and longitude.
# Dec. at Zenith = lat. Make the ra = LST.
# Check at equator that horizon (alt = 0.0) dec = -90.0 for South (SCP) and = 90.0 North (NCP).
# Off equator, North lat > 0, dec = lat - 90.0 for South horizon and = 90.0 - lat for North horizon.
# For South lat < 0, use absolute value of lat to find declinations on the horizon. Same answers.
# Altitude of NCP = lat and alt of SCP = -lat.
# Use matplotlib to plot data points in dec vs. ra then alt vs. az.

# Version Python 3.5.1
def radec2altaz(ra, dec, lst):
	n = len(ra)
	alt = np.zeros((n, 1))
	az = np.zeros((n, 1))

	# Inputs should be in decimal form. If not, then apply ten().
	# Please stick with one pair of (latitude, longitude) at a time.
#	if len(lat) == 0:
	lat = np.float64(18.3538056) 
	# Default value for Arecibo Observatory (37.873199 degrees North at UCB).
#	if len(lon) == 0: 
	lon = np.float64(-66.7552222) 
	# Default at Arecibo (-122.257063 degrees West at UCB).
	# timezone = UTC - 4
	# hour angle ha + ra = LST

	for i, item in enumerate(ra):
		ra = np.float64(ra)
		dec = np.float64(dec)
		lst = np.float64(lst)
		alpha = np.float64(ra[i] * np.pi / 12.0)
		delta = np.float64(dec[i] * np.pi / 180.0) 
		lst_rad = np.float64(lst[i] * np.pi / 12.0)
		phi = np.float64(lat * np.pi / 180.0) 
		
		# Everything from degrees to radians.
		x_0 = np.float64(np.cos(delta) * np.cos(alpha))
		x_1 = np.float64(np.cos(delta) * np.sin(alpha))
		x_2 = np.float64(np.sin(delta))
		x = np.matrix([[x_0], [x_1], [x_2]])
		
		# Rotation matrices.
		transform1 = np.matrix([[np.cos(lst_rad), np.sin(lst_rad), 0.0], [np.sin(lst_rad), -np.cos(lst_rad), 0.0], [0.0, 0.0, 1.0]])
		transform2 = np.matrix([[-np.sin(phi), 0.0, np.cos(phi)], [0.0, -1.0, 0.0], [np.cos(phi), 0.0, np.sin(phi)]])
		transform = transform2 * transform1 * x
		alt[i] = np.arcsin(transform[2]) * 180.0 / np.pi
		az[i] = np.arctan2(transform[1], transform[0]) * 180.0 / np.pi

		if az[i] < 0.0:
			az[i] = az[i] + 360.0
		if az[i] > 360.0:
			az[i] = az[i] - 360.0

	print('radec2altaz gives alt array = ', alt)
	print('radec2altaz gives az array = ', az)

	return np.array([alt, az])

def hadec2altaz(ha, dec):

	n = len(ha)
	alt = np.zeros((n, 1))
	az = np.zeros((n, 1))

#	if len(lat) == 0: 
	lat = np.float64(18.3538056)
	# Default value for Arecibo Observatory (37.873199 degrees North at UCB).  
#	if len(lon) == 0: 
	lon = np.float64(-66.7552222)
	# Default at Arecibo (-122.257063 degrees West at UCB).
	
	for i, item in enumerate(ha):
		haha = np.float64(ha[i] * np.pi / 12.0)
		delta = np.float64(dec[i] * np.pi / 180.0)
		phi = np.float64(lat * np.pi / 180.0) 
		# Everything from degrees to radians.   
		# alpha = np.float64(ra * np.pi / 12.0)
		# lst_rad = np.float64(lst * np.pi / 12.0)
		# ha = lst_rad - alpha                        

		x_0 = np.float64(np.cos(delta) * np.cos(haha))
		x_1 = np.float64(np.cos(delta) * np.sin(haha))
		x_2 = np.float64(np.sin(delta))
		x = np.matrix([[x_0], [x_1], [x_2]])

		transform2 = np.matrix([[-np.sin(phi), 0.0, np.cos(phi)], [0.0, -1.0, 0.0], [np.cos(phi), 0.0, np.sin(phi)]])
		transform = transform2 * x
		
		alt[i] = np.arcsin(transform[2]) * 180.0 / np.pi
		az[i] = np.arctan2(transform[1], transform[0]) * 180.0 / np.pi

		if az[i] < 0.0: 
			az[i] = az[i] + 360.0
		if az[i] > 360.0: 
			az[i] = az[i] + 360.0

	print('hadec2altaz gives alt array = ', alt)
	print('hadec2altaz gives az array = ', az)

	return np.array([alt, az])

# Input test arrays only of size > 1.

ra = np.array((0.0, 1.1, 0.0, 4.2))
dec = np.array((0.0, 18.354, 90.0, -90.0))
lst = np.array((0.0, 1.1, 0.0, 4.2))
ha = np.array((0.0, 0.0, 0.0, 0.0))

radec2altaz(ra, dec, lst)
hadec2altaz(ha, dec)
