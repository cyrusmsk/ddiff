module ddiff.imgdiff;

import std.range : iota;

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
    ubyte[] image;
}

/// Diff between two images.
Result imageDiff(ref Image image1, ref Image image2, Options options) {
    static ulong diffPixelsCount = 0;
    auto maxDelta = MAX_DELTA * options.threshold * options.threshold;

    Image diff;
    diff.createNoInit(image1.width(), image1.height(), PixelType.rgba8);

    image1.copyPixelsTo(diff);

    static ulong diffPixelsCounter;
    auto lines = iota(0, diff.height());
    foreach(y; lines) {
        diffPixelsCounter = 0;
        ubyte* scan1 = cast(ubyte*) diff.scanptr(y);
        ubyte* scan2 = cast(ubyte*) image2.scanptr(y);

        foreach(x; iota(0, diff.width())) {
            ubyte a_r = scan1[4*x + 0];
            ubyte a_g = scan1[4*x + 1];
            ubyte a_b = scan1[4*x + 2];
            ubyte a_a = scan1[4*x + 3];

            ubyte b_r = scan2[4*x + 0];
            ubyte b_g = scan2[4*x + 1];
            ubyte b_b = scan2[4*x + 2];
            ubyte b_a = scan2[4*x + 3];

            if (a_r != b_r && a_g != b_g && a_b != b_b && a_a != b_a) {
                auto deltaValue = delta(a_r, a_g, a_b, b_r, b_g, b_b);
                if (deltaValue > maxDelta) {
                    scan1[4*x + 0] = 255;
                    scan1[4*x + 1] = 0;
                    scan1[4*x + 2] = 0;
                    scan1[4*x + 3] = 255;

                    diffPixelsCounter++;
                }
            }
        }
    }

    if (diffPixelsCounter > 0) {
        diffPixelsCount += diffPixelsCounter;
    }

    return Result(diffPixelsCount == 0, diffPixelsCount, diff.saveToMemory(options.imgFormat));
}
