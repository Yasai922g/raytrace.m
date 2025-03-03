for mn=0:1:0
    if mn==0
        material="complex"
    elseif mn==1
        material="concreate"
    elseif mn==2
        material="wood"
    elseif mn==3
        material="material"
    elseif mn==4
        material="perfect_reflector"
    end

dname_gltf = fullfile('/home/sasaki/Documents/Blender/x_312/detail/',material);

    for i=0:2:2
        if i==0
            Angle1=0;
        elseif i==1
            Angle1=30*i;
        elseif i==2
            Angle1=30*(i+1);
        elseif i==3
             Angle1=-30;
        elseif i==4
             Angle1=-90;
        end
       
        Angle2=0;

        angles1 = string(Angle1);
        angles2 = string(Angle2);

        %csvファイルに書き込むものを指定
        speed=0.8;
        %jisoku0.5m/s
        num=0;
        rssi=0;
        % ss=0;
        minute=0;
        Am=0;
        
        str_TP="1";
       
        T=table(num,minute,rssi);

        
        %使用する指向性アンテナ
        antenna1=phased.NRAntennaElement('Beamwidth',[15,15]);
        ant_name='ph_nr_15_15';
        antenna2=phased.IsotropicAntennaElement;
        % for num=320:5:3920
        for num=12000:25:14300
            numstr=string(num)
            fname_gltf = strcat('room_',numstr,'.gltf');
            glftname = fullfile(dname_gltf,fname_gltf);

            %実験環境
            fc = 30e9;
            viewer=siteviewer(SceneModel=glftname,ShowEdges=false,Transparency=0.5);
            %設定された室内寛容の材質を確認，表示
            %viewer.Materials(1:11,:)



            %送信機設置座標
            r1=0.5;
            r2=1.3;
            r3=1;
            %受信機設置座標
            x=4.12;
            y=1.3;
            z=1;


            tx = txsite("cartesian", ...
                        "AntennaPosition",[r1; r2; r3] ,...
                        "Antenna",antenna1,...
                        "TransmitterPower",1,...
                        "SystemLoss",15,...
                        "TransmitterFrequency",fc);
                    tx.AntennaAngle=[Angle1,Angle2];
            %受信機
            rx = rxsite("cartesian", ...
                "SystemLoss",15,...
                "AntennaPosition",[x;y;z]);


            pm = propagationModel("raytracing", ...
                "CoordinateSystem","cartesian", ...
                "Method","sbr", ...
                "MaxNumReflections",5, ...
                "SurfaceMaterial","auto",...
                "AngularSeparation","high");

            % ss=sigstrength(rx,tx,pm);

            rays1=raytrace(tx,rx,pm);
            rays1=rays1{1};

            ray_size=(size(rays1));
            % ray_size=1;

            %送信電力
            Pt=10*log10(tx.TransmitterPower*10^3);
            Tx_loss=tx.SystemLoss;
            Rx_loss=rx.SystemLoss;
            x=zeros(1,ray_size(1,2));
            y=zeros(1,ray_size(1,2));
            dBm=zeros(1,ray_size(1,2));
            xy=zeros(1,ray_size(1,2));
            rssi_mW=zeros(1,ray_size(1,2));
            Ploss=zeros(1,ray_size(1,2));
            angle=zeros(2,1);


            for r=1:1:ray_size(1,2)

                 if rays1(1,r).AngleOfDeparture(1,1)>180+Angle1
                        angle(1,1)=-180+(rays1(1,r).AngleOfDeparture(1,1)-Angle1-180);
                 elseif rays1(1,r).AngleOfDeparture(1,1)< Angle1-180
                     angle(1,1)=180+(rays1(1,r).AngleOfDeparture(1,1)-Angle1+180);
                 else
                     angle(1,1)=rays1(1,r).AngleOfDeparture(1,1)-Angle1;
                 end
 
                angle(2,1)=rays1(1,r).AngleOfDeparture(2,1);
                Gtx=directivity(antenna1,fc,angle);

                Grx=directivity(antenna2,fc,rays1(1,r).AngleOfArrival);
                %パスロス
                Ploss(1,r)=rays1(1,r).PathLoss;

                %rssi[dBm]
                dBm(1,r)=Pt+Gtx+Grx-Ploss(1,r)-Tx_loss-Rx_loss;

                rssi_mW(1,r)=10^(dBm(1,r)/10);
                Am(1,r)=sqrt(rssi_mW(1,r));

                %ｘ成分
                x(1,r)=Am(1,r)*cos(rays1(1,r).PhaseShift);
                %y成分
                y(1,r)=Am(1,r)*sin(rays1(1,r).PhaseShift);
            end


            %合成ベクトルの合成
            t=((sum(x))^2+(sum(y))^2);
            rssi=10*log10(t);

            % ss=sigstrength(rx,tx,pm)

            % minute=((num/1000)-0.32)/speed;
            minute=((num/10000)-0.32)/speed;
            U=table(num,minute,rssi);
            T=vertcat(T,U);
            close(viewer);
        end



        file_name = fullfile('/home/sasaki/Documents/human_room/Smaterial/Rssi/0122/detail/',material,ant_name,angles1);
        %ファイルがなかったら自動生成
        if not(exist(file_name,'dir'))
            mkdir(file_name)
        end

        file_name_c = strcat('detail_',material,'_',ant_name,'_az_',angles1,'_ev_',angles2,'_',str_TP,'.csv');
        csvname = fullfile(file_name,file_name_c);
        %csvファイルに書き込み
        writetable(T,csvname);

        clearvars T
        msg = "Finish!!"
    end
end


    
