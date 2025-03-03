format longG
%sendDATA_info
%ペイロード　50MB
data_MB=50;
str_data_MB=num2str(data_MB);
%送信速度：100 Mbps
send_speed=100;
str_send_speed=num2str(send_speed);
data_length=data_MB*10^6*8;
swich_speed=1/(send_speed*10^6);
%0.4 / 3.2e9 = 1.25e-10 s(スイッチの切り替え速度)
time=data_length*swich_speed;
%rssiが記録されている時間
walk_speed=0.8;
time_length=(3.92-0.32)/walk_speed;
test_num=floor(time_length/time)+1;
ant_name="ph_nr_15_15";
position="A";

overhead=zeros(1,5);
a=zeros(1,5);
for i=1:1:5
    a(1,i)=10^i;
    sum=10^i*10;
    overhead(1,i)=sum/(sum+4*10^8);
end

dir_glaph_name= fullfile('/Users/e20087/Documents/2024/Ber/Rssi/0121/glaf/');
% glaph_file_name=strcat('Overhead_',ant_name,'_',position,'.pdf');
glaph_file_name=strcat('Ov_',ant_name,'.pdf');

if not(exist(dir_glaph_name,'dir'))
                    mkdir(dir_glaph_name)
end

glaph_name=fullfile(dir_glaph_name,glaph_file_name);
loglog(a,overhead,'LineWidth',2,'Color',[1 0 1],'Marker','.',"MarkerSize",35);
% P.merkar='s';
ylim([10^-7 10^0]);
% xticks([2.7083 2.75 2.8 2.85 2.9]);
%ylim([10.^-10 10.^0]);
% ylim([10.^-6 10.^0])
% xticklabels([{'10^0'} {'10^1'} {'10^2'} {'10^3'} {'10^4'}]);
%ytics([10.^-10 10.^-5 10.^0])
% ytics([10.^-2 10.^-1 10.^0])
xlabel('\alpha');
ylabel('Overhead Ratio [%]');
ha1=gca;
ha1.LineWidth=3;
set(gca,'FontSize',20)
fontname(gcf,"Times")

exportgraphics(gcf,glaph_name)
delete(gca);
