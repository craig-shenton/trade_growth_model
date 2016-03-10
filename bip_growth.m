%% Bipartite Growth Model

% model parameters
time = 10000;            % number of time periods
lambda = 1;              % vertex attachment probability
ini_pref = 0.1;          % initial preference, must be > 0
m = 1;                   % nunber of edges per new node

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
    %_____EXTRINSIC GROWTH_____%
    if rand <= lambda
        if rand < 0.5
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
        else
            % attach edge via uniform attachment
            node_u = ceil(rand * u);                 
            % add node to V 
            v = v + 1;
            % select node m in V
            node_v = v;
            % add edge from node_v to node_u
            G(node_v,node_u) = 1;
            % add 1 to edge count
            sumedges = sumedges + 1;
        end
    end
    %_____INTRINSIC GROWTH_____%   
    % attach edge via uniform attachment
    node_u = ceil(rand * u);                   
    % attach edge via pref attachment
    node_v = pref_attach( G, node_u, ini_pref);
    % add edge from node_v to node_u
    G(node_v,node_u) = 1;
    % add 1 to edge count
    sumedges = sumedges + 1;  
end                
   

% find in/out degree
out_degree=sum(G(1:node_u,1:node_u),2); 
in_degree=sum(G(1:node_u,1:node_u),1);

% find complimentary cdf (out_degree)
x1 = out_degree;
x1 = reshape(x1,numel(x1),1); % reshape input vector
[cdfun, q, flo,fup] = ecdf(x1);
ccdf = 1-cdfun;
prob_df = [q ccdf flo fup];

% find complimentary cdf (in_degree)
x2 = in_degree;
x2 = reshape(x2,numel(x2),1); % reshape input vector
[cdfun, q, flo,fup] = ecdf(x2);
ccdf = 1-cdfun;
prob_df2 = [q ccdf flo fup];

% plot both degree distributions (loglog)
figure
hold on
h(5) = stairs(prob_df(:,1),prob_df(:,2),'b-','LineWidth',1);
h(1) = stairs(prob_df(:,1),1-prob_df(:,3),'b--'); 
h(2) = stairs(prob_df(:,1),1-prob_df(:,4),'b--');
h(6) = stairs(prob_df2(:,1),prob_df2(:,2),'r-','LineWidth',1);
h(3) = stairs(prob_df2(:,1),1-prob_df2(:,3),'r--'); 
h(4) = stairs(prob_df2(:,1),1-prob_df2(:,4),'r--');
leg_info = get(h, 'Annotation');
for i = 1:4
    y2 = get(leg_info{i}, 'LegendInformation');
    set(y2, 'IconDisplayStyle', 'off')
end
legend('Exporters','Importers')
title('Model Paramerters, \lambda = 1, m = 1')
set(gca,'XLim',([0 1000]));
set(gca,'YLim',([0.001 1]));
set(gca,'yscale','log')
set(gca,'xscale','log')
xlabel('k','FontSize',11)
ylabel('Pr(K \geq k)','FontSize',11)
grid on
box on
axis square
set(gcf, 'Position', [10 10 400 400])
set(gcf, 'Color', 'w');
export_fig 'C:\Users\craigrshenton\Desktop\Dropbox\thesis\4_results\bipartite_gen_model\img\model_lambda_1.eps' ...
    -eps;                                            
export_fig 'C:\Users\craigrshenton\Desktop\Dropbox\thesis\4_results\bipartite_gen_model\img\model_lambda_1.png' ...
    -png;
