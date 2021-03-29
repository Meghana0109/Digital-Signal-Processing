Power Spectral Density shows the distribution of energy of the signal over frequency. 
PSD can be calculated using non-parametric method(e.g, Welch Method) and parametric method(e.g, Yule-Walker AR Model). These are practical observations of PSD of a given signal. 
In the experiment, we calculate PSD of the signal and compare it with theoretical PSD. 
Theroretical PSD is calculated using the transfer function of the digital filter through which the noise/signal is passed. Theoretical PSD = |H(exp(j*2*pi*f)|^2*(variance)
Welch method calculates PSD by dividing the signal into blocks of equal sizes, with possible overlap samples. The PSD of individual block is calcultated and then PSD of all blocks are averaged to obtain the PSD of the signal.
Yule_Walker AR Model uses correlation properties to calculate PSD. Using the filtered signal(random sequence passed through digital filter) obtained in the Welch's method, correlations are obtained. Using the correlation, the variance of the signal and the coefficients of transfer function are estimated. Using these estimated values, the PSD is obtained just like the theoretical PSD formula.
