function dir=rot(r,q,transform_direction)   %No estoy seguro de esto....

%r vector to transform
%q quaternion
%transform_direction: Transformation direction 1== direc transformation 
                                              %-1== inverse transfor

Cbi=quat2rotm([q(4,1) q(1:3,1)']);
 

if transform_direction==1

 dir=Cbi*r;

else
    
    dir=Cbi'*r;
end

end
