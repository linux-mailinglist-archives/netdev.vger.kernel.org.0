Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF954F7EF0
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245115AbiDGM3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241933AbiDGM3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:29:41 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA52172447
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 05:27:38 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id d7so6180631edn.11
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 05:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=VRuoAIQ8VM7Z7lkjnKl30FJLKecdPI+AAj9EpsNSn2k=;
        b=pjuzAXsmGUfimoqYqkuIDhQezqaFwxIutqB489Dv2Wm6p+bqikvsuLx0pRh5WRfKF0
         xzqz+Rxa2d6UoA9YV2hYUMqzJ3rJ3BwpR5d10EhpJI7rMd0X3yRCj9H/XCPV26VohZyT
         gXLwdemo1hExYlfRek+blr/0B9Sg02n87v+A/EtvANbahRzFqYdBVw3WLOFmLpMSh9ku
         xczB7aP7A4m4WsvgbrY8y3z7yNpHX0ZNy4F/g5zZDmop9kvZF3DJkWtf8MLEFSzyLeWt
         eKDpMnjYliQRoEEeNy0Xqzuv3TEAiYUXm3wORsCQynvBP1duaALpucL9HXfP7CSTIXLH
         tFvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=VRuoAIQ8VM7Z7lkjnKl30FJLKecdPI+AAj9EpsNSn2k=;
        b=lYhjdzHt8uwRRX4+2bKM/9JpqpnlqtF8N9G3itJHA8pVPDTZMGVD5dsZnIiTMCwN+Q
         uBequWGL/BeOkHDLJyJJC1jETqL88yQXkFft8sdILd5M6QS4In/Tw52ZMponTpvKu1FB
         e46XyA05h7nd0MK84PA+jH+Nf5ZqT8W2i/oYQYgNPLC2kSvqw9j8gvFnBtaBoTA23jPE
         uQiKk5PYc20nACPtxpaCppTZKByW0Ksr4CvifYyZxyNEmKaAZlsr3cyCyoh4XlRaQMAG
         bh6xGhOCbtgg3hf6bgfPJPblb5j6Uv9yyNWY4aW2AB+bOy2txS1apKRsJs5EcasmLzop
         IXQQ==
X-Gm-Message-State: AOAM533WbZpswG15MHvSPCX9i6b49xL5OEiY++lTS66DBbIgQdiO1mDk
        xQu0s4YOf7K+RZ68R53W0q3eX1j6cBgvsqZ8v+Q=
X-Google-Smtp-Source: ABdhPJw0Jqrrh7/d2QZPdCy+X/ZgkW51U3q/hqh4YEClrBeDkimwT6OirRgRyVtwDUG2wV87fTl/0HtTj+00K+kH6d4=
X-Received: by 2002:a05:6402:3604:b0:41c:c4e6:2988 with SMTP id
 el4-20020a056402360400b0041cc4e62988mr13852621edb.157.1649334457045; Thu, 07
 Apr 2022 05:27:37 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Thu, 7 Apr 2022 13:27:25 +0100
Message-ID: <CAHpNFcM-uqvy7kTzdNjt9ipt4XVGKC4xyWbvxqGDYsxKORSsDQ@mail.gmail.com>
Subject: Frame Buffer - Personally QFT  is a much more pleasurable experience
 than VRR at 2xFPS+ Stable FPS & X-OR Partial Frame Retention saving on compression.
To:     torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VecSR - Vector Standard Render

VESA Standards : Vector Graphics, Boxes, Ellipses, Curves & Fonts :
Consolas & other brilliant fonts : (c)RS

Vector Compression VESA Standard Display protocol 3 : RS

SiMD Render - Vector Graphics, Boxes, Ellipses, Curves & Fonts

OT-SVG Fonts & TT-SVG Obviously Rendered in Direct X 9+ & OpenGL 3+
Mode & Desktop Rendering modes

Improve Console & TV & BIOS & General Animated Render

*
Vector Compression VESA Standard Display protocol 3 +
DSC : Zero compression or low level compression version of DSC
1.2bc

Frame by Frame compression with vector prediction.

Personally QFT  is a much more pleasurable experience than VRR at 2xFPS+
Stable FPS & X-OR Partial Frame Retention saving on compression.

X-OR Frame Buffer Compression & Blank Space Compression:

X-OR X=3D1 New Data & X=3D0 being not sent,
Therefore Masking the frame buffer,

A Frame buffer needs a cleared aria; A curve or ellipsoid for example,
Draw the ellipsoid; This is the mask & can be in 3 levels:

X-OR : Draw or not Draw Aria : Blitter XOR
AND : Draw 1 Value & The other : Blitter Additive
Variable Value Resistor : Draw 1 Value +- The other : Blitter + or - Modifi=
er
*

Vector Compression VESA Standard Display protocol 3 : RS

SiMD Render - Vector Graphics, Boxes, Ellipses, Curves & Fonts
Improve Console & TV & BIOS & General Animated Render

Vector Display Standards with low relative CPU Weight
SiMD Polygon Font Method Render

