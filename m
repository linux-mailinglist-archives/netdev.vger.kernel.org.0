Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653754F7CB7
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244234AbiDGK3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237564AbiDGK3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:29:22 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33D489CD9
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 03:27:21 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b15so5865275edn.4
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 03:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=nCzDGoAAIWVuUNjHdyahcYIJjBTGEOu0CAiErPb7eZo=;
        b=FTJlEqqxBDV64LIwPkvXBcoh9trQUUoRjT/D4FLXc0CRQIvjCyXGkj+b7F9UHxe4d1
         cNkUActC2RJGsdazfex8QIIQUNZ1oQYpEIVojzwNimpGYp5PkONtQBzSs4oYFaBbxQHX
         aNrcjt1373oh4kjOzi1XJLURIFzdcuJ7w8Vew2TgJ5iR3RE9FeUXjs2fM8r2cHqlne34
         qANEnEj1ay/Q3MhgY0Yr4zRu3Ikctc8NRurX8RNDqmkQOVKUaRibR/TpOgM58vECD2L/
         DFpj1nWhv4nXX5k3SDj9G7X8KkxNEQDrrT/dVZlhzAeGUZnrZRFFmHhGSoBTeQmHBs0+
         unqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=nCzDGoAAIWVuUNjHdyahcYIJjBTGEOu0CAiErPb7eZo=;
        b=R/ATJXejxpbsyRxI6K740oAnj5gpKGDqL1miwqcUucCxV8Xk02wd3c8ER6q6vWlDpy
         fGeZ7MckFup7eS2QGT2DB9/945DecJ7DhgnImpG2dwPXm9zqf3fLy8rI13xDqx+sHKnp
         /9EKOT5lu3NC1xkAv5WIdA92wmrpru7kyeqc18d0Jn+60hL6SOnn9JMRWK2nmLUDuaPE
         Ln1pHdOuKcb5u5B6wCgbw2D6+M8vnXsL7OWbQo95hlkcRQHmBIFX7hTuSOqAF7wxcr3V
         +Ac1XA0Yp3lNtWDeI+e/kf3r9+JuV5QLTMGYkE8R5hZH7Tb9bvn5MB5lPhgEdt+4Njua
         vSOg==
X-Gm-Message-State: AOAM5308WJRScpBB+paSoQQvtkelkQUod7ZBkZper7IZw5C7aoyCLIL8
        2Yqx0kFbwuYxQY903k1BSS1zKLBDDCy1nrRPrQM=
X-Google-Smtp-Source: ABdhPJzhJm5G6h/1s8qVHgh0xyjNXtVFlMfjIEnaY70+LOKOo9Ha2HjJO8TEhwRk+ZG5QCT6FZxu83GxSr2RHLv5o5I=
X-Received: by 2002:a05:6402:34d6:b0:419:4dc2:91c5 with SMTP id
 w22-20020a05640234d600b004194dc291c5mr13599230edc.329.1649327239973; Thu, 07
 Apr 2022 03:27:19 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Thu, 7 Apr 2022 11:27:07 +0100
Message-ID: <CAHpNFcPcz0B9ohjoRDsuN1F_tac2mLrpdUn6N9NidvtGevkF8A@mail.gmail.com>
Subject: Random : (Dynamic Elliptic Curve / T) * Factor Of T : problems for
 Arm (32-bit), Motorola 68000 (M68k), Microblaze, SPARX32, Xtensa, and other
 niche architectures.
To:     torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Random : (Dynamic Elliptic Curve / T) * Factor Of T :

"Problems for Arm (32-bit), Motorola 68000 (M68k), Microblaze,
SPARX32, Xtensa, and other niche architectures."

NoJitter - Initiating the dev/random ; Initiating Random with a SEED
is the prospect I propose,
My personal Time Crystal RNG is based upon the variable clock rate
principle of Quartz clock crystals & could potentially sound too
regular.

However as we know very small variabilities in Super Stable Quartz
crystals (Factory made) causes doubt,

However in the 0.005 or smaller range & Especially with variable
frequencies & power input levels to controlled crystals; Creative
Chaos Exists,

Particular market is motherboards that tweak frequencies to improve perform=
ance!

Clock rate variance is combined with a seed; As a Factoring agent &
Again as a differentiator.

What Is a Factoring Differentiator ? a Math that shifts values subtly
& therefor shifts our results from predictable to unpredictable; Well
hard to!

The more effort we make; The harder it will be to see our Dynamic
Elliptic Curve.

Rupert S

https://www.phoronix.com/scan.php?page=3Dnews_item&px=3DLinux-RNG-Opportuni=
stic-urandom

