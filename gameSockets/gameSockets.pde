import websockets.*;

final float totalGrid = 5;

WebsocketServer ws;

Player player;Lifes lifes;

ArrayList<Bomb> bombs;

void setup() {
  //size(576, 471, P3D);
  size(192, 157, P3D);

  ws = new WebsocketServer(this, 8025, "/");

  player = new Player();
  lifes = new Lifes(5);
  bombs = new ArrayList();
}

void draw() {
  background(0);
  lights();
  ground();

  player.move(mouseX, mouseY - height);
  player.display();
  lifes.display();
  
  for (int i = bombs.size() - 1; i >= 0; i--) {
    Bomb b = bombs.get(i);

    b.update();
    
    if (b.explode()) {
      if(player.explode(b)) {
        if(!b.hit){
        pushMatrix();
          lifes.lifes--;
          player.hit();
          translate(b.pos.x, b.pos.y, b.pos.z);
          fill(255,0,0);
          //sphere(100);
        popMatrix();
        }
        b.hit = true;
      }
      if(!b.hit){           //quita las que no explotan
        bombs.remove(b); 
      }
      
      if(b.remove){      //remove=1 después de la explosion
        bombs.remove(b);    //quita las 
      }
    }

    b.display();
  }
}

void keyPressed() {
  bombs.add(new Bomb(new PVector(random(width), 0, random(-height))));
}

void webSocketServerEvent(String msg) {
  println(msg);
  
  float x = int(msg.substring(0, msg.indexOf(",")));
  float y = int(msg.substring(msg.indexOf(",") + 1));
  bombs.add(new Bomb(new PVector(x, 0, -y)));
}

void ground() {
  stroke(255);
  strokeWeight(1.5);
  for (float i = 0; i <= totalGrid; i++) {
    line(i * width / totalGrid, height, -height, i * width / totalGrid, height, 0);
    line(0, height, i * height / totalGrid - height, width, height, i * height / totalGrid - height);
  }
}