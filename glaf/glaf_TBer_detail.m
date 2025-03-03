ant_name="ph_nr_15_15";
position="A";
pilot_bit="10";
Files=dir('*.csv');
pv0='1';
pv1='1';
p='pv0_1';
az_angles0='0';
az_angles1='90';
materials='complex';
count=50;
count_name=num2str(count);
% データサイズ（ビット単位）
dataSizeBits = (4 * 1e8 / count) + 10; % 1MB = 8メガビット、+10ビット
% 送信速度（ビット毎秒）
transmissionRate = 100 * 1e6; % 100メガビット毎秒
% 送信にかかる時間（秒）
transmissionTime = dataSizeBits / transmissionRate;
Sumtime=4.5;
l=Sumtime/transmissionTime;
l=floor(l)
time_x=zeros(1,l);
Time=zeros(1,l);
for t=1:1:l
    time_x(1,t)=transmissionTime*t;
end


format long
% ペイロード送信回数（time）



    %Ber
    
    Files(1,1).folder= fullfile('/Users/e20087/Documents/2024/Ber/Rssi/0129/Ber/csv/',count_name,materials,p,az_angles1);
    Path=Files(1).folder;
    Files(1,1).name=strcat('BER_',ant_name,'_',materials,'_Beam0_',az_angles0,'_Beam1_',az_angles1,'_pv0_',pv0,'_pv1_',pv1,'.csv');
    %read;
    T=readmatrix(fullfile(Path,Files(1).name));
    

   
dir_glaph_name= fullfile('/Users/e20087/Documents/2024/Ber/Rssi/0129/Ber/glaf/time/',materials);
% glaph_file_name=strcat('Overhead_',ant_name,'_',position,'.pdf');
if not(exist(dir_glaph_name,'dir'))
                    mkdir(dir_glaph_name)
end
glaph_file_name=strcat('Detail_TBER_',ant_name,'_Beam0_',az_angles0,'_Beam1_',az_angles1,'_pv0_',pv0,'_pv1_',pv1,'_',count_name,'.pdf');

data=zeros(1,t);
n_data=zeros(1,t);
k=1;
for j=2:1:3
    for i=2:1:51
        if T(j,i)==0
            msg=("in")
            data(1,k)=1*10^-7;
        else
            data(1,k)=T(j,i);
        end
        k=k+1;
        if k>t
            break
        end
    end
end
count_time=1;
for mn=1:1:l
    if time_x(1,mn)>=1.0 && time_x(1,mn)<=1.45
        Time(1,count_time)=time_x(1,mn);
        n_data(1,count_time)=data(1,mn);
        count_time=count_time+1;
    end
end
glaph_name=fullfile(dir_glaph_name,glaph_file_name);
semilogy(Time,n_data,'LineWidth',2,'Color',[0 0 1]);
% xlim([2.7 2.9875]);
xlim([1.1 1.3875]);
% xticks([2.7 2.8 2.9 2.9875]);
xticks([1.1 1.2 1.3 1.3875]);

%ylim([10.^-10 10.^0]);
ylim([10.^-4 10.^0])
xlabel('\it{t}\rm{ [s]}');
ylabel('BER');
ha1=gca;
ha1.LineWidth=4;
set(gca,'FontSize',30)
fontname(gcf,"Times")
exportgraphics(gcf,glaph_name)
delete(gca);