"Linux 5.19 To Try To Opportunistically Initialize /dev/urandom
Written by Michael Larabel in Linux Security on 7 April 2022 at 05:44
AM EDT. Add A Comment
LINUX SECURITY -- Linux 5.18 is bringing many random/RNG improvements
thanks to the work of kernel developer Jason Donenfeld. One of the
changes though that had to be backed out during the merge window was
trying to get /dev/random and /dev/urandom to behave exactly the same.
While reverted for now with the 5.18 code, Donenfeld has prepared a
change that should get it into good shape for major architectures with
the next kernel cycle.

That unifying of /dev/random and /dev/urandom work had to be backed
out due to some CPU architectures not having enough source of
randomness at boot and no jitter entropy. This was causing problems
for Arm (32-bit), Motorola 68000 (M68k), Microblaze, SPARX32, Xtensa,
and other niche architectures.

With this patch now in the random.git development tree, it's trying to
opportunistically initialize on /dev/urandom reads. For major,
prominent architectures this should allow the same behavior as was
desired with the Linux 5.18 RNG changes around urandom.
In 6f98a4bfee72 ("random: block in /dev/urandom"), we tried to make a
successful try_to_generate_entropy() call *required* if the RNG was
not already initialized. Unfortunately, weird architectures and old
userspaces combined in TCG test harnesses, making that change still
not realistic, so it was reverted in 0313bc278dac ("Revert "random:
block in /dev/urandom"").

However, rather than making a successful try_to_generate_entropy()
call *required*, we can instead make it *best-effort*.

If try_to_generate_entropy() fails, it fails, and nothing changes from
the current behavior. If it succeeds, then /dev/urandom becomes safe
to use for free. This way, we don't risk the regression potential that
led to us reverting the required-try_to_generate_entropy() call
before.

Practically speaking, this means that at least on x86, /dev/urandom
becomes safe. Probably other architectures with working cycle counters
will also become safe. And architectures with slow or broken cycle
counters at least won't be affected at all by this change.

So it may not be the glorious "all things are unified!" change we were
hoping for initially, but practically speaking, it makes a positive
impact.

Assuming no further RNG issues uncovered with this work, you can
expect to find this change appear in the Linux 5.19 kernel this
summer."

*****

NT Interrupt counter Entropy : A counter theory : RS

"more importantly, our
distribution is not 2-monotone like NT's, because in addition to the
cycle counter, we also include in those 4 words a register value, a
return address, and an inverted jiffies. (Whether capturing anything
beyond the cycle counter in the interrupt handler is even adding much of
value is a question for a different time.)"

NT Interrupt counter Entropy : A counter theory : RS

To be clear interrupts are old fashioned (NT & Bios) : Points

Network cards have offloading? Yes & why cannot we?

Offloaded does not mean that a time differential matrix HASH AES of 32Bit w=
ords,
Cross pollinated though MMX, AVX , SiMD is plausible!

Combined with even network latency timing & interrupt latency...

Various system differentials can alternate line in our table per clock sync=
!

In this reference Quartz clock instability is not only counter acted by NTP=
...
But also utilized as a variable co-modifier.

So why not also advantage ourselves of the clock frequency scaling
effect to confuse odds again for Entropy (Random, Not Entropy)

SSD does also have a write counter & a cleared state, not so boring as
one thinks if per 32KB segment is hashed in 4Bit, 8,Bit 32Bit float!
(remember we have DOT3 DOT 4 & INT8 in ML)

We can utilize write cycle statistics & all hardware; Interrupts by
themselves are rather Boring!

Computed timings on processes multiplexed over 3 Threads per group in
competition is also a potential complexifier of Random

Rupert S

https://science.n-helix.com/2018/12/rng.html

https://science.n-helix.com/2022/02/rdseed.html

https://science.n-helix.com/2017/04/rng-and-random-web.html

https://science.n-helix.com/2022/02/interrupt-entropy.html

https://science.n-helix.com/2021/11/monticarlo-workload-selector.html

https://science.n-helix.com/2022/03/security-aspect-leaf-hash-identifiers.h=
tml

https://science.n-helix.com/2022/02/visual-acuity-of-eye-replacements.html

****

PreSEED Poly Elliptic SiMD RAND : RS

Preseed ; 3 Seeds with AES or Poly ChaCha or even 1 : 2 would be
rather fast Init

Blending them would make a rather paranoid Kernel developer feel safe! :D

Like so List:

3 seeds 32Bit or 64Bit :
Examples :

1 Seed : Pre seeded from CPU IRQ & Net 16Bit values each & merged
2 & 3 from server https://pollinate.n-helix.com &or System TRNG

4 Seed mix 128Bit Value

