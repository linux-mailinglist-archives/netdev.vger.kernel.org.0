Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536E54F0820
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 08:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352994AbiDCGpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 02:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238200AbiDCGpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 02:45:31 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06488FD25
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 23:43:35 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a6so2949705ejk.0
        for <netdev@vger.kernel.org>; Sat, 02 Apr 2022 23:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3Xx2ErVMBxvM/FsKeVuUk3St6Mlwp0omh3F7AKnqaSI=;
        b=i9rDzybQOX37P+qV8TaQQg/OWkO8nhv8kgK42pzWL139Z8Xu9iSCKQwDblvXomhQdz
         erv8P/h9REJoC4eMGW651lYjvDDBy3NA7QOPQL8DfMmtPpvkbCZ6n7//UrRniEAi29yw
         4tSlQ1bvLmKZJeBSJwKQV45geF/xfvB/Lm3lHTu/WbIlhhLZQ8DqrR+FpcUJpM2zaJZm
         LRVQ0cFP1rJPYw3si2S3se7+ZTQmjcFLpmEc4dDx+6seXPz/iiZziII8dEb84JGicwcN
         IuS8ILoduby5VIzBgGJF+E7viQ/8AwAUImqesCBKIfbnxqlXVNc4drxfJZAMlQi7wTS2
         SACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3Xx2ErVMBxvM/FsKeVuUk3St6Mlwp0omh3F7AKnqaSI=;
        b=v3lor8oitvqFbpM13O2m/QmNtLUt9NDlbOxPEmqyFksD9bXphfmg08ewuSpqfenzgo
         +ql7JSTXxz4/MUDl8kioDdKOmzyVy2jSrgblwfTfmtPX+sP4UWw0/yH6P9WTChsLkw3p
         MpZ1dWgUeVWiCZRnRj15GvqpeH0pfPr3yCsH25qzEzVwnHXJO0iMu0UgOnQ1IHAXIcWC
         Ebgm2FX8cGSbbH56gs8feCUEVJ4ooAonY3rhzveYkkJa4o3RSIDdNrrdGLzSdxOuiPxQ
         colGR18HEDEC92FKQN5aPzayneMs4tq9BKZhIJI2cfW6LxZV0C6snXYkwvMx0HltS00D
         3zew==
X-Gm-Message-State: AOAM5332Cn3i81zyrUwGl2cnEYKPLKen3uJH2kXugewxmd/DjIoW6tlH
        g9cWO12sOhqy8RsO8C0vMmnsGZ2+At4/rrQGEVI=
X-Google-Smtp-Source: ABdhPJx/3YPNiIHFwcdTaaNlKfTfaMhjgdlgvxJs/3tX27AB4qh3X5TrQZv3Z73xqSyo00fOZ3JUVsT4gKwvPn2U1js=
X-Received: by 2002:a17:907:6e06:b0:6e4:dae7:9574 with SMTP id
 sd6-20020a1709076e0600b006e4dae79574mr6451508ejc.540.1648968213486; Sat, 02
 Apr 2022 23:43:33 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Sun, 3 Apr 2022 07:43:37 +0100
Message-ID: <CAHpNFcNqkhWQ3xpSw1+MowYrVWii8FMjVOzv_DViCPSBMAHz0g@mail.gmail.com>
Subject: VecSR Compression (HDMI & DP) & X-OR DSC1.2C & Along with our
 brilliant security features in NTP Folder (Security bat & WebHSM) & Default
 JS VESA_BT sure to please all on their servers
To:     torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VecSR Compression (HDMI  & DP) & X-OR DSC1.2C & Along with our
brilliant security features in NTP Folder (Security bat & WebHSM) &
Default JS https://bit.ly/VESA_BT sure to please all on their servers

is QFT a Zero compression or low level compression version of DSC
1.2b? Maybe X-OR X=3D1 New Data & X=3D0 being not sent ? Therefore Masking
The Frame Buffer!

If not i dually submit it for inclusion in the standard along with
Vector Compression VESA Standard Display protocol 3
https://lkml.org/lkml/2022/4/2/328
https://lkml.org/lkml/2022/4/2/295

Include vector today *important* RS
https://vesa.org/vesa-display-compression-codecs/

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

*****

VecSR - Vector Standard Render

VESA Standards : Vector Graphics, Boxes, Ellipses, Curves & Fonts :
Consolas & other brilliant fonts : (c)RS

SiMD Render - Vector Graphics, Boxes, Ellipses, Curves & Fonts

OT-SVG Fonts & TT-SVG Obviously Rendered in Direct X 9+ & OpenGL 3+
Mode & Desktop Rendering modes

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

(c)Rupert S

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
