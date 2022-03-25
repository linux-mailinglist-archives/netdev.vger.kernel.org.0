Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0DE4E74B3
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359142AbiCYOEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358977AbiCYOEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:04:25 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1673D76FE
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:02:49 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id dr20so15568281ejc.6
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=mTkB/8ok0Jsn34jiNB203Plx4NPfqmN3UIIy2Jyu7bo=;
        b=In8qGeWW39amfdfMaC7ALJwwk2vGMRr7lk3s0LuuCmMDrxlYuKp3Rw/6rsW5fK8Glk
         owwPL6TsetbV897lpSyliYR53rBbH8Du7kfmVB1i0Wx9yhTKjEZhQsfhRlWmVajNgvOM
         nhs+APW1gXhEvsnz0sfKQ/EUrupA0vRe1xplRl8+TDIn9B7Zncg8D4QuK/DlQ4WuexHq
         UWWHyB9h7j7K03KcGsElBWO8Kkm7WPVH4bc32h1GD8EeuI25OMggTeHvyLN/rqLMAY8N
         JKCGBqpmnvRhobpxCr29K1Y3o9HVPXUz4M0crNYKx0m2G2e+u0xQ2+x4B7N6x2u/wK/X
         LWxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=mTkB/8ok0Jsn34jiNB203Plx4NPfqmN3UIIy2Jyu7bo=;
        b=yhl+c8qYMyvownsCw9qMsT1yP+DZJOq8SwSQPz4/qFVcRO1piEVcjyFQYSN6oe3NZx
         dfhl4mn2OgMOZls/hMT72wCbolO0whDlAX9ErmZ5NlawaGEm90LSUm+6waynH35Iroho
         5yeE7HVSN9Hiv9MLQ/vkfxAT1b34oIbVd0oHdWR7VkppeOzsmlzvpt5xwItTD+vJeUrC
         kTG2AX2wGZ6yo2gkM8+/8lF1naPF5mHTHlsnCt5gSmKCOe6BtjM+epXt3lKhXBxm9ztc
         J/zb2npKa57FLkekK1W73rWl+hAg6dHDILsoIFvRTJrjRPUg9c7BShcfEKh1hKX0W01N
         aMng==
X-Gm-Message-State: AOAM533DoqAgL/xvP4hPUkfA3HJKa+0KDl1gmui9OKDx/X/6/L63VE9k
        L1BnPyj0Sgmlm2Rltr22g7v9Jgz/K7bnPxu50lg=
X-Google-Smtp-Source: ABdhPJwa+fESlJNgq3HJUEZBYThRPkGFuUFWog5FxbokThEcrv6N1wNu+ZKY4DjXlyBAga2mWsQ1PY/VlBrI93FD4kU=
X-Received: by 2002:a17:906:d555:b0:6db:148e:5cc with SMTP id
 cr21-20020a170906d55500b006db148e05ccmr11527925ejc.63.1648216967841; Fri, 25
 Mar 2022 07:02:47 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Fri, 25 Mar 2022 14:02:37 +0000
Message-ID: <CAHpNFcMj2Pr5EyTEW2S_UDnLSpzacEznEb=aSOr-arV5F-i4oA@mail.gmail.com>
Subject: New GPU/CPU & Motherboard Bios strategy for ASUS unique RX6700XTC-FlareEdition2021
To:     mobile@cloudflare.com
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

https://www.phoronix.com/scan.php?page=3Dnews_item&px=3DLinux-5.18-x86-Plat=
form-Drivers

New GPU/CPU & Motherboard Bios strategy for ASUS unique
RX6700XTC-FlareEdition2021

Important Business : RS
Date: Sun, Jan 3, 2021 at 11:12 AM
To: Kr*****, L** <l**.kr****@amd.com>
  To: <Med**@xilinx.com>

FPGA BitFile & Code Opt (c)RS 2021-01

Priority of Operating process for streamlining Dynamic FPGA units on
CPU & GPU By Rupert S

Factors common in FPGA are:100000 Gates to 750000 Gates (Ideal for
complex tasks)

Programmable Processor command implementation & reprogram  speed 3ns
to 15 Seconds
2 million gates
Processor core usage to reprogram ?
15% of a 200Mhz processor =3D 200ns programming time
Processor core usage to reprogram ? 20% to 25% of a 200Mhz processor =3D
30ns programming time

250 to 2900 Gates 1uns to 2ns
(ideal for small complex instructions)
Processor usage (in programming) 2 to 5% CPU @200Mhz

2000 to 12500 to 25000 Gates (ideal for very complex function)
30uns to 8ns (ideal for small complex instructions & RISC)

Processor usage (in programming) 2 to 9% CPU @200Mhz

Plans to load a BitFile rely on constant use & not on the fly, However
small gate arrays permit microsecond coding..

However I do state that a parameter for operating order is specified &
for most users Automatic.

Operating system functions.. for example AUDIO are a priority & will
stay consistent..

So we will have specific common instructions that are specific to OS &
BIOS Firmware..
Commons will take 20% of a large FPGA (relative)

With the aim of having at least 4 common & hard to match functions; As
a core large ARRAY..The aim being not to reprogram every second,

