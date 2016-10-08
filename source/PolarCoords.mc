using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.System as Sys;

class PolarCoords {
    const CIRCLE_DIVS = 24 * 30;
    hidden const QUART_DIVS = CIRCLE_DIVS >> 2;
    hidden const QUART_DIVS1 = QUART_DIVS - 1;
    hidden const OCT_DIVS = CIRCLE_DIVS >> 3;
    hidden const DIVS_PER_DEG = CIRCLE_DIVS / 360;

    hidden const PI2 = Math.PI * 2.0;

    //hidden const sin = new[QUART_DIVS];

    hidden const octF = [
        :oct0DivToXY,
        :oct1DivToXY,
        :oct2DivToXY,
        :oct3DivToXY,
        :oct4DivToXY,
        :oct5DivToXY,
        :oct6DivToXY,
        :oct7DivToXY
    ];

    hidden static function calcCentre(n) {
        var tmp = n >> 1;
        if (n % 2 == 0) {
            return [tmp-1, tmp];
        } else {
            return [tmp, tmp];
        }
    }

    var width;
    var height;
    var centre;
    var centreX;
    var centreY;
    var radius;

    function initialize(w, h) {
        width = w;
        height = h;

        centreX = calcCentre(w);
        centreY = calcCentre(h);
		centre = [(centreX[0] + centreX[1]) / 2.0, (centreY[0] + centreY[1]) / 2.0];

        var minDim = height > width ? width : height;
        if (minDim % 2 == 0) {
            radius = (minDim >> 1) - 1;
        } else {
            radius = minDim >> 1;
        }

//        for (var i = 0; i < QUART_DIVS; i++) {
//            var rads = divsToRad(i);
//            sin[i] = Math.sin(rads);
//        }
    }

    hidden function divsToRad(divs) {
        return divs.toDouble() / CIRCLE_DIVS * PI2;
    }

    function renderArc(dc, start, end, r) {
        var quadS = (start / 90).toNumber();
        var quadE = end == 360 ? 3 : (end / 90).toNumber();

        if (quadS == quadE) {
            renderQuadArc(dc, quadS, start, end, r);
        } else {
            renderQuadArc(dc, quadS, start, (quadS+1) * 90, r);
            quadS++;
            while (quadS < quadE) {
                renderQuadArc(dc, quadS, quadS * 90, (quadS+1) * 90, r);
                quadS++;
            }
            renderQuadArc(dc, quadS, quadE * 90, end, r);
        }

    }

    hidden function renderQuadArc(dc, quad, start, end, r) {
    	if (start == end) {
    		return;
		}
        if (quad == 0) {
            dc.drawArc(centreX[0], centreY[1], r, Gfx.ARC_CLOCKWISE, 270-start, 270-end);
        } else if (quad == 1) {
            dc.drawArc(centreX[0], centreY[0], r, Gfx.ARC_CLOCKWISE, 270-start, 270-end-1);
        } else if (quad == 2) {
            dc.drawArc(centreX[1], centreY[0], r, Gfx.ARC_CLOCKWISE, 270-start, 270-end);
        } else if (quad == 3) {
            dc.drawArc(centreX[1], centreY[1], r, Gfx.ARC_CLOCKWISE, 270-start, 270-end);
        }
    }
/*
    function divsToXY(result, divs, r) {
        var oct = (divs / OCT_DIVS).toNumber();
        var subDivs = divs % OCT_DIVS;
        self.method(octF[oct]).invoke(result, subDivs, r);
        result[0] = Utils.round(result[0]);
        result[1] = Utils.round(result[1]);
    }

    function degsToXY(result, deg, r) {
        if (deg < 0) {
            deg += 360;
        } else if (deg >= 360) {
            deg -= 360;
        }
        var divs = Utils.round(deg * DIVS_PER_DEG);
        divsToXY(result, divs, r);
    }

    function oct0DivToXY(result, subDivs, r) {
        result[0] = centreX[0] - sin[subDivs] * r;
        result[1] = centreY[1] + sin[QUART_DIVS1 - subDivs] * r;
    }

    function oct1DivToXY(result, subDivs, r) {
        result[0] = centreX[0] - sin[QUART_DIVS1 - subDivs] * r;
        result[1] = centreY[1] + sin[subDivs] * r;
    }

    function oct2DivToXY(result, subDivs, r) {
        result[0] = centreX[0] - sin[QUART_DIVS1 - subDivs] * r;
        result[1] = centreY[0] - sin[subDivs] * r;
    }

    function oct3DivToXY(result, subDivs, r) {
        result[0] = centreX[0] - sin[subDivs] * r;
        result[1] = centreY[0] - sin[QUART_DIVS1 - subDivs] * r;
    }

    function oct4DivToXY(result, subDivs, r) {
        result[0] = centreX[1] + sin[subDivs] * r;
        result[1] = centreY[0] - sin[QUART_DIVS1 - subDivs] * r;
    }

    function oct5DivToXY(result, subDivs, r) {
        result[0] = centreX[1] + sin[QUART_DIVS1 - subDivs] * r;
        result[1] = centreY[0] - sin[subDivs] * r;
    }

    function oct6DivToXY(result, subDivs, r) {
        result[0] = centreX[1] + sin[QUART_DIVS1 - subDivs] * r;
        result[1] = centreY[1] + sin[subDivs] * r;
    }

    function oct7DivToXY(result, subDivs, r) {
        result[0] = centreX[1] + sin[subDivs] * r;
        result[1] = centreY[1] + sin[QUART_DIVS1 - subDivs] * r;
    }
*/
}
