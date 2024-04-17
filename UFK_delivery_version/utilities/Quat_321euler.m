function q=Quat_321euler(euler_angles)


%TRANFORM EULER ANGLES TO QUATERION

Cz=[cos(euler_angles(3)) sin(euler_angles(3)) 0;
   -sin(euler_angles(3)) cos(euler_angles(3)) 0;
           0                    0             1];
       
Cy=[cos(euler_angles(2)) 0 -sin(euler_angles(2));
          0              1           0         ;
   sin(euler_angles(2))  0  cos(euler_angles(2))];

Cx=[1            0                    0;
    0 cos(euler_angles(1)) sin(euler_angles(1));
    0 -sin(euler_angles(1)) cos(euler_angles(1))];



Cbi=Cx*Cy*Cz;

quat = rotm2quat(Cbi);

q=[quat(2:4)';quat(1)];

end
