import("stdfaust.lib");

toneBar = shoeModelWood1(freq,exPos,t60,t60DecayRatio,t60DecaySlope)
with{
  freq = hslider("freq",30,0,2000,0.001) : si.smoo; 
  exPos = 0;
  t60 = 0.1;
  t60DecayRatio = 1;
  t60DecaySlope = 10; 
};

excitation = button("gate");

process = excitation : toneBar <: _,_;


shoeModelWood1(freq,exPos,t60,t60DecayRatio,t60DecaySlope) = _ <: par(i,nModes,pm.modeFilter(modesFreqs(i),modesT60s(i),modesGains(int(exPos),i))) :> /(nModes)
with{
nModes = 20;
nExPos = 6;
modesFreqRatios(n) = ba.take(n+1,(1,3.16138,5.6589,23.3993,29.4881,33.2413,46.2394,57.8162,61.7872,77.3313,79.611,82.5017,88.7778,100.923,103.562,111.665,122.33,124.645,129.354,131.168));
modesFreqs(i) = freq*modesFreqRatios(i);
modesGains(p,n) = waveform{0.718001,0.838796,0.155404,0.807061,0.362951,0.891497,0.383656,0.584904,1,0.45679,0.710436,0.0805481,0.210202,0.65057,0.284418,0.568047,0.468773,0.564931,0.509983,0.288223,0.716813,0.840983,0.130722,0.805002,0.36513,0.886154,0.382871,0.584278,1,0.476542,0.715483,0.088835,0.214313,0.668956,0.279007,0.556612,0.456492,0.579041,0.504462,0.282478,0.730716,0.846669,0.201671,0.755464,0.249645,0.908099,0.260591,0.467697,1,0.470757,0.762068,0.0722022,0.172736,0.659524,0.481715,0.518875,0.419795,0.450258,0.621594,0.261945,0.242194,0.364606,0.644044,0.652086,0.210453,0.557837,0.728195,0.462266,0.512843,1,0.201049,0.672684,0.371294,0.552182,0.431874,0.63735,0.575502,0.0271193,0.169856,0.0976911,0.245337,0.361275,0.624021,0.645387,0.169591,0.579282,0.728221,0.535766,0.539896,1,0.214133,0.784748,0.239458,0.550076,0.415226,0.667365,0.594916,0.0160324,0.150901,0.0740913,0.250097,0.378804,0.664824,0.667911,0.217667,0.574777,0.745489,0.477955,0.524182,1,0.261901,0.695175,0.404669,0.571591,0.445712,0.650393,0.586017,0.0134666,0.182718,0.074512},int(p*nModes+n) : rdtable : select2(modesFreqs(n)<(ma.SR/2-1),0);
modesT60s(i) = t60*pow(1-(modesFreqRatios(i)/136.982)*t60DecayRatio,t60DecaySlope);
};
