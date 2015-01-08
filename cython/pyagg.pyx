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
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
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
cimport numpy
import numpy
from libc.stdint cimport (uint8_t, uint16_t)
cimport _pyagg

cdef class _ndarray_canvas_base_uint8:
    cdef uint8_t[:,:,::1] py_image
    cdef _pyagg.ndarray_canvas_base[uint8_t]* _this
    cdef uint8_t[::1] default_color

    cdef void base_init(self, uint8_t[:,:,::1] image, default_color):
        if image is None:
            raise ValueError('image argument must not be None.')
        if image.shape[2] != len(default_color):
            raise ValueError('image argument must be {0} channel (ie, must be MxNx{0}).'.format(len(default_color)))
        # In order to ensure that our backing memory is not deallocated from underneath us, we retain a
        # reference to the memory view supplied to the constructor (image) as self.py_image, to be kept in
        # lock step with ndarray_canvas<>'s reference to that memory and destroyed when that reference
        # is lost.
        self.py_image = image
        self.default_color = numpy.asarray(default_color, dtype=numpy.uint8, order='c')

    def __dealloc__(self):
        del self._this

    @property
    def channel_count(self):
        return self._this.channel_count()

    @property
    def width(self):
        return self._this.width()

    @property
    def height(self):
        return self._this.height()

    @property
    def image(self):
        # User is not likely to be concerned with the details of the cython memory view around array or buffer
        # supplied to the constructor or attach, but instead expects the original array or buffer (which is why
        # self.py_image.base is returned rather than self.py_image).
        return self.py_image.base

    cdef uint8_t[::1] get_color(self, c, n):
        cdef uint8_t[::1] c_npy
        if c is None:
            c_npy = self.default_color
        else:
            c_npy = numpy.asarray(c, dtype=numpy.uint8, order='c')
            if c_npy.ndim > 1:
                raise ValueError('{} argument must be a flat iterable.'.format(n))
            if c_npy.shape[0] != self._this.channel_count():
                raise ValueError('{} argument must contain {} element(s).'.format(self._this.channel_count()))
        return c_npy

    def draw_line(self, x0, y0, x1, y1, w=1, c=None, aa=True):
        """draw_line(self, x0, y0, x1, y1, w=1, c=(255,...), aa=True):
        x0...y1: start and endpoint coordinates; floating point values
        w: width; floating point value
        c: iterable of color components; components are 8-bit unsigned integers in the range [0,255]
        aa: if True, rendering is anti-aliased"""
        cdef uint8_t[::1] c_npy = self.get_color(c, 'line color')
        self._this.draw_line(x0, y0, x1, y1, w, &c_npy[0], aa)

    def draw_polygon(self, points,
                     outline=True, outline_w=1,
                     outline_c=None,
                     fill=False,
                     fill_c=None,
                     aa=True):
        """draw_polygon(self, points, outline=True, outline_w=1, outline_c=None, fill=False, fill_c=None, aa=True):
        points: iterable of x,y floating point coordinate pairs
        outline: if True, outline is drawn
        outline_w: outline width; floating point value
        outline_c: outline color, an iterable of color components; components are 8-bit unsigned integers in the range [0,255]
        fill: if True, polygon is filled
        fill_c: polygon fill color
        aa: if True, rendering is anti-aliased"""
        cdef uint8_t[::1] outline_c_npy = self.get_color(outline_c, 'outline color')
        cdef uint8_t[::1] fill_c_npy = self.get_color(fill_c, 'fill color')
        cdef double[:,::1] points_npy = numpy.asarray(points, dtype=numpy.float64, order='c')
        if points_npy.shape[1] != 2:
            raise ValueError('Points argument must be an iterable of (x, y) pairs.')
        self._this.draw_polygon(&points_npy[0][0], points_npy.shape[0],
                                outline, outline_w, &outline_c_npy[0],
                                fill, &fill_c_npy[0],
                                aa)

cdef class ndarray_canvas_rgb24(_ndarray_canvas_base_uint8):
    """ndarray_canvas_rgb24 provides AGG (Anti-Grain Geometry) drawing routines that render to the numpy
    array passed as ndarray_canvas_rgb24's constructor argument.  Because this array is modified in place,
    it must be of type numpy.uint8, must be C-contiguous, and must be MxNx3 (3 channels: red, green, blue)."""
    def __cinit__(self, uint8_t[:,:,::1] image):
        self.base_init(image, (255,)*3)
        self._this = <_pyagg.ndarray_canvas_base[uint8_t]*> new _pyagg.ndarray_canvas[_pyagg.pixfmt_rgb24, uint8_t](&image[0][0][0], image.shape[1], image.shape[0], image.strides[0], 3)

