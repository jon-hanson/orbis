package orbis;

import java.awt.*;
import java.awt.image.*;
import java.util.List;

public class Palette {

    public final List<Color> colours;
    public final int transIndex;

    public Palette(List<Color> colours, int transIndex) {
        this.colours = colours;
        this.transIndex = transIndex;
    }

    public IndexColorModel asColorModel() {
        final int n = colours.size();
        final byte[] r = new byte[n];
        final byte[] g = new byte[n];
        final byte[] b = new byte[n];
        for (int i = 0; i < n; ++i) {
            final Color c = colours.get(i);
            r[i] = (byte)c.getRed();
            g[i] = (byte)c.getGreen();
            b[i] = (byte)c.getBlue();
        }

        return new IndexColorModel(8, n, r, g, b); //, transIndex);
    }
}
