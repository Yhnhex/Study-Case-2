function q=rand_quat()

%Generates random quaternion

quat=-100+200*rand(4,1);

q=quat/norm(quat);


end
