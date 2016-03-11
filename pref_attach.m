function [ node_v ] = pref_attach( G, node_u, ini_pref)

% preferential attachment mechanism - 
% i.e., node_n attaches to node_m via pref attachment

% INPUT: 
% G - adjacency matrix
% node_n - source node
% ini_pref - initial preference, must be > 0 (hidden model parameter)

% OUTPUT: 
% node_m - target node

% find k in G
degree = sum(G(1:node_u,1:node_u),2);
if sum(degree) < size(degree,1)
    % check if connected
    check_link = false;
    while ~check_link
        % pick node_v via pref attachment
        node = RouletteWheelSelection(degree+ini_pref);
        % check if connected
        check_link = (G(node,node_u) == 0);
    end
    node_v = node;
else
    % if all are connected
    node_v = RouletteWheelSelection(degree+ini_pref);

end