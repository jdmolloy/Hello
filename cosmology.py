#! /usr/bin/env python
import numpy as np, pylab

def scale_factor(t):
    a = np.ones_like(t) # Do your calculation here
    a = (t/(13.8e9))**0.5 # t is input in years
    return a

def n_neutrino(T, n1eV=5e13):
    n = np.ones_like(T) * n1eV # Do your real calculation here
    k = 8.61733e-5
    n = n1eV * (k*T)**3 # n output given per centimeter cubed
    return n

def sigma_neutrino(T, s1MeV=1e-43):
    sigma = np.ones_like(T) * s1MeV # Do your real calculation here
    k = 8.61733e-5
    sigma = s1MeV * (k*T/1e6)**2 # sigma output in centimeters squared
    return sigma

def Hubble(t):
    H = np.ones_like(t)
    H = 1 / (2*t) # Now input t in seconds. Output given per second.
    return H

def time_to_temp(t):
    T = np.ones_like(t) # Do your real calculation here
    k = 1.38065e-23 # Metric units
    h_bar = 1.05457e-34
    g_eff = 10.75
    if t < 1:
        g_eff = 10.75
    elif t < 15: # Keep g_eff = 10.75 unless if statements actually work
        g_eff = 5.5
    else:
        g_eff = 2
    T = ((45 * h_bar**3 * (3e8)**5)/(16 * 3.14159**3 * g_eff * 6.674e-11))**0.25 / k * t**(-0.5)
    return T

def calc_collision_rate(t, n1eV=5e13, s1MeV=1e-43):
    rate = np.ones_like(t) # Do your real calculation here
    T = np.ones_like(t)
    kk = 1.38065e-23 # Metric units
    h_bar = 1.05457e-34
    T = ((45 * h_bar**3 * (3e8)**5)/(16 * 3.14159**3 * 10.75 * 6.674e-11))**0.25 / kk * t**(-0.5)
    n = np.ones_like(T) * n1eV
    k = 8.61733e-5
    n = n1eV * (k*T)**3 # n output given per centimeter cubed
    sigma = np.ones_like(T) * s1MeV
    k = 8.61733e-5
    sigma = s1MeV * (k*T/1e6)**2 # sigma output in centimeters squared
    rate = n*sigma*3e10
    return rate

# Part D
# t_freeze is the time when H = rate
# t_freeze = 1 / (2*rate(t))
t_freeze = 0.271 # seconds

def calc_n_over_p(t, n1eV=5e13, s1MeV=1e-43):
    n_over_p = np.ones_like(t) # Do your real calculation here
    euler = 2.71828
    T = np.ones_like(t) # try t = 0.27 seconds
    kk = 1.38065e-23 # Metric units
    h_bar = 1.05457e-34
    T = ((45 * h_bar**3 * (3e8)**5)/(16 * 3.14159**3 * 10.75 * 6.674e-11))**0.25 / kk * t**(-0.5)
    k = 8.61733e-5
    n_over_p = euler**(-1.29e6/(k*T))
    # At t ~ t_freeze = 0.27 sec, n_over_p ~ 0.458.
    n_over_p = 0.458 * euler**(-180/890) # 180 for deuterium formation and 890 for neutron decay
    return n_over_p

def calc_D_over_n(t, eta=5e-10, dE=2.2):
    D_over_n = np.ones_like(t) # Do your calculation here
    k = 8.61733e-5
    euler = 2.71828
    T = np.ones_like(t)
    kk = 1.38065e-23 # Metric units
    h_bar = 1.05457e-34
    T = ((45 * h_bar**3 * (3e8)**5)/(16 * 3.14159**3 * 10.75 * 6.674e-11))**0.25 / kk * t**(-0.5)
    # I'd rather keep g_eff = 10.75, because it gives more accurate values for temperature.
    D_over_n = 6.5 * eta * (k*T/9.3957e8)**1.5 * euler**(dE*1e6/(k*T))
    return D_over_n

def n_proton(t):
    n = np.ones_like(t) # Input t in years
    # Use the value at 1 second: 3e30 per centimeter cubed
    a_1sec = (3.169e-8/(13.8e9))**0.5
    a = (t/(13.8e9))**0.5
    n = 3e30 * (a_1sec/a)**3 # n output given per centimeter cubed
    return n
#Use neutron decay between 1 and 180 seconds.

t = np.logspace(.001, 300, num=1000)
pylab.plot(t, calc_D_over_n(t))
pylab.show()
