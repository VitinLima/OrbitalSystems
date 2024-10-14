function [a_s, e_s, w_s] = HohmannCalculations(SniperBody, TargetBody)
  s1 = @(P_t, e_t, w_t, rp_s) (-P_t .* e_t .* rp_s .* cos (w_t) + P_t .* rp_s + e_t .^ 2 .* rp_s .^ 2 - rp_s .^ 2 + sqrt (-(P_t .^ 2 - 2 * P_t .* rp_s - e_t .^ 2 .* rp_s .^ 2 + rp_s .^ 2) .* (-4 * P_t .^ 2 .* sin (w_t) .^ 2 - 4 * P_t .^ 2 .* cos (w_t) .^ 2 + 8 * P_t .* e_t .* rp_s .* cos (w_t) - 4 * e_t .^ 2 .* rp_s .^ 2 + 4 * rp_s .^ 2) + (2 * P_t .* e_t .* rp_s .* cos (w_t) - 2 * P_t .* rp_s - 2 * e_t .^ 2 .* rp_s .^ 2 + 2 * rp_s .^ 2) .^ 2) / 2) ./ (-P_t .^ 2 .* sin (w_t) .^ 2 - P_t .^ 2 .* cos (w_t) .^ 2 + 2 * P_t .* e_t .* rp_s .* cos (w_t) - e_t .^ 2 .* rp_s .^ 2 + rp_s .^ 2);
  s2 = @(P_t, e_t, w_t, rp_s) (-P_t .* e_t .* rp_s .* cos (w_t) + P_t .* rp_s + e_t .^ 2 .* rp_s .^ 2 - rp_s .^ 2 - sqrt (-(P_t .^ 2 - 2 * P_t .* rp_s - e_t .^ 2 .* rp_s .^ 2 + rp_s .^ 2) .* (-4 * P_t .^ 2 .* sin (w_t) .^ 2 - 4 * P_t .^ 2 .* cos (w_t) .^ 2 + 8 * P_t .* e_t .* rp_s .* cos (w_t) - 4 * e_t .^ 2 .* rp_s .^ 2 + 4 * rp_s .^ 2) + (2 * P_t .* e_t .* rp_s .* cos (w_t) - 2 * P_t .* rp_s - 2 * e_t .^ 2 .* rp_s .^ 2 + 2 * rp_s .^ 2) .^ 2) / 2) ./ (-P_t .^ 2 .* sin (w_t) .^ 2 - P_t .^ 2 .* cos (w_t) .^ 2 + 2 * P_t .* e_t .* rp_s .* cos (w_t) - e_t .^ 2 .* rp_s .^ 2 + rp_s .^ 2);

  P_t = TargetBody.SemiLatus;
  e_t = TargetBody.Excentricity;
  w_t = (TargetBody.ArgumentOfPerifocus + TargetBody.LongitudeOfAscendingNode - SniperBody.ArgumentOfPerifocus - SniperBody.TrueAnomaly)*pi/180;
  rp_s = SniperBody.Radius;

  e_s = s1(P_t, e_t, w_t, rp_s);
  if e_s > 1 || e_s < 0
    e_s = s2(P_t, e_t, w_t, rp_s);
  endif

  a_s = rp_s/(1-e_s);
  w_s = SniperBody.ArgumentOfPerifocus + SniperBody.TrueAnomaly;
end
