Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECB14ECA88
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 19:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349270AbiC3R0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 13:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349252AbiC3R0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 13:26:30 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8482E5FD6
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 10:24:42 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id pv16so42963265ejb.0
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 10:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=U2xWSUScXkI45pg1q8y4+hkage1RhlH6yEvmueXn3YA=;
        b=U1+9v6UYmACR6tG0ba8bax6lpwCM+0gFM73DcjFnnBUKKZ6ecJn7HohHHzjH4gRGua
         xtxoH4tbtAnpg8s5JSKuVLnOu3Y029LYQVs9mGMmHpaXlRtTim0MpIfTvdtoIHCQ6dhE
         r1fnFct6dyh/RWm92vEWmdaVe8bCAAr/+X2Ge1OmXJb4PBgSRBHdKt+d7F58rWu8hNjq
         208/X0VJHLhHfst3I/fyUWOPIKvkTyLKn9EiMedPcEn/Y+NX9R/NeLkK70eoG0bNsMlG
         t/paI8k6ju/sw8L/aX6XfZbyoxJWmK+wNiXFRRRPxgptYqSEnApy26aApv0e3sAqXCSJ
         5auQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=U2xWSUScXkI45pg1q8y4+hkage1RhlH6yEvmueXn3YA=;
        b=7Zg1YTt8+3KLWJ1AAwVp4fdkcUMeVaZ8S8okymKjKjcFrmLu4XCcKRnTiyZOyJl4NG
         mqLTS7JDQ3GPi8NSni5TNcXDsC2DpP1k+0jdKSIomX/W6NRWccJh2x/MhvT4fDuf5GSA
         vO7btkTJo/StK8FZven9WVVOTbiW1By9lf3U0eN0jU8IEsEJKNt6yPc0hk0X4EcjZA/r
         W0kiRB4DbXGWArT9+E+1nWx5ndPGoEDYRl2ZoS3LC+J1D2WQstgX11iQWCCGvDL+TYaB
         oMvVQP1CA3ZnqeVzDP2GT7igmm7dGkM92RsQUATrOvvrWvrnT2K/biZV0+lf8M++Z5p8
         peIA==
X-Gm-Message-State: AOAM532CUQkMaE+vGD/3/9TYACn20O8hUyArlERlCCNor7qVFowwOjuK
        NHDHojtwZgdXbQbfWk/RUDyMnYk30svNhUFsfmY=
X-Google-Smtp-Source: ABdhPJyzsFWhLPEX8HB6dHjAkg3i8edNoqOYrP11QZF1eMMeG53s1ocWdC5Hagxsn+744gQnKuXt8jzsbbxr7yCGDGc=
X-Received: by 2002:a17:906:d555:b0:6db:148e:5cc with SMTP id
 cr21-20020a170906d55500b006db148e05ccmr614989ejc.63.1648661080924; Wed, 30
 Mar 2022 10:24:40 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Wed, 30 Mar 2022 18:24:36 +0100
Message-ID: <CAHpNFcNkhGE2yE9ttiPVd_8be3b_V2r2D==OJCS9Z=xYNy9hxA@mail.gmail.com>
Subject: Matrix processors & how to use them, Both Mac, Intel, AMD & NV Want
 to make heavy use of , But how to utilize them : RS https://www.phoronix.com/vr.php?view=31014
To:     submissions@vialicensing.com
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

Matrix processors & how to use them, Both Mac, Intel, AMD & NV Want to
make heavy use of , But how to utilize them : RS
https://www.phoronix.com/vr.php?view=31014

Multi Operation Maths - CPU,GPU Computation (c)RS

Kind of an F16 operation & Integer 16 or Int8 if you need it, With
careful management and special libraries ..
Capable of speeding up PC,Mac & Consoles :HPC:
Requires specially compiled libraries so compiled codes can be managed
& roll ops assessed.

Performing multiple 4,8,16,32 operations on a 64Bit integer core (The example)


Rules:

All operations need to be by the same multiplication

Rolls usable to convert value for example Mul & Division

For example :

451 722 551 834 x 6

In the case of non base factor roll numbers

We have to fraction the difference between the value and our base roll number,

10 for example and 6, So the maths is convoluted & may not be worth it,

Could do 6 + rolls & then -Rolls

On a 10 processor the first factor would be 10x because we could
compensate by placement

But we still need space to expand the result to the right or left

0451072205510834 x 10 =

