import("stdfaust.lib");

toneBar = shoeModelSteel(freq,exPos,t60,t60DecayRatio,t60DecaySlope)
with{
  freq = hslider("freq",30,0,2000,0.001) : si.smoo; 
  exPos = 0;
  t60 = 0.1;
  t60DecayRatio = 1;
  t60DecaySlope = 10; 
};

excitation = button("gate");

process = excitation : toneBar <: _,_;



shoeModelSteel(freq,exPos,t60,t60DecayRatio,t60DecaySlope) = _ <: par(i,nModes,pm.modeFilter(modesFreqs(i),modesT60s(i),modesGains(int(exPos),i))) :> /(nModes)
with{
nModes = 17;
nExPos = 6;
modesFreqRatios(n) = ba.take(n+1,(1,6.22507,17.2474,25.5554,118.911,145.673,163.778,230.875,283.652,306.318,384.332,390.829,406.657,438.189,497.834,510.593,547.477));
modesFreqs(i) = freq*modesFreqRatios(i);
modesGains(p,n) = waveform{1,0.94042,0.865387,0.0813237,0.807112,0.269878,0.926792,0.386938,0.592136,0.997269,0.468639,0.713843,0.0239666,0.166159,0.625277,0.295309,0.574723,0.992257,0.936441,0.86003,0.112547,0.804121,0.283198,0.921016,0.38864,0.589033,1,0.498495,0.713175,0.0617097,0.168165,0.645192,0.291398,0.563829,1,0.938074,0.881573,0.131888,0.757219,0.154972,0.93365,0.265434,0.477401,0.999994,0.490549,0.75394,0.13932,0.123889,0.635595,0.497294,0.525291,0.100283,0.0603349,0.325294,0.646741,0.655334,0.264917,0.538774,0.741222,0.475489,0.522334,1,0.282464,0.687526,0.350933,0.573978,0.460034,0.64376,0.101641,0.0714052,0.332893,0.646586,0.661826,0.235057,0.582509,0.756622,0.564989,0.564613,1,0.363858,0.82373,0.262829,0.593006,0.45079,0.693156,0.0939084,0.06417,0.344882,0.687436,0.684371,0.282676,0.571855,0.774309,0.506085,0.548198,1,0.378748,0.737732,0.422717,0.613976,0.489624,0.675953},int(p*nModes+n) : rdtable : select2(modesFreqs(n)<(ma.SR/2-1),0);
modesT60s(i) = t60*pow(1-(modesFreqRatios(i)/600.912)*t60DecayRatio,t60DecaySlope);
};


