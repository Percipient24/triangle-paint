// equilateral size variables
int edge = 60;
int half_edge = edge / 2;
int tri_width = int(float(half_edge) * sqrt(3));

// size of the grid
int across;
int down;

// using these colors
color[] swatches = {
  color(253,128,0),
  color(251,186,0),
  color(51,142,221),
  color(55,193,222)
};

// indexes into swatches
int[][] design;

// 1, 2, 3, 4, or c
// maps to swatch
// 0, 1, 2, 3 or 'c'haotic
char paint_mode = 'c';

void setup() {
  size(800,600);
  
  // calculate size with some extra to go off the edge
  across = ceil(float(width) / float(tri_width)) + 2;
  down = ceil(float(height) / float(half_edge)) + 2;
  
  // initialize the design to be that size
  design = new int[across][down];
  
  // and fill it randomly
  for(int x = 0; x < across; x++) {
    for(int y = 0; y < down; y++) {
      design[x][y] = int(random(0,swatches.length));
    }
  }
  
  noStroke();
}

// yes, it's drawing the whole screen every time
// yes, I should noloop it and fix it
// no, I won't do that today
void draw() {
  if (mousePressed) {
    paintByMouse(); 
  }
  
  int fudge = 0;
  for(int x = 0; x < across; x++) {
    // fudge is used to offset the columns vertically so they line up
    fudge = x%2 == 0 ? -half_edge : -edge;
    
    for (int y = 0; y < down; y++) {
      fill(swatches[design[x][y]]);
      
      // triangles change facing based on even/odd of y
      if (y%2 == 0) {
        triangle(x * tri_width, y * half_edge + fudge,
                 x * tri_width, y * half_edge + edge + fudge,
                 x * tri_width + tri_width, y * half_edge + half_edge + fudge);
      } else {
        triangle(x * tri_width, y * half_edge + half_edge + fudge,
                 x * tri_width + tri_width, y * half_edge + edge + fudge,
                 x * tri_width + tri_width, y * half_edge + fudge);
      }
    }
  }
}

// changes the painting color when a key is released
void keyReleased() {
  switch(key) {
    case '1':
    case '2':
    case '3':
    case '4':
    case 'c':
      paint_mode = key;
      println(paint_mode);
    break;
  }
}

// this was the hard part:
// figures out which triangle the mouse is over, and colors it
void paintByMouse() {
  
  int x = mouseX / tri_width;
  float x_perc = float(mouseX - x * tri_width) / float(tri_width);
  
  int y = mouseY / half_edge;
  
  if(x%2 == 0) {
    if ( y%2 == 0) {
      y = mouseY < y * half_edge + half_edge - int(x_perc * half_edge) ? y : y + 1;
    } else {
      y = mouseY > y * half_edge + int(x_perc * half_edge) ? y + 1 : y;
    }
  } else {
   if ( y%2 == 1) {
      y = mouseY < y * half_edge + half_edge - int(x_perc * half_edge) ? y + 1 : y + 2;
    } else {
      y = mouseY > y * half_edge + int(x_perc * half_edge)  ? y + 2 : y + 1;
    } 
  }
  
  // stay within the grid
  x = constrain(x,0,across);
  y = constrain(y,0,down);
  
  int current = design[x][y];
  
  switch(paint_mode) {
    // someday I'll make a map, but not today
    case '1':
      design[x][y] = 0;
      break;
    case '2':
      design[x][y] = 1;
      break;
    case '3':
      design[x][y] = 2;
      break;
    case '4':
      design[x][y] = 3;
      break;
    case 'c':
      // cycle the swatch up one, % accounting for swatch length wrap
      design[x][y] = (current + 1) % swatches.length;
      break;
  }
}
