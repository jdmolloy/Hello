import numpy as np
import pylab
import scipy as sp

def radec2altaz(ra, dec, lst, lat, lon):
	n = len(ra)
	alt = np.zeros((n, 1))
	az = np.zeros((n, 1))

	# Inputs should be in decimal form. If not, then apply ten().
	# Please stick with one pair of (latitude, longitude) at a time.
	if len(lat) == 0:
		lat = np.float64(18.3538056) 
	# Default value for Arecibo Observatory (37.873199 degrees North at UCB).
	if len(lon) == 0: 
		lon = np.float64(-66.7552222) 
	# Default at Arecibo (-122.257063 degrees West at UCB).
	# timezone = UTC - 4
	# hour angle ha + ra = LST

	for num in ra:
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
		#x = np.array([x_0, x_1, x_2])  Matrix multiplication (3 by 3) * (1 by 3) doesn't work
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

	return np.array([alt, az])


def hadec2altaz(ha, dec, lat, lon):

	n = len(ha)
	alt = np.zeros((n, 1))
	az = np.zeros((n, 1))

	if len(lat) == 0: 
		lat = np.float64(18.3538056)
	# Default value for Arecibo Observatory (37.873199 degrees North at UCB).  
	if len(lon) == 0: 
		lon = np.float64(-66.7552222)
	# Default at Arecibo (-122.257063 degrees West at UCB).

	for num in ha:
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
		x = np.array([x_0, x_1, x_2])

		transform2 = np.matrix([[-np.sin(phi), 0.0, np.cos(phi)], [0.0, -1.0, 0.0], [np.cos(phi), 0.0, np.sin(phi)]])
		transform = x * transform2  # Alternative solution to matrix multiplication problem above
		alt[i] = np.arcsin(transform[2]) * 180.0 / np.pi
		az[i] = np.arctan2(transform[1], transform[0]) * 180.0 / np.pi

		if az[i] < 0.0: 
			az[i] = az[i] + 360.0
		if az[i] > 360.0: 
			az[i] = az[i] + 360.0

	return np.array([alt, az])
