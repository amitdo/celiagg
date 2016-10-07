from nose.tools import assert_raises
import numpy as np

from pyagg import (GraphicsState, BlendMode, DrawingMode, Image, LineCap,
                   LineJoin, PixelFormat, Rect)


def test_state_properties():
    gs = GraphicsState()

    gs.anti_aliased = True
    assert gs.anti_aliased is True
    gs.anti_aliased = False
    assert gs.anti_aliased is False

    gs.drawing_mode = DrawingMode.DrawEofFill
    assert gs.drawing_mode == DrawingMode.DrawEofFill
    gs.drawing_mode = DrawingMode.DrawFillStroke
    assert gs.drawing_mode == DrawingMode.DrawFillStroke

    gs.blend_mode = BlendMode.BlendXor
    assert gs.blend_mode == BlendMode.BlendXor
    gs.blend_mode = BlendMode.BlendLighten
    assert gs.blend_mode == BlendMode.BlendLighten

    gs.image_blend_mode = BlendMode.BlendXor
    assert gs.image_blend_mode == BlendMode.BlendXor
    gs.image_blend_mode = BlendMode.BlendLighten
    assert gs.image_blend_mode == BlendMode.BlendLighten

    gs.line_cap = LineCap.CapSquare
    assert gs.line_cap == LineCap.CapSquare
    gs.line_cap = LineCap.CapRound
    assert gs.line_cap == LineCap.CapRound

    gs.line_join = LineJoin.JoinRound
    assert gs.line_join == LineJoin.JoinRound
    gs.line_join = LineJoin.JoinBevel
    assert gs.line_join == LineJoin.JoinBevel

    gs.master_alpha = 0.42
    assert gs.master_alpha == 0.42
    gs.anti_alias_gamma = 1.337
    assert gs.anti_alias_gamma == 1.337
    gs.line_width = 10.0
    assert gs.line_width == 10.0

    box = Rect(0.0, 0.0, 10.0, 20.0)
    gs.clip_box = box
    assert gs.clip_box == box
    assert not (gs.clip_box is box)

    dashes = [(1.0, 2.0), (3.0, 4.0)]
    gs.line_dash_pattern = dashes
    assert gs.line_dash_pattern == dashes
    gs.line_dash_pattern = []
    assert len(gs.line_dash_pattern) == 0

    img = Image(np.zeros((10, 10), dtype=np.uint8), PixelFormat.Gray8)
    assert gs.stencil is None
    gs.stencil = img
    assert gs.stencil is img
    gs.stencil = None
    assert gs.stencil is None

    img = Image(np.zeros((10, 10, 3), dtype=np.uint8), PixelFormat.RGB24)
    with assert_raises(ValueError):
        gs.stencil = img


def test_kwargs_initialization():
    box = Rect(0.0, 0.0, 10.0, 20.0)
    dashes = [(1.0, 2.0), (3.0, 4.0)]
    img = Image(np.zeros((10, 10), dtype=np.uint8), PixelFormat.Gray8)
    gs = GraphicsState(
        anti_aliased=True,
        drawing_mode=DrawingMode.DrawEofFill,
        blend_mode=BlendMode.BlendXor,
        image_blend_mode=BlendMode.BlendXor,
        line_cap=LineCap.CapSquare,
        line_join=LineJoin.JoinRound,
        master_alpha=0.42,
        anti_alias_gamma=1.337,
        line_width=10.0,
        clip_box=box,
        line_dash_pattern=dashes,
        stencil=img
    )

    assert gs.anti_aliased is True
    assert gs.drawing_mode == DrawingMode.DrawEofFill
    assert gs.blend_mode == BlendMode.BlendXor
    assert gs.image_blend_mode == BlendMode.BlendXor
    assert gs.line_cap == LineCap.CapSquare
    assert gs.line_join == LineJoin.JoinRound
    assert gs.master_alpha == 0.42
    assert gs.anti_alias_gamma == 1.337
    assert gs.line_width == 10.0
    assert gs.clip_box == box
    assert gs.line_dash_pattern == dashes
    assert gs.stencil is img