For example during boot process with: Bitfile preorder profile:
1uns to 2ns (ideal for small complex instructions)

During the operation of the Computer or array the FPGA may contain
specific ANTIVirus & firewall functions, That we map to ML

The small unit groups of fast reprogrammables will be ideal for
application that we are using for more than 30 minutes.. & May be
clustered.

Optimus (Prime) bitfile : RS
Obviously handheld devices require uniquely optimum feature set & tiny
processor size..
Create the boundry and push that limit.

We will obviously prefer to enable Hardcode pre trained models such as :

SiMD
Tessellation & maths objective : for gaming & science
Dynamic DMA Clusters (OS,Security,Root)
Maths Unit
HardDrive Accelerators
Compressors
Compiler optimisers CPU/GPU
Core Prefetch/ML optimiser (on die)
Combined Shader & function for both DirectX,Metal & Vulkan utility..
GPU & CPU Synergy Network & Cache.
Direct Audio & Video,Haptic processing dynamic; element 3D Extrapolation..
Dynamic Meta Data processing & conversion ..
(Very important because not all Meta data is understood directly in
the used process.)

Obviously handheld devices require uniquely optimum feature set & tiny
processor size..
Create the boundry and push that limit.

(c)Rupert S https://science.n-helix.com

"processor programs a reprogrammable execution unit with the bitfile
so that the reprogrammable execution unit is capable of executing
specialized instructions associated with the program."

https://hothardware.com/news/amd-patent-hybrid-cpu-fpga-design-xilinx

"AMD Patent Reveals Hybrid CPU-FPGA Design That Could Be Enabled By Xilinx =
Tech
xilinx office

While they often aren=E2=80=99t as great as CPUs on their own, FPGAs can do=
 a
wonderful job accelerating specific tasks. Whether it's accelerating
acting as a fabric for wide-scale datacenter services boosting AI
performance, an FPGA in the hands of a capable engineer can offload a
wide variety of tasks from a CPU and speed processes along. Intel has
talked a big game about integrating Xeons with FPGAs over the last six
years, but it hasn't resulted in a single product hitting its lineup.
A new patent by AMD, though, could mean that the FPGA newcomer might
be ready to make one of its own.

In October, AMD announced plans to acquire Xilinx as part of a big
push into the datacenter. On Thursday, the United States Patent and
Trademark Office (USPTO) published an AMD patent for integrating
programmable execution units with a CPU. AMD made 20 claims in its
patent application, but the gist is that a processor can include one
or more execution units that can be programmed to handle different
types of custom instruction sets. That's exactly what an FPGA does. It
might be a little bit until we see products based on this design, as
it seems a little too soon to be part of CPUs included in recent EPYC
leaks.

While AMD has made waves with its chiplet designs for Zen 2 and Zen 3
processors, that doesn't seem to be what's happening here. The
programmable unit in AMD's FPGA patent actually shares registers with
the processor's floating-point and integer execution units, which
would be difficult, or at least very slow, if they're not on the same
package. This kind of integration should make it easy for developers
to weave these custom instructions into applications, and the CPU
would just know to pass those onto the on-processor FPGA. Those
programmable units can handle atypical data types, specifically FP16
(or half-precision) values used to speed up AI training and inference.

xilinx vu19p

In the case of multiple programmable units, each unit could be
programmed with a different set of specialized instructions, so the
processor could accelerate multiple instruction sets, and these
programmable EUs can be reprogrammed on the fly. The idea is that when
a processor loads a program, it also loads a bitfile that configures
the programmable execution unit to speed up certain tasks. The CPU's
own decode and dispatch unit could address the programmable unit,
passing those custom instructions to be processed.

AMD has been working on different ways to speed up AI calculations for
years. First the company announced and released the Radeon Impact
series of AI accelerators, which were just big headless Radeon
graphics processors with custom drivers. The company doubled down on
that with the release of the MI60, its first 7-nm GPU ahead of the
Radeon RX 5000 series launch, in 2018. A shift to focusing on AI via
FPGAs after the Xilinx acquisition makes sense, and we're excited to
see what the company comes up with."

*****

https://science.n-helix.com/2018/12/rng.html

https://science.n-helix.com/2022/02/rdseed.html

https://science.n-helix.com/2017/04/rng-and-random-web.html

https://science.n-helix.com/2022/02/interrupt-entropy.html

https://science.n-helix.com/2021/11/monticarlo-workload-selector.html

https://science.n-helix.com/2022/03/security-aspect-leaf-hash-identifiers.h=
tml


Audio, Visual & Bluetooth & Headset & mobile developments only go so far:

https://science.n-helix.com/2022/02/visual-acuity-of-eye-replacements.html

https://science.n-helix.com/2022/03/ice-ssrtp.html

https://science.n-helix.com/2021/11/ihmtes.html

https://science.n-helix.com/2021/10/eccd-vr-3datmos-enhanced-codec.html
https://science.n-helix.com/2021/11/wave-focus-anc.html
https://science.n-helix.com/2021/12/3d-audio-plugin.html

Integral to Telecoms Security TRNG

*RAND OP Ubuntu :
https://manpages.ubuntu.com/manpages/trusty/man1/pollinate.1.html

https://pollinate.n-helix.com
