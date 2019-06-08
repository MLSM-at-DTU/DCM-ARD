clear;
close all;
rng(42); % fix seed for reproducibility

outdir = 'output_hard_spec/';
inputFile = 'swissmetro_processed.csv';
dataName = 'swissmetro_varalt_shuffled_groups_hardfakespec1';

fprintf('Output directory: %s\n', outdir);
fprintf('Input file: %s\n', inputFile);
fprintf('Data name: %s\n', dataName);

% load data
M = csvread(inputFile,1);
    
% shuffle data
M = M(randperm(size(M,1)),:);

% process data
ids = M(:,1);
Y_true = M(:,2);
age = M(:,3);
ga = M(:,4)+1;
purpose = M(:,5);
who = M(:,6)+1;
luggage = M(:,7)+1; 
luggage(luggage == 4) = 3;
income = M(:,8)+1;
availableChoices = M(:,9:11);
TRAIN_ASC = ones(length(M),1);
TRAIN_TT = M(:,12);
TRAIN_CO = M(:,15);
TRAIN_HE = M(:,18);
SM_ASC = ones(length(M),1);
SM_TT = M(:,13);
SM_CO = M(:,16);
SM_HE = M(:,19);
CAR_ASC = ones(length(M),1);
CAR_TT = M(:,14);
CAR_CO = M(:,17);

% define specifications to test
alternative_names = {'TRAIN', 'SM', 'CAR'};
specs = cell(length(alternative_names),1);


% hard search space
specs{1} = {...
        ... % TRAIN_ASC
        'TRAIN_ASC', 'TRAIN_ASC x ga', 'TRAIN_ASC x age', 'TRAIN_ASC x purpose', 'TRAIN_ASC x who', 'TRAIN_ASC x luggage', 'TRAIN_ASC x income',... 
        ... % TRAIN_TT
        'TRAIN_TT', 'TRAIN_TT x ga', 'TRAIN_TT x age', 'TRAIN_TT x purpose', 'TRAIN_TT x who', 'TRAIN_TT x luggage', 'TRAIN_TT x income',...
        'segt(TRAIN_TT,4)','segt(TRAIN_TT,8)',...
        'logt(TRAIN_TT)', 'logt(TRAIN_TT) x ga', 'logt(TRAIN_TT) x age', 'logt(TRAIN_TT) x purpose', 'logt(TRAIN_TT) x who', 'logt(TRAIN_TT) x luggage', 'logt(TRAIN_TT) x income',...
        'boxt(TRAIN_TT)', 'boxt(TRAIN_TT) x ga', 'boxt(TRAIN_TT) x age', 'boxt(TRAIN_TT) x purpose', 'boxt(TRAIN_TT) x who', 'boxt(TRAIN_TT) x luggage', 'boxt(TRAIN_TT) x income',...
        ... % TRAIN_CO
        'TRAIN_CO', 'TRAIN_CO x ga', 'TRAIN_CO x age', 'TRAIN_CO x purpose', 'TRAIN_CO x who', 'TRAIN_CO x luggage', 'TRAIN_CO x income',...
        'segt(TRAIN_CO,4)','segt(TRAIN_CO,8)',...
        'logt(TRAIN_CO)', 'logt(TRAIN_CO) x ga', 'logt(TRAIN_CO) x age', 'logt(TRAIN_CO) x purpose', 'logt(TRAIN_CO) x who', 'logt(TRAIN_CO) x luggage', 'logt(TRAIN_CO) x income',...
        'boxt(TRAIN_CO)', 'boxt(TRAIN_CO) x ga', 'boxt(TRAIN_CO) x age', 'boxt(TRAIN_CO) x purpose', 'boxt(TRAIN_CO) x who', 'boxt(TRAIN_CO) x luggage', 'boxt(TRAIN_CO) x income',...
        ... % TRAIN_HE
        'TRAIN_HE', 'TRAIN_HE x ga', 'TRAIN_HE x age', 'TRAIN_HE x purpose', 'TRAIN_HE x who', 'TRAIN_HE x luggage', 'TRAIN_HE x income',...
        ...%'segt(TRAIN_HE,3)',...
        'logt(TRAIN_HE)', 'logt(TRAIN_HE) x ga', 'logt(TRAIN_HE) x age', 'logt(TRAIN_HE) x purpose', 'logt(TRAIN_HE) x who', 'logt(TRAIN_HE) x luggage', 'logt(TRAIN_HE) x income'};
        %'boxt(TRAIN_HE)', 'boxt(TRAIN_HE) x ga', 'boxt(TRAIN_HE) x age', 'boxt(TRAIN_HE) x purpose'};
