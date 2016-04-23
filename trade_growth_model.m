%% Trade Growth Model

% model parameters
time = 1000;                 % number of time periods
lambda = 0.1;                % vertex attachment probability
ini_pref = 0.1;              % initial preference, must be > 0

% inistialise graph
u = 1;                       % number of nodes
G = zeros(time,time);        % create seed network
sumedges = sum(sum(G));      % starting edges
G(1,1,:) = 1;

% start time
t = 0;

while t < time
    % add 1 to timer
    t = t + 1;
    %_____EXTRINSIC GROWTH_____%
    if rand <= lambda
        % add node to U
        u = u + 1;
        % select node u in U
        node_u = u;
        for i = 1:5
        % attach edge via pref attachment
        node_y = pref_attach( G, node_u, ini_pref);
        % add edge from node_v to node_u
        G(node_y,node_u) = 1;     
        % add 1 to edge count
        sumedges = sumedges + 1; 
        end
    else
        %_____INTRINSIC GROWTH_____%   
        % attach edge via uniform attachment
        node_a = ceil(rand * u);                   
        % attach edge via pref attachment
        node_b = pref_attach( G, node_a, ini_pref);
        % add edge from node_v to node_u
        G(node_b,node_a) = 1;
        % add 1 to edge count
        sumedges = sumedges + 1;
    end
   
end               
