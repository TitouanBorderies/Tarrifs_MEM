var y c k i tau_H;
varexo e_tau;

parameters beta rho alpha delta theta tau_bar;

beta = 0.99;
rho = 0.9;
alpha = 0.33;
delta = 0.025;
theta = 2;
tau_bar = 0.1;

model;
c = (1 - alpha)*(1 - tau_H)*y;
y = k(-1)^alpha;
i = y - c;
k = (1 - delta)*k(-1) + i;
log(tau_H) = log(tau_bar) + e_tau;
end;

initval;
k = 1;
y = 1;
c = 0.8;
i = 0.2;
tau_H = tau_bar;
e_tau = 0;
end;

shocks;
var e_tau;
periods 10:12;
values 0.2;  // Choc de taxe douanière temporaire
end;

stoch_simul(order=1,irf=20);

% Charger données réelles pour comparaison
load gdp_data.mat;
T = length(log_gdp);
disp('Derniers points PIB réel (log) :');
disp(log_gdp(T-4:T));
