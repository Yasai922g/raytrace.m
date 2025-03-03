ant_name="ph_nr_15_15";
position="A";
pilot_bit="10";
send_speed='100';
Files=dir('*.csv');
format long

data=zeros(1,6);
x=zeros(1,6);
material="complex";
p="pv0_1";
av0="0";
av1="90";

for i=1:1:6
    if i==1
        count=1;
    elseif i==2
        count=10;
    elseif i==3
        count=100;
    elseif i==4
        count=1000;
    elseif i==5
        count=10000;
    elseif i==6
        count=100000;
    end

    count_name=num2str(count);

    Files(1,1).folder= fullfile('/Users/e20087/Documents/2024/Ber/Rssi/0122/Ber/csv/',count_name,material,p,av1);
    Path=Files(1).folder;
    Files(1,1).name=strcat('BER_',ant_name,'_',material,'_Beam0_',av0,'_Beam1_',av1,'_',p,'_pv1_1','.csv');
    T=readmatrix(fullfile(Path,Files(1).name));
    data(1,i)=T(2,count+2)

    x(1,i)=count;

end


dir_glaph_name= fullfile('/Users/e20087/Documents/2024/Ber/Rssi/0122/glaf/');
% glaph_file_name=strcat('Overhead_',ant_name,'_',position,'.pdf');
glaph_file_name=strcat('alpha_',ant_name,'_',material,'_Beam0_',av0,'_Beam1_',av1,'_',p,'_pv1_1','.pdf');
if not(exist(dir_glaph_name,'dir'))
    mkdir(dir_glaph_name)
end

glaph_name=fullfile(dir_glaph_name,glaph_file_name);
loglog(x,data,'LineWidth',2,'Color',[0 0 1],'Marker','.',"MarkerSize",35);
%p.Marker="s";
xlim([10^0 10^5]);
xticks([10^0 10^1 10^2 10^3 10^4 10^5])
% % xticklabels([{'10^0'} {'10^3'} {'10^4'} {'10^5'}])
%ylim([10.^-10 10.^0]);
ylim([10.^-6 10.^0])
% xticklabels([{'10^0'} {'10^1'} {'10^2'} {'10^3'} {'10^4'}]);
%ytics([10.^-10 10.^-5 10.^0])
% ytics([10.^-2 10.^-1 10.^0])
xlabel('\alpha');
ylabel('BER');

ha1=gca;
ha1.LineWidth=3;
set(gca,'FontSize',20)
fontname(gcf,"Times")

exportgraphics(gcf,glaph_name)
delete(gca);