Default option point scaling (the space) : Metadata Vector Fonts with
Curl mathematical vector :

16 Bit : SiMD 1 width
32 Bit : SiMD Double Width

High precision for AVX 32Bit to 256Bit width precision.

Vectoring with SiMD allows traditional CPU mastered VESA Emulation
desktops & safe mode to be super fast & displays to conform to VESA
render standards with little effort & a 1MB Table ROM.

Though the VESA & HDMI & DisplayPort standards Facilitates direct low
bandwidth transport of and transformation of 3D & 2D graphics & fonts
into directly Rendered Super High Fidelity SiMD & AVX Rendering Vector

Display Standards Vector Render : DSVR-SiMD Can and will be directly
rendered to a Surface for visual element : SfVE-Vec

As such transport of Vectors & transformation onto display (Monitor,
3D Unit, Render, TV, & Though HDMI, PCI Port & DP & RAM)

Directly resolve The total graphics pipeline into high quality output
or input & allow communication of almost infinite Floating point
values for all rendered 3D & 2D Elements on a given surface (RAM
Render Page or Surface)

In high precision that is almost unbeatable & yet consumes many levels
less RAM & Transport Protocol bandwidth,

Further more can also render Vector 3D & 2D Audio & other elements
though Vector 'Fonting' Systems, Examples exist : 3D Wave Tables,
Harmonic reproduction units for example Yamaha and Casio keyboards.

Personally QFT  is a much more pleasurable experience than VRR at 2xFPS+
Stable FPS & X-OR Partial Frame Retention saving on compression.

"QFT a Zero compression or low level compression version of DSC
1.2bc

X-OR Frame Buffer Compression & Blank Space Compression:
Vector Compression VESA Standard Display protocol 3"

"QFT transports each frame at a higher rate to decrease =E2=80=9Cdisplay
latency=E2=80=9D, which is the amount of time between a frame being ready f=
or
transport in the GPU and that frame being completely displayed. This
latency is the sum of the transport time through the source=E2=80=99s outpu=
t
circuits, the transport time across the interface, the processing of
the video data in the display, and the painting of the screen with the
new data. This overall latency affects the responsiveness of games:
how long it appears between a button is pressed to the time at which
the resultant action is observed on the screen.


While there are a lot of variables in this equation, not many are
adjustable from an HDMI specification perspective. QFT operates on the
transport portion of this equation by reducing the time it takes to
send only the active video across the cable. This results in reduced
display latency and increased responsiveness."
*

(c)Rupert S

Include vector today *important* RS
https://vesa.org/vesa-display-compression-codecs/

https://science.n-helix.com/2016/04/3d-desktop-virtualization.html

https://science.n-helix.com/2019/06/vulkan-stack.html

https://science.n-helix.com/2019/06/kernel.html

https://science.n-helix.com/2022/03/fsr-focal-length.html

https://science.n-helix.com/2018/01/integer-floats-with-remainder-theory.ht=
ml

https://bit.ly/VESA_BT
*

*Application of SiMD Polygon Font Method Render
*3D Render method with Console input DEMO : RS

3D Display access to correct display of fonts at angles in games &
apps without Utilizing 3rd Axis maths on a simple Shape polygon Vector
font or shape. (c)Rupert S

3rd dimensional access with vector fonts by a simple method:

Render text to virtual screen layer AKA a fully rendered monochrome, 2
colour or multi colour..

Bitmap/Texture,

Due to latency we have 3 frames ahead to render to bitmap DPT 3 / Dot 5

Can be higher resolution & we can sub sample with closer view priority...

We then rotate the texture on our output polygon & factor size differential=
.

The maths is simple enough to implement in games on an SSE configured
Celeron D (depending on resolution and Bilinear filter & resize

Why ? Because rotating a polygon is harder than subtracting or adding
width, Hight & direction to fully complex polygon Fonts & Polygon
lines or curves...

The maths is simple enough to implement in games on an SSE configured
Celeron D (depending on resolution and Bilinear filter & resize.

*

VecSR is really good for secondary loading of sprites & text; In these
terms very good for pre loading on for example the X86, RISC, AMIGA &
Famicon type devices,
With appropriate loading into Sprite buffers or Emulated Secondaries
(Special Animations) or Font Buffers.

Although Large TT-SVG & OT-SVG fonts load well in 8MB Ram on the Amiga
with Integer & Emulated Float (Library); Traditional BitMap fonts work
well in a Set Size & can resize well if cached!

The full process leads upto the terminal & how to optimise CON,
We can & will need to exceed capacities of any system & To improve them!

presenting: Dev-Con-VectorE=C2=B2
Fast/dev/CON 3DText & Audio Almost any CPU & GPU ''SiMD & Float/int"
Class VESA Console +

With Console in VecSR you can 3DText & Audio,

VecSR Firmware update 2022 For immediate implementation in all
operating systems & ROM's

Potential is fast & useful.

*

https://science.n-helix.com/2022/04/vecsr.html
