using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;

class Utils {

    static function round(d) {
        return (d + 0.5).toNumber();
    }

    static function momsToTime(time) {
        return Gregorian.info(time, Time.FORMAT_SHORT);
    }

    static function timeToDegs(time) {
        return Utils.round(time.hour * 15.0 + time.min / 4.0);
    }

    static function momsToDegs(moms) {
        var time = Utils.momsToTime(moms);
        return Utils.round(time.hour * 15.0 + time.min / 4.0);
    }

	static function asString(mom) {
        var gt = Gregorian.info(mom, Time.FORMAT_SHORT);
        return gt.hour + ":" + gt.min.format("%02d") + ":" + gt.sec.format("%02d");
    }
    
    static function fillQuad(dc, a, b, c, d) {
        dc.fillPolygon([a, b, c, d]);
        dc.drawLine(a[0], a[1], b[0], b[1]);
        dc.drawLine(b[0], b[1], c[0], c[1]);
        dc.drawLine(c[0], c[1], d[0], d[1]);
        dc.drawLine(d[0], d[1], a[0], a[1]);
    }
}