4510722055108340

or 4510 roll -12
7220 roll -8
5510 roll -4
8340 no roll

Converting base 10 to & from hex may make sense

Depending on the cost of roll; This operation may be worth it!

This operation is in Base 10 & 8Bit makes more sense mostly for common
operations in hex..

But 8 is not a very big number for larger maths & 16Bit makes more
sense; Because it has a larger number.

Performing numeric expansion:
consoles in particular and FPU where expansion is required for
emergence mathematics

Performing numeric expansion for circumstances where we require larger
numbers for example:

To fill the 187 FPU buffer..

To do that we will roll to the left & expand the number, although we
may need multiple operations..

Like i say : Roll + or Roll -

1447000
-Roll 3 = 1447
or
+Roll 3 = 1447000000

That way we can potentially exceed the Bit Depth 32Bit for example.

Rupert S https://science.n-helix.com

https://science.n-helix.com/2021/02/multi-operation-maths.html

https://science.n-helix.com/2018/01/integer-floats-with-remainder-theory.html

*****

Packed F16C & F16 Values in use on CPU & GPU - RS.txt

F16C & F16 : lower precision values that are usable to optimise GPU &
CPU operation that involve; Less Detailed values like Hashes or game
data Metadata or Machine Learning : RS

Firstly the F16C is the FX 8320E supported instruction so the CPU can
potentially use packed F16 Float instructions directly from the CPU,
As quoted F16 carefully managed produces a pipeline that is 100% F16..

Packed F16 instructions use 2 data sets per 32Bit storage register...

Data is converted if the array of instructions includes F32 & commonly
all F16 should be present first; Before group conversion or
alternatively...

Allocating an additional 16Bits of data for example 0000x4 or subtle
variance data that allows unique renders... Such as a chaos key or
Entropy / RNG Random data...

Potentially allocating a static key in the form of AES Output from
base pair F16c Value...

The additional data make potentially each game player render unique!

Fast Conversion Proposals include:

Unique per player additional data (AES Key conversion for example, Or
DES; DES Produces smaller faster values)

Static key, Sorted by data type (Base on player profile or Game map)

Dynamic Key

0000 or empty buffer hash

Side by Side : Wide format texture = 2xF16 Value on same 32Bit Value
Top & Bottom : F16 Double layered format texture = 2xF16 Value on same
32Bit Value

Yes transparency for alien skin can use : Top & Bottom F16 layered texture
Machines also; Or even 4 layers for a truly special effect.

Combine both methodology and crypto hash with one or more layer of
BumpMap RayTracing SiMD

SiMD is also 16Bit compatible so no conversion required.

Weather & clouds are examples perfect for light fast loads over
massive GPU Arrays.

F16 are also theoretically ideal for 16Bit audio if using SiMD..

In the case of AVX probably worth using dynamic key conversion..
A Dynamic Remainder key that allows lower bits to interpolate Sound data.

Other object sources such as render can potentially use the F16 system to..
Interpolate or Tessellate bits on shift from F16 to F32 on final plane
write to frame buffer..
The memory required would be the buffer & not the source process..

An example is to replace the bits missing from F16 in F32/F64 with
tessellation shaping and sharpening code; Dynamically relative to
performance of the GPU/CPU...
F16 values obviously transfer from GPU to CPU fast & CPU to GPU..

Image enhancement is also possible with a bitshift stack buffer that
passes additional data to the missing bits..
For example pre processed micro BumpMapping or Compute shading
process; That will pull the bits in.. Under the F16 data
453000.172000 > 453545.172711 bit swap.. could be complex!
Done with a cache? Entirely possible with united cache L3

DLSS & Dynamic sharpen & Smooth/Filter enhanced virtual resolution ..
Can significantly enhance the process..
Of dynamic buffer pipelining to render path. (on requirement benefit)

(c)Rupert S https://science.n-helix.com/2019/06/vulkan-stack.html

https://gpuopen.com/learn/first-steps-implementing-fp16/

*****

Submissions for review

RS

https://drive.google.com/drive/folders/1X5fUvsXkvBU6td78uq3EdEUJ_S6iUplA?usp=sharing

https://lore.kernel.org/lkml/20220329164117.1449-1-mario.limonciello@amd.com/

https://www.phoronix.com/scan.php?page=news_item&px=AMD-PSP-Sysfs-Expose

https://lkml.org/lkml/2022/3/30/1005
