using Toybox.Math as Math;
using Toybox.System as Sys;
using Toybox.Time as Time;

module SunTimes {
    const PI2  = Math.PI * 2.0;
    const DEG2RAD = Math.PI / 180.0;

    const SECS_PER_DAY = Time.Gregorian.SECONDS_PER_DAY;

    const JUL_1970 = 2440588.0 - 0.5;
    const JUL_2000 = 2451545;
    const JUL_LEAPSECS = 0.0008;

    const JUL_ADJ = JUL_2000 - JUL_LEAPSECS;

    var lastJD = null;
    var lastTimes = null;

    function calculate(time, lat, lng) {
        var jd = time.value().toDouble() / SECS_PER_DAY + JUL_1970;
        if (jd == lastJD) {
            return lastTimes;
        }
        var n = Math.round(jd - JUL_ADJ);
        var JS = n - lng / PI2;
        var M = 6.24005996669 + 0.01720196999 * JS;
        var sinM = Math.sin(M);
        var C = (1.9148 * sinM + 0.02 * Math.sin(M + M) + 0.0003 * Math.sin(M * 3)) * DEG2RAD;
        var L = M + C + Math.PI + 1.79659306278;
        var JT = JS + 0.0053 * sinM - 0.0069 * Math.sin(L + L) + JUL_2000;
        var dec = Math.asin(0.39778850739 * Math.sin(L));
        var cw = (-0.0145380805 - Math.sin(lat) * Math.sin(dec)) / (Math.cos(lat) * Math.cos(dec));
        var w = Math.acos(cw) / PI2;
        var times = [julToTimeMom(JT - w), julToTimeMom(JT + w)];

        lastJD = jd;
        lastTimes = times;

    	//Sys.println("SunTimes(" + lat + ", " + lng + " -> " + Utils.asString(times[0]) + " - " + Utils.asString(times[1])); 
        return times;
    }

    function julToTimeMom(jul) {
        return new Time.Moment((jul - JUL_1970) * SECS_PER_DAY);
    }
}
