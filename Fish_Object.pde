class Fish {
  float x; //declare coordinates, size, speeds
  int size;
  float xSpeed;
  float y;
  float ySpeed;
  int place; //tells fish to start on right or left side of the screen (0 == left, 1 == right)
  boolean onScreen; //is the fish on currently on the screen?
  
  Fish() {
    size = int(random(30,100)); //randomly choose size, initial y coordinate, x and ySpeeds, and starting place (left or right side of screen)
    y = int(random(0,250));
    xSpeed = random(1,5);
    ySpeed = int(random(1,3));
    place = int(random(0,2));
    onScreen = false; //tells game whether fish is on the screen
    if(place == 0) {//if the fish is to the left of the screen, do not change its original speed
      x = -100;
    }
    else if(place == 1) {
      xSpeed *= -1; //if the fish is to the right of the screen, makke it move left
      x = 700;
    }
  }
  void move() {
    x+=xSpeed;
    y+=ySpeed; 
    ySpeed+=GRAV;
    
    if(y + size/2 - 10 > FLOORY) {
      ySpeed*=-1;    //make fish bounce (reverse the sign of its speed) when it hits the ground
    }
    if((x < width + 100) && (x > -100)) { //is the fish on the screen
      onScreen = true;
    }
    else {
      onScreen = false;
    }
  }

  void display() {
    imageMode(CENTER);
    pushMatrix();
    translate(x,y); //translate to the x and y coordinates so that the fish can be scaled
    scale(size/30.0);
    if (place == 0) {
      image(fishRight,0,0); //if you start on left of the screen, then look right
    }
    else {
      image(fishLeft,0,0); //else, look left
    }
    popMatrix();
  }
}
