%% Function - doPeel
function [spikeInfer,dFFInfer,dFFResidual] = doPeel(dff,frameRate,S)

%fetch parameters
ca_genmode=S.ca_genmode;
spk_recmode=S.spk_recmode;
A1=S.A1;
tau1=S.tau1;
A2=S.A2;
tau2=S.tau2;
tauOn=S.tauOn;
ca_rest=S.ca_rest;
ca_amp=S.ca_amp;
ca_gamma=S.ca_gamma;
ca_onsettau=S.ca_onsettau;
ca_amp1=S.ca_amp1;
ca_tau1=S.ca_tau1;
ca_kappas=S.ca_kappas;
dffmax=S.dffmax;
kd=S.kd;
kappab=S.kappab;
sdnoise=S.sdnoise;
schmitt=S.peelOptions.schmitt;
peel_p=S.peelOptions.peel_p;

for m = 1:size(dff,1)
    %     [ca_p,exp_p,peel_p, data] = InitPeeling(dff(m,:),frameRate);  
    
    % override some parameters, if necessary
    ca_p.ca_genmode = ca_genmode;
    ca_p.amp1=A1;
    ca_p.tau1=tau1;
    ca_p.amp2=A2;
    ca_p.tau2=tau2;
    ca_p.onsettau = tauOn;
    ca_p.ca_rest= ca_rest;
    ca_p.ca_amp= ca_amp;
    ca_p.ca_gamma= ca_gamma;
    ca_p.ca_onsettau= ca_onsettau;
    ca_p.ca_amp1= ca_amp1;
    ca_p.ca_tau1= ca_tau1;
    ca_p.ca_kappas= ca_kappas;

    exp_p.dffmax=dffmax;
    exp_p.kd=kd;
    exp_p.kappab=kappab;
    exp_p.noiseSD = sdnoise;
    
    switch lower(ca_p.ca_genmode)
        case 'lindff'
            PeakA = A1 .* (tau1./tauOn.*(tau1./tauOn+1).^-(tauOn./tau1+1));
        case 'satdff'
            ca_p.ca_amp1=ca_p.ca_amp./(1+ca_p.ca_kappas+exp_p.kappab);             % set for consistency
            ca_p.ca_tau1=(1+ca_p.ca_kappas+exp_p.kappab)./ca_p.ca_gamma;
            PeakCa = ca_p.ca_amp1 + ca_p.ca_rest;
            PeakDFF = Calcium2Fluor(PeakCa,ca_p.ca_rest,exp_p.kd,exp_p.dffmax);
            PeakA = PeakDFF .* ...
                (ca_p.ca_tau1./ca_p.ca_onsettau.*(ca_p.ca_tau1./ca_p.ca_onsettau+1).^-(ca_p.ca_onsettau./ca_p.ca_tau1+1));
        otherwise
            error('Error in DoPeel. Illdefined SpkGenMode');
    end
    
    snr = PeakA./exp_p.noiseSD;
    
    peel_p.spk_recmode = spk_recmode;
    peel_p.smtthigh = schmitt(1)*exp_p.noiseSD;
    peel_p.smttlow = schmitt(2)*exp_p.noiseSD;
    
    peel_p.smttmindur= schmitt(3);
    peel_p.slidwinsiz = 10.0;
    peel_p.fitupdatetime=0.5;
    
    peel_p.doPlot = 0;
    
    [ca_p, peel_p, data] = Peeling(dff(m,:), frameRate, ca_p, exp_p, peel_p);
    
    spikeInfer{m} = data.spikes;
    dFFInfer{m} = data.model;
    dFFResidual{m} = data.peel;
end