specs{2} = {...
        ... % SM_ASC
        'SM_ASC', 'SM_ASC x ga', 'SM_ASC x age', 'SM_ASC x purpose', 'SM_ASC x who', 'SM_ASC x luggage', 'SM_ASC x income',... 
        ... % SM_TT
        'SM_TT', 'SM_TT x ga', 'SM_TT x age', 'SM_TT x purpose', 'SM_TT x who', 'SM_TT x luggage', 'SM_TT x income',...
        'segt(SM_TT,4)','segt(SM_TT,8)',...
        'logt(SM_TT)', 'logt(SM_TT) x ga', 'logt(SM_TT) x age', 'logt(SM_TT) x purpose', 'logt(SM_TT) x who', 'logt(SM_TT) x luggage', 'logt(SM_TT) x income',...
        'boxt(SM_TT)', 'boxt(SM_TT) x ga', 'boxt(SM_TT) x age', 'boxt(SM_TT) x purpose', 'boxt(SM_TT) x who', 'boxt(SM_TT) x luggage', 'boxt(SM_TT) x income',...
        ... % SM_CO
        'SM_CO', 'SM_CO x ga', 'SM_CO x age', 'SM_CO x purpose', 'SM_CO x who', 'SM_CO x luggage', 'SM_CO x income',...
        ...%'segt(SM_CO,4)','segt(SM_CO,8)',...
        'logt(SM_CO)', 'logt(SM_CO) x ga', 'logt(SM_CO) x age', 'logt(SM_CO) x purpose', 'logt(SM_CO) x who', 'logt(SM_CO) x luggage', 'logt(SM_CO) x income',...
        'boxt(SM_CO)', 'boxt(SM_CO) x ga', 'boxt(SM_CO) x age', 'boxt(SM_CO) x purpose', 'boxt(SM_CO) x who', 'boxt(SM_CO) x luggage', 'boxt(SM_CO) x income',...
        ... % SM_HE
        'SM_HE', 'SM_HE x ga', 'SM_HE x age', 'SM_HE x purpose', 'SM_HE x who', 'SM_HE x luggage', 'SM_HE x income',...
        ...%'segt(SM_HE,3)',...
        'logt(SM_HE)', 'logt(SM_HE) x ga', 'logt(SM_HE) x age', 'logt(SM_HE) x purpose', 'logt(SM_HE) x who', 'logt(SM_HE) x luggage', 'logt(SM_HE) x income'};
        %'boxt(SM_HE)', 'boxt(SM_HE) x ga', 'boxt(SM_HE) x age', 'boxt(SM_HE) x purpose'};
