// The MIT License (MIT)
//
// Copyright (c) 2016 WUSTL ZPLAB
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// Authors: John Wiggins

#ifndef PYAGG_GRAPHICS_STATE_H
#define PYAGG_GRAPHICS_STATE_H

#include <vector>
#include <agg_basics.h>
#include <agg_math_stroke.h>
#include <agg_pixfmt_rgba.h>

#include "image.h"

class GraphicsState
{
public:
    typedef agg::rect_d Rect;
    typedef std::vector<double> DashPattern;

    enum InnerJoin
    {
        InnerBevel = agg::inner_bevel,
        InnerMiter = agg::inner_miter,
        InnerJag = agg::inner_jag,
        InnerRound = agg::inner_round
    };

    enum LineJoin
    {
        JoinMiter = agg::miter_join,
        JoinRound = agg::round_join,
        JoinBevel = agg::bevel_join
    };

    enum LineCap
    {
        CapButt   = agg::butt_cap,
        CapSquare = agg::square_cap,
        CapRound  = agg::round_cap
    };

    enum DrawingMode
    {
        // Bit 0: fill, Bit 1: stroke, Bit 2: EO flag
        DrawInvisible = 0x0000,
        DrawFill = 0x0001,
        DrawStroke = 0x0002,
        DrawEofFill = 0x0004 | DrawFill,
        DrawFillStroke = DrawFill | DrawStroke,
        DrawEofFillStroke = DrawEofFill | DrawStroke
    };

    enum TextDrawingMode
    {
        // Bit 0: fill, Bit 1: stroke, Bit 2: clip
        TextDrawInvisible = 0x0000,
        TextDrawFill = 0x0001,
        TextDrawStroke = 0x0002,
        TextDrawClip = 0x0004,
        TextDrawFillStroke = TextDrawFill | TextDrawStroke,
        TextDrawFillClip = TextDrawFill | TextDrawClip,
        TextDrawStrokeClip = TextDrawStroke | TextDrawClip,
        TextDrawFillStrokeClip = TextDrawFill | TextDrawStroke | TextDrawClip,
    };

    enum BlendMode
    {
        BlendAlpha      = agg::end_of_comp_op_e,
        BlendClear      = agg::comp_op_clear,
        BlendSrc        = agg::comp_op_src,
        BlendDst        = agg::comp_op_dst,
        BlendSrcOver    = agg::comp_op_src_over,
        BlendDstOver    = agg::comp_op_dst_over,
        BlendSrcIn      = agg::comp_op_src_in,
        BlendDstIn      = agg::comp_op_dst_in,
        BlendSrcOut     = agg::comp_op_src_out,
        BlendDstOut     = agg::comp_op_dst_out,
        BlendSrcAtop    = agg::comp_op_src_atop,
        BlendDstAtop    = agg::comp_op_dst_atop,
        BlendXor        = agg::comp_op_xor,
        BlendAdd        = agg::comp_op_plus,
        BlendMultiply   = agg::comp_op_multiply,
        BlendScreen     = agg::comp_op_screen,
        BlendOverlay    = agg::comp_op_overlay,
        BlendDarken     = agg::comp_op_darken,
        BlendLighten    = agg::comp_op_lighten,
        BlendColorDodge = agg::comp_op_color_dodge,
        BlendColorBurn  = agg::comp_op_color_burn,
        BlendHardLight  = agg::comp_op_hard_light,
        BlendSoftLight  = agg::comp_op_soft_light,
        BlendDifference = agg::comp_op_difference,
        BlendExclusion  = agg::comp_op_exclusion,
    };

    GraphicsState() :
        m_clipBox(0, 0, 0, 0),
        m_stencil(NULL),
        m_drawingMode(DrawFillStroke),
        m_textDrawingMode(TextDrawFill),
        m_blendMode(BlendAlpha),
        m_imageBlendMode(BlendDst),
        m_masterAlpha(1.0),
        m_antiAliasGamma(1.0),
        m_lineDashPhase(0.0),
        m_miterLimit(1.0),
        m_innerMiterLimit(1.0),
        m_lineWidth(1.0),
        m_lineCap(CapSquare),
        m_lineJoin(JoinMiter),
        m_innerJoin(InnerMiter),
        m_antiAliased(true)
        {}

    void antiAliased(bool aa) { m_antiAliased = aa; }
    bool antiAliased() const { return m_antiAliased; }

    void clipBox(Rect r) { m_clipBox = r; }
    void clipBox(double x1, double y1, double x2, double y2) { clipBox(Rect(x1, y1, x2, y2)); }
    Rect clipBox() const { return m_clipBox; }

    void drawingMode(DrawingMode m) { m_drawingMode = m; }
    DrawingMode drawingMode() const { return m_drawingMode; }

    void textDrawingMode(TextDrawingMode tm) { m_textDrawingMode = tm; }
    TextDrawingMode textDrawingMode() const { return m_textDrawingMode; }

    void blendMode(BlendMode m) { m_blendMode = m; }
    BlendMode blendMode() const { return m_blendMode; }

    void imageBlendMode(BlendMode m) { m_imageBlendMode = m; }
    BlendMode imageBlendMode() const { return m_imageBlendMode; }

    void masterAlpha(double a) { m_masterAlpha = a; }
    double masterAlpha() const { return m_masterAlpha; }

    void antiAliasGamma(double g) { m_antiAliasGamma = g; }
    double antiAliasGamma() const { return m_antiAliasGamma; }

    void lineWidth(double w) { m_lineWidth = w; }
    double lineWidth() const { return m_lineWidth; }

    void lineCap(LineCap cap) { m_lineCap = cap; }
    LineCap lineCap() const { return m_lineCap; }

    void lineJoin(LineJoin join) { m_lineJoin = join; }
    LineJoin lineJoin() const { return m_lineJoin; }

    void innerJoin(InnerJoin join) { m_innerJoin = join; }
    InnerJoin innerJoin() const { return m_innerJoin; }

    void miterLimit(double limit) { m_miterLimit = limit; }
    double miterLimit() const { return m_miterLimit; }

    void innerMiterLimit(double limit) { m_innerMiterLimit = limit; }
    double innerMiterLimit() const { return m_innerMiterLimit; }

    void lineDashPattern(const double *dashes, size_t count)
    {
        m_dashes.clear();
        m_dashes.reserve(count * 2);
        for (size_t i=0; i < count; ++i)
        {
            m_dashes.push_back(dashes[i*2]);
            m_dashes.push_back(dashes[i*2 + 1]);
        }
    }
    const DashPattern& lineDashPattern() const { return m_dashes; }

    void lineDashPhase(const double phase) { m_lineDashPhase = phase; }
    double lineDashPhase() const { return m_lineDashPhase; }

    void stencil(const Image* image) { m_stencil = image; }
    const Image* stencil() const { return m_stencil; }

private:
    Rect            m_clipBox;
    DashPattern     m_dashes;
    const Image*    m_stencil;
    DrawingMode     m_drawingMode;
    TextDrawingMode m_textDrawingMode;
    BlendMode       m_blendMode;
    BlendMode       m_imageBlendMode;
    double          m_masterAlpha;
    double          m_antiAliasGamma;
    double          m_lineDashPhase;
    double          m_miterLimit;
    double          m_innerMiterLimit;
    double          m_lineWidth;
    LineCap         m_lineCap;
    LineJoin        m_lineJoin;
    InnerJoin       m_innerJoin;
    bool            m_antiAliased;
};

#endif // PYAGG_GRAPHICS_STATE_H
