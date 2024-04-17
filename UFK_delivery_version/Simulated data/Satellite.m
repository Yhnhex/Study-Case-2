classdef Satellite
    
    %Object class function that buits a satellite of radomly generated with
    %prismatic form and random optical propoerties

    properties
       Normals
       alpha
       Cabs
       Cesp
       Cdif
       siz
       siz2
       Areas
       total_Area
       
      
             
    end
    
    methods
        function obj =Sat_rand_generation(obj,sat_size,sub_cat,deploy_panels)
         
            
            obj.Normals=[ 1  0  0;
                      -1  0  0;
                       0  1  0;
                       0 -1  0;
                       0  0  1;
                       0  0 -1];
                   
             obj.alpha=1;%normrnd(1.2,0.1);
                    
             if deploy_panels==1
                 
                 Cabs_body=normrnd(0.62,0.12);
                 while Cabs_body>=1
                      Cabs_body=normrnd(0.62,0.12);
                 end

                 Cesp_body_aux=normrnd(0.7,0.1);

                 while Cesp_body_aux>=1
                    Cesp_body_aux=normrnd(0.7,0.1);    
                 end

                 Cesp_body=Cesp_body_aux*(1-Cabs_body);

                 Cdif_body=1-Cabs_body-Cesp_body;


                 Cabs_panel=normrnd(0.75,0.1);

                while Cabs_panel>=1
                      Cabs_panel=normrnd(0.75,0.1);
                 end

                 Cesp_panel_aux=normrnd(0.8,0.05);

                 while Cesp_panel_aux>=1
                    Cesp_panel_aux=normrnd(0.8,0.05);    
                 end

                 Cesp_panel=Cesp_panel_aux*(1-Cabs_panel);

           
                 Cdif_panel=1-Cabs_panel-Cesp_panel;
                 
                 
                 
                  if sat_size==1% Cubesats
                  
                     if sub_cat==1
                       xdim=0.1;
                       ydim=0.1;
                       zdim=0.1;
                       Apanel=xdim*zdim;
                         
                        obj.Areas=[ydim*zdim +2*Apanel, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_panel, Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_body];
                        obj.Cdif=[Cdif_panel, Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_body];
                        obj.siz=1;
                        obj.siz2=1.1;
                         
                         
                     elseif sub_cat==2
                       xdim=0.1;
                       ydim=0.1;
                       zdim=0.3;
                       Apanel=xdim*zdim;
                         
                        obj.Areas=[ydim*zdim +2*Apanel, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_panel, Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_body];
                        obj.Cdif=[Cdif_panel, Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_body];
                        obj.siz=1;
                        obj.siz2=1.2;
                         
                     elseif sub_cat==3
                       xdim=0.1;
                       ydim=0.2;
                       zdim=0.3;
                       Apanel=xdim*zdim;
                         
                        obj.Areas=[ydim*zdim +2*Apanel, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_panel, Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_body];
                        obj.Cdif=[Cdif_panel, Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_body];
                        obj.siz=1;
                        obj.siz2=1.3;
                         
                     else
                       xdim=0.2;
                       ydim=0.2;
                       zdim=0.3;
                       Apanel=xdim*zdim;
                         
                        obj.Areas=[ydim*zdim +2*Apanel, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_panel, Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_body];
                        obj.Cdif=[Cdif_panel, Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_body];
                        obj.siz=1;
                        obj.siz2=1.4;
                         
                     end
                    
                 elseif sat_size==2 %Microsat
                     
                     if sub_cat==1
                         
                       xdim=normrnd(0.5,0.1);
                       ydim=normrnd(0.5,0.1);
                       zdim=normrnd(0.5,0.1);
                       Apanel=xdim*zdim;
                         
                        obj.Areas=[ydim*zdim +2*Apanel, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_panel, Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_body];
                        obj.Cdif=[Cdif_panel, Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_body];
                        obj.siz=2;
                        obj.siz2=2.1;
                         
                     elseif sub_cat==2
                         
                       xdim=normrnd(0.7,0.1);
                       ydim=normrnd(0.7,0.1);
                       zdim=normrnd(0.7,0.1);
                       Apanel=xdim*zdim;
                         
                        obj.Areas=[ydim*zdim +2*Apanel, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_panel, Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_body];
                        obj.Cdif=[Cdif_panel, Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_body];
                        obj.siz=2;
                        obj.siz2=2.2;
                        
                     else
                       xdim=normrnd(1,0.1);
                       ydim=normrnd(1,0.1);
                       zdim=normrnd(1,0.1);
                       Apanel=xdim*zdim;
                         
                        obj.Areas=[ydim*zdim +2*Apanel, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_panel, Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_body];
                        obj.Cdif=[Cdif_panel, Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_body];
                        obj.siz=2;
                        obj.siz2=2.3;
                         
                     end
                    
                 elseif sat_size==3 %big_sat
                     
                     if sub_cat==1
                         xdim=normrnd(1.25,0.15);
                       ydim=normrnd(1.25,0.15);
                       zdim=normrnd(1.25,0.15);
                       Apanel=xdim*zdim;
                         
                        obj.Areas=[ydim*zdim +2*Apanel, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_panel, Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_body];
                        obj.Cdif=[Cdif_panel, Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_body];
                        obj.siz=3;
                        obj.siz2=3.1;
                         
                         
                     elseif sub_cat==2
                       xdim=normrnd(1.5,0.15);
                       ydim=normrnd(1.5,0.15);
                       zdim=normrnd(1.5,0.15);
                       Apanel=xdim*zdim;
                         
                        obj.Areas=[ydim*zdim +2*Apanel, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_panel, Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_body];
                        obj.Cdif=[Cdif_panel, Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_body];
                        obj.siz=3;
                        obj.siz2=3.2;
                         
                         
                     else
                       xdim=normrnd(1.8,0.15);
                       ydim=normrnd(1.8,0.15);
                       zdim=normrnd(1.8,0.15);
                       Apanel=xdim*zdim;
                         
                        obj.Areas=[ydim*zdim +2*Apanel, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_panel, Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_body];
                        obj.Cdif=[Cdif_panel, Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_body];
                        obj.siz=3;
                        obj.siz2=3.3;
                         
                         
                     end
                     
                     
                   
                 end 
                 
  %%%%%%%%%%%%%%% No solar panel deployed %%%%%%%%%%%%%%%%%%%%%%               
             else
                
               Cabs_body=normrnd(0.62,0.12);
               while Cabs_body>=1
                    Cabs_body=normrnd(0.62,0.12);
               end

               Cesp_body_aux=normrnd(0.7,0.1);
               while Cesp_body_aux>=1
                   Cesp_body_aux=normrnd(0.7,0.1);
               end

               Cesp_body=Cesp_body_aux*(1-Cabs_body);
               Cdif_body=1-Cabs_body-Cesp_body;


               Cabs_top=normrnd(0.55,0.2);
               while Cabs_top>=1
                   Cabs_top=normrnd(0.55,0.2);
               end

               Cesp_top_aux=normrnd(0.7,0.1);
               while Cesp_top_aux>=1
                   Cesp_top_aux=normrnd(0.7,0.1);
               end

               Cesp_top=Cesp_top_aux*(1-Cabs_top);
               Cdif_top=1-Cabs_top-Cesp_top;
                 
                 if sat_size==1% Cubesats
                    
                 
                     if sub_cat==1
                         
                        obj.Areas=[0.1*0.1, 0.1*0.1 0.1*0.1 0.1*0.1 0.1*0.1 0.1*.1];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_top, Cesp_top];
                        obj.Cdif=[Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_top, Cdif_top];
                        obj.siz=1;
                        obj.siz2=1.1;
                         
                     elseif sub_cat==2
                         
                        obj.Areas=[0.1*0.3, 0.1*0.3 0.1*0.3 0.1*0.3 0.1*0.1 0.1*.1];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_top, Cesp_top];
                        obj.Cdif=[Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_top, Cdif_top];
                        obj.siz=1;
                        obj.siz2=1.2;
                         
                         
                     elseif sub_cat==3
                         
                        obj.Areas=[0.2*0.3, 0.2*0.3 0.1*0.3 0.1*0.3 0.2*0.1 0.2*.1];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_top, Cesp_top];
                        obj.Cdif=[Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_top, Cdif_top];
                        obj.siz=1;
                        obj.siz2=1.3;
                         
                         
                     else
                         
                        obj.Areas=[0.2*0.3, 0.2*0.3 0.2*0.3 0.2*0.3 0.2*0.2 0.2*.2];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_top, Cesp_top];
                        obj.Cdif=[Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_top, Cdif_top];
                        obj.siz=1;
                        obj.siz2=1.4;
                         
                         
                     end
                    
                 elseif sat_size==2 %Microsat
                     
                     if sub_cat==1
                         
                         xdim=normrnd(0.5,0.1);
                         ydim=normrnd(0.5,0.1);
                         zdim=normrnd(0.5,0.1);
                         
                        obj.Areas=[ydim*zdim, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_top, Cesp_top];
                        obj.Cdif=[Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_top, Cdif_top];
                        obj.siz=2;
                        obj.siz2=2.1;
                         
                     elseif sub_cat==2
                         
                         xdim=normrnd(0.7,0.1);
                         ydim=normrnd(0.7,0.1);
                         zdim=normrnd(0.7,0.1);
                         
                        obj.Areas=[ydim*zdim, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_top, Cesp_top];
                        obj.Cdif=[Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_top, Cdif_top];
                        obj.siz=2;
                        obj.siz2=2.2;
                         
                     else
                         
                        xdim=normrnd(1,0.1);
                        ydim=normrnd(1,0.1);
                        zdim=normrnd(1,0.1);
                         
                        obj.Areas=[ydim*zdim, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_top, Cesp_top];
                        obj.Cdif=[Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_top, Cdif_top];
                        obj.siz=2;
                        obj.siz2=2.3;
                         
                     end
                    
                 elseif sat_size==3 %big_sat
                  
                     
                     if sub_cat==1
                         
                        xdim=normrnd(1.25,0.15);
                        ydim=normrnd(1.25,0.15);
                        zdim=normrnd(1.25,0.15);
                         
                        obj.Areas=[ydim*zdim, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_top, Cesp_top];
                        obj.Cdif=[Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_top, Cdif_top];
                        obj.siz=3;
                        obj.siz2=3.1;
                         
                     elseif sub_cat==2
                         
                        xdim=normrnd(1.5,0.15);
                        ydim=normrnd(1.5,0.15);
                        zdim=normrnd(1.5,0.15);
                         
                        obj.Areas=[ydim*zdim, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_top, Cesp_top];
                        obj.Cdif=[Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_top, Cdif_top];
                        obj.siz=3;
                        obj.siz2=3.2;
                         
                     else
                         
                        xdim=normrnd(1.8,0.15);
                        ydim=normrnd(1.8,0.15);
                        zdim=normrnd(1.8,0.15);
                         
                        obj.Areas=[ydim*zdim, ydim*zdim, xdim*zdim, xdim*zdim, xdim*ydim, xdim*ydim];
                        obj.total_Area=sum(obj.Areas);
                        obj.Cesp=[Cesp_body, Cesp_body, Cesp_body, Cesp_body, Cesp_top, Cesp_top];
                        obj.Cdif=[Cdif_body, Cdif_body, Cdif_body, Cdif_body, Cdif_top, Cdif_top];
                        obj.siz=3;
                        obj.siz2=3.3;
                         
                     end
                   
                 end
             
             end 
             
        end
%%%%%%%%%%%%%%% End of random generation%%%%%%%%%%%%%%%%%%%%%%
        
        

    end
    
end

