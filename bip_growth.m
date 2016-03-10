%% Bipartite Growth Model

% model parameters
time = 10000;            % number of time periods
lambda = 10;             % average number of edges attached per node 
p_lam = 1/(2*lambda);    % vertex attachment probability
ini_pref = 0.1;          % initial preference, must be > 0
m = 10;                   % nunber of edges per new node

% inistialise graph
u = 1;                   % number of nodes in U
v = 1;                   % number of nodes in V
G = zeros(u,v);          %create seed network
G(u:v,v:u) = 1;          % attach u1 to v1
sumedges = sum(sum(G));  % starting edges

% start time
t = 0;

while t < time
    % add 1 to timer
    t = t + 1
    % with prob (1/2lambda)
    if rand <= p_lam                            
        % add new node
        add_node = zeros(size(G,1)+1,size(G,2)+1);              
        add_node(1:size(G,1),1:size(G,2)) = G;  
        G = add_node;
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
    % with prob 1-(1/2lambda)
    else                                        
        % attach edge via uniform attachment
        node_u = ceil(rand * u); 
        % with prob (1/2lambda)
        if rand <= p_lam                         
            % add new node
            add_node = zeros(size(G,1)+1,size(G,2)+1);
            add_node(1:size(G,1),1:size(G,2)) = G;  
            G = add_node;
            % add node to V 
            v = v + 1;
            % select node m in V
            node_v = v;
            % add edge from node_v to node_u
            G(node_v,node_u) = 1;   
        % with prob 1-(1/2lambda)
        else                                        
            % attach edge via pref attachment
            node_v = pref_attach( G, node_u, ini_pref);
            % add 1 to edge count
            sumedges = sumedges + 1;  
            % add edge from node_v to node_u
            G(node_v,node_u) = 1;   
        end
    end                  
   
end

% find in/out degree
out_degree=sum(G,2); 
in_degree=sum(G,1);

% find complimentary cdf (out_degree)
x1 = out_degree;
x1 = reshape(x1,numel(x1),1); % reshape input vector
[cdfun, q] = ecdf(x1);
ccdf = 1-cdfun;
prob_df = [q ccdf];

% find complimentary cdf (in_degree)
x2 = in_degree;
x2 = reshape(x2,numel(x2),1); % reshape input vector
[cdfun, q] = ecdf(x2);
ccdf = 1-cdfun;
prob_df2 = [q ccdf];

% plot both degree distributions (loglog)
figure
hold on
h(1) = plot(prob_df(:,1),prob_df(:,2),'-');
h(2) = plot(prob_df2(:,1),prob_df2(:,2),'-');
legend('Exporters','Importers')
set(gca,'XLim',([0 1000]));
set(gca,'YLim',([0.001 1]));
set(gca,'yscale','log')
set(gca,'xscale','log')
xlabel('k','FontSize',11)
ylabel('Pr(K \geq k)','FontSize',11)
grid on
box on
axis square
