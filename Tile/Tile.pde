import java.util.*;
import controlP5.*;
import javax.swing.JFileChooser;

static final int NUM_PHOTOS = 1000;

static final float BOX_TOP = -0.1;
static final float BOX_BOTTOM = 0.85;
static final float SCALE_MIN = 0.1;
static final float SCALE_MAX = 0.7;

static final float MAIN_PHOTO_Y = 0.75;
static final float MAIN_PHOTO_SCALE = 0.9;

static final boolean DEBUG_SHOW_IMAGE = true;
static final boolean DEBUG_SHOW_ELLIPSE = false;

ArrayList<PImage> images = new ArrayList<PImage>();
Random rand = new Random();
File folder = new File("/Users/boxysean/__Fluxfinity");

ControlP5 cp5;
PGraphics tileImage;

int laptops = 1000;

int widthMin = 50;
int widthMax = 80;

float rotationMin = -PI/6;
float rotationMax = PI/6;

float keyboardPaddingPercentMin = 0.03;
float keyboardPaddingPercentMax = 0.10;

float keyboardSizePercentMin = 0.4;
float keyboardSizePercentMax = 0.6;

int keyboardThicknessMin = 5;
int keyboardThicknessMax = 10;

int keyboardRowsMin = 3;
int keyboardRowsMax = 6;

int keyboardColumnsMin = 8;
int keyboardColumnsMax = 15;

float trackpadPaddingPercentMin = 0.05;
float trackpadPaddingPercentMax = 0.05;

float screenPaddingPercentMin = 0.05;
float screenPaddingPercentMax = 0.15;

float strokeWeight = 1.0;

boolean drawAgain = true;

HashSet<String> filesLoaded = new HashSet<String>();

class Pair implements Comparable<Pair> {
	float x, y;

	public Pair(float xx, float yy) {
		x = xx;
		y = yy;
	}

	public int compareTo(Pair p) {
		if (p.y < y) {
			return -1;
		} else if (p.y > y) {
			return 1;
		} else if (p.x < x) {
			return -1;
		} else if (p.x > x) {
			return 1;
		} else {
			return 0;
		}
	}
}

