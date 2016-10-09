package orbis;

public class Coord {
    public static final double scale = 1;

    public final double x;
    public final double y;

    public Coord(double x, double y) {
        this.x = x;
        this.y = y;
    }

    public double x() {
        return (x * scale);
    }

    public double y() {
        return (y * scale);
    }

    Coord swapXY() {
        return new Coord(y, x);
    }

    Coord add(Coord rhs) {
        return new Coord(x + rhs.x, y + rhs.y);
    }

    Coord add(double x, double y) {
        return new Coord(this.x + x, this.y + y);
    }

    Coord sub(Coord rhs) {
        return new Coord(x - rhs.x, y - rhs.y);
    }

    Coord sub(double x, double y) {
        return new Coord(this.x - x, this.y - y);
    }

    @Override
    public String toString() {
        return "<" + x + ", " + y + '>';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Coord coord = (Coord) o;

        if (Double.compare(coord.x, x) != 0) return false;
        return Double.compare(coord.y, y) == 0;

    }

    @Override
    public int hashCode() {
        int result;
        long temp;
        temp = Double.doubleToLongBits(x);
        result = (int) (temp ^ (temp >>> 32));
        temp = Double.doubleToLongBits(y);
        result = 31 * result + (int) (temp ^ (temp >>> 32));
        return result;
    }
}
