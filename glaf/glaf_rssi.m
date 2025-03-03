ant_name="ph_nr_15_15";
position="A"
material="complex";
p0="1";
p1="1";


%Beam0
az_angles0="-30";
ev_angles0="0";
dir_name0= fullfile('/Users/e20087/Documents/2024/Ber/Rssi/1013/',material,ant_name,az_angles0);
file_name0=strcat(material,'_',ant_name,'_az_',az_angles0,'_ev_',ev_angles0,'_',p0,'.csv');
csvname0= fullfile(dir_name0,file_name0);
% dir_name0 = fullfile('/home/sasaki/Documents/human_room/0424/ph_nr_45_45/A/0/result_ph_nr_45_45_az_0_ev_0.csv');
%filename=('result_ph_nr_15_15_az_0_ev_0.csv');
%file_name0=strcat('result_',ant_name,'_az_',az_angles0,'_ev_',ev_angles0,'.csv');
%csvname = fullfile(dir_name0,filename);

%Beam1
az_angles1="30";
ev_angles1="0";
dir_name1 = fullfile('/Users/e20087/Documents/2024/Ber/Rssi/1013/',material,ant_name,az_angles1);
file_name1=strcat(material,'_',ant_name,'_az_',az_angles1,'_ev_',ev_angles1,'_',p1,'.csv');
csvname1 = fullfile(dir_name1,file_name1);


%read
data_1=readmatrix(csvname0,'TrimNonNumeric',true);
data_2=readmatrix(csvname1,'TrimNonNumeric',true);

dir_glaph_name= fullfile('/Users/e20087/Documents/2024/Ber/Rssi/0121/glaph/',material);

glaph_file_name=strcat('Match_',ant_name,'_Beam0_',az_angles0,'_Beam1_',az_angles1,'_p0_',p0,'_p1_',p1,'.pdf');

if not(exist(dir_glaph_name,'dir'))
                    mkdir(dir_glaph_name)
end

glaph_name=fullfile(dir_glaph_name,glaph_file_name);

plot(data_1(2:722,2),data_1(2:722,3),'LineWidth',2,'Color',[0 0 1]);
xlim([0 4.5]);
xticks([0 1 2 3 4 4.5]);
ylim([-120 -20]);
yticks([-120 -100 -80 -60 -40 -20]);
xlabel('\it{t}\rm{ [s]}');
ylabel('Received Power [dBm]');
hold on
plot(data_2(2:722,2),data_2(2:722,3),'LineWidth',2,'Color',[1 0 0]);

legend('Beam0','Beam1','Location','northeast')
ha1=gca;
ha1.LineWidth=4;
set(gca,'FontSize',30)
fontname(gcf,"Times")

exportgraphics(gcf,glaph_name)
delete(gca);