%% Bipartite Growth Model

% model parameters
time = 10000;               % number of time periods
lambda = 0.05;              % vertex attachment probability
ini_pref = 0.1;             % initial preference, must be > 0
m = 1;                      % nunber of edges per new node
n = m;                      % number of nodes in the network

% inistialise graph
u = m;                      % number of nodes in U
v = m;                      % number of nodes in V
G = zeros(time+1,time+1);   % create seed network
M = magic(m);
M(M <= m^2-m) = 0;
M(M > m^2-m) = 1;
G(1:m,1:m) = M;
sumedges = sum(sum(G));     % starting edges

% start time
t = m;

while n < 1000
    % add 1 to timer
    t = t + 1;
    %_____EXTRINSIC GROWTH_____%
    if rand <= lambda
        if rand < 0.5
            % add node to U
            u = u + 1;
            n = n + 1;
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
            n = n + 1;
            % select node v in V
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

%% plot both degree distributions (loglog)

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
title('Model Paramerters, \lambda = 0.05, m = 1')
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
%export_fig 'C:\Users\craigrshenton\Desktop\Dropbox\thesis\4_results\bipartite_gen_model\img\model_lambda_005.eps' ...
%    -eps;                                            
%export_fig 'C:\Users\craigrshenton\Desktop\Dropbox\thesis\4_results\bipartite_gen_model\img\model_lambda_005.png' ...
%    -png;

%% model attachment rate

% out = [out_degree1(1:size(out_degree,1)) out_degree];
% in = [in_degree1(1:size(out_degree,1))' in_degree'];
% 
% figure
% subplot(2,1,1)
% % h(1) = fill(X,Y,'r','EdgeColor','none');
% % set(h(1),'facealpha',.2)
% %h(2) = plot(Out_all(:,2),Out_all(:,1),'+');
% [pd,gof,output] = fit(out(:,2),out(:,1),'poly2');
% coeffs = coeffvalues(pd);
% eq = 'A_k = a*k^2 + b*k + c';
% h = plot(pd,out(:,2),out(:,1),'+');
% % coeffs = polyfit(Out_all(:,2),Out_all(:,1), 2);
% % fittedX = linspace(min(Out_all(:,2)), max(Out_all(:,2)), length(Out_all(:,1)));
% % fittedY = polyval(coeffs, fittedX);
% % h(3) = plot(fittedX, fittedY,'-','linewidth',1,'Color','r');
% leg_info = get(h, 'Annotation');
% y2 = get(leg_info{1}, 'LegendInformation');
% set(y2, 'IconDisplayStyle', 'off')
% legend(eq,'location','southeast')
% t=textLoc(sprintf('Adj R^{2} = %.2f\na = %.2f\nb = %.2f\nc = %.2f',...
%     gof.adjrsquare,coeffs(1),coeffs(2),coeffs(3)),{'NorthWest',1/50},'FontSize',8);
% xlabel('k','FontSize',11)
% ylabel('A_{k}','FontSize',11)
% title('Exporters')
% set(gca,'XLim',([0 200]));
% set(gca,'YLim',([0 400]));
% %set(gca,'Xtick',0:10:120)
% %set(gca,'Ytick',0:10:50)
% grid on
% box on
% %axis square
% 
% subplot(2,1,2)
% hold on
% h(1) = plot(in(:,2),in(:,1),'+');
% xlabel('k','FontSize',11)
% ylabel('A_{k}','FontSize',11)
% title('Importers')
% set(gca,'XLim',([0 200]));
% set(gca,'YLim',([0 400]));
% %set(gca,'Xtick',0:10:120)
% %set(gca,'Ytick',0:10:50)
% grid on
% box on
% %axis square
% 
% set(gcf, 'Position', [10 10 800 700])
% set(gcf, 'Color', 'w');
% %export_fig 'C:\Users\craigrshenton\Desktop\Dropbox\thesis\5_results\bipartite_gen_model\img\attachment_rate.eps' ...
%     %-eps;                                            
% %export_fig 'C:\Users\craigrshenton\Desktop\Dropbox\thesis\5_results\bipartite_gen_model\img\attachment_rate.png' ...
%     %-png;