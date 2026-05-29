CLNNC-ASR Software Package  (2026-5-26)

## 1. Introduction

This is the code for the paper "Composite learning neural network position and stiffness control of articulated soft robots". 

## 2. Hardware environment

+ Qbmove Advanced actuator *3 (Only required for experiments)  
+ 24V DC power supply (Only required for experiments)  

## 3. Software version
matlab 2024b  

FTDI serial drivers (Only required for experiments)  

qbtools_adv_win_v2.2.5 (Only required for experiments)  

## 4. Operating instructions (Only required for experiments)
1.Use the qbtools_adv_win_v2.2.5 tool to move the qbmove links to the equilibrium position.  

2.Execute the Matlab code.  


## 5. Code structure

|———— Readme.md                                      //Help  

|———— CLNN_sim_3dof_2NN.slx                          //Simulation slx  

|———— CLNN_sim_3dof_2NN_exp.slx                      //Experiment slx  

|———— clnn_control_3dof_2NN.m                        //CLNNC controller  

|———— phi_3dof_2NN_q.m                               // Network activation function phi_q  

|———— phi_3dof_2NN_s.m                                  // Network activation function phi_s  

|———— plant_robot_3Dof_2NN.m                            //Plant  

|———— run_CLNN_3dof_2NN.m                               //Run  

|———— setting_3dof_2NN.m                                //Setting  
 
|———— plot_compare_3DoF_sim.m                            //plot


## 6. Simulation scheme
To run the algorithm follow these steps:  

#### 1. Run Matlab in "\CLNNC" directory.  
  
#### 2. Configure the parameters of the test you want to perform. In particular:  

+ Change "is_cl". This defines whether to use composite learning.  

+ Change "is_noise". This defines whether to inject noise.  

#### 3.Run run_CLNN_3Dof_2NN.m.  

#### 4.If the program terminates, please regenerate V0_q, V0_s in run_CNN_3dof_2NN. m.  

#### 5.ILC code can refer to the repository:https://github.com/NMMI/ILC-code


## 7.Plot

Run plot_compare_3DoF_sim.m.



# CLNNC-ASR