void setupButtons() {
  cp5 = new ControlP5(this);
  cp5.setColorLabel(#FF0000);

  // size(1200, 1200);

  int cp5y = 50;

/*  cp5.addSlider("laptops").setBroadcast(false).setPosition(50, cp5y).setSize(200, 30)
    .setRange(50, 2000).setValue(laptops).setBroadcast(true);

  cp5y += 40;

  cp5.addRange("width").setBroadcast(false).setPosition(50, cp5y).setSize(200, 30)
    .setRange(20, 200).setRangeValues(widthMin, widthMax).setBroadcast(true);

  cp5y += 40;

  cp5.addRange("rotation").setBroadcast(false).setPosition(50, cp5y).setSize(200, 30)
    .setRange(20, 200).setRangeValues(widthMin, widthMax).setBroadcast(true);

  cp5y += 40;

  cp5.addRange("keyboardPaddingPercent").setBroadcast(false).setPosition(50, cp5y).setSize(200, 30)
    .setRange(0, 0.25).setRangeValues(keyboardPaddingPercentMin, keyboardPaddingPercentMax).setBroadcast(true);

  cp5y += 40;

  cp5.addRange("keyboardSizePercent").setBroadcast(false).setPosition(50, cp5y).setSize(200, 30)
    .setRange(0.2, 0.8).setRangeValues(keyboardSizePercentMin, keyboardSizePercentMax).setBroadcast(true);

  cp5y += 40;

  cp5.addRange("keyboardThickness").setBroadcast(false).setPosition(50, cp5y).setSize(200, 30)
    .setRange(0, 20).setRangeValues(keyboardThicknessMin, keyboardThicknessMax).setBroadcast(true);

  cp5y += 40;

  cp5.addRange("keyboardRows").setBroadcast(false).setPosition(50, cp5y).setSize(200, 30)
    .setRange(0, 10).setRangeValues(keyboardRowsMin, keyboardRowsMax).setBroadcast(true);

  cp5y += 40;

  cp5.addRange("keyboardColumns").setBroadcast(false).setPosition(50, cp5y).setSize(200, 30)
    .setRange(0, 30).setRangeValues(keyboardColumnsMin, keyboardColumnsMax).setBroadcast(true);

  cp5y += 40;

  cp5.addRange("trackpadPaddingPercent").setBroadcast(false).setPosition(50, cp5y).setSize(200, 30)
    .setRange(0, 0.25).setRangeValues(trackpadPaddingPercentMin, trackpadPaddingPercentMax).setBroadcast(true);

  cp5y += 40;

  cp5.addRange("screenPaddingPercent").setBroadcast(false).setPosition(50, cp5y).setSize(200, 30)
    .setRange(0, 0.25).setRangeValues(screenPaddingPercentMin, screenPaddingPercentMax).setBroadcast(true);

  cp5y += 40;

  cp5.addSlider("strokeWeight").setBroadcast(false).setPosition(50, cp5y).setSize(200, 30)
    .setRange(0, 5).setValue(strokeWeight).setBroadcast(true);

  cp5y += 40;*/

  cp5.addButton("drawAgain").setPosition(50, cp5y).setSize(60,30).setOn();
  cp5.addButton("reload").setPosition(120, cp5y).setSize(60,30).setOn();
  cp5.addButton("savePNG").setPosition(190, cp5y).setSize(60,30).setOn();
  cp5.addButton("imageForEach").setPosition(260, cp5y).setSize(60,30).setOn();
}

void controlEvent(ControlEvent e) {
  if (e.isFrom("width")) {
    widthMin = int(e.getController().getArrayValue(0));
    widthMax = int(e.getController().getArrayValue(1));
  } else if (e.isFrom("rotation")) {
    rotationMin = e.getController().getArrayValue(0);
    rotationMax = e.getController().getArrayValue(1);
  } else if (e.isFrom("keyboardPaddingPercent")) {
    keyboardPaddingPercentMin = e.getController().getArrayValue(0);
    keyboardPaddingPercentMax = e.getController().getArrayValue(1);
  } else if (e.isFrom("keyboardSizePercent")) {
    keyboardSizePercentMin = e.getController().getArrayValue(0);
    keyboardSizePercentMax = e.getController().getArrayValue(1);
  } else if (e.isFrom("keyboardThickness")) {
    keyboardThicknessMin = int(e.getController().getArrayValue(0));
    keyboardThicknessMax = int(e.getController().getArrayValue(1));
  } else if (e.isFrom("keyboardRows")) {
    keyboardRowsMin = int(e.getController().getArrayValue(0));
    keyboardRowsMax = int(e.getController().getArrayValue(1));
  } else if (e.isFrom("keyboardColumns")) {
    keyboardColumnsMin = int(e.getController().getArrayValue(0));
    keyboardColumnsMax = int(e.getController().getArrayValue(1));
  } else if (e.isFrom("trackpadPaddingPercent")) {
    trackpadPaddingPercentMin = e.getController().getArrayValue(0);
    trackpadPaddingPercentMax = e.getController().getArrayValue(1);
  } else if (e.isFrom("screenPaddingPercent")) {
    screenPaddingPercentMin = e.getController().getArrayValue(0);
    screenPaddingPercentMax = e.getController().getArrayValue(1);
  } else if (e.isFrom("reload")) {
  		loadFilesFromFolder(folder);
  } else if (e.isFrom("savePNG")) {
    tileImage.save("/Users/boxysean/__Fluxfinity_output/Fluxfinity-" + System.currentTimeMillis() + ".png");
  } else if (e.isFrom("loadFile")) {
		JFileChooser chooser = new JFileChooser();
        chooser.setCurrentDirectory(new File("~"));
    	chooser.setFileFilter(chooser.getAcceptAllFileFilter());
		int returnVal = chooser.showOpenDialog(null);
		if (returnVal == JFileChooser.APPROVE_OPTION) {
			File f = chooser.getSelectedFile();
		    println("You chose to open this file: " + f.getName());
			images.add(loadImage(f.getAbsolutePath()));
		}
  } else if (e.isFrom("imageForEach")) {
  	int counter = 0;
  	for (PImage im : images) {
  		drawIt(tileImage, im);
	    tileImage.save(String.format("/Users/boxysean/__Fluxfinity_gen/Fluxfinity-%04d.jpg", counter++));
  	}
  }
}

void loadFilesFromFolder(File folder) {
	File[] listOfFiles = folder.listFiles();

	for (File f : listOfFiles) {
		if (f.getName().endsWith(".png") && !filesLoaded.contains(f.getName())) {
			println("loading " + f + "...");
			images.add(loadImage(f.getAbsolutePath()));
			filesLoaded.add(f.getName());
		}
	}
}

void setup() {
	size(1024, 768);

  	tileImage = createGraphics(width, height);

	loadFilesFromFolder(folder);

	setupButtons();
}

void drawIt(PGraphics g) {
	drawIt(g, null);
}

void drawIt(PGraphics g, PImage mainImage) {
	g.beginDraw();
	g.background(#000000);

	ArrayList<Pair> points = new ArrayList<Pair>();

	// Randomly exponentially placed photos
	// for (int i = 0; i < NUM_PHOTOS; i++) {
	// 	float x = rand.nextFloat();
	// 	float yy = log(1-rand.nextFloat()) / -0.8;
	// 	float y = map(min(yy, 5), 0, 5, 0, 1);
	// 	points.add(new Pair(x, y));
	// }

	// Placed
	for (float y = 0.1; y <= 1.00001; y += 0.05) {
		float spacing = (log(1-y) / -1) / 10.0;
		System.out.printf("Spacing %.2f\n", spacing);
		for (float x = -spacing/2 + spacing * rand.nextFloat(); x <= 1.00001; x += spacing + rand.nextFloat() * spacing/2) {
			// System.out.printf("%.2f %.2f\n", x, y);
			points.add(new Pair(x, y + (spacing * rand.nextFloat() - spacing/2.0) / 2));
		}
	}

	int bandwidthCount[] = new int[4];

	for (Pair p : points) {
		bandwidthCount[(int) (p.y * 3 - 0.0001)]++;
	}

	System.out.printf("bandwidths: %d %d %d\n", bandwidthCount[0], bandwidthCount[1], bandwidthCount[2]);

	Collections.sort(points);
	Collections.reverse(points);

	float boxLeftX = -100;
	float boxRightX = width + 100;
	float boxTopY = height * BOX_TOP;
	float boxBottomY = height * BOX_BOTTOM;

	for (Pair p : points) {
		PImage im = images.get((int) random(0, images.size()));

		float offsetX = boxLeftX + (boxRightX - boxLeftX) * p.x;
		float offsetY = boxTopY + (boxBottomY - boxTopY) * p.y;

		g.pushMatrix();
		g.translate(offsetX, offsetY);
		g.scale(map(p.y, 0, 1, SCALE_MIN, SCALE_MAX));
		if (DEBUG_SHOW_IMAGE) g.image(im, -im.width/2, -im.height/2);
		if (DEBUG_SHOW_ELLIPSE) g.ellipse(0, 0, 50, 50);
		g.popMatrix();
	}

	g.pushMatrix();
	g.translate(width/2, height * MAIN_PHOTO_Y);
	g.scale(MAIN_PHOTO_SCALE);
	if (mainImage == null) {
		mainImage = images.get(images.size()-1);
	}
	g.image(mainImage, -mainImage.width/2, -mainImage.height/2);
	g.popMatrix();

	g.endDraw();
}

void draw() {
    background(#FFFFFF);

	if (drawAgain) {
		drawIt(tileImage);
		drawAgain = false;
	}

	image(tileImage, 0, 0);
}

boolean sketchFullScreen() {
	return true;
}
