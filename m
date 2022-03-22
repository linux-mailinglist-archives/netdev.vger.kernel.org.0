Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F624E431C
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 16:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238625AbiCVPhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 11:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbiCVPhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 11:37:04 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1727AE75
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 08:35:32 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w4so22097772edc.7
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 08:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=1iSiwW/U+DweOlsvahyNIrQHjcrb1kkSroEQxDJW2/M=;
        b=hQQEYfVUnY/Dpp6X5unwmO+zpJj06sYmQi0pQmGFsCuVX21DGipWNkP8hCku8xKK/J
         0xAoN4O05/RDleqpXrshI617LYtJ1J++mHdYcoyPl1Wl10nz1H5ss67bty4LoYdymmId
         tLKIXDa5ADTY7gCOKMAxTHw1KgQw3fnyQtr+AGHm57hKk/E1BMiIx+DjBMehuTYb46DP
         UxfJhpHbBgopFq5DdRLtP44iFteI6hf9cffvzUe2Fwtk5xZzGakEK/gRZWocRxylDmOO
         Nh1mZwcvxvobL9wjiMGUyZ/PS9h41Xg5HNcC0b+yaME/ACAV3P5kfITr3+u+/MUrz3Qa
         w4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=1iSiwW/U+DweOlsvahyNIrQHjcrb1kkSroEQxDJW2/M=;
        b=U2SsPNkDYVaEn7CUaXmfa5i7e4A9EjZhLlWAno70sNVwbRtJAMIx6Z9iuLUVcxfIh0
         Y/eEIZN8QkSgaangFbNIybBkf8ov60/Q6FvWOFuyxzQ1UeHiL1Q0swiIKhYksXFJba0S
         rAISAhOP2r717kz363UqJ8ra6n1ezb4Hf2XRikgCYE+YCAgXMCTHkqzcOixI/88dYujr
         Ug9isXf51tuHiyVltUciuBOBoYlX/Q0EXtF4UnQwhZkfMXZnzVMoa2nz23F/87F8+IoS
         iOgqqtEiSezbO+TJB/HfKVnhcX+NQ9pOA3Z9q47JmYop2C0nJfK4OeEBZgZ+rHoTrxG4
         Xl3Q==
X-Gm-Message-State: AOAM531HuFDsYPdd/HQ+qh4xIf6dxCeNfP+HFrf8r0RSvqD36kzBHap0
        H9R0OnqZW5f2f7oZl6R7GdmTp/UK1e36rbNMAsY=
X-Google-Smtp-Source: ABdhPJzmpFGC4btTzix/OIqzZ+QN4+ZetwAddHho6/uOfHsss0zqotCIyMFiwxU7n+mRtKBrBqxPsxKWG0oq8gwG4II=
X-Received: by 2002:a05:6402:8d7:b0:419:1162:a507 with SMTP id
 d23-20020a05640208d700b004191162a507mr21614603edz.157.1647963330960; Tue, 22
 Mar 2022 08:35:30 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Tue, 22 Mar 2022 15:35:21 +0000
Message-ID: <CAHpNFcNdWdcrkHCWLAFRYbhr_g49msMaS5cChczOjjk2UFxdHQ@mail.gmail.com>
Subject: Haptic & 3D Audio : Kernel Core Security & Privacy 'Cache Ripper
 Memory Sniffers & Privacy Baiters ALL GONE' Cash_Bo_Montin Selector RS for
 Cache & System Operations Optimisation & Compute CBoMontin Processor
 Scheduler - Good for consoles & RT Kernels & Firmware (For HTTP+JS HyperThreading)
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

Haptic & 3D Audio : Kernel Core Security & Privacy 'Cache Ripper
Memory Sniffers & Privacy Baiters ALL GONE' Cash_Bo_Montin Selector RS
for Cache & System Operations Optimisation & Compute CBoMontin
Processor Scheduler - Good for consoles & RT Kernels & Firmware (For
HTTP+JS HyperThreading)

Primary Reference:
https://science.n-helix.com/2021/11/monticarlo-workload-selector.html

Cash_Bo_Montin Selector (c)Rupert S for Cache & System Operations
Optimisation & Compute
CBoMontin Processor Scheduler - Good for consoles & RT Kernels (For
HTTP+JS HyperThreading)

