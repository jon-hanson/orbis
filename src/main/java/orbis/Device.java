package orbis;

import java.awt.*;
import java.util.*;
import java.util.List;
import java.util.stream.Collectors;

public class Device {
    public static class Fenix3 extends Device {
        public enum Colours {
            TRANSPARENT(Color.WHITE),
            BLACK(Color.BLACK),
            WHITE(Color.WHITE),
            LT_GRAY(new Color(0xAA, 0xAA, 0xAA)),
            DK_GRAY(new Color(0x55, 0x55, 0x55)),
            RED(Color.RED),
            GREEN(Color.GREEN),
            BLUE(Color.BLUE),
            DK_RED(new Color(0xAA, 0, 0)),
            DK_GREEN(new Color(0, 0xAA, 0)),
            DK_BLUE(new Color(0, 0, 0xFF)),
            ORANGE(new Color(0xFF, 0x55, 0)),
            YELLOW(new Color(0xFF, 0xAA, 0)),
            PURPLE(new Color(0x55, 0, 0xAA)),
            PINK(new Color(0xFF, 0, 0xFF));

            public final Color rgb;

            Colours(Color rgb) {
                this.rgb = rgb;
            }
        }

        private static List<Color> colours() {
            return Arrays.stream(Colours.values())
                .map(c -> c.rgb)
                .collect(Collectors.toList());
        }

        public Fenix3() {
            super(colours(), Colours.TRANSPARENT.ordinal(), 218, 218);
        }
    }

    public static Device fenix3() {
        return new Fenix3();
    }

    public final Palette palette;
    public final int width;
    public final int height;

    public Device(Palette palette, int width, int height) {
        this.palette = palette;
        this.width = width;
        this.height = height;
    }

    public Device(List<Color> colours, int transIndex, int width, int height) {
        this(new Palette(colours, transIndex), width, height);
    }
}
