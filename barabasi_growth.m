%% Barabasi Growth Model

% model parameters
time = 1000;            % number of time periods
ini_pref = 0.1;          % initial preference, must be > 0
m = 5;                   % nunber of edges per new node

% inistialise graph
u = m;                   % number of nodes in U
v = m;                   % number of nodes in V
G = zeros(time+1,time+1);    % create seed network
M = magic(m);
M(M <= m^2-m) = 0;
M(M > m^2-m) = 1;
G(1:m,1:m) = M;
sumedges = sum(sum(G));  % starting edges

% start time
t = m;

while t < time
    % add 1 to timer
    t = t + 1                    
    % add node to U
    u = u + 1;  
    % select node u in U
    node_u = u;                             
    % attach edge via pref attachment
    for i = 1:m
        node_v = pref_attach( G, node_u, ini_pref);
        % add edge from node_v to node_u
        G(node_v,node_u) = 1;     
        % add 1 to edge count
        sumedges = sumedges + 1; 
    end              
end

% find in/out degree
degree=sum(G,2); 

% find complimentary cdf (out_degree)
x1 = degree;
x1 = reshape(x1,numel(x1),1); % reshape input vector
[cdfun, q] = ecdf(x1);
ccdf = 1-cdfun;
prob_df = [q ccdf];

% plot both degree distributions (loglog)
figure
hold on
h(1) = plot(prob_df(:,1),prob_df(:,2),'-');
legend('Barabasi')
set(gca,'XLim',([0 1000]));
set(gca,'YLim',([0.0001 1]));
set(gca,'yscale','log')
set(gca,'xscale','log')
xlabel('k','FontSize',11)
ylabel('Pr(K \geq k)','FontSize',11)
grid on
box on
axis square
