ant_name="ph_nr_15_15";
position="A";
pilot_bit='10';
Files=dir('*.csv');
format long
% ペイロード送信回数（time）
time=3;
time_name=num2str(time);


str_s='1000';

pv_str='pv1_1';
az_angles0='0';
az_angles1='90';
pv1='1';
data1=zeros(11,1);
data2=zeros(11,1);
x=zeros(11,1);
for n=1:1:2
    num=1;
    if n==1
        materials='complex';
    elseif n==2
        materials='concreate';
    end
    for count=0:5:50
        if count==0
            pv0=num2str(1);
           
        else
            pv0=num2str(count);
         
        end
           x(num,1)=count;
        Files(n,1).folder= fullfile('/Users/e20087/Documents/2024/Ber/Rssi/0130/Ber/csv/',str_s,materials,pv_str,az_angles1);
        Path=Files(n).folder;
        Files(n,1).name=strcat('BER_',ant_name,'_',materials,'_Beam0_',az_angles0,'_Beam1_',az_angles1,'_pv0_',pv0,'_pv1_',pv1,'.csv');

        %read;
        T=readmatrix(fullfile(Path,Files(n).name),'Range',[2,1002]);
        if n==1
            data1(num,1)=T(2,1)
        elseif n==2
            data2(num,1)=T(2,1)
        end
        num=num+1;
        
    end
end


dir_glaph_name= fullfile('/Users/e20087/Documents/2024/Ber/Rssi/0130/Ber/glaf/');
% glaph_file_name=strcat('Overhead_',ant_name,'_',position,'.pdf');
glaph_file_name=strcat('BER_',ant_name,'_Beam0_',az_angles0,'_Beam1_',az_angles1,'_',pv_str,'.pdf');
if not(exist(dir_glaph_name,'dir'))
    mkdir(dir_glaph_name)
end
for i=1:1:11
    if data1(i,1)==0
        data1(i,1)=1*10^-6;
    end
    if data2(i,1)==0
        data2(i,1)=1*10^-6;
    end

end

glaph_name=fullfile(dir_glaph_name,glaph_file_name);
semilogy(x,data1,'LineWidth',2,'Color',[0.4660 0.6740 0.1880]);
% semilogy(x,data1,'LineWidth',2,'Color',[1 0 0]);
xlim([0 50]);
%ylim([10.^-10 10.^0]);
ylim([10.^-4 10.^0])
yticks([10.^-4 10.^-2 10.^0])
% xticks([1 5 10 15 ]);
% yticklabels({'10^-5', '10.^-4','10.^-3','10.^-2','10.^-1','10.^-0'})
% ytics([10.^-2 10.^-1 10.^0])
xlabel('\Delta P_{0} [dB]');
ylabel('BER')
hold on
semilogy(x,data2,'LineWidth',2,'Color',[0.8500 0.3250 0.0980]);
%semilogy(x,data2,'LineWidth',2,'Color',[0.4940 0.1840 0.5560]);
legend('wood','concrete','Location','northwest')
ha1=gca;
ha1.LineWidth=2;
set(gca,'FontSize',20)
fontname(gcf,"Times")
pbaspect([1 0.4 1])
exportgraphics(gcf,glaph_name)
delete(gca);

