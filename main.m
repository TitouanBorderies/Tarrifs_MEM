% main.m
% Ce script télécharge les données de PIB US depuis DBnomics,
% exécute un modèle DSGE Dynare, et trace les résultats.

%% Étape 1 : Télécharger les données PIB réel US depuis DBnomics

% URL corrigée pour données PIB BEA (plus directe pour le PIB réel US)
url = 'https://api.db.nomics.world/v22/series/CEPII/CHELEM-TRADE-INDIC?dimensions=%7B%22country%22%3A%5B%22USA%22%5D%7D&facets=1&format=json&limit=1000&observations=1&q=GDP';
filename = 'us_gdp.csv';

% Options avec Timeout étendu à 30 secondes
options = weboptions('Timeout', 30);
websave(filename, url, options);

%% Étape 2 : Lire les données CSV
opts = detectImportOptions(filename);
data = readtable(filename, opts);

% Extraire la date et les valeurs de PIB
periods = data{:, 'period'};
gdp_values = data{:, 'value'};

% Nettoyer les données (convertir string → datetime et string → double)
periods = datetime(periods, 'InputFormat', 'yyyy-QQ', 'Format', 'yyyy-QQ');
gdp_values = str2double(gdp_values); % au cas où les valeurs sont du texte

% Sauvegarder les données pour Dynare
save('us_gdp_data.mat', 'periods', 'gdp_values');

%% Étape 3 : Lancer Dynare avec le modèle
dynare model.mod noclearall

%% Étape 4 : Tracer le PIB observé vs simulé
n = min(length(gdp_values), length(oo_.endo_simul(1,:)));

figure;
hold on;
plot(periods(1:n), gdp_values(1:n), 'b-', 'LineWidth', 2);
plot(periods(1:n), oo_.endo_simul(1,1:n), 'r--', 'LineWidth', 2);
legend('PIB réel (observé)', 'PIB simulé (modèle Dynare)', 'Location', 'Best');
xlabel('Date');
ylabel('PIB');
title('Comparaison PIB observé vs PIB simulé');
grid on;
hold off;
