function [ node_m ] = pref_attach( G, node_n, ini_pref)

% preferential attachment mechanism - 
% i.e., node_n attaches to node_m via pref attachment

% INPUT: 
% G - adjacency matrix
% node_n - source node
% ini_pref - initial preference, must be > 0 (hidden model parameter)

% OUTPUT: 
% node_m - target node

degree = sum(G,1);
% select node based on degree, k
node_m = RouletteWheelSelection(degree+ini_pref);
% check if connected
check_link = G(node_n,node_m);
% if connected 
while check_link < 0 
     % pick on pref attachment
     deg_m = RouletteWheelSelection(degree+ini_pref);
     % check if connected
     check_link = G(node_n,node_m);
end

end