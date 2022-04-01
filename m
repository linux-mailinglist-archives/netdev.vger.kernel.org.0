Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E6E4EE841
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 08:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245435AbiDAGgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 02:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243444AbiDAGgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 02:36:21 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E7C1544AD
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 23:34:31 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c62so1785970edf.5
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 23:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=VQ9dInbN1MIbDpNZ3yhXf78kn1bDUy2UR64X9mj+xE8=;
        b=KjvLVqIt1cJBJcaGY0wPZRu5D/ym4w/vcqDpPPQ1QuGVqxsjNExImrzLzTKOgbF3nT
         GLxfzNhoAlQAAU920jo/RtVCvPrF3eiHVgWkqAsI4zVu2ZwgjN74/+plZGQ8DIVoZoXH
         eRJ/pVXsupKEZB+nsA7YqjO1w+W1NYA9Teq1tNfODfOFwd03Zp/RU2cbKB8zwC7jJ5/F
         TOMdOdOdCVDPC3vBudLhq/ok/sHmNbJW+RyUeUU+HQkZfsbL3Sg0F556O3PxZISBTzwx
         kPM0T4HGeoKTuMgulqt9z4zvl8urEnBQHgsOxpENCKYL7euXEtPfKdPpwCR40Rq36et2
         HJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VQ9dInbN1MIbDpNZ3yhXf78kn1bDUy2UR64X9mj+xE8=;
        b=mUGyu9QKSgFTK//SLOvj+EplIjuha0exTLyEmHoKFCNmacFw2VFVggEJVA+rxLgaOk
         aTXIhwZlbK9U+LUj81fk8HlBHnlV7IDOhGIoxVpWRkxBG+PxGFFP87GVroPa1yTEzG+h
         thMGIgBO5bSe1g+GrSkyKc66pBT1e6gMlkEc/iFmAjiCvOXbyMmXVqPDHMfgDzlyJHCX
         djYiGmCS0RsjEj5P5IlNemkVofS/iu2F2ZWGeu52kZ8pxltaBTq09tMEoSIt0Oa/ENUr
         7lGJngaS7zHYFxDsPjCFIBWp6c4utuklOEATVltRnpYAv3+p9Deh36ZnyftD2ZhvsFfZ
         KsWw==
X-Gm-Message-State: AOAM533CVM/Km6y+gEnJ1xAxSyOWNdlUsl6PRN185toFI3oSsukEMJ5/
        PZkmVHIhcBqR0NuFMytLZHApMypOZhLTBzTXX0U=
X-Google-Smtp-Source: ABdhPJxe/nXEOdSnbLjj9SQqwGpdB7DLMEPTtY1e/RCzyO7/w2isO7hubMGdTWKrBPttE9SLQOvzU8uZChoZBxKeCdE=
X-Received: by 2002:a50:99cd:0:b0:418:d6c2:2405 with SMTP id
 n13-20020a5099cd000000b00418d6c22405mr19764333edb.342.1648794869607; Thu, 31
 Mar 2022 23:34:29 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Fri, 1 Apr 2022 07:34:28 +0100
Message-ID: <CAHpNFcOJJPTSnhKCyAk-B8hSvoe4hPoC2rz0cTDqNXMKPh1L0g@mail.gmail.com>
Subject: VecSR - Vector Standard Render VESA Standards : Vector Graphics,
 Boxes, Ellipses, Curves & Fonts : Consolas & other brilliant fonts
To:     torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

https://science.n-helix.com/2016/04/3d-desktop-virtualization.html

https://science.n-helix.com/2019/06/vulkan-stack.html

https://science.n-helix.com/2019/06/kernel.html

https://science.n-helix.com/2022/03/fsr-focal-length.html

https://science.n-helix.com/2018/01/integer-floats-with-remainder-theory.html

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

We then rotate the texture on our output polygon & factor size differential.

The maths is simple enough to implement in games on an SSE configured
Celeron D (depending on resolution and Bilinear filter & resize

Why ? Because rotating a polygon is harder than subtracting or adding
width, Hight & direction to fully complex polygon Fonts & Polygon
lines or curves...

The maths is simple enough to implement in games on an SSE configured
Celeron D (depending on resolution and Bilinear filter & resize.

https://science.n-helix.com/2022/04/vecsr.html
