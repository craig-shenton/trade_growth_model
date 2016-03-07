
time = 100;             % number of time periods
lambda = 1;             % average number of edges attached per node 
p_lam = 1/(2*lambda);   % vertex attachment probability

n = 1;                  % nodes in U
m = 1;                  % nodes in V

G = zeros(n+m,n+m);     %create seed network

G(n:m,n+m:n+m) = 1;     % attach u1 to v1

sumedges = sum(sum(G)); % starting edges

t = 0;
while t < time
    t = t + 1;                                  % add 1 to timer
    if rand <= p_lam                            % with prob (1/2lambda)
        n = n + 1;                              % add node to U
        add_node = zeros(size(G,1)+1,size(G,1)+1);              
        add_node(1:size(G,1),1:size(G,1)) = G;  % expand G by 1 row/col
        G = add_node;
        node_n = n;                             % select node n in U
        
    else                                        % with prob 1-(1/2lambda)
        node_n = ceil(rand * n);                % select random node in U   
    end
    
    if rand <= p_lam                            % with prob (1/2lambda)
        m = m + 1;                              % add node to U           
        add_node = zeros(size(G,1)+1,size(G,1)+1);
        add_node(1:size(G,1),1:size(G,1)) = G;              % expand G by 1 row/col
        G = add_node;
        node_m = m;                             % select node m in V
    else                                        % with prob 1-(1/2lambda)
        deg = sum(G,2);
        deg_m = RouletteWheelSelection(deg);    % pick on pref attachment
        if G(node_n,deg_m) == ~1                % if not connected 
            node_m = rand_m;                    % select pref node in V
            sumedges = sumedges + 1;            % add 1 to edge count
        else
            
        end    
    end
    G(n+node_m,node_n) = 1;                      % add edge from node_m to node_n
   
end

out_degree=sum(G,2); 
in_degree=sum(G,1);


x1 = out_degree;
x1 = reshape(x1,numel(x1),1); % reshape input vector
[cdfun, q] = ecdf(x1);
ccdf = 1-cdfun;
prob_df1 = [q ccdf];

x2 = in_degree;
x2 = reshape(x2,numel(x2),1); % reshape input vector
[cdfun, q] = ecdf(x2);
ccdf = 1-cdfun;
prob_df2 = [q ccdf];

figure
hold on
h(1) = plot(prob_df1(:,1),prob_df1(:,2),'-');
h(2) = plot(prob_df2(:,1),prob_df2(:,2),'-');
legend('Exporters','Importers')
set(gca,'XLim',([0 200]));
%set(gca,'YLim',([0.001 10]));
set(gca,'yscale','log')
set(gca,'xscale','log')
xlabel('k','FontSize',11)
ylabel('Pr(K \geq k)','FontSize',11)
grid on
box on
axis square
