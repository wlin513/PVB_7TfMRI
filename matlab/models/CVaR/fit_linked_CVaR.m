function [out]=fit_linked_CVaR(opt1_events,opt2_events,choice,start,abandontn,resp_made,etabins,betabins,fig_yes)
%inputs opt1_events[nblk,ntrial],opt2_events[nblk,ntrial],choice[nblk,ntrial]
if(nargin<9)fig_yes=0; end
if(nargin<8) betabins=30; end
if(nargin<7) etabins=30; end
if(nargin<6) resp_made=true(size(choice)); end
if(nargin<5) abandontn=0; end
if(nargin<4) start=0.5; end

out=struct;

log_beta_space=log(0.01):(log(100)-log(0.01))/(betabins-1):log(100);
beta_space=exp(log_beta_space);

%s_eta_space=-0.99^(1/3):(0.99^(1/3)+0.99^(1/3))/(etabins-1):0.99^(1/3);
eta_space=-0.99:(0.99+0.99)/(etabins-1):0.99;
%eta_space=s_eta_space.^3;

% alpha_pos=betarnd(1,1,1000,1);
% alpha_neg=betarnd(1,1,1000,1);
% taus=alpha_pos./(alpha_pos+alpha_neg);
taus=betarnd(1,1,1000,1);
alpha=1;
alpha_pos=taus*alpha;
alpha_neg=(1-taus)*alpha;

%learn first option
    opt1_expv=ones(length(alpha_pos),size(opt1_events,1),size(opt1_events,2))*start;
    for k=1:size(opt1_events,1)
        for i=1:size(opt1_events,2)-1
            for j=1:length(alpha_pos)
                if opt1_events(k,i)>opt1_expv(j,k,i)
                 opt1_expv(j,k,i+1)=opt1_expv(j,k,i)+alpha_pos(j)*(opt1_events(k,i)-opt1_expv(j,k,i));
                else 
                    opt1_expv(j,k,i+1)=opt1_expv(j,k,i)+alpha_neg(j)*(opt1_events(k,i)-opt1_expv(j,k,i));
                end
            end
        end
    end
    %learn the second option
    opt2_expv=ones(length(alpha_pos),size(opt2_events,1),size(opt2_events,2))*start;
    for k=1:size(opt2_events,1)
        for i=1:size(opt2_events,2)-1
            for j=1:length(alpha_pos)
                if opt2_events(k,i)>opt2_expv(j,k,i)
                    opt2_expv(j,k,i+1)=opt2_expv(j,k,i)+alpha_pos(j)*(opt2_events(k,i)-opt2_expv(j,k,i));
                else
                    opt2_expv(j,k,i+1)=opt2_expv(j,k,i)+alpha_neg(j)*(opt2_events(k,i)-opt2_expv(j,k,i));
                end
            end
        end
    end

    
for i=1:length(eta_space)
    for j=1:length(beta_space)
    [cvar1,cvar2]=read_cvar(eta_space(i),opt1_expv,opt2_expv);
    cvardiff=cvar1-cvar2;
    prob1(i,j,:,:)=1./(1+exp(-(beta_space(j).*cvardiff)));
    end
end

ch=repmat(permute(choice,[3 4 1 2]),[length(eta_space) length(beta_space) 1 1]);
% This calculates the likelihood of the choices made given the model
% parameters
probch=((ch.*prob1)+((1-ch).*(1-prob1)));
clear prob1

  %this bit removes data from trials in which the participant made no
  %response
 
  %probch=probch(:,:,resp_made,:,:);

  % This calculates the overall liklihood of the parameters by taking the
  % product of the individual trials. I presume the final term which
  % multiples the number by a large amount just makes the numbers
  % manageable (otherwise they are very small). Note that this is now a
  % four dimensional matrix which contains the likelihood of the data
  % given the three parameters which are coded on the dimensions (learning
  % rate, temperature, a). The final dimension separates the data from each
  % indvidiual participant
  out.posterior_prob(:,:)=squeeze(prod(prod(probch,3),4))*10^(size(probch,3)*size(probch,4)/5);  
  %renormalise
  out.posterior_prob=out.posterior_prob./(sum(sum(sum(out.posterior_prob))));
  
  clear probch


% This produces a marginal distribution of the learning rate by summing
% across the other dimensions and then renormalising.
% The numerator sums over dimensions 2 and 3 leaving a 2D matrix which contains
% the marginal likelihood for each of the different value of learning rate, for each
% participant. The denominator calcualtes the total likelihood for each of the subjects
% and then produces a matrix which reproduces these totals in each column
% with alphabins (length(i)) number of rows.
out.marg_eta=squeeze(sum(out.posterior_prob,2));

% This generates the expected value of the learning rate using a weighted
% sum-- marginal probabilities multiplied by learning rate values. Note
% for both the learning rate and temperature mean and variance are
% caculated in log space
out.mean_eta=eta_space*out.marg_eta;

% this calculates the variance of the distribution of learning rates

out.var_eta=(eta_space-out.mean_eta).^2*out.marg_eta;


out.marg_beta=squeeze(sum(out.posterior_prob,1))';
out.mean_beta=exp(log_beta_space*out.marg_beta);
out.var_beta=exp(((log_beta_space-log(out.mean_beta)).^2)*out.marg_beta);


out.eta_label=eta_space;
out.beta_label=beta_space;

if fig_yes==1 
   figure
   subplot(2,1,1);
   plot(eta_space,out.marg_eta);
   title('eta');
   subplot(2,1,2);
   plot(beta_space,out.marg_beta);
   title('beta');
end

% get LL from estimated parameters
    [cvar1,cvar2]=read_cvar(out.mean_eta,opt1_expv,opt2_expv);
    cvardiff=cvar1-cvar2;
    prob_ch_left=1./(1+exp(-(out.mean_beta.*cvardiff)));


resp_made=resp_made(:,abandontn+1:end);

likelihood=prob_ch_left;
likelihood(choice==0)=1-likelihood(choice==0);
out.neg_log_like=-sum(log(likelihood(resp_made)+1e-16));
out.BIC=(2.*out.neg_log_like)+2*(log(sum(sum(resp_made)))-log(2*pi)); % BIC given 3 free parameters
out.AIC=(2.*out.neg_log_like)+3;