specs{3} = {...%'CAR_ASC', 'CAR_ASC x ga', 'CAR_ASC x age', 'CAR_ASC x purpose',...
        ... % CAR_TT
        'CAR_TT', 'CAR_TT x ga', 'CAR_TT x age', 'CAR_TT x purpose', 'CAR_TT x who', 'CAR_TT x luggage', 'CAR_TT x income',...
        'segt(CAR_TT,4)','segt(CAR_TT,8)',...
        'logt(CAR_TT)', 'logt(CAR_TT) x ga', 'logt(CAR_TT) x age', 'logt(CAR_TT) x purpose', 'logt(CAR_TT) x who', 'logt(CAR_TT) x luggage', 'logt(CAR_TT) x income',...
        'boxt(CAR_TT)', 'boxt(CAR_TT) x ga', 'boxt(CAR_TT) x age', 'boxt(CAR_TT) x purpose', 'boxt(CAR_TT) x who', 'boxt(CAR_TT) x luggage', 'boxt(CAR_TT) x income',...
        ... % CAR_CO
        'CAR_CO', 'CAR_CO x ga', 'CAR_CO x age', 'CAR_CO x purpose', 'CAR_CO x who', 'CAR_CO x luggage', 'CAR_CO x income',...
        'segt(CAR_CO,4)','segt(CAR_CO,8)',...
        'logt(CAR_CO)', 'logt(CAR_CO) x ga', 'logt(CAR_CO) x age', 'logt(CAR_CO) x purpose', 'logt(CAR_CO) x who', 'logt(CAR_CO) x luggage', 'logt(CAR_CO) x income',...
        'boxt(CAR_CO)', 'boxt(CAR_CO) x ga', 'boxt(CAR_CO) x age', 'boxt(CAR_CO) x purpose', 'boxt(CAR_CO) x who', 'boxt(CAR_CO) x luggage', 'boxt(CAR_CO) x income'};

fprintf('\nVariables to consider for each utility function:\n');
for c=1:length(specs)
    fprintf('%s: ', alternative_names{c});
    for d=1:length(specs{c})
        fprintf('%s, ', specs{c}{d});
    end
    fprintf('\n');
end

% "fake" specifications for generating aritifical choices
generateFakeData = true;
fakeSpec = cell(length(alternative_names),1);

% easy/hard fake spec 1
fakeSpec{1} = {'TRAIN_ASC', 'TRAIN_TT', 'TRAIN_CO'};
fakeSpec{2} = {'SM_ASC', 'SM_TT', 'SM_CO'};
fakeSpec{3} = {'CAR_TT', 'CAR_CO'};

% % easy/hard fake spec 2
% fakeSpec{1} = {'TRAIN_ASC',  'TRAIN_TT', 'TRAIN_TT x age', 'TRAIN_CO'};
% fakeSpec{2} = {'SM_ASC', 'SM_TT', 'SM_CO', 'SM_CO x ga'};
% fakeSpec{3} = {'CAR_TT', 'CAR_TT x age', 'CAR_CO'};
 
% % easy/hard fake spec 3
% fakeSpec{1} = {'TRAIN_ASC',  'TRAIN_TT', 'TRAIN_TT x age', 'TRAIN_CO', 'TRAIN_CO x ga', 'TRAIN_HE'};
% fakeSpec{2} = {'SM_ASC', 'SM_TT', 'SM_CO', 'SM_CO x ga', 'logt(SM_HE)'};
% fakeSpec{3} = {'CAR_TT', 'CAR_TT x age', 'CAR_CO'};

% % easy/hard fake spec 4
% fakeSpec{1} = {'TRAIN_ASC', 'TRAIN_ASC x ga', 'TRAIN_TT', 'TRAIN_CO'};
% fakeSpec{2} = {'SM_ASC', 'SM_ASC x ga', 'SM_TT', 'SM_CO'};
% fakeSpec{3} = {'CAR_TT', 'CAR_CO'};

% % easy/hard fake spec 5
% fakeSpec{1} = {'TRAIN_ASC', 'TRAIN_ASC x ga', 'TRAIN_TT', 'TRAIN_CO'};
% fakeSpec{2} = {'SM_ASC', 'SM_ASC x ga', 'SM_TT', 'SM_CO'};
% fakeSpec{3} = {'CAR_TT', 'CAR_CO', 'CAR_CO x purpose'};

% % hard fake spec 6
% fakeSpec{1} = {'TRAIN_ASC', 'TRAIN_CO', 'boxt(TRAIN_TT)', 'boxt(TRAIN_TT) x ga'};
% fakeSpec{2} = {'SM_ASC', 'SM_TT',};
% fakeSpec{3} = {'CAR_TT', 'CAR_CO'};

