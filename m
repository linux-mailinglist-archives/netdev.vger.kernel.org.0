Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED24C4F03D0
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 16:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356127AbiDBOKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 10:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243607AbiDBOKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 10:10:50 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34A713D57
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 07:08:54 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id o10so11346832ejd.1
        for <netdev@vger.kernel.org>; Sat, 02 Apr 2022 07:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=wigNce4qvVmV3d7DkdJzc8BH1TPhQWRtN2hw97s9mNw=;
        b=bEnc5Xu/f9tfdiQvw1VrBF2c4hTnQpn+nPJhfMCv6Uo62aLg32LRqUa/V0O8NyeDs+
         oGzc7pjI8mfm90kVDggKmmPs9A+imFq05/mujxsbIUMNqlLFTOcdFzCTUa5Nvvs3+Qs7
         gIJDnFn2L4mf0tmeGZuDBfKvJmYLTf0Us2u0sWZj5IO7e/MVBT8CuNo1UUhqYLdgmhpV
         Ds6wFwqrrp0bo+/LzOcimtgax7LIiXXOzVLY/tsKcAOmX4spmFduBxYGXCuXkZWLeJvb
         aPwHSmwOHbH4oTkp96PDay3Yl3mloYzwDHcYhlKTDrox8vTJDtbXEK36R6Icw0QGb03r
         tLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=wigNce4qvVmV3d7DkdJzc8BH1TPhQWRtN2hw97s9mNw=;
        b=o7ki84D4ze4OStlLxDW/PCjHYl1p0ymPHo1LcM3AcTiV/fm8h+rDrIMgKNeHJLthbl
         sdTR7uHiNrVhJz31wfFh5Ya+4lxy6Py9nHpFlnkmEOlBV0dmgF82RcncSYUJMZjFKrXj
         wkzzmIzgQumAKKM+rQ6KwK69V6IDgwUbnqSsQ3Wu4zMNPwUVnDDGjzSw8tufF+0blr5v
         SIHbggmAlZnRKJpRqa8dLpla8FkQ1lZMRqH4IapIolm0VKzsArOHaurZpm02AZkItyZT
         YIH8Ua0EjUj3ZLk/e/lOV3MDUXJiLPwLwgv4XAnlHKEfk3+h4LzHgzlN4jpt9lQn6zEp
         MSZQ==
X-Gm-Message-State: AOAM5335YoDnMYx7aN493Ma53/L1ssQ6L427YJlMX0+QVTmu57C08qpR
        CseZmlpSzJ++jmxZ8pGgghNEomjTpb4PlXhSHcI=
X-Google-Smtp-Source: ABdhPJwbdc+fO0hy1xLt8T9rkKjD8XTsqwFzNGDzOaWO9aTsShzwErg/VRYPXMBWsyxM8Fp6u1qLzpwZ12jx9Xc4U3g=
X-Received: by 2002:a17:906:1e94:b0:6cc:4382:f12e with SMTP id
 e20-20020a1709061e9400b006cc4382f12emr3929722ejj.482.1648908533020; Sat, 02
 Apr 2022 07:08:53 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Sat, 2 Apr 2022 15:08:55 +0100
Message-ID: <CAHpNFcNSzf8OQfX0MEVyYrZxVpR23qBG-_FDqAyAfuySvtP__A@mail.gmail.com>
Subject: VecSR Wins another global Feat - The font-palette CSS property -
 font-palette and Custom @font-palette-values Palettes
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

VecSR Wins another global Feat - The font-palette CSS property -
font-palette and Custom @font-palette-values Palettes

https://science.n-helix.com/2022/04/vecsr.html

font-palette and Custom @font-palette-values Palettes

The font-palette CSS property allows selecting a palette from a color
font. In combination with the @font-palette-values at-rule, custom
palettes can be defined. This feature is useful in designs where an
icon or emoji font is used with dark or light mode, or when using
multi-colored icon fonts that use the font-palette to harmonize with
the content's color scheme.

hwb() CSS function

HWB (short for 'hue whiteness blackness') is another method of
specifying sRGB colors, similar to HSL, but often even easier for
humans to work with. The hwb() function specifies HWB values in CSS.
The function takes three arguments. The first, hue, specifies hue in
degrees (not constrained to the range [0, 360]). The next two,
whiteness and blackness, are specified as percentages.

***

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


**********

Other Features in this Release

AudioContext.outputLatency

AudioContext.outputLatency property is an estimation in seconds of the
interval between when the user agent requests a host system to play a
buffer and when the first sample in the buffer is processed by the
audio output device. For devices such as speakers or headphones that
produce an acoustic signal, 'processed by the audio output device'
refers to the time when a sample's sound is produced. This property
helps developers compensate for the latency between the input and the
output. It's also useful for synchronization of video and audio
streams.

This property is already implemented in Firefox.

font-palette and Custom @font-palette-values Palettes

The font-palette CSS property allows selecting a palette from a color
font. In combination with the @font-palette-values at-rule, custom
palettes can be defined. This feature is useful in designs where an
icon or emoji font is used with dark or light mode, or when using
multi-colored icon fonts that use the font-palette to harmonize with
the content's color scheme.

hwb() CSS function

HWB (short for 'hue whiteness blackness') is another method of
specifying sRGB colors, similar to HSL, but often even easier for
humans to work with. The hwb() function specifies HWB values in CSS.
The function takes three arguments. The first, hue, specifies hue in
degrees (not constrained to the range [0, 360]). The next two,
whiteness and blackness, are specified as percentages.

Make Popup Argument for window.open() Evaluate to 'true'

This feature follows a recent change to the spec for parsing the popup
argument for window.open(). Previously, when popup was set equal to
true, window.open() was interpreted to mean false. This is
counterintuitive and confusing. This change makes boolean features
easier to use and understand.

MediaCapabilities API for WebRTC

The MediaCapabilities API has been extended to support WebRTC streams.
The MediaCapabilities API helps websites make informed decisions on
what codec, resolution, etc. to use for video playback by indicating
whether a configuration is supported and also whether the playback is
expected to be smooth.
Without this feature, web apps need to guess about suitable
configurations. This can result in poor quality such as when an
application uses low resolution or frame rates unnecessarily, or
stuttering when the frame rate is too high.
