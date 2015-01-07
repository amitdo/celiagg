// The MIT License (MIT)
// 
// Copyright (c) 2014 WUSTL ZPLAB
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
// Authors: Erik Hvatum <ice.rikh@gmail.com> 

#pragma once

#include "agg_conv_contour.h"
#include "agg_conv_stroke.h"
#include "agg_path_storage.h"
#include "agg_pixfmt_gray.h"
#include "agg_pixfmt_rgb.h"
#include "agg_pixfmt_rgba.h"
#include "agg_rasterizer_scanline_aa.h"
#include "agg_renderer_base.h"
#include "agg_renderer_scanline.h"
#include "agg_rendering_buffer.h"
#include "agg_scanline_p.h"
#include <cstdint>

template<typename pixfmt_T>
typename pixfmt_T::color_type color_from_channel_array(const typename pixfmt_T::value_type* c);

template<>
agg::pixfmt_rgba32::color_type color_from_channel_array<agg::pixfmt_rgba32>(const std::uint8_t* c);

template<>
agg::pixfmt_rgb24::color_type color_from_channel_array<agg::pixfmt_rgb24>(const std::uint8_t* c);

template<typename pixfmt_T>
class ndarray_canvas
{
public:
    ndarray_canvas() = delete;
    ndarray_canvas(typename pixfmt_T::value_type* buf, const unsigned& width, const unsigned& height, const int& stride);
    unsigned width() const;
    unsigned height() const;

    void draw_line(const double& x0, const double& y0,
                   const double& x1, const double& y1,
                   const double& w,
                   const typename pixfmt_T::value_type* c,
                   const bool& aa);
    void draw_polygon(const double* points, const size_t& point_count,
                      const bool& outline, const double& outline_w, const typename pixfmt_T::value_type* outline_c,
                      const bool& fill, const typename pixfmt_T::value_type* fill_c,
                      const bool& aa);

protected:
    typedef agg::renderer_base<pixfmt_T> rendererbase_t;
    typedef agg::renderer_scanline_aa_solid<rendererbase_t> renderer_t;

    agg::rendering_buffer m_renbuf;
    pixfmt_T m_pixfmt;
    rendererbase_t m_rendererbase;
    renderer_t m_renderer;

    agg::rasterizer_scanline_aa<> m_rasterizer;
    agg::scanline_p8 m_scanline;

    inline void set_aa(const bool& aa);
};

#include "ndarray_canvas.hxx"