% % hard fake spec 7
% fakeSpec{1} = {'TRAIN_ASC', 'boxt(TRAIN_TT)', 'TRAIN_CO'};
% fakeSpec{2} = {'SM_ASC', 'boxt(SM_TT)', 'SM_CO'};
% fakeSpec{3} = {'boxt(CAR_TT)', 'CAR_CO'};

% % hard fake spec 8
% fakeSpec{1} = {'TRAIN_ASC', 'TRAIN_ASC x ga', 'TRAIN_TT', 'TRAIN_CO', 'TRAIN_CO x who'};
% fakeSpec{2} = {'SM_ASC', 'SM_ASC x ga', 'SM_TT', 'SM_CO', 'SM_CO x who'};
% fakeSpec{3} = {'CAR_TT', 'CAR_CO', 'CAR_CO x luggage'};

% % hard fake spec 9
% fakeSpec{1} = {'TRAIN_ASC', 'TRAIN_TT', 'TRAIN_CO', 'TRAIN_CO x ga'};
% fakeSpec{2} = {'SM_ASC', 'SM_TT', 'SM_TT x age', 'SM_CO', 'SM_CO x ga'};
% fakeSpec{3} = {'CAR_TT', 'CAR_CO', 'CAR_CO x income'};

% % hard fake spec 10
% fakeSpec{1} = {'TRAIN_ASC', 'logt(TRAIN_TT)', 'TRAIN_CO', 'TRAIN_CO x who'};
% fakeSpec{2} = {'SM_ASC', 'SM_ASC x age', 'boxt(SM_TT)', 'SM_CO', 'SM_CO x ga', 'SM_HE'};
% fakeSpec{3} = {'boxt(CAR_TT)', 'CAR_CO', 'CAR_CO x income'};

if generateFakeData
    fprintf('\nTrue specification for generating artificial choices:\n');
    for c=1:length(fakeSpec)
        fprintf('%s: ', alternative_names{c});
        for d=1:length(fakeSpec{c})
            fprintf('%s, ', fakeSpec{c}{d});
        end
        fprintf('\n');
    end
end

% generate dataset (i.e. all variable transformation and interactions)
fprintf('\nGenerating dataset with all possible variable transformation and interactions...\n');
N = size(Y_true,1);
nChoices = max(Y_true); % number of choices/classes
% create feature transformations
D = zeros(nChoices,1);
D_fake = zeros(nChoices,1);
groups = cell(nChoices,1);
X = cell(nChoices,1);
X_fake = cell(nChoices,1); % for generating fake choices
for c=1:nChoices
    groups{c} = [];
    X{c} = [];
    X_fake{c} = [];
    for d=1:length(specs{c})
        varName = specs{c}{d};
        %fprintf('choice %s: adding variable %s\n', alternative_names{c}, varName);
        if contains(varName, ' x ')
            [matches,~] = strsplit(varName,'\s* x \s*','DelimiterType','RegularExpression');
            var = eval(matches{1});
            inter_vars = cell(length(matches) - 1, 1);
            for i=1:length(inter_vars)
                inter_vars{i} = eval(matches{i+1});
            end
            res = [];
            for n=1:N
                if length(inter_vars) == 1
                    dim = max(inter_vars{1})-1; % last column is unnecessary
                    vec = zeros(1,dim);
                    sn = inter_vars{1}(n);
                    if sn <= dim
                        vec(sn) = var(n);
                    end
                elseif length(inter_vars) == 2
                    dim = (max(inter_vars{1})-1)*(max(inter_vars{2})-1); % last column is unnecessary
                    vec = zeros(1,dim);
                    sn1 = inter_vars{1}(n);
                    if sn1 < max(inter_vars{1})
                        sn2 = inter_vars{2}(n);
                        if sn2 < max(inter_vars{2})
                            sn = (sn1-1)*(max(inter_vars{2})-1) + sn2;
                            vec(sn) = var(n);
                        end
                    end
                else
                    error('Not implemented');
                end
                res = [res; vec];
            end
            
            D(c) = D(c) + dim;
            groups{c} = [groups{c}, d*ones(1,dim)];
            X{c} = [X{c}, res];
            if sum(strcmp(fakeSpec{c}, varName)) > 0
                fprintf('Adding %s to true specification (dim=%d)\n', varName, dim);
                D_fake(c) = D_fake(c) + dim;
                X_fake{c} = [X_fake{c}, res];
            end
        else
            var = eval(varName);
            dim = size(var,2);
            D(c) = D(c) + dim;
            groups{c} = [groups{c}, d*ones(1,dim)];
            X{c} = [X{c}, var];
            if sum(strcmp(fakeSpec{c}, varName)) > 0
                fprintf('Adding %s to true specification (dim=%d)\n', varName, dim);
                D_fake(c) = D_fake(c) + dim;
                X_fake{c} = [X_fake{c}, var];
            end
        end
    end
