# The MIT License (MIT)
#
# Copyright (c) 2016 WUSTL ZPLAB
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
# Authors: John Wiggins

cpdef enum LineJoin:
    JoinMiter = _enums.JoinMiter
    JoinRound = _enums.JoinRound
    JoinBevel = _enums.JoinBevel

cpdef enum LineCap:
    CapButt = _enums.CapButt
    CapSquare = _enums.CapSquare
    CapRound = _enums.CapRound

cpdef enum DrawingMode:
    DrawFill = _enums.DrawFill
    DrawEofFill = _enums.DrawEofFill
    DrawStroke = _enums.DrawStroke
    DrawFillStroke = _enums.DrawFillStroke
    DrawEofFillStroke = _enums.DrawEofFillStroke

cpdef enum BlendMode:
    BlendAlpha = _enums.BlendAlpha
    BlendClear = _enums.BlendClear
    BlendSrc = _enums.BlendSrc
    BlendDst = _enums.BlendDst
    BlendSrcOver = _enums.BlendSrcOver
    BlendDstOver = _enums.BlendDstOver
    BlendSrcIn = _enums.BlendSrcIn
    BlendDstIn = _enums.BlendDstIn
    BlendSrcOut = _enums.BlendSrcOut
    BlendDstOut = _enums.BlendDstOut
    BlendSrcAtop = _enums.BlendSrcAtop
    BlendDstAtop = _enums.BlendDstAtop
    BlendXor = _enums.BlendXor
    BlendAdd = _enums.BlendAdd
    BlendMultiply = _enums.BlendMultiply
    BlendScreen = _enums.BlendScreen
    BlendOverlay = _enums.BlendOverlay
    BlendDarken = _enums.BlendDarken
    BlendLighten = _enums.BlendLighten
    BlendColorDodge = _enums.BlendColorDodge
    BlendColorBurn = _enums.BlendColorBurn
    BlendHardLight = _enums.BlendHardLight
    BlendSoftLight = _enums.BlendSoftLight
    BlendDifference = _enums.BlendDifference
    BlendExclusion = _enums.BlendExclusion
