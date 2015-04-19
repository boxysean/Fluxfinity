import java.util.*;

static final int NUM_PHOTOS = 500;

static final float BOX_TOP = 0.0;
static final float BOX_BOTTOM = 0.6;
static final float SCALE_MIN = 0.1;
static final float SCALE_MAX = 0.7;

static final float MAIN_PHOTO_Y = 0.6;

static final boolean DEBUG_SHOW_ELLIPSE = false;

PImage mainImage = null;
ArrayList<PImage> images = new ArrayList<PImage>();
Random rand = new Random();

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

void setup() {
	size(1024, 768);

	String imagePath = sketchPath("../assets/photoboothtestimages");

	File folder = new File(imagePath);
	File[] listOfFiles = folder.listFiles();

	for (File f : listOfFiles) {
		if (!f.getName().endsWith("-trim.png")) {
			println("loading " + f + "...");
			images.add(loadImage(f.getAbsolutePath()));
			// break;
		}
	}

	mainImage = images.get(0);

	noLoop();
}

void draw() {
	// for (PImage i : images) {
	// 	image(i, 0, 0);
	// }

	ArrayList<Pair> points = new ArrayList<Pair>();

	for (int i = 0; i < NUM_PHOTOS; i++) {
		float x = rand.nextFloat();
		float yy = log(1-rand.nextFloat()) / -0.8;
		float y = map(min(yy, 5), 0, 5, 0, 1);
		points.add(new Pair(x, y));
	}

	int bandwidthCount[] = new int[3];

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

		float offsetX = (boxRightX - boxLeftX) * p.x;
		float offsetY = (boxBottomY - boxTopY) * p.y;

		pushMatrix();
		translate(offsetX, offsetY);
		scale(map(p.y, 0, 1, SCALE_MIN, SCALE_MAX));
		image(im, -im.width/2, -im.height/2);
		if (DEBUG_SHOW_ELLIPSE) ellipse(0, 0, 10, 10);
		popMatrix();
	}

	pushMatrix();
	translate(width/2, height * MAIN_PHOTO_Y);
	image(mainImage, -mainImage.width/2, -mainImage.height/2);
	popMatrix();
}
