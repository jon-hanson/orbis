package orbis;

import java.awt.*;
import java.awt.event.*;
import java.awt.geom.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.Arrays;
import javax.imageio.ImageIO;

import static java.awt.GraphicsEnvironment.*;

public class MainFrame extends Frame {

    public static void main(String args[]) {
        final Font[] fonts = getLocalGraphicsEnvironment().getAllFonts();
        new MainFrame(Device.fenix3());
    }

    private static final String fontName = "Eurostile Next LT Com Semibold Extended";
    //private static final String fontName = "Orbitron-Medium";

    private final Theme theme = Theme.dark();
    private boolean closing = false;

    private final int w;
    private final int h;

    private final Coord centre;
    private final Coord corner;
    private final double radius;

    private BufferedImage image;
    private Graphics2D gfx2d;
    private Insets ins;

    MainFrame(Device device) {
        super("OrbixJ");

        this.w = device.width;
        this.h = device.height;
        this.centre = new Coord((w)/2.0, (h)/2.0);
        this.corner = new Coord(w-1, h-1);
        this.radius = (Math.min(w, h) - 1.0) / 2.0;

        pack();

        addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent we) {
                closing = true;
                dispose();
            }
        });

        setResizable(false);
        ins = getInsets();
        final Dimension dim = new Dimension(w + ins.left + ins.right, h + ins.top + ins.bottom);
        setSize(dim);
        setLocationRelativeTo(null);
        setBackground(theme.backgroundColour());
        setVisible(true);

        dumpFonts();

        image = new BufferedImage(w, h, BufferedImage.TYPE_BYTE_INDEXED, device.palette.asColorModel());
        gfx2d = image.createGraphics();
        gfx2d.setBackground(theme.backgroundColour()); //new Color(0xff, 0xff, 0xff, 0));
        gfx2d.clearRect(0, 0, w, h);
        gfx2d.setRenderingHint(RenderingHints.KEY_COLOR_RENDERING, RenderingHints.VALUE_COLOR_RENDER_QUALITY);
        gfx2d.setRenderingHint(RenderingHints.KEY_DITHERING, RenderingHints.VALUE_DITHER_DISABLE);
        gfx2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        gfx2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        gfx2d.setRenderingHint(RenderingHints.KEY_STROKE_CONTROL, RenderingHints.VALUE_STROKE_PURE);
        gfx2d.setTransform(new AffineTransform(1.0/Coord.scale, 0.0, 0.0, 1.0/Coord.scale, 0.0, 0.0));
        gfx2d.setStroke(new BasicStroke((float)Coord.scale));
        gfx2d.setFont(new Font(fontName, Font.PLAIN, 12));

        //Colours.RED.set(gfx2d).drawArc(0, 0, corner.x(), corner.y(), 0, 360);

        renderTicks(gfx2d);

        repaint();

        save(theme.fileName());
    }

    private void dumpFonts() {
        Arrays.stream(GraphicsEnvironment.getLocalGraphicsEnvironment()
            .getAllFonts()
        ).forEach(font ->
            System.out.println(font.getFontName())
        );
    }
    private void renderTicks(Graphics2D gfx2d) {
        final FontMetrics fm = gfx2d.getFontMetrics();
        gfx2d.setColor(theme.tickColour());
        final double l = 4;
        final double w2 = 0.25;
        for (int h = 0; h < 24  ; ++h) {
            {
                final double deg = 90.0 + (h * 15.0);
                final double r1 = radius - 10.0;
                final double r2 = r1 - l * 2.0;
                drawLine(gfx2d, p2XY(deg - w2, r1), p2XY(deg - w2, r2));
                drawLine(gfx2d, p2XY(deg, r1), p2XY(deg, r2));
                drawLine(gfx2d, p2XY(deg + w2, r1), p2XY(deg + w2, r2));

                if (h % 2 == 0) {
                    gfx2d.setColor(theme.hourColour());

                    final String s = (String.valueOf(h) + (h >= 4 && h <= 8 ? " " : "")); //.replace('0', 'O');
                    final Rectangle2D rect = fm.getStringBounds(s, gfx2d);
                    final Coord p = p2XY(deg, r2 - l * 3.0);
                    final float dx = (float)rect.getWidth() / 2.0f;
                    final float dy = (float)rect.getHeight() / 2.0f - fm.getAscent() - 1.0f;

                    gfx2d.drawString(s, (float)p.x() - dx, (float)p.y() - dy);

                    gfx2d.setColor(theme.tickColour());
                }
            }

            for (int m = 1; m < 6; ++m) {
                final double deg = 90.0 + (h * 15.0 + m * 2.5);
                final Coord s = p2XY(deg, radius - 10.0);
                final Coord e = p2XY(deg, radius - 10.0 - l);
                drawLine(gfx2d, s, e);
            }

        }
    }

    private Graphics2D drawLine(Graphics2D gfx2d, Coord s, Coord e) {
        gfx2d.draw(new Line2D.Double(s.x(), s.y(), e.x(), e.y()));
        return gfx2d;
    }

    private Graphics2D drawQuad(Graphics2D gfx2d, Coord s, Coord e) {
        gfx2d.draw(new Line2D.Double(s.x(), s.y(), e.x(), e.y()));
        return gfx2d;
    }

    private Coord p2XY(double degs, double radius) {
        return centre.add(
            radius * Math.cos(d2r(degs)),
            radius * Math.sin(d2r(degs))
        );
    }

    private static double d2r(double degs) {
        return degs / 180.0 * Math.PI;
    }

    void save(String fileName) {
        try {
            ImageIO.write(image, "png", new File(fileName + ".png"));
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    @Override
    public void paint(Graphics gfx) {
        super.paint(gfx);
        final Graphics2D g2d = (Graphics2D)gfx;
//        g2d.setTransform(new AffineTransform(1.0/Coord.scale, 0.0, 0.0, 1.0/Coord.scale, ins.left, ins.top));
//        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
//        g2d.setRenderingHint(RenderingHints.KEY_STROKE_CONTROL, RenderingHints.VALUE_STROKE_PURE);
//        g2d.setStroke(new BasicStroke((float)Coord.scale));
//        renderTicks(g2d);
        g2d.drawImage(image, ins.left, ins.top, null);
    }
}