cdef class ndarray_canvas_rgba32(_ndarray_canvas_base_uint8):
    """ndarray_canvas_rgba32 provides AGG (Anti-Grain Geometry) drawing routines that render to the numpy
    array passed as ndarray_canvas_rgba32's constructor argument.  Because this array is modified in place,
    it must be of type numpy.uint8, must be C-contiguous, and must be MxNx4 (4 channels: red, green, blue,
    and alpha)."""
    def __cinit__(self, uint8_t[:,:,::1] image):
        self.base_init(image, (255,)*4)
        self._this = <_pyagg.ndarray_canvas_base[uint8_t]*> new _pyagg.ndarray_canvas[_pyagg.pixfmt_rgba32, uint8_t](&image[0][0][0], image.shape[1], image.shape[0], image.strides[0], 4)

cdef class ndarray_canvas_ga16(_ndarray_canvas_base_uint8):
    """ndarray_canvas_ga16 provides AGG (Anti-Grain Geometry) drawing routines that render to the numpy
    array passed as ndarray_canvas_ga16's constructor argument.  Because this array is modified in place,
    it must be of type numpy.uint8, must be C-contiguous, and must be MxNx2 (2 channels: intensity and
    alpha)."""
    def __cinit__(self, uint8_t[:,:,::1] image):
        self.base_init(image, (255,)*2)
        self._this = <_pyagg.ndarray_canvas_base[uint8_t]*> new _pyagg.ndarray_canvas[_pyagg.pixfmt_gray8, uint8_t](&image[0][0][0], image.shape[1], image.shape[0], image.strides[0], 2)

# TODO: make the 16 bit integer per channel stuff commented out below work (the problem may just be that AGG wants
# buffers to always be unsigned chars, which we could work around with a typecast).
# 
# Ambitious TODO: Add floating point pixel formats, renderers, and cython interface
#
#cdef class _ndarray_canvas_base_uint16:
#    cdef uint16_t[:,:,::1] py_image
#    cdef _pyagg.ndarray_canvas_base[uint16_t]* _this
#    cdef uint16_t[::1] default_color
#
#    cdef void base_init(self, uint16_t[:,:,::1] image, channel_count, default_color):
#        if image is None:
#            raise ValueError('image argument must not be None.')
#        if image.shape[2] != channel_count:
#            raise ValueError('image argument must be {0} channel (ie, must be MxNx{0}).'.format(channel_count))
#        # In order to ensure that our backing memory is not deallocated from underneath us, we retain a
#        # reference to the memory view supplied to the constructor (image) as self.py_image, to be kept in
#        # lock step with ndarray_canvas<>'s reference to that memory and destroyed when that reference
#        # is lost.
#        self.py_image = image
#        self.default_color = numpy.asarray(default_color, dtype=numpy.uint16, order='c')
#
#    def __dealloc__(self):
#        del self._this
#
#    @property
#    def channel_count(self):
#        return self._this.channel_count()
#
#    @property
#    def width(self):
#        return self._this.width()
#
#    @property
#    def height(self):
#        return self._this.height()
#
#    @property
#    def image(self):
#        # User is not likely to be concerned with the details of the cython memory view around array or buffer
#        # supplied to the constructor or attach, but instead expects the original array or buffer (which is why
#        # self.py_image.base is returned rather than self.py_image).
#        return self.py_image.base
#
#    cdef uint16_t[::1] get_color(self, c, n):
#        cdef uint16_t[::1] c_npy
#        if c is None:
#            c_npy = self.default_color
#        else:
#            c_npy = numpy.asarray(c, dtype=numpy.uint16, order='c')
#            if c_npy.ndim > 1:
#                raise ValueError('{} argument must be a flat iterable.'.format(n))
#            if c_npy.shape[0] != self._this.channel_count():
#                raise ValueError('{} argument must contain {} element(s).'.format(self._this.channel_count()))
#        return c_npy
#
#    def draw_line(self, x0, y0, x1, y1, w=1, c=None, aa=True):
#        """draw_line(self, x0, y0, x1, y1, w=1, c=(255,...), aa=True):
#        x0...y1: start and endpoint coordinates; floating point values
#        w: width; floating point value
#        c: iterable of color components; components are 8-bit unsigned integers in the range [0,255]
#        aa: if True, rendering is anti-aliased"""
#        cdef uint16_t[::1] c_npy = self.get_color(c, 'line color')
#        self._this.draw_line(x0, y0, x1, y1, w, &c_npy[0], aa)
#
#    def draw_polygon(self, points,
#                     outline=True, outline_w=1,
#                     outline_c=None,
#                     fill=False,
#                     fill_c=None,
#                     aa=True):
#        """draw_polygon(self, points, outline=True, outline_w=1, outline_c=None, fill=False, fill_c=None, aa=True):
#        points: iterable of x,y floating point coordinate pairs
#        outline: if True, outline is drawn
#        outline_w: outline width; floating point value
#        outline_c: outline color, an iterable of color components; components are 8-bit unsigned integers in the range [0,255]
#        fill: if True, polygon is filled
#        fill_c: polygon fill color
#        aa: if True, rendering is anti-aliased"""
#        cdef uint16_t[::1] outline_c_npy = self.get_color(outline_c, 'outline color')
#        cdef uint16_t[::1] fill_c_npy = self.get_color(fill_c, 'fill color')
#        cdef double[:,::1] points_npy = numpy.asarray(points, dtype=numpy.float64, order='c')
#        if points_npy.shape[1] != 2:
#            raise ValueError('Points argument must be an iterable of (x, y) pairs.')
#        self._this.draw_polygon(&points_npy[0][0], points_npy.shape[0],
#                                outline, outline_w, &outline_c_npy[0],
#                                fill, &fill_c_npy[0],
#                                aa)