*
Monticarlo Workload Selector

CPU, GPU, APU, SPU, ROM, Kernel & Operating system :

CPU/GPU/Chip/Kernel Cache & Thread Work Operations management

In/out Memory operations & CU feature selection are ordered into
groups based on:

CU Selection is preferred by Chip features used by code & Cache
in-lining in the same group.

Global Use (In application or common DLL) Group Core CU
Localised Thread group, Sub prioritised to Sub CU in location of work use
Prioritised to local CU with Chip feature available & with lower
utilisation (lowers latency)

{ Monticarlos In/Out }
System input load Predictable Statistic analysis }
Monticarlo Assumed averages per task }
System: IO, IRQ, DMA, Data Motion }

{ Process by Advantage }
{ Process By Task FeatureSet }
{ Process by time & Tick & Clock Cycle: Estimates }
{ Monticarlos Out/In }

Random task & workload optimiser ,
Task & Workload Assignment Requestor,
Pointer Allocator,
Cache RAM Allocation System.

Multithreaded pointer Cache Object tasks & management.

{SEV_TDL_TDX Kernel Interaction mount point: Input & Output by SSL Code Class}:
{Code Runtime Classification & Arch:Feature & Location Store: Kernel
System Interaction Cache Flow Buffer}
HT-ReadLinkAtTopForReference/SEV_SSLSecureCore
HT-ReadLinkAtTopForReference/SSL_DRM_CleanKernel
*

Based upon the fact that you can input Monti Carlos Semi Random
Ordered work loads into the core process:

*Core Process Instruction*

CPU, Cache, Light memory load job selector
Resident in Cache L3 for 256KB+- Cache list + Code 4Kb L2 with list access to L3

L2:L3 <> L1 Data + Instruction

*formula*

(c)RS 12:00 to 14:00 Haptic & 3D Audio : Group Cluster Thread SPU:GPU CU

Merge = "GPU+CPU SiMD" 3D Wave (Audio 93% * Haptic 7%)

Grouping selector
3D Wave selector

Group Property value A = Audio S=Sound G=Geometry V=Video H=Haptic
B=Both BH=BothHaptic

CPU Int : ID+ (group of)"ASGVH"

Float ops FPU Light localised positioning 8 thread

Shader ID + Group 16 Blocks
SiMD/AVX Big Group 2 Cycle
GPU CU / Audio CU (Localised grouping MultiThreads)

https://www.youtube.com/watch?v=cJkx-OLgLzo

*

Task & Workload Assignment Requestor : Memory & Power

We have to bear in mind power requirements & task persistence in the
:Task & Workload Assignment Requestor

knowledge of the operating systems requirements:
Latency list in groups { high processor load requirements > Low
processor load requirements } : { latency Estimates }
Ram load , Store & clear {high burst : 2ns < 15ns } GB/s Ordered
Ram load , Store & clear {high burst : 5ns < 20ns } MB/s Disordered

GPU Ram load , Store & clear {high burst : 2ns < 15ns } GB/s Ordered
AUDIO Ram load , Store & clear {high burst : 1ns < 15ns } MB/s Disordered

AUDIO Ram load , Store & clear {high burst : 1ns < 15ns } MB/s Ordered
AUDIO Ram load , Store & clear {high burst : 1ns < 15ns } KB/s Disordered

Network load , Send & Receive {Medium burst : 2ns < 15ns } GB/s Ordered
Network load , Send & Receive {high burst : 1ns < 20ns } MB/s Disordered
Hard drive management & storage {medium : 15ns SSD < 40ns HDD}

*

Also Good for disassociated Asymmetric cores; Since these pose a
significant challenge to most software,
However categorising by Processor function yields remarkable
classification abilities:

Processor Advanced Instruction set
Core speed
Importance

Location in association with a group of baton passing & inter-thread
messaging & cache,
Symmetry classed processes & threads.

*

Bo-Montin Workload Compute :&: Hardware Accelerated Audio : 3D Audio
Dolby NR & DTS

Hardware Accelerated Audio : 3D Audio Dolby NR & DTS : Project
Acoustics : Strangely enough ....
Be more positive about Audio Block : Dolby & DTS will use it & thereby in games!

