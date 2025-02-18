// Importo las librerías necesarias
#include <webots/robot.h>
#include <webots/motor.h>
#include <webots/distance_sensor.h>
#include <webots/position_sensor.h>
#include <stdio.h>


#define TIME_STEP 64

int main(int argc, char **argv) {
  wb_robot_init(); // inicializo el robot
  
  // Variables
  float dist = 0;
  int etapa = 1;
  float posicion_dedo = 0;
  float posicion_brazo = 0;
  
  WbDeviceTag brazo1 = wb_robot_get_device("shoulder_pan_joint"); // Obtengo el dispositivo del robot, brazo 1
  WbDeviceTag brazo2 = wb_robot_get_device("shoulder_lift_joint"); // Obtengo el dispositivo del robot,  brazo 2
  WbDeviceTag brazo3 = wb_robot_get_device("elbow_joint"); // Obtengo el dispositivo del robot, brazo 3
  WbDeviceTag brazo4 = wb_robot_get_device("wrist_1_joint"); // Obtengo el dispositivo del robot, brazo 4
  WbDeviceTag brazo5 = wb_robot_get_device("wrist_2_joint"); // Obtengo el dispositivo del robot, brazo 5
  WbDeviceTag brazo6 = wb_robot_get_device("wrist_3_joint"); // Obtengo el dispositivo del robot, brazo 6

  WbDeviceTag dedo1 = wb_robot_get_device("finger_1_joint_1"); // Obtengo el dedo1 de la mano
  WbDeviceTag dedo2 = wb_robot_get_device("finger_2_joint_1"); // Obtengo el dedo2 de la mano
  WbDeviceTag dedo3 = wb_robot_get_device("finger_middle_joint_1"); // Obtengo el dedo3 de la mano
  
  
  WbDeviceTag sensor_distancia = wb_robot_get_device("sensor_distancia"); // Obtengo el sensor
  wb_distance_sensor_enable(sensor_distancia, TIME_STEP); // Enciendo el sensor
  
  WbDeviceTag sensor_dedo = wb_robot_get_device("finger_1_joint_1_sensor"); // Obtengo el sensor
  wb_position_sensor_enable(sensor_dedo, TIME_STEP); // Enciendo el sensor del dedo1
  
  
  WbDeviceTag sensor_brazo = wb_robot_get_device("shoulder_lift_joint_sensor"); // Obtengo el sensor
  wb_position_sensor_enable(sensor_brazo, TIME_STEP); // Obtengo el sensor del brazo2
   
   
   
  while (wb_robot_step(TIME_STEP) != -1) { // Sigue avanzando la simulación mientras que esta sea diferente de -1
  
    dist = wb_distance_sensor_get_value(sensor_distancia); // Obtengo la distancia que detecte el sensor
    posicion_dedo = wb_position_sensor_get_value(sensor_dedo); // Obtengo la posición del dedo
    posicion_brazo = wb_position_sensor_get_value(sensor_brazo); // Obtengo la posición del brazo
    
    /* 
    Se encarga de poner el brazo a su posición orginal.
    Cuango la distancia del sensor sea inferior a 130, cambia a la 2 etapa.
    */
    if (etapa == 1) {
      wb_motor_set_position(brazo1, 0);
      wb_motor_set_position(brazo2, 0);
      wb_motor_set_position(brazo3, 0);
      wb_motor_set_position(dedo1, 0.05);
      wb_motor_set_position(dedo2, 0.05);
      wb_motor_set_position(dedo3, 0.05);
      
      if (dist < 130) {
        etapa = 2;
      }
    }
    
    /* 
    Se encarga de cerrar la mano hasta un 85%. Si se pone al 100% puede romper la lata.
    Cuango la posición del dedo sea mayor al 84%, cambia a la 3 etapa
    */
    if (etapa == 2) {
      wb_motor_set_position(brazo1, 0);
      wb_motor_set_position(brazo2, 0);
      wb_motor_set_position(brazo3, 0);
      wb_motor_set_position(dedo1, 0.85);
      wb_motor_set_position(dedo2, 0.85);
      wb_motor_set_position(dedo3, 0.85);
      
      if (posicion_dedo > 0.84) {
        etapa = 3;
      }
    }
    
    /* 
    Se encarga de mover el brazo2 y el brazo3 el brazo a la posición -1.7,
    mientras que el brazo1 lo mantiene en su posición original.
    Cuango la posición del brazo sea inferior a -1.69, cambia a la 4 etapa.
    Nota: la posición -1.7 no es un número aleatorio. Se obtiene probando en las siguientes web:
    mano 3 dedos → https://webots.cloud/run?version=R2023b&url=https%3A%2F%2Fgithub.com%2Fcyberbotics%2Fwebots%2Fblob%2Freleased%2Fprojects%2Fdevices%2Frobotiq%2Fprotos%2FRobotiq3fGripper.proto 

    brazo → https://webots.cloud/run?version=R2023b&url=https%3A%2F%2Fgithub.com%2Fcyberbotics%2Fwebots%2Fblob%2Freleased%2Fprojects%2Frobots%2Funiversal_robots%2Fprotos%2FUR3e.proto
    */
    if (etapa == 3) {
      wb_motor_set_position(brazo1, 0);
      wb_motor_set_position(brazo2, -1.7);
      wb_motor_set_position(brazo3, -1.7);
      
      if (posicion_brazo < -1.69) {
        etapa = 4;
      }
    }
    
    
    /*
    Se encarga de volver a abrir la mano, es decir, poner la posición de todos los dedos a 0.
    Cuando la posición del dedo esté a punto de llegar a 0,05 pasa a la etapa 1.
    */
    if (etapa == 4) {
      wb_motor_set_position(dedo1, 0.05);
      wb_motor_set_position(dedo2, 0.05);
      wb_motor_set_position(dedo3, 0.05);
      
      if (posicion_dedo < .055) {
        etapa = 1;
      }
    }
 
 

  }


  wb_robot_cleanup();

  return 0;
}
