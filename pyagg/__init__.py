# The MIT License (MIT)
#
# Copyright (c) 2014-2016 WUSTL ZPLAB
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Authors: Erik Hvatum <ice.rikh@gmail.com>
#          John Wiggins <john.wiggins@xfel.eu>

from ._pyagg import (
    Agg2D, BlendMode, Color, Direction, DrawPathFlag, FontCacheType,
    GraphicsState, Image, ImageFilter, ImageResample, LineCap, LineJoin,
    Rect, TextAlignment, Transform, ViewportOption
)

from ._pyagg import (hist_min_max_float32, hist_min_max_uint12,
                     hist_min_max_uint16, hist_min_max_uint8)

from ._pyagg import (ndarray_canvas_g8, ndarray_canvas_ga16,
                     ndarray_canvas_rgb24, ndarray_canvas_rgba32)
