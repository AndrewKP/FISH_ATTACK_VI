/*Andrew Peterson
 9/10/15
 AHHHHH! Fish Attack!
 Use the left and right arrow keys to control the worm as he avoids wave after wave of hungry fish. Good Luck!
 If you collide with a fish, then the game is over.  Your score depends on how long you survive.
 The game has endless play.
 */

PImage fishLeft; //images are royalty-free and from google images
PImage fishRight;
PImage wormLeft;
PImage wormRight; 
PImage underwaterBackground;

PFont font; //declare font object

int charX; //declare character speeds and coordiantes, char height annd width
final static int CHARXSPEED = 4;
final static int CHARW = 40;
int charY;
final static int CHARH = 30;
boolean right; //controls whether char is stationary or moving right or left
boolean left;
boolean lookRight; //is char looking right? If not, he is looking left

final static float GRAV = .1; //constant acceleration due to gravity

Fish [] fish; //declare an array of Fish objects


final static int FLOORY = 350; //tells game where to put floor

int gameState;
final static int TITLE = 0;
final static int PLAYING = 1;
final static int LOSESCREEN = 2;

int timeSaved; //keeps a value of how long the game has been running
int timeCount; //uses timeSaved to make sure a fish is released at regular intervals
int gameTime; //tells game how long it ran on title screen
boolean firstTime;

int maxCount; //these two ints tell the game how much of the fish array to access when performing the fish.functions()
int minCount;  

int score; 

void setup() {
  size(500, 365);
  charX = width/2;
  charY = FLOORY - CHARH; //start character in middle of screen on floor
  fish = new Fish[100]; //initialize the array
  for (int i = 0; i < fish.length; i++) {
    fish[i] = new Fish(); //initialize fish variables
  }

  score = 0;
  gameTime = 0;

  maxCount = 1; //start by releasing the first fish (fish[0])
  minCount = 0;

  gameState = TITLE; //start me at title screen

  timeSaved = 0; //initialize fish timing variables
  timeCount = 0;
  firstTime = true; //first time through PLAYING, millis() needs to be stored in gameTime. --> this tells game when it is going throgh PLAYING for the first time

  font = createFont("Comic Sans MS", 30); 

  underwaterBackground = loadImage("underwater background.gif"); 
  fishLeft = loadImage("Fish left.png");
  fishRight = loadImage("Fish right.png");
  wormLeft = loadImage("worm left.png");
  wormRight = loadImage("worm right.png");
  lookRight = true; //start game looking right
}

void draw() {
  if (gameState == TITLE) {
    background(0);
    textFont(font);
    textAlign(CENTER);
    text("FISH ATTACK!", width/2, height/2);
    text("Press Any Key To Start!", width/2, 300);
    textSize(20);
    text("Use the Left and Right Arrow Keys to Play!", width/2,350);
  }
  if (gameState == PLAYING) {
    imageMode(CORNER);
    image(underwaterBackground, 0, 0);
    if(firstTime) { //this block is only run once per game. This ensures that the time spent running the TITLE part of the game is recorded.
    gameTime = millis(); 
    firstTime = false;
    }
    score = millis() - gameTime; //score = amount of millis you spend in PLAYING
    textFont(font);
    text(int(score/100.0), 50, 50); //you get 10 points for every second you stay alive

    displayChar();
    moveChar();
    
    if (maxCount > 20) {
    minCount = maxCount - 20; //minCount starts at 0, but after the first fish passes the screen, we don't need to access that part of the fish array
    } //keeping minCount 20 less than maxCount means that we are accessing at most 20 elements of the fish array, 
      //while displaying all fish that are supposed to be onscreen.
    
    for (int i = minCount; i < maxCount; i++) { //run the main fish functions for 20 fish (at most)
      fish[i].move();
      fish[i].display();
    }
    
    addFish(); //tells game when to add fish to screen by iterating maxCount after every 3 seconds
    refreshFish(); // resets fish array when needed
    collision(); //has char collided with a fish yet?
    
  }
  if(gameState == LOSESCREEN) {
    textFont(font);
    text("Oops, You Lost!", width/2,height/2);
    text("Press SPACE To Try Again",width/2,300);
  }
}

void keyPressed() {
  if (gameState == TITLE) { //press any key in TITLE gameState, and then switch to PLAYING
    gameState = PLAYING;
  }
  if (keyCode == RIGHT) { //if right arrow key is pressed, move right
    right = true;
    left = false;
  } else if (keyCode == LEFT) { //if left arrow key is pressed, move left
    right = false;
    left = true;
  }
  if (gameState == LOSESCREEN && key == ' ') { //press SPACE to start game over after you get to LOSESCREEN
    setup();
  }
}

void keyReleased() {
  if (keyCode == RIGHT) { //if right arrow key is released, then stop moving right
    right = false;
  } else if (keyCode == LEFT) { //if left arrow key is released, then stop moving left
    left = false;
  }
}