Workload Compute : Where you optimise workload lists though SiMD Maths
to HASH subtasks into new GPU workloads,

Simply utilize Direct ML to anticipate future motion vectors (As with video)

OpenCL & Direct Compute : Lists & Compute RAM Loads and Shaders to load...

DMA & Reversed DMA (From GPU to & from RAM)
ReBAR to vector compressed textures without intervention of one
processor or another...

Compression Block :
KRAKEN & BC Compression & Decompression
&
SiMD Direct Compressed Load using the Cache Block per SiMD Work Group.

Shaders Optimised & compiled in FPU & SiMD Code form for GPU: Compiling Methods:

In advance load & compile : BRT : Before Runtime Time : task load
optimised & ordered Task Executor : Bo-Montin Scheduler

GPU SiMD & FPU (micro 128KB Block encoder : decoder : compiler)
CPU SiMD & FPU (micro 128KB Block encoder : decoder : compiler)

JIT : Just in Time task load optimised & ordered Task Executor :
Bo-Montin Scheduler

load & compile :

GPU SiMD & FPU (micro 128KB Block encoder : decoder : compiler)
CPU SiMD & FPU (micro 128KB Block encoder : decoder : compiler)

(c)Rupert S https://science.n-helix.com

https://science.n-helix.com/2021/11/monticarlo-workload-selector.html

https://science.n-helix.com/2022/03/security-aspect-leaf-hash-identifiers.html

https://science.n-helix.com/2022/02/interrupt-entropy.html

https://science.n-helix.com/2018/12/rng.html

https://science.n-helix.com/2022/02/rdseed.html

https://science.n-helix.com/2017/04/rng-and-random-web.html

https://science.n-helix.com/2022/02/visual-acuity-of-eye-replacements.html

*

EMS Leaf Allocations & Why we find them useful:  (c)RS
https://science.n-helix.com

Memory clear though page Voltage removal..

