/* Fractal Lightning with Fractal Trees */


// GLOBAL PARAMETERS
int strikePercentage = 9; // the percent of frames that have a lightning bolt.
int defaultFrameRate = 4;
int howLongIsBolt = 200;// 55 how long is the maximum length of the bolt?

// GLOBAL VARIABLES
int startX = 10;              // where a lightning bolt line segment starts
int startY = 0;
int endX = 0;                  // where a lightning bolt line segment stops
int endY = 0;
// Tree variables
int lengthMin = 1;


int changeSceneCounter; // keeps track of how long since a scene change

// AUXILLARY FUNCTIONS
int returnRandomNumber(int max) {
  // this function returns a random integer,x, such that 0<= X <= max
  // the argument, max, must be an integer >= 0.
return ((int) (Math.random()*(max+1)));
}


void drawBolt(int startX, int startY, int yLimit, int sW, int xVar, int splitProbability) {

 /*  This function draws a lighting bolt starting at startX, startY and
     ending when the Y coordinate is at the yLimit.


     The amount of xVariation is defined by xVar -- an integer 0-20 where 20 means more variation.

     The sW is the stroke width of the bolt.

     The probability of the bolt splitting is defined by splitProbability -- 0 to 99.
     */
  int endX, endY = 0;

  if (sW < 1) {
     sW = 1;
  }
  strokeWeight(sW);
  while (endY < yLimit) {
    endX = startX + returnRandomNumber(xVar-1)-(xVar/2);
          // e.g. if xvar is 18, this will return a random number between -9 and +9
          // and add it to startX. So, x increases or decreases by a random amount.
    endY = startY + returnRandomNumber(xVar/2);
          // this line advances Y by a random amount with half of the variation of
          // the x variation. e.g. in the above example when xVar is 18, this would
          // make an endY that is startY plus a random value from 0 to 9.
    line (startX, startY, endX, endY); // draw the line segment
    startX = endX; // move the starting point for the next line segment to
    startY = endY; // the ending point of this line segment

    /* Determine if the lightning bolt is going to split into two bolts */
    if (returnRandomNumber(99)<splitProbability) {
        // splitProbability is used to decide how likely it is for the lightning bolt
        // to split. If 99, then it will always split. If 0, then it will never split.
        // otherwise, it sill split according to its percentage.
        // A single bolt can split multiple times, because the split can happen (or not)
        // at each line segment.
      System.out.println("Bolt Splits!"); // a debugging statement
      drawBolt(startX, startY,yLimit, sW-1, xVar+1, splitProbability);
        // call this function drawBolt, again. This is a RECURSIVE function call.
        // it starts drawing the new lightning bolt that resulted from the split
        // at the current x, y location.
        // we send startX and startY (the starting point for the 'daughter' bolt.
        // the y-limit is the same.
        // for fun, we increase the xvariable after the split to make the
        // bolts cooler. (xVar+1).
        // and we keep the split probability the same (you could increase it, but
        // the program crashed with too many recursive calls).
    }
  }
}



public void drawTrees () {
 for (int i = 0; i < 20+Math.random()*10; i++){
   fractalTree((int) (Math.random()*900),         // starting X coord
                (int) (450-(Math.random()*3)),    // starting Y coord
                (float) (15+Math.random()*60),     // length of tree trunk
               (float) (70+Math.random()*40),      // angle of tree trunk vs horizon
               (int) (4 + Math.random()*5));      // thickness of tree trunk
}

}

public void fractalTree (int x, int y, float length, float angle, float sW) {
    double dRadians;
    float xLineEnd, yLineEnd;

    //System.out.println("In Fractal Tree: "+x+","+y+", "+length+", "+angle);

    if (length < 2) {
        return;
    }

    if (sW < 1) {
      sW = 1;
    }
      strokeWeight (sW);
      dRadians = angle * (Math.PI/180);
      xLineEnd = (int) x - cos((float) dRadians)*length;
      yLineEnd = (int) y - sin((float) dRadians)*length;
      fill (255,255,255);
      stroke (10,90,10);
      line (x, y, xLineEnd, yLineEnd);
      fractalTree ((int) xLineEnd, (int) yLineEnd,
                          length*3/4,(float) (angle + (Math.random()*40)),sW-0.75);
      fractalTree ((int) xLineEnd, (int) yLineEnd,
                          length*3/4,
                           (float) (angle - (Math.random()*40)),sW-0.75);

}


void setup()
{

  size(900,450); // these should be at least as large has the howWidePhoto and howTallPhoto parameters
  background (0,0,0);
  changeSceneCounter = 50;
  drawTrees();
  //frameRate(defaultFrameRate); // slow down redraw to keep lightning on screen
}


void draw()
{
fill (0,0,0);
stroke(0,0,0);
//quad (0,0,0,110,900,110,900,0);
//System.out.println ("Thunder CountDown: "+thunderCountDown+".");

changeSceneCounter--;
if (changeSceneCounter == 0) {
  background(0,0,0);
  drawTrees();
  changeSceneCounter = 50;
}
if (returnRandomNumber(99)<strikePercentage) {
  // we don't draw lightning everytime we land in draw. To make it more realistic,
  // lighting happens randomly, and not often. strikePercentage is used to decide
  // how often. If it's 99, then everytime we enter draw, there will be a lightning strike.
  // if zero, then there will never be a lightning strike
  stroke(250,254,224); // set the stroke color (yellow)
  startX = returnRandomNumber(900-10)+10; // the starting point of the lighting bolt.
                                       // a randomSpot on the top of the screen.
                                       // we add 10 so that it is not starting at the
                                       // edge of the screen. And we substract 10 from the
                                       // random number so it's not at the right edge
                                       // of the screen
  drawBolt(startX, 0, (int) (0.5*Math.random()+1)*howLongIsBolt, 3,18,10);

  }
}

void mousePressed()
{
setup();
drawBolt(mouseX, mouseY, howLongIsBolt, 3,30, 20);
}
