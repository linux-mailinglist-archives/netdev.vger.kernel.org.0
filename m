Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DAE4F65A7
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbiDFQim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238872AbiDFQi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:38:26 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804962F3D10
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 06:57:27 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id k23so4476093ejd.3
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 06:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=12C6tMvUOqmE7iPeN67Buox9hidIxbeU6o+nTMIlrmg=;
        b=TIHndFfPo+aaXhrleHu1XKHsvk8SmC+eKthCJ1x8k1jOU+FlmZp1HraGZe+KRNSejw
         lAdLIaFuzOEvGXFyAJm6TYPZxSDLp8r3tTzTA7hH4bWGi5bmSlmjb/JhO4m81EX/23zo
         JMC37cyMVhkPc2YolTh/ZQH4C8yQX30KAKqpvHjDMS121yd+bZ+kGjC4fw/VSDTd/Bel
         r++sz3h90Y1q3YMtz3u9vkqTtI9AnQYD9Dxw44zbHFq/3sIfbG/fosSlnR1j3w9I45Hd
         c20ZFtPU/2IMcvlxH0WaArlfD88e06eBvHl6UAsbzD3EpoCHHQmgMnUL6JnMa80b+0IK
         VdEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=12C6tMvUOqmE7iPeN67Buox9hidIxbeU6o+nTMIlrmg=;
        b=NDdQSgFAwmnFMkG+rGthDAVtnXziLt2scnU+k02ryKA+tcaU9Z1BiCDK9mDVGgQ+dx
         k0cOQnIP4mPIW6HH+xa2w2EBM3iGaqP1zgDIC0FoQxqeMDKugxc8lFJhPcR0yHiRYv1O
         3wwkMfAWXImUw4HwUWkcXGinD7pHWdkHQ+05okX2IuGU3pfrVsCOmPpSvFbzCJeJKSEN
         wAICUOtP6rTExnypT2WdAfjKpd/m+EyqrHYqXJEXcw855xkS1WN5Jk52tfrBwniNu3W6
         4p9K59CKgX8NMCQ3wzKUoxSL8zBFhKP8NdrYpYNwv/MlXkdVbQr2OTuJu8pJ0tRrLbnH
         5vHQ==
X-Gm-Message-State: AOAM530Z9Gixuro6N5RFpH0tC9iTbYpEeexqsOId69QWyjfITKIDsr10
        BbU/oOJ1e6C23is6VVaTn9W+Us5WSb8VGul0kZ4=
X-Google-Smtp-Source: ABdhPJzFnHz+H9bUAOi37zIlujICLHHCorayrVW8scWF90/ZOC3VDJeoKK7oBD1gDjScx2MY4DTEtjSy2PyuLZI+P4Y=
X-Received: by 2002:a17:907:6e06:b0:6e4:dae7:9574 with SMTP id
 sd6-20020a1709076e0600b006e4dae79574mr8718896ejc.540.1649253445762; Wed, 06
 Apr 2022 06:57:25 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Wed, 6 Apr 2022 14:57:14 +0100
Message-ID: <CAHpNFcObr9v28HTpqKS=eAKC5wV2z7k0NaVXz94ga6JN1kJ_vA@mail.gmail.com>
Subject: Display Stream Compression Support - 3D Mux , 3D Mu-X by GPU & CPU
 though SiMD & AVX 32Bit IfNotOR to a Singular planar Frame Buffer
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

https://lkml.org/lkml/2022/4/6/401

*
[PATCH v7 13/14] drm/msm: Update generated headers Vinod Koul
  [PATCH v7 07/14] drm/msm/disp/dpu1: Add support for DSC in encoder Vinod =
Koul
  [PATCH v7 09/14] drm/msm: Add missing num_dspp field documentation Vinod =
Koul
  [PATCH v7 06/14] drm/msm/disp/dpu1: Add DSC support in hw_ctl Vinod Koul
  [PATCH v7 08/14] drm/msm/dpu: don't use merge_3d if DSC merge topo
... Vinod Koul
  [PATCH v7 03/14] drm/msm/disp/dpu1: Add support for DSC Vinod Koul
  [PATCH v7 01/14] drm/msm/dsi: add support for dsc data Vinod Koul
[New] [PATCH v7 00/14] drm/msm: Add Display Stream Compression Support
Vinod Koul
*
3D Mux , 3D Mu-X by GPU & CPU though SiMD & AVX 32Bit IfNotOR to a
Single planar Frame Buffer is logical in the case of Multi Window
desktops,
A Blitter Frame Works well for X-OR.

The relevance is that a Single Frame buffer per Eye does 3D Imagery!
(Google Glass & MS & PS4 VR)

We can and will need more; For this Substance Called Flexibility we
need 2 Details:

ReDirectable DMA & Multi Frame Blitter...

By this method we can literally write every detail if we wish in
Shader, But we do not need to worry!

X-OR Blitter Recovers from Overwrite by detecting details that are new.

Simple is best but keep in mind that CPU Frame Buffer (In RAM & Cache)
& GPU Frame Buffer (in GPU) & Direct Access RAM : ReBAR to
Transparently access GPU RAM!

Allowing ALL.

****

Vector Compression VESA Standard Display protocol 3 +
DSC : Zero compression or low level compression version of DSC
1.2bc

Frame by Frame compression with vector prediction.

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

Rupert S
