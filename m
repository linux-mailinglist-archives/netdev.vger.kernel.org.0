Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912264F45FF
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351380AbiDEUCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573075AbiDERxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 13:53:13 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4014DE09C
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 10:51:11 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id dr20so28135414ejc.6
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 10:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=71VjE26wPh9ej6RgLNzZLjV1gyE1eSSpA4bJwgE7Yx0=;
        b=TWaP8JwC5o8iBLTw9CODzM5aRo0JC/FLK+j+aWugaAWMVUqJa3ytY5ypTcq7HlgQNT
         vMyudlVc3uFiCg5wlfZj4es1DKKUsZnsAyrNmPleekmNiHH9X9kiAmw58x1QBUZWhouA
         B+CnACM2mjA30xil9LgJNEfH6/6FvEm8WD1XknfPOg8PvZHpLsab+uDwrMIdxv5fAS5j
         EsvmxXh5sSXIC7rgcUH/OWYBBSTDctz0P10laxSUMfNxjiY8HMxlHuxOPFFipbGLUvMd
         vUWuD62m0P7jQdxjKrM2L6XSW6AODE7UiBDuqkn95bfFdlKqE7aP/foEJfxLyJ8/fBTw
         yxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=71VjE26wPh9ej6RgLNzZLjV1gyE1eSSpA4bJwgE7Yx0=;
        b=mMKjHA623gi3NOOYiTAfF3Shg9RKWWeEby6zw8WmfC8ZUABE8cgcWnt1XBlSrems4c
         GivyUrNIzk64qLKj+Nn//f+Ynyy/nb+CpxNvEpeC7W+4J+E9nf1AcGvI3oG+nEzpx38p
         6OEdhRGdymRBDbdstHmKUAhkcjqRW7gPSa0Gqz5Gxw/gp3FBslcKjtnX8eo3+D+UWfkG
         ajphi1Et/rOXF3NCqcLLJfOWHqELrnOI9WHYdn9m5f2ZmUp2pY3/o1SoZeL4y9HPNuBs
         Js84PHlkIR6I+5qufI4xRBvefwJlFdDApeKavKBTF0AVp06+fGfQk4kIGoObsxQt2WIG
         oKZw==
X-Gm-Message-State: AOAM533nu2XESnFxQyU7OPuhMY3cSGKNrLvy84pPuD7x4xx44NgXtDPp
        ZUNROBKKg2VXDilar1OnMXOwKbIz/wihVkx+qmw=
X-Google-Smtp-Source: ABdhPJy3WqnbFWhFyzR2jjv9wo3teILmv3rquwAOArhBIyRmnyDnYZLaGkiIJ7sloKGihwZJppz+pMAkxRt4WJz8Q/4=
X-Received: by 2002:a17:906:d555:b0:6db:148e:5cc with SMTP id
 cr21-20020a170906d55500b006db148e05ccmr4559155ejc.63.1649181069336; Tue, 05
 Apr 2022 10:51:09 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Tue, 5 Apr 2022 18:50:57 +0100
Message-ID: <CAHpNFcPDv_NYw-h50YgH5qmQmFmpWVL6DCf4jvjg-KE0iSN2OQ@mail.gmail.com>
Subject: USB & Dongle & Bluetooth & 2.4g Devices 'Example' Logitech devices'
 need a /dev/random Seed Saved for their Cryptological security for both the
 device & the USB Dongle>
To:     torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB & Dongle & Bluetooth & 2.4g Devices 'Example' Logitech devices'
need a /dev/random Seed Saved for their Cryptological security for
both the device & the USB Dongle>

Instructions  *RAND OP Ubuntu :
https://manpages.ubuntu.com/manpages/trusty/man1/pollinate.1.html

https://pollinate.n-helix.com

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
