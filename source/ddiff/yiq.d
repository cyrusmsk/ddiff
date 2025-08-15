module ddiff.yiq;

enum MAX_DELTA = 35_215.0;

double rgb2y(ubyte r, ubyte g, ubyte b) {
	return cast(double)r*0.29889531 + cast(double)g*0.58662247 + cast(double)b*0.11448223;
}

double rgb2i(ubyte r, ubyte g, ubyte b) {
	return cast(double)r*0.59597799 - cast(double)g*0.27417610 - cast(double)b*0.32180189;
}

double rgb2q(ubyte r, ubyte g, ubyte b) {
	return cast(double)r*0.21147017 - cast(double)g*0.52261711 + cast(double)b*0.31114694;
}

double delta(T)(T a_r, T a_g, T a_b, T b_r, T b_g, T b_b) {
    double y = (rgb2y(a_r, a_g, a_b) - rgb2y(b_r, b_g, b_b))^^2;
    double i = (rgb2i(a_r, a_g, a_b) - rgb2i(b_r, b_g, b_b))^^2;
    double q = (rgb2q(a_r, a_g, a_b) - rgb2q(b_r, b_g, b_b))^^2;

    return 0.5053 * y + 0.299 * i + 0.1957 * q;
}