end
fprintf('Di*Kd=[%d,%d,%d]\n', D(1), D(2), D(3));
fprintf('Total variables to test: %d\n', sum(D));

% pre-compute some variables/statistics required for later
Di = zeros(nChoices,1);
Kd = cell(nChoices,1);
Dgroup = cell(nChoices,1);
for c=1:nChoices
    Di(c) = max(groups{c});
    Kd{c} = zeros(Di(c),1);
    for k=1:Di(c)
        Kd{c}(k) = sum(groups{c}==k);
    end
    Dgroup{c} = zeros(D(c),1);
    for d=1:D(c)
        Dgroup{c}(d) = Kd{c}(groups{c}(d));
    end
end
fprintf('Di=[%d,%d,%d]\n', Di(1), Di(2), Di(3));

% standardize data
for c=1:nChoices
    meanX = mean(X_fake{c},1);
    stdX = std(X_fake{c},1);
    meanX(stdX == 0) = 0; % for bias terms
    stdX(stdX == 0) = 1; 
    X_fake{c} = (X_fake{c} - meanX) ./ stdX;
    %X_fake{c}(:,1) = ones(1,N); % fix bias terms
    
    meanX = mean(X{c},1);
    stdX = std(X{c},1);
    meanX(stdX == 0) = 0; % for bias terms
    stdX(stdX == 0) = 1; 
    X{c} = (X{c} - meanX) ./ stdX;
    %X{c}(:,1) = ones(1,N); % fix bias terms
end

