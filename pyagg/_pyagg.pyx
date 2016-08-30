# The MIT License (MIT)
#
# Copyright (c) 2014 WUSTL ZPLAB
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

from libcpp cimport bool
import cython
from cython.operator cimport dereference
cimport numpy
import numpy
from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t

cimport _enums
cimport _gradient
cimport _graphics_state
cimport _ndarray_canvas
cimport _path
cimport _text
cimport _transform


cdef _get_utf8_text(text, exp_msg):
    # Ensure UTF-8 encoded text is passed to C++ code.
    if isinstance(text, unicode):
        return (<unicode>text).encode('utf8')
    else:
        raise TypeError(exp_msg)

include "enums.pxi"
include "gradient.pxi"
include "graphics_state.pxi"
include "ndarray_canvas.pxi"
include "path.pxi"
include "text.pxi"
include "transform.pxi"