Advantages :

AVX & SiMD Mixxer is fast 'Byte Swap & Maths etcetera" & MultiThreaded
AES Support is common :

*
HASH : RSA Source Cert C/TRNG : (c)RS

Elliptic RSA : Cert Mixer : RSA 4096/2048/1024Temporal : 384/256/192
ECC Temporal

Centric Entropy HASH: Butterfly Effects

Blake2
ChaCha
SM4
SHA2
SHA3

Elliptic Encipher
AES
Poly ChaCha

Elliptic : Time Variance : Tick Count Variance : On & Off Variance : IRQ

*
Time & Crystal : Quartz as a diffraction point fractal differentiator : RS

RDTSC Variable bit differentiation & deviation of the quartz sub .0001
Value combined with complexity of unique interplay with Alternative
clocks such as Network cards, Audio cards & USB Sticks & Bluetooth
radio clocks & Ultimately the NTP Pools themselves when required.

(TIME Differential Float maths) TSC : RDTSC : RDTSCP : TCE supports
single and half precision floating-point calculations

Processor features: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
pge mca cmov pat pse36 clflush mmx fxsr sse sse2 htt pni ssse3 fma
cx16 sse4_1 sse4_2 popcnt aes f16c syscall nx lm avx svm sse4a osvw
ibs xop skinit wdt lwp fma4 tce tbm topx page1gb rdtscp bmi1

*
For RDTSCP =3D TValue TV1=3D16.0685 TV2=3D16.1432 TV3=3D15.1871
When Processor Mzh =3D PV1 PV2 PV3
RAND Source =3D Es1 Es2 Es3

If Xt =3D 1.9 < then roll right

((TV1 - TV2) * (PV1 - PV2)) / ((TV1 - TV3) * (PV1 - PV3)) =3D FractorXt(Xt)

Es1 * Xt =3D Differential

Es2 Es3

(c) Rupert S

Quartz as a diffraction point fractal differentiator : RS

https://tches.iacr.org/index.php/TCHES/article/download/7274/6452
https://perso.univ-rennes1.fr/david.lubicz/articles/gda.pdf
https://patents.google.com/patent/US9335971
*

"Taking spinlocks from IRQ context is problematic for PREEMPT_RT. That
is, in part, why we take trylocks instead. But apparently this still
trips up various lock dependency analysers. That seems like a bug in the
analyser's that should be fixed, rather than having to change things
here.

But maybe there's another reason to change things up: by deferring the
crng pre-init loading to the worker, we can use the cryptographic hash
function rather than xor, which is perhaps a meaningful difference when
considering this data has only been through the relatively weak
fast_mix() function.

The biggest downside of this approach is that the pre-init loading is
now deferred until later, which means things that need random numbers
after interrupts are enabled, but before work-queues are running -- or
before this particular worker manages to run -- are going to get into
trouble. Hopefully in the real world, this window is rather small,
especially since this code won't run until 64 interrupts have occurred."

https://lore.kernel.org/lkml/Yhc4LwK3biZFIqwQ@owl.dominikbrodowski.net/T/

Rupert S

*

Random : (Dynamic Elliptic Curve / T) * Factor Of T :

"Problems for Arm (32-bit), Motorola 68000 (M68k), Microblaze,
SPARX32, Xtensa, and other niche architectures."

NoJitter - Initiating the dev/random ; Initiating Random with a SEED
is the prospect I propose,
My personal Time Crystal RNG is based upon the variable clock rate
principle of Quartz clock crystals & could potentially sound too
regular.

However as we know very small variabilities in Super Stable Quartz
crystals (Factory made) causes doubt,

However in the 0.005 or smaller range & Especially with variable
frequencies & power input levels to controlled crystals; Creative
Chaos Exists,

Particular market is motherboards that tweak frequencies to improve perform=
ance!

Clock rate variance is combined with a seed; As a Factoring agent &
Again as a differentiator.

What Is a Factoring Differentiator ? a Math that shifts values subtly
& therefor shifts our results from predictable to unpredictable; Well
hard to!

The more effort we make; The harder it will be to see our Dynamic
Elliptic Curve.

Rupert S

https://www.phoronix.com/scan.php?page=3Dnews_item&px=3DLinux-RNG-Opportuni=
stic-urandom

*****
Serve C-TRNG QT Fractional Differentiator(c)RS

Server C/TRNG Quarts Time * Fractional differentiator : 8Bit, 16Bit,
32Bit, Float Int32 : Fractional Differentiator : fig-mantuary micro
differentiator.

SipHash: a fast short-input PRF

