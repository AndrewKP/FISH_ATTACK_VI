void moveChar() {
  if (right) {
    charX+=CHARXSPEED; //if right is true, then move right
    lookRight = true;
  } else if (left) {
    charX-=CHARXSPEED; //if left  is true, then move left
    lookRight = false;
  }

  if (charX > width) { //keep char inside view of screen
    charX = width;
  }
  if (charX < 0) {
    charX = 0;
  }
}

void displayChar() {
  if (lookRight) {
    image(wormRight, charX, charY); //draw character looking the right way
  } else {
    image(wormLeft, charX, charY);
  }
}

void addFish() {
  if (timeSaved == 0) {
    timeSaved = millis(); //get first timeSaved immediately when the game starts
  }

  timeCount = millis() - timeSaved; //the difference between millis() and timeSaved is the time since that last fish was released

  if (maxCount < fish.length-7) { //maxCount should never be more than 93, because if maxCount is increased by 6 from 94, there is no fish[100]
    if (timeCount > 3000) {
      timeSaved = millis(); //set timeSaved again so the game knows when the last fish was released
      if (timeSaved < 15000) {
        maxCount++; //release some fish every 3 seconds
      }
      else if (timeSaved > 15000 && timeSaved < 30000) { //game gets harder as more fish are released per 3 seconds
        maxCount+=2;
      }
      else if (timeSaved > 30000 && timeSaved < 45000) { 
        maxCount +=3;
      }
      else if (timeSaved > 45000) {
        maxCount += 4;
      }
      else if (timeSaved > 60000) {
        maxCount +=6;
      }
    }
  }
}

void refreshFish() {
  if (maxCount >= fish.length-7) { //if the fish array is near its end, see if the array needs to be refreshed
    boolean startOver = true; //tells game whether game fish array needs to be refreshed
    for (int i = minCount; i < maxCount; i++) {
      if (fish[i].onScreen) {
        startOver = false; //if there are any fish still onScreen, do not refresh the fish array yet
      }
    }
    if (startOver) { //if there are no fish onscreen, start all of the fish in the array with different values
      for (int i = 0; i < fish.length; i++) {
        fish[i] = new Fish();
      }
      minCount = 0; //restart the variables that affect the display and movement of the fish
      maxCount = 1;
    }
  }
}

void collision() { //test all of the fish onscreen to see if they have collided with the character
  for (int i = minCount; i < maxCount; i++) {
    if (dist(fish[i].x, fish[i].y, charX+int(.5*CHARW), charY + int(.66*CHARH)) < (fish[i].size/2)) { 
      //if the distance between the center of the fish and char's center is less than the radius of the fish...
      //then you are hit by the fish
      gameState = LOSESCREEN;
    }
  }
}

