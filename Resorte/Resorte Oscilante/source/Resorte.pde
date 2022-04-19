//Podemos usar un dt igual al de excel
float dt = 0.05;
//Valor arbitrario para el tiempo dado el DT
float t = dt * 300;
float g = 9.8;
float l = 100.0;
float m = 2.0;
//valores por defecto, son los más adecuados
float thetaEul = 1.0;
float thetaVelEul = 0.0;
float thetaAccEul = 0.0;

float ks = -0.5;
float kd = 0.1;

//PVector sirve para describir precisamente un vector por lo general con:
//posición, velocidad, aceleración en 2D o 3D

//Posiciones
PVector posOrigen, pos;

//Componentes del vector
PVector a_euler = new PVector(0,0);
PVector vel_euler = new PVector(0,0);
PVector pos_euler = new PVector(0,0);

void setup() {
  noLoop();
  size(600, 600);
  background(200); 
  //Inicializamos esto en 0, 0
  posOrigen = new PVector(0, 0);
  pos = new PVector(0, 0);
}


float Fuerzas(float pos, float vel) {   
  PVector Fk = new PVector(0,0);
  PVector Fr = new PVector(0,0);
  PVector Fd = new PVector(0,0);
  PVector Ft = new PVector(0,0);
  
  float aceleracion = 0.0;
  //Como sabemos gracias a PVector podemos sacar sus componentes
  Fr.y = ks * (pos - l);     
  Fd.y = kd * vel;     
  Fk.y = Fr.y - Fd.y;
  Ft.y = Fk.y + (m*g);     
  aceleracion = Ft.y / m;  
  return aceleracion;
}

void draw() {
  background(200);
  translate(width/2, height/60);
  
  //Linea que sostiene
  strokeWeight(3);
  stroke(0);
  line(-width, 0, width, 0);
  
 //Resorte Euler
  a_euler.y = Fuerzas(pos_euler.y, vel_euler.y);     
  pos_euler.y = pos_euler.y + vel_euler.y * dt;
  vel_euler.y = vel_euler.y + a_euler.y * dt;
  pos_euler.x = pos_euler.x + vel_euler.x * dt;
  vel_euler.x = vel_euler.x + a_euler.x * dt;  
  
  thetaEul += thetaVelEul * dt;
  thetaVelEul += thetaAccEul * dt;
  thetaAccEul = (-1 * g/l) * sin(thetaEul);
  
  //Una propuesta es poner un ángulo para que vaya de un lado a otro
  //Tomamos la mitad de Pi para que tome la mitad del circulo y no se vaya para arriba
  pos.x = l * cos(thetaEul+HALF_PI);
  pos.y = l * sin(thetaEul+HALF_PI);  
   
  //Actualización en pantalla
  strokeWeight(3);
  stroke(0, 0, 0);
  //Linea del resorte
  line(posOrigen.x, posOrigen.y, pos.x+pos_euler.x, pos.y+pos_euler.y);
  stroke(3);
  //Masa que cuelga
  fill(255, 150, 0);
  ellipse(pos.x+pos_euler.x, pos.y+pos_euler.y, 50, 50);
  fill(0);
  textSize(15);
  text("Presiona S (start) para empezar", -250, 0);
  fill(0);
  textSize(15);
  text("Presiona P (pause) para pausar", 0, 0);
}

//Función de Pausa y Comenzar
void keyPressed(){
if (key == 'p'){ noLoop();}
if (key == 's'){ loop();}
}
