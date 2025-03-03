ant_name="ph_nr_15_15";
position="A";
pilot_bit='10';
Files=dir('*.csv');
format long
% ペイロード送信回数（time）
time=3;
time_name=num2str(time);


str_s='1000';

% pv_str='pv0_1';
az_angles0='0';
% pv0='1';
materials='concreate';
data1=zeros(24,1);
data2=zeros(24,1);
data3=zeros(24,1);
x=zeros(11,1);
for n=1:1:3
    num=1;
    if n==1
        pv_str='pv1_1';
        pv0='1';
        pv1='1';
    elseif n==2
        pv_str='pv0_1';
        pv0='1';
        pv1='40';
    elseif n==3
        pv_str='pv1_1';
        pv0='40';
        pv1='1';
    end
    for count=-180:15:180
        az_angles1=num2str(count);
           
        x(num,1)=count;
        Files(n,1).folder= fullfile('/Users/e20087/Documents/2024/Ber/Rssi/0131/アンテナ配置角度/Ber/csv/',str_s,materials,pv_str,az_angles1);
        Path=Files(n).folder;
        Files(n,1).name=strcat('BER_',ant_name,'_',materials,'_Beam0_',az_angles0,'_Beam1_',az_angles1,'_pv0_',pv0,'_pv1_',pv1,'.csv');

        %read;
        T=readmatrix(fullfile(Path,Files(n).name),'Range',[2,1002]);
        if n==1
            data1(num,1)=T(2,1)
        elseif n==2
            data2(num,1)=T(2,1)
        elseif n==3
            data3(num,1)=T(2,1)
        end
        num=num+1;
        
    end
end


dir_glaph_name= fullfile('/Users/e20087/Documents/2024/Ber/Rssi/0131/Ber/glaf/');
% glaph_file_name=strcat('Overhead_',ant_name,'_',position,'.pdf');
glaph_file_name=strcat('Anglech_BER_',ant_name,'_',materials,'.pdf');
if not(exist(dir_glaph_name,'dir'))
    mkdir(dir_glaph_name)
end
for i=1:1:25
    if data1(i,1)==0
        data1(i,1)=1*10^-6;
    end
    if data2(i,1)==0
        data2(i,1)=1*10^-6;
    end
    if data3(i,1)==0
        data3(i,1)=1*10^-6;
    end

end

glaph_name=fullfile(dir_glaph_name,glaph_file_name);
semilogy(x,data1,'LineWidth',2,'Color',[0 0.4470 0.7410]);
xlim([-180 180]);
%ylim([10.^-10 10.^0]);
ylim([10.^-4 10.^0])
% yticks([10.^-4 10.^-2 10.^0])
xticks([-180 -150 -100 -50 0 50 100 150 180]);
% yticklabels({'10^-5', '10.^-4','10.^-3','10.^-2','10.^-1','10.^-0'})
% ytics([10.^-2 10.^-1 10.^0])
xlabel("$\varphi_{1} $  [$^\circ$]","Interpreter","latex");
ylabel('BER')
hold on
semilogy(x,data2,'LineWidth',2,'Color',[0.8500 0.3250 0.0980]);
hold on
semilogy(x,data3,'LineWidth',2,'Color',[0.9290 0.6940 0.1250]);


legend('P=(10,10)','P=(10,-30)','P=(-30,10)','Location','northwest')
ha1=gca;
ha1.LineWidth=3;
set(gca,'FontSize',20)
fontname(gcf,"Times")
% pbaspect([1 0.3 1])
exportgraphics(gcf,glaph_name)
delete(gca);