Rotation Alignment : "The advantage of choosing such =E2=80=9Caligned=E2=80=
=9D
rotation counts is that aligned rotation counts are much faster than
unaligned rotation counts on many non-64-bit architectures."

http://cr.yp.to/siphash/siphash-20120918.pdf

https://www.aumasson.jp/siphash/siphash.pdf

"Choice of rotation counts. Finding really bad rotation counts for ARX
algorithms turns out to be difficult. For example, randomly setting
all rotations in
BLAKE-512 or Skein to a value in {8, 16, 24, . . . , 56} may allow known at=
tacks
to reach slightly more rounds, but no dramatic improvement is expected.
The advantage of choosing such =E2=80=9Caligned=E2=80=9D rotation counts is=
 that
aligned rotation counts are much faster than unaligned rotation counts
on many non-64-bit
architectures. Many 8-bit microcontrollers have only 1-bit shifts of bytes,=
 so
rotation by (e.g.) 3 bits is particularly expensive; implementing a rotatio=
n by
a mere permutation of bytes greatly speeds up ARX algorithms. Even 64-bit
systems can benefit from alignment, when a sequence of shift-shift-xor can =
be
replaced by SSSE3=E2=80=99s pshufb byte-shuffling instruction. For comparis=
on,
implementing BLAKE-256=E2=80=99s 16- and 8-bit rotations with pshufb led to=
 a
20% speedup
on Intel=E2=80=99s Nehalem microarchitecture."

https://www.kernel.org/doc/html/latest/security/siphash.html

https://en.wikipedia.org/wiki/SipHash

Code SIP-HASH
https://github.com/veorq/SipHash

Serve C-TRNG QT Fractional Differentiator(c)RS

Server C/TRNG Quarts Time * Fractional differentiator : 8Bit, 16Bit,
32Bit, Float Int32 : Fractional Differentiator : fig-mantuary micro
differentiator.

As we see rotation may benefact from the addition of Quartz crystal
alignment sync data from 4 cycles & aligning data blocks,

Obviously we can pre share 4 64Bit blocks use use a pre seed AES/ChaCha Qua=
d!
Indeed we can have 16 64Bit pre Seeds & chose them by time sync for kernel

Security bug; Solutions & explanation's (contains additional RANDOM
Security Methods) :RS

https://science.n-helix.com/2020/06/cryptoseed.html
https://science.n-helix.com/2019/05/zombie-load.html
https://science.n-helix.com/2018/01/microprocessor-bug-meltdown.html

Rupert S https://science.n-helix.com

*RAND OP Ubuntu :
https://manpages.ubuntu.com/manpages/trusty/man1/pollinate.1.html

https://pollinate.n-helix.com

https://science.n-helix.com/2018/12/rng.html

https://science.n-helix.com/2022/02/rdseed.html

https://science.n-helix.com/2017/04/rng-and-random-web.html

https://science.n-helix.com/2021/11/monticarlo-workload-selector.html

https://science.n-helix.com/2022/02/visual-acuity-of-eye-replacements.html

https://science.n-helix.com/2022/02/interrupt-entropy.html

https://aka.ms/win10rng
*

Encryption Methods:
https://tools.ietf.org/id/?doc=3Dhash

https://tools.ietf.org/id/?doc=3Dencrypt

HASH :

https://datatracker.ietf.org/doc/html/draft-ietf-cose-hash-algs

https://tools.ietf.org/id/draft-ribose-cfrg-sm4-10.html

https://tools.ietf.org/id/?doc=3Dsha

https://tools.ietf.org/id/?doc=3Drsa

Encryption Common Support:

https://tools.ietf.org/id/?doc=3Dchacha

https://tools.ietf.org/id/?doc=3Daes

SM4e does seem a good possibility for C/T/RNG CORE HASH Functions!

ARM Crypto Extensions Code (Maybe AES Extensions would work here)
https://lkml.org/lkml/2022/3/15/324

ARM Neon / SiMD / AVX Compatible (GPU is possible)
https://lkml.org/lkml/2022/3/15/323

*

197 FIPS NIST Standards Specification C/T/RNG
https://science.n-helix.com/2022/02/interrupt-entropy.html

Only a Neanderthal would approve a non additive source combination
that is injected into the HASH & Re-HASHED ,

One does not Procreate inadequate RANDOM from a simple bias KERNEL,
Hardware RNG's added together may add around 450% Complexity!

Hardware RNG devices MUST be able to Re-HASH to their 197 NIST
Standards Specification, That is FINAL 2022 DT

KEYS: trusted: allow use of kernel RNG for key material

https://lkml.org/lkml/2022/3/16/598

CAAM PRNG Reference : https://lkml.org/lkml/2022/3/16/649