Systematic Cache randomisation flipping (On RAM Cache Directs
syncobable (RAND Static, Lower quality RAND)(Why not DEV Write 8 x
16KB (Aligned Streams (2x) L2 CACHE Reasons)

Anyway in order to do this we Allocate Leaf Pages or Large Pages...
De Allocation invokes scrubbing or VOID Call in the case of a VM.

So in our case VT86 Instructions are quite useful in a Hypervisor;
&So Hypervisor from kernel = WIN!

(c)Rupert Summerskill

Reference T Clear
https://www.phoronix.com/scan.php?page=news_item&px=Linux-MGLRU-v9-Promising

*

If you could "Decode" Win DLL & particularly the Compiler code, plug
in! you could use these on console :

https://bit.ly/DJ_EQ
https://bit.ly/VESA_BT

https://www.youtube.com/watch?v=cJkx-OLgLzo

High performance firmware:

https://science.n-helix.com/2021/11/monticarlo-workload-selector.html

https://science.n-helix.com/2021/11/parallel-execution.html

https://science.n-helix.com/2019/06/kernel.html

HT-ReadLinkAtTopForReference/SEV_SSLSecureCore
HT-ReadLinkAtTopForReference/SSL_DRM_CleanKernel

HT-ReadLinkAtTopForReference/workcacheserver

HT-ReadLinkAtTopForReference/HPCLinux

*
More on HRTF 3D Audio

TERMINATOR Interview #Feeling
https://www.youtube.com/watch?v=srksXVEkfAs & Yes you want that Conan
to sound right in 3D HTRF

Cyberpunk 2077 HDR : THX, DTS, Dolby : Haptic response so clear you
can feel the 3D SOUND
https://www.youtube.com/watch?v=0t34NQ7Yrwo

https://science.n-helix.com/2021/10/eccd-vr-3datmos-enhanced-codec.html

https://science.n-helix.com/2021/12/3d-audio-plugin.html

HT-ReadLinkAtTopForReference/Quality3DAudioTest

https://bit.ly/VESA_BT
*

*RAND OP Ubuntu :
https://manpages.ubuntu.com/manpages/trusty/man1/pollinate.1.html

https://pollinate.n-helix.com

*

(Spectra & Repoline Ablation) PreFETCH Statistical Load Adaptive CPU
Optimising Task Manager ML(c)RS 2022

Come to think of it, Light encryption 'In State' may be possible in
the Cache L3 (the main problem with repoline) & L2 (secondary) : How?

PFIO_Pol & GPIO Combined with PSLAC TaskManager (CBo_Montin)
Processor, Kernel, UserSpace.

Byte Swapping for example or 16b instruction, If a lightly used
instruction is used
(one that is under utilized)
Other XOR SiMD instructions can potentially be used to pre load L2 &
L1 Instruction & Data.

Spectra & Repoline 1% CPU Hit : 75% improved Security : ALL CPU v& GPU
Processor Type Compatible.

In Terms of passwords & SSL Certificate loads only, The Coding would
take 20Minutes & consume only 0.1% of total CPU Time.

Also Good for disassociated Asymmetric cores; Since these pose a
significant challenge to most software,
However categorising by Processor function yields remarkable
classification abilities:

Processor Advanced Instruction set
Core speed
Importance

Location in association with a group of baton passing & inter-thread
messaging & cache,
Symmetry classed processes & threads.

HASH Example
https://lkml.org/lkml/2022/3/17/120
https://lkml.org/lkml/2022/3/17/119
https://lkml.org/lkml/2022/3/17/116
https://lkml.org/lkml/2022/3/17/115
https://lkml.org/lkml/2022/3/17/118

https://science.n-helix.com/2022/02/interrupt-entropy.html
In reference to :
https://science.n-helix.com/2021/11/monticarlo-workload-selector.html

CPU Statistical load debug 128 Thread :
https://lkml.org/lkml/2022/3/17/243

PFIO_Pol Generic Processor Function IO & Feature Statistics polling +
CPUFunctionClass.h + VCache Memory Table Secure HASH

GPIO: Simple logic analyzer using polling : Prefer = Precise Core
VClock + GPIO + Processor Function IO & Feature Statistics polling

https://lkml.org/lkml/2022/3/17/216
https://lkml.org/lkml/2022/3/17/215
*******

Security bug; Solutions & explanation's :RS

https://science.n-helix.com/2020/06/cryptoseed.html
https://science.n-helix.com/2019/05/zombie-load.html
https://science.n-helix.com/2018/01/microprocessor-bug-meltdown.html

https://www.phoronix.com/scan.php?page=article&item=spectre-bhi-retpoline&num=1

https://lore.kernel.org/lkml/?t=20211204091833

The core scheduler is not the task prioritiser, This deals with Secure
CPU & Processor Transactions.

Good for consoles & RT Kernels (For HTTP+JS HyperThreading)

Rupert S

*Kernel Runtime Strict KeyLock Secure Chaos Scheduler: CTimeTree*

[PATCH 0/5] Make Cluster Scheduling Configurable
 2021-12-04  9:14 UTC  (4+ messages)
` [PATCH 4/5] scheduler: Add boot time enabling/disabling of cluster scheduling

[mark:arm64/preempt-dynamic-static-key 6/6]
kernel/locking/locktorture.c:122:3: error: implicit declaration of
function 'preempt_schedule'
 2021-12-03 23:39 UTC

[PATCH] preempt/dynamic: Fix setup_preempt_mode() return value
 2021-12-03 23:32 UTC

[PATCH v11 0/4] Introduce Platform Firmware Runtime Update and Telemetry drivers
 2021-12-04  8:07 UTC  (4+ messages)
` [PATCH v11 2/4] drivers/acpi: Introduce Platform Firmware Runtime
Update device driver

*CPU Core Logic*

[RFC 0/6] Sparse HART id support
 2021-12-04  0:40 UTC  (7+ messages)
` [RFC 1/6] RISC-V: Avoid using per cpu array for ordered booting
` [RFC 2/6] RISC-V: Do not print the SBI version during HSM extension boot print
` [RFC 3/6] RISC-V: Use __cpu_up_stack/task_pointer only for spinwait method
` [RFC 5/6] RISC-V: Move spinwait booting method to its own config
` [RFC 6/6] RISC-V: Do not use cpumask data structure for hartid bitmap

AES RAND*****

If we had a front door & a back door & we said that, "That door is
only available exclusively to us "Someone would still want to use our
code!
AES is good for one thing! Stopping Cyber Crime!
hod Save us from total anarchistic cynicism

Rupert S

/*
  * This function will use the architecture-specific hardware random
- * number generator if it is available.  The arch-specific hw RNG will
- * almost certainly be faster than what we can do in software, but it
- * is impossible to verify that it is implemented securely (as
- * opposed, to, say, the AES encryption of a sequence number using a
- * key known by the NSA).  So it's useful if we need the speed, but
- * only if we're willing to trust the hardware manufacturer not to
- * have put in a back door.
- *
- * Return number of bytes filled in.
+ * number generator if it is available. It is not recommended for
+ * use. Use get_random_bytes() instead. It returns the number of
+ * bytes filled in.
  */

https://lore.kernel.org/lkml/20220209135211.557032-1-Jason@zx2c4.com/t/

RAND : Callback & spinlock

Callback & spinlock are not just linux : Best we hash &or Encrypt
several sources (if we have them)
If we have a pure source of Random.. we like the purity! but 90% of
the time we like to hash them all together & keep the quality & source
integrally variable to improve complexity.
Rupert S
https://www.spinics.net/lists/linux-crypto/msg61312.html

'function gets random data from the best available sourceThe current
code has a sequence in several places that calls one or more of
arch_get_random_long() or related functions, checks the return
value(s) and on failure falls back to random_get_entropy().get_source
long() is intended to replace all such sequences.This is better in
several ways. In the fallback case it gives much more random output
than random_get_entropy(). It never wasted effort by calling
arch_get_random_long() et al. when the relevant config variables are
not set. When it does usearch_get_random_long(), it does not deliver
raw output from that function but masks it by mixing with stored
random data.'

https://science.n-helix.com/2022/02/rdseed.html
https://science.n-helix.com/2022/02/interrupt-entropy.html
https://science.n-helix.com/2021/11/monticarlo-workload-selector.html

RAND : Callback & spinlock : Code Method

Spinlock IRQ Interrupted upon RAND Pool Transfer > Why not Use DMA
Transfer & Memory Buffer Merge with SiMD : AVX Byte Swapping & Merge
into present RAM Buffer or Future location with Memory location Fast
Table.

Part of Bo-Montin Selector Code:

(CPU & Thread Synced & on same CPU)

(Thread 1 : cpu:1:2:3:4)
(RAND)
(Buffer 1) > SiMD cache & Function :

(Thread 2 : cpu:1:2:3:4)
(Memory Location Table : EMS:XMS:32Bit:64Bit)
(Selection Buffer & Transfer)

(Buffer 1) (Buffer 2) (Buffer 3)
(Entropy Sample : DieHARD : Small)

Rupert S

https://lore.kernel.org/all/20220211011446.392673-1-Jason@zx2c4.com/

Random Initiator : Linus' 50ee7529ec45

Linus' 50ee7529ec45 ("random: try to actively add entropy
rather than passively wait for it"), the RNG does a haveged-style jitter
dance around the scheduler, in order to produce entropy

The key is to initialize with a SEED key; To avoid the seed needing to
be replaced too often we Encipher it in a set order with an additive
key..

to create the perfect circumstances we utilize 2 seeds:
AES/SHA2/PolyCHA

Initiator math key CH1:8Bit to 32Bit High quality HASH Cryptic
& Key 2 CrH

8Bit to 256Bit : Stored HASH Cryptic

We operate maths on the differential and Crypro the HASH :
AES/SHA2/PolyCHA
CrH 'Math' CH1(1,2,3>)

AES/SHA2/PolyCHA > Save to /dev/random & use

We may also use the code directly to do unique HASH RAND & therefore
keep crucial details personal or per application & MultiThreads &or
CPU & GPU & Task.

Rupert S

TRNG Samples & Method

https://drive.google.com/file/d/1b_Sl1oI7qTlc6__ihLt-N601nyLsY7QU/view?usp=drive_web
https://drive.google.com/file/d/1yi4ERt0xdPc9ooh9vWrPY1LV_eXV-1Wc/view?usp=drive_web
https://drive.google.com/file/d/11dKUNl0ngouSIJzOD92lO546tfGwC0tu/view?usp=drive_web
https://drive.google.com/file/d/10a0E4Gh5S-itzBVh0fOaxS7JS9ru-68T/view?usp=drive_web
