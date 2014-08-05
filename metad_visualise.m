% Visualisation and diagnostics for meta-d' fit object generated either by
% HMM toolbox
%
% SF 2014

%% Observed and expected type 2 ROCs for S1 and S2 responses
h1 = figure(1);
set(gcf, 'Position', [500 500 1000 1000]);

subplot(2,2,1);
plot(fit.obs_FAR2_rS1, fit.obs_HR2_rS1, 'ko-','linewidth',1.5,'markersize',12);
hold on
plot(fit.est_FAR2_rS1, fit.est_HR2_rS1, '+-','color',[0.5 0.5 0.5], 'linewidth',1.5,'markersize',10);
set(gca, 'XLim', [0 1], 'YLim', [0 1], 'FontSize', 16);
ylabel('HR2');
xlabel('FAR2');
line([0 1],[0 1],'linestyle','--','color','k');
axis square
box off

subplot(2,2,2);
plot(fit.obs_FAR2_rS2, fit.obs_HR2_rS2, 'ko-','linewidth',1.5,'markersize',12);
hold on
plot(fit.est_FAR2_rS2, fit.est_HR2_rS2, '+-','color',[0.5 0.5 0.5], 'linewidth',1.5,'markersize',10);
set(gca, 'XLim', [0 1], 'YLim', [0 1], 'FontSize', 16);
ylabel('HR2');
xlabel('FAR2');
line([0 1],[0 1],'linestyle','--','color','k');
axis square
box off

%% Observed and expected type 2 ROC in z-space

subplot(2,2,3);
plot(norminv(fit.obs_FAR2_rS1), norminv(fit.obs_HR2_rS1), 'ko-','linewidth',1.5,'markersize',12);
hold on
plot(norminv(fit.est_FAR2_rS1), norminv(fit.est_HR2_rS1), '+-','color',[0.5 0.5 0.5], 'linewidth',1.5,'markersize',10);
set(gca, 'FontSize', 16);
ylabel('z(HR2)');
xlabel('z(FAR2)');
axis square
box off

subplot(2,2,4);
plot(norminv(fit.obs_FAR2_rS2), norminv(fit.obs_HR2_rS2), 'ko-','linewidth',1.5,'markersize',12);
hold on
plot(norminv(fit.est_FAR2_rS2), norminv(fit.est_HR2_rS2), '+-','color',[0.5 0.5 0.5], 'linewidth',1.5,'markersize',10);
set(gca, 'FontSize', 16);
ylabel('z(HR2)');
xlabel('z(FAR2)');
axis square
box off

%% Plot posteriors for parameters
h2 = figure(2);
maxSamp = [];
subplot(1,2,1);
for i = 1:length(fit.t2ca_rS1)
    [n x] = hist(fit.mcmc.samples.cS1(1,:,i));
    bar(x, n, 'edgecolor','b','facecolor',[1 1 1]);
    hold on
    maxSamp = [maxSamp max(n)];
end
for i = 1:length(fit.t2ca_rS2)
    [n x] = hist(fit.mcmc.samples.cS2(1,:,i));
    bar(x, n, 'edgecolor','b','facecolor',[1 1 1]);
    hold on
    maxSamp = [maxSamp max(n)];
end
xlabel('c_2');
ylabel('samples');

subplot(1,2,2);
[n x] = hist(fit.mcmc.samples.meta_d(1,:));
bar(x, n, 'edgecolor','b','facecolor',[1 1 1]);
xlabel('meta-d''');
ylabel('samples');