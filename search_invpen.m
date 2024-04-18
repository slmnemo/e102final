%{
    Wrapper file to find good poles for an inverted pendulum
%}

zetarange = 3.4:0.01:3.7;
wrange = 0.18:0.005:0.23;
disp = 0.5;

outcsv = "figures/invpen_vals_disp"+num2str(disp)+".csv";
file = fopen(outcsv,"w");
fprintf(file, "idx, zeta, omega, t_set\n");
fspec = "%d, %2.4f, %2.4f, %2.4f\n";

k = 0;
for zetaCon = zetarange
    for wCon = wrange
        [os, t_settle, sys_data] = sim_invpendulum(disp,zetaCon,wCon);
        if (os < 0.01) && (t_settle < 25)
            fprintf(file, fspec, k, zetaCon, wCon, t_settle);
            k = k + 1;
        end
    end
end

file = fclose(file);


        


