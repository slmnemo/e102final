%{
    Wrapper file to find good poles for an inverted pendulum
%}

zetarange = 3.55:0.01:3.8;
wrange = 0.183:0.001:0.21;
disp = 0.5;
t_settle_thres = 15;
os_thres = 0.01;

outcsv = "figures/invpen_vals_disp"+num2str(disp)+".csv";
file = fopen(outcsv,"w");
fprintf(file, "idx, zeta, omega, t_set\n");
fspec = "%d, %2.4f, %2.4f, %2.4f\n";

k = 0;
for zetaCon = zetarange
    for wCon = wrange
        [os, t_settle, sys_data] = sim_invpendulum(disp,zetaCon,wCon);
        if (os < os_thres) && (t_settle < t_settle_thres)
            fprintf(file, fspec, k, zetaCon, wCon, t_settle);
            k = k + 1;
        end
    end
end

file = fclose(file);


        


