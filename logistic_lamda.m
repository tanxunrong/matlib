%载入数据
clc,clear,close all;
x = load('ex5Logx.dat');
y = load('ex5Logy.dat');

%画出数据的分布图
plot(x(find(y),1),x(find(y),2),'o','MarkerFaceColor','b')
hold on;
plot(x(find(y==0),1),x(find(y==0),2),'r+')
legend('y=1','y=0')

% Add polynomial features to x by 
% calling the feature mapping function
% provided in separate m-file
x = map_feature(x(:,1), x(:,2));

[m, n] = size(x);

% Initialize fitting parameters
theta = zeros(n, 1);

% Define the sigmoid function
g = inline('1.0 ./ (1.0 + exp(-z))'); 

% setup for Newton's method
MAX_ITR = 15;
J = zeros(MAX_ITR, 1);

% Lambda is the regularization parameter
lambda = 2;%lambda=0,1,10，修改这个地方，运行3次可以得到3种结果。

% Newton's Method
for i = 1:MAX_ITR
    % Calculate the hypothesis function
    z = x * theta;
    h = g(z);
    
    % Calculate J (for testing convergence)
    J(i) =(1/m)*sum(-y.*log(h) - (1-y).*log(1-h))+ ...
    (lambda/(2*m))*norm(theta([2:end]))^2;
    
    % Calculate gradient and hessian.
    G = (lambda/m).*theta; G(1) = 0; % extra term for gradient
    L = (lambda/m).*eye(n); L(1) = 0;% extra term for Hessian
    grad = ((1/m).*x' * (h-y)) + G;
    H = ((1/m).*x' * diag(h) * diag(1-h) * x) + L;
    
    % Here is the actual update
    theta = theta - H\grad;
  
end
% Show J to determine if algorithm has converged
J
% display the norm of our parameters
norm_theta = norm(theta) 
norm_theta

% Plot the results 
% We will evaluate theta*x over a 
% grid of features and plot the contour 
% where theta*x equals zero

% Here is the grid range
u = linspace(-1, 1.5, 200);
v = linspace(-1, 1.5, 200);

z = zeros(length(u), length(v));
% Evaluate z = theta*x over the grid
for i = 1:length(u)
    for j = 1:length(v)
        z(i,j) = map_feature(u(i), v(j))*theta;%这里绘制的并不是损失函数与迭代次数之间的曲线，而是线性变换后的值
    end
end
z = z'; % important to transpose z before calling contour

% Plot z = 0
% Notice you need to specify the range [0, 0]
contour(u, v, z, [0, 0], 'LineWidth', 2)%在z上画出为0值时的界面，因为为0时刚好概率为0.5，符合要求
legend('y = 1', 'y = 0', 'Decision boundary')
title(sprintf('\\lambda = %g', lambda), 'FontSize', 14)


hold off

% Uncomment to plot J
figure
plot(0:MAX_ITR-1, J, 'o--', 'MarkerFaceColor', 'r', 'MarkerSize', 8)
xlabel('Iteration'); ylabel('J')