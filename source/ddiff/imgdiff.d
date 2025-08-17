module ddiff.imgdiff;

import std.range : iota;
import std.algorithm : sum;
import std.parallelism : parallel;
import std.typecons;

import gamut;
import ddiff.yiq;

struct Options {
    double threshold;
    bool diffImage;
    ImageFormat imgFormat;
}

struct Result {
    bool equal;
    ulong diffPixelsCount;
    RefCounted!(Image*, RefCountedAutoInitialize.no) image;
}

/// Diff between two images.
Result imageDiff(ref Image image1, ref Image image2, Options options) {
    auto maxDelta = MAX_DELTA * options.threshold * options.threshold;

    Image* diff = new Image(image1.width(), image1.height(), PixelType.rgba8);

    (*diff).createNoInit(image1.width(), image1.height(), PixelType.rgba8);

    if (options.diffImage)
        image1.copyPixelsTo(*diff);

    enum N = 8;
    ulong[N] diffPixelsCounts;
    int mid = cast(int) image1.height() / N;

    foreach(id; parallel(iota(0,N), 1)) {
        ulong diffPixelsCounter = 0;
        foreach(y; id*mid..id*mid + mid) {
            ubyte* scan = cast(ubyte*) (*diff).scanptr(y);
            ubyte* scan1 = cast(ubyte*) image1.scanptr(y);
            ubyte* scan2 = cast(ubyte*) image2.scanptr(y);

            foreach(x; iota(0, (*diff).width())) {
                ubyte a_r = scan1[4*x + 0];
                ubyte a_g = scan1[4*x + 1];
                ubyte a_b = scan1[4*x + 2];
                ubyte a_a = scan1[4*x + 3];

                ubyte b_r = scan2[4*x + 0];
                ubyte b_g = scan2[4*x + 1];
                ubyte b_b = scan2[4*x + 2];
                ubyte b_a = scan2[4*x + 3];

                if (a_r != b_r || a_g != b_g || a_b != b_b || a_a != b_a) {
                    immutable deltaValue = delta(a_r, a_g, a_b, b_r, b_g, b_b);
                    if (deltaValue > maxDelta) {
                        scan[4*x + 0] = 255;
                        scan[4*x + 1] = 0;
                        scan[4*x + 2] = 0;
                        scan[4*x + 3] = 255;

                        diffPixelsCounter++;
                    }
                }
            }
        }
        if (diffPixelsCounter > 0) {
            diffPixelsCounts[id] = diffPixelsCounter;
        }
    }
    ulong diffPixelsCount = sum(diffPixelsCounts[]);

    return Result(diffPixelsCount == 0, diffPixelsCount, diff.refCounted);
}