% generate artificial choice data
fprintf('\nGenerating artificial choice data...\n');
if generateFakeData
    fprintf('Fitting DCM to true choices using MLE...\n');
    Y_onehot = full(ind2vec(Y_true', nChoices))';
    for c=1:nChoices
        theta{c} = zeros(D_fake(c),1);
    end
    % fit DCM with MLE
    theta_optim = minimize(theta, @neglog_DCM, -10000, X_fake, Y_true, Y_onehot, availableChoices);
    probs = DCM(theta_optim, X_fake, availableChoices);
    
    % sample artificial choices
    fprintf('Sampling artificial choices...\n');
    Y_fake = zeros(N,1);
    for n=1:N
        [~,choice] = max(mnrnd(1, probs(n,:)));
        Y_fake(n) = choice;
    end
    Y = Y_fake;
else
    Y = Y_true;
end

% train/test split
Ntr = floor(1.0*N);
Xtr = cell(3,1);
Xts = cell(3,1);
for c=1:nChoices
	Xtr{c} = X{c}(1:Ntr,:);
    Xts{c} = X{c}((Ntr+1):end,:);
end
Ytr = Y(1:Ntr,:);
Ytr_onehot = full(ind2vec(Ytr', nChoices))';
Yts = Y((Ntr+1):end,:);
availableChoicesTr = availableChoices(1:Ntr,:);
availableChoicesTs = availableChoices((Ntr+1):end,:);

Ntr = size(Xtr{1},1);
Nts = size(Xts{1},1);

% quick test of log likelihood and derivatives
theta = cell(3,1);
for c=1:nChoices
    theta{c} = randn(D(c),1);
end
[g,gd] = log_DCM(theta, Xtr, Ytr, Ytr_onehot, availableChoicesTr);
fprintf('\nInitial likelihood function test: %f\n', g);

% log likelihood function
loglik.name = @log_DCM_svi;    % discrete choice log likelihood
loglik.inargs{1} = Xtr;        % input data 
loglik.inargs{2} = Ytr;        % targets; encoded as 1..C
loglik.inargs{3} = Ytr_onehot; % targets; one-hot encoded
loglik.inargs{4} = availableChoicesTr; % available alternatives per observation

dec = 0.95; 

options = zeros(1,10); 
options(1) = 5000;               % number of iterations per stage
%options(2) = 0.05/size(Xtr,1);  % initial value of the learning rate
options(2) = 0.0001/size(Xtr,1); % initial value of the learning rate
%options(3) = 10;   % ratio between the full length of the dataset and the minibatch
options(3) = 30;   % ratio between the full length of the dataset and the minibatch
fprintf('Mini-batch size: %d\n', ceil(Ntr/options(3)));

mu = cell(3,1);
C = cell(3,1);
for c=1:nChoices
    mu{c} = zeros(D(c),1);
    C{c} = 0.1*ones(D(c),1);
end

iters = 200; % number of optimization stages (each stage takes options(1) iterations)

fprintf('\nRunning DSVI...\n');
F = zeros(1,iters*options(1));
ops = options; 
tic;
for it=1:iters
%      
    [Ftmp, mu, C] = dsvi_DCM_ARD(mu, C, loglik, options, groups, Dgroup);

    F((it-1)*options(1)+1:it*options(1)) = Ftmp;

    % decrease the learning rate for the next stage 
    options(2) = dec*options(2);

    % evaluate trainset accuracy
    S = DCM(mu, Xtr, availableChoicesTr);
    [~,preds_tr] = max(S,[],2);
    train_acc = sum(preds_tr == Ytr) / length(Ytr);

    % evaluate testset accuracy
    S = DCM(mu, Xts, availableChoicesTs);
    [~,preds_ts] = max(S,[],2);
    test_acc = sum(preds_ts == Yts) / length(Yts);
   
    %fprintf('Iters=%d, Ftmp=%f, TestAcc=%f\n',it*options(1), mean(Ftmp), test_acc);
    fprintf('Iters=%d, Ftmp=%.1f, TrainAcc=%.3f, TestAcc=%.3f\n',it*options(1), mean(Ftmp), train_acc, test_acc);
%   
end
timetakenVar = toc;
fprintf('Elapsed time (minutes): %.1f\n', timetakenVar / 60);

% evaluate trainset accuracy
S = DCM(mu, Xtr, availableChoicesTr);
[~,preds_tr] = max(S,[],2);
train_acc = sum(preds_tr == Ytr) / length(Ytr);
fprintf('Train accuracy: %.3f\n', train_acc);

% evaluate testset accuracy
S = DCM(mu, Xts, availableChoicesTs);
[~,preds_ts] = max(S,[],2);
test_acc = sum(preds_ts == Yts) / length(Yts);
fprintf('Test accuracy: %.3f\n', test_acc);

fileID = fopen([outdir dataName '_accuracy.txt'],'w');
fprintf(fileID, 'Train accuracy: %.3f\n', train_acc);
fprintf(fileID, 'Test accuracy: %.3f\n', test_acc);
fclose(fileID);

vars = cell(3,1);
for c=1:nChoices
    vars{c} = C{c}.*C{c}; 
end

fprintf('\nMaking plots...\n');

% plot lower bound
mF = zeros(1,length(F));
W = 200;
for n=1:length(F)
    st = n-W+1;
    st(st<1)=1;
    mF(n) = mean(F(st:n));
end
figure;
plot(mF,'b', 'linewidth',1);
xlabel('Iterations','fontsize',20);
ylabel('Lower bound','fontsize',20);
set(gca,'fontsize',20);
print('-depsc2', '-r300', [outdir dataName '_lowerBound']);

% plot sparsity (mu)
figure;
colorstring = 'bgry';
min_mu = 0;
max_mu = 0;
max_len = 0;
for c=1:nChoices
    min_mu = min(min_mu, min(mu{c}));
    max_mu = max(max_mu, max(mu{c}));
    max_len = max(max_len, length(mu{c}));
    plot(1:D(c), mu{c}(1:end),'b', 'linewidth', 1.5, 'color', colorstring(c));
    hold on
end
xlabel('Variable index','fontsize',20);
ylabel('Mean of the Var. Distr.','fontsize',20);
set(gca,'fontsize',20);
range = max_mu - min_mu;
axis([0 max_len+1 (min_mu-0.02*range) (max_mu+0.02*range)])
print('-depsc2', '-r300', [outdir dataName '_selection']);

% plot sparsity (lambda)
figure;
min_lambda = 0;
max_lambda = 0;
max_len = 0;
lambda = cell(nChoices,1);
for c=1:nChoices
    %lambda = mu{k}(1:end).^2 + vars{k}(1:end);
    lambda{c} = ones(D(c),1) ./ Dgroup{c};
    for d=1:(D(c))
        k = groups{c}(d);
        lambda{c}(d) = lambda{c}(d) * sum(C{c}(groups{c}==k).^2 + mu{c}(groups{c}==k).^2);
    end
    max_len = max(max_len, length(lambda{c}));
    min_lambda = min(min_lambda, min(lambda{c}));
    max_lambda = max(max_lambda, max(lambda{c}));
    plot(1:D(c), lambda{c}, 'b', 'linewidth', 1.5, 'color', colorstring(c));
    hold on
end
xlabel('Variable index','fontsize',20);
ylabel('Optimal prior variances','fontsize',20);
set(gca,'fontsize',20);
range = max_lambda - min_lambda;
axis([0 max_len+1 (min_lambda-0.02*range) (max_lambda+0.02*range)])
print('-depsc2', '-r300', [outdir dataName '_selectionLambda']);

% save results
save([outdir dataName '.mat'], 'timetakenVar', 'mu', 'C', 'lambda', 'F', 'Ftmp', 'specs', 'fakeSpec');

% output results
varNames = cell(nChoices,1);
for c=1:nChoices
    varNames{c} = cell(D(c),1);
    ix = 1;
    for d=1:Di(c)
        for k=1:Kd{c}(d)
            varNames{c}{ix} = sprintf('%s_%d',specs{c}{d},k);
            ix = ix + 1;
        end
    end
end
        
fileID = fopen([outdir dataName '.txt'],'w');
for c=1:nChoices
    for d=1:(D(c))
        fprintf(fileID, '%s\t%.3f\t%.3f\n', varNames{c}{d}, mu{c}(d), lambda{c}(d));
    end
end
fclose(fileID);

% show top-k features per alternative
fileID = fopen([outdir dataName '_topk.txt'],'w');
for c=1:nChoices
    [~, ix] = sort(lambda{c}, 'descend');
    sorted_names = varNames{c}(ix);
    sorted_mu = mu{c}(ix);
    sorted_lambda = lambda{c}(ix);
    fprintf('\nTop 20 features for alternative %s:\n', alternative_names{c});
    fprintf(fileID, '\nTop 20 features for alternative %s:\n', alternative_names{c});
    fprintf('Feature\t\tMu\tLambda\n');
    fprintf(fileID, 'Feature\t\tMu\tLambda\n');
    for i=1:20
        fprintf('%s\t%.3f\t%.3f\n', sorted_names{i}, sorted_mu(i), sorted_lambda(i));
        fprintf(fileID, '%s\t%.3f\t%.3f\n', sorted_names{i}, sorted_mu(i), sorted_lambda(i));
    end
end
fclose(fileID);

function ret = logt(vec)
    ret = log(vec+1);
end

function ret = boxt(vec)
    ret = boxcox(vec+1);
end

function ret = segt(vec,k)
    I = eye(k);
    ret = I(kmeans(vec, k),:);
    ret = ret(:,1:(k-1)); % don't add last column - it should be captured by the bias term
end
