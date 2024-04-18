%{
    Wrapper file to find good poles for an inverted pendulum
%}

zetarange = 1.005:0.001:1.015;
wrange = 0.5:0.01:0.7;
conPmodrange = 10:2:10;
obsPmodrange = 50:5:50;
KiPmodrange = 10.3:0.2:10.3;
dis = 0.5;
t_settle_thres = 10;
os_thres = 1;

outcsv = "figures/invpen_vals_disp"+num2str(dis)+".csv";
file = fopen(outcsv,"w");
fprintf(file, "idx, zeta, omega, t_set,conPmod,obsPmod,KiPmod\n");
fspec = "%d, %2.4f, %2.4f, %2.4f, %2.1f, %2.1f, %2.1f\n";

k = 0;
for zetaCon = zetarange
    for wCon = wrange
        for conPmod = conPmodrange
            for obsPmod = obsPmodrange
                for KiPmod = KiPmodrange
                    [os, t_settle, sys_data] = sim_invpendulum(dis,zetaCon,wCon,conPmod,obsPmod,KiPmod);
                    fprintf("testing %.4f, %.4f, %2f, %2f, %2f\n",zetaCon,wCon,conPmod,obsPmod,KiPmod);
                    if (os < os_thres) && (t_settle < t_settle_thres)
                        fprintf(file, fspec, k, zetaCon, wCon, t_settle, conPmod, obsPmod, KiPmod);
                        k = k + 1;
                    end
                end
            end
        end
    end
end

file = fclose(file);


        