#cdef class ndarray_canvas_rgb48(_ndarray_canvas_base_uint16):
#    """ndarray_canvas_rgb48 provides AGG (Anti-Grain Geometry) drawing routines that render to the numpy
#    array passed as ndarray_canvas_rgb48's constructor argument.  Because this array is modified in place,
#    it must be of type numpy.uint16, must be C-contiguous, and must be MxNx3 (3 channels: red, green, blue)."""
#    def __cinit__(self, uint16_t[:,:,::1] image):
#        self.base_init(image, 3, (65535,)*3)
#        self._this = <_pyagg.ndarray_canvas_base[uint16_t]*> new _pyagg.ndarray_canvas[_pyagg.pixfmt_rgb48, uint16_t](&image[0][0][0], image.shape[1], image.shape[0], image.strides[0], 3)

#       cdef class ndarray_canvas_rgba64(_ndarray_canvas_base_uint16):
#           """ndarray_canvas_rgba64 provides AGG (Anti-Grain Geometry) drawing routines that render to the numpy
#           array passed as ndarray_canvas_rgba32's constructor argument.  Because this array is modified in place,
#           it must be of type numpy.uint16, must be C-contiguous, and must be MxNx4 (4 channels: red, green, blue,
#           and alpha)."""
#           def __cinit__(self, uint16_t[:,:,::1] image):
#               '''hello worlddd'''
#               self.base_init(image, 4, (65535,)*4)
#               self._this = <_pyagg.ndarray_canvas_base[uint16_t]*> new _pyagg.ndarray_canvas[_pyagg.pixfmt_rgba64, uint16_t](&image[0][0][0], image.shape[1], image.shape[0], image.strides[0], 4)
#
#       cdef class ndarray_canvas_ga32(_ndarray_canvas_base_uint16):
#           """ndarray_canvas_ga16 provides AGG (Anti-Grain Geometry) drawing routines that render to the numpy
#           array passed as ndarray_canvas_ga16's constructor argument.  Because this array is modified in place,
#           it must be of type numpy.uint16, must be C-contiguous, and must be MxNx2 (2 channels: intensity and
#           alpha)."""
#           def __cinit__(self, uint16_t[:,:,::1] image):
#               self.base_init(image, 2, (65535,)*2)
#               self._this = <_pyagg.ndarray_canvas_base[uint16_t]*> new _pyagg.ndarray_canvas[_pyagg.pixfmt_gray16, uint16_t](&image[0][0][0], image.shape[1], image.shape[0], image.strides[0], 2)