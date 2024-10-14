clear;
clc;

% Derivation of Hohmann Equations, pt 2

% Uncomment to change equations display style
##sympref display flat

pkg load symbolic;

syms rp_s e_s e_t P_t k ta_s ta_t w_t

delta1 = e_s**2 + 5*e_s + 6;

coefs2 = coeffs(delta1, e_s, 'all');
a2 = coefs2(1);
b2 = coefs2(2);
c2 = coefs2(3);
delta2 = b2^2 - 4*a2*c2;

s1 = function_handle((-b2 + sqrt(delta2))/2/a2, 'vars', [P_t e_t w_t rp_s]);
s2 = function_handle((-b2 - sqrt(delta2))/2/a2, 'vars', [P_t e_t w_t rp_s]);

f_delta1 = function_handle(delta1, 'vars', [P_t e_t w_t e_s rp_s]);

a_t = 2.923542111961733;
e_t = 0.337218354448035;
P_t = a_t*(1-e_t^2);
w_t = pi*30/180;
rp_s = 1;

s1 = s1(P_t, e_t, w_t, rp_s)
s2 = s2(P_t, e_t, w_t, rp_s)
f_delta1(P_t, e_t, w_t, s1, rp_s)
