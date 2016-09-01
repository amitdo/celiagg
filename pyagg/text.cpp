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

#include "text.h"
#include "glyph_iter.h"

Font::Font(char const* fontName, double const height, bool const bold,
           bool const italic, FontCacheType const ch)
: m_cacheType(ch),
#ifdef _USE_FREETYPE
  m_fontEngine(),
#else
  m_fontDC(::GetDC(0)),
  m_fontEngine(m_fontDC),
#endif
  m_fontCacheManager(m_fontEngine)
{
#ifdef _USE_FREETYPE
    m_fontEngine.load_font(fontName,
                           0,
                           (ch == VectorFontCache) ?
                                agg::glyph_ren_outline :
                                agg::glyph_ren_agg_gray8);
    m_fontEngine.hinting(true);
    m_fontEngine.height(height);
#else
    m_fontEngine.hinting(true);
    m_fontEngine.create_font(fontName,
                             (ch == VectorFontCache) ?
                                agg::glyph_ren_outline :
                                agg::glyph_ren_agg_gray8,
                              height,
                              0.0,
                              bold ? 700 : 400,
                              italic);
#endif
    m_fontEngine.flip_y(true);
}

Font::FontCacheManager&
Font::cache()
{
    return m_fontCacheManager;
}

Font::FontCacheType
Font::cacheType() const
{
    return m_cacheType;
}

double
Font::height() const
{
    return m_fontEngine.height();
}

bool
Font::hinting() const
{
    return m_fontEngine.hinting();
}

void
Font::hinting(bool const hint)
{
    m_fontEngine.hinting(hint);
}

double
Font::stringWidth(char const* str)
{
    GlyphIterator iterator(str, *this);
    while (iterator.step() != GlyphIterator::k_StepActionEnd) {}
    return iterator.xOffset();
}

void
Font::transform(const agg::trans_affine& transform)
{
    m_fontEngine.transform(transform);
}
