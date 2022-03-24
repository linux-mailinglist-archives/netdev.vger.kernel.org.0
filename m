Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662E04E642F
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350482AbiCXNh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350517AbiCXNhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:37:51 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A8AA94D3
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:36:17 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t1so5651199edc.3
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=0Nq8S1Rhf/Bs+KrV0IuyNlsRmenRT8p+AwSfsyHSu+o=;
        b=jZFYqnFhND4asoRNoXpf7ae5C+8ZDunUdn1h1lOYIjmHoZ0PrekSDA3VeN9/NfLgr/
         noYumHiOerDmThWrSJGrc3/eGxu+Dtt5KGMHeRFs4WQbX0mXY7qMKlEvLT+V4aIpaI1y
         KPqKmnwwBuptyQwRJngVAsUsNeTEfHIvtXSLt3qyYjDdE1x/t0a0R9OynP6PCEOo9+VX
         7oUYLVO0QG3iL9nyDZipjKKGC22X2y6hM+EVDLJfwepxWocMdtzBKnLWJEuhKiTnYMGZ
         U/8PJjynB/xasYq4JWw+25WDhgeG3XW6dsS6kUYEaUBelul88MLbm9GWPO43LiyezjR8
         FjkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=0Nq8S1Rhf/Bs+KrV0IuyNlsRmenRT8p+AwSfsyHSu+o=;
        b=4F/ApwPIdteJCSR83hHGY3/tuaKBY45U4x06+nylpulMDz0dzBNpinhYrcYtQpLoTT
         vgL+yaFnAiCiJYWnVuekneNrGbVbGofXOgfgJQ6TZgFXrNQy2EK8jsckRe5vlw7JrojA
         d8f3j3w76MaAlNY1WOFRbhfgh9SOAL2ah9/2/2ssS2W6ZCMCvFOfC4XbEz45gv7PvsWH
         9ENlFlEauxaOTJC1q/PXm5DRchczJPAztFq8XVwFm0N+2n/F7fz4ZQ2abgaWVUD6RW0z
         viaflvNMr2RW7Ee2XfnLrAe9S9vGQw+rAeTzFzsPllRe69XPuhDzGnoDKoxNcVczgL5S
         8S4g==
X-Gm-Message-State: AOAM531UjF5RkzjwhOUCmpYe3uv4Oyoi2Wf2Bh7fCs7zGHzttJrJt+ba
        BFQKdeGsiByX7qNXBNcOxVuH22TiJRLCek45bhY=
X-Google-Smtp-Source: ABdhPJymUHtVuy8vl5PusINjiLTObNcciMnFncsv6OqOS+KLKID9Yy5PWr5zx/+NfIFoGP1Ww2MMQWBwolQkZHcHiNA=
X-Received: by 2002:a50:99cd:0:b0:418:d6c2:2405 with SMTP id
 n13-20020a5099cd000000b00418d6c22405mr6725695edb.342.1648128975441; Thu, 24
 Mar 2022 06:36:15 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Thu, 24 Mar 2022 13:36:10 +0000
Message-ID: <CAHpNFcPG==qZbLKJqfOzw=Q7yFF-TCJW3hrctoK1EwC5S1sjHg@mail.gmail.com>
Subject: (my version) Time clock jitter especially with a TMP but it is enough
 for a math like Elliptic curve as most of it is SERVER anyway! However i do
 promise you that My Jitter Crystal Dynamic is enough along with Var Statement
 simulation of statistical uniqueness within the total dynamic of a system ARM
 Or RISC, However 3 runtimes with variables are required minimum to BOAST
 about it (signed Duke The Thrust of it) IS Enough! I have a Vision & it IS enough
To:     torvalds@linux-foundation.org, do-webmaster@nist.gov
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

(my version) Time clock jitter especially with a TMP but it is enough
for a math like Elliptic curve as most of it is SERVER anyway! However
i do promise you that My Jitter Crystal Dynamic is enough along with
Var Statement simulation of statistical uniqueness within the total
dynamic of a system ARM Or RISC, However 3 runtimes with variables are
required minimum to BOAST about it (signed Duke The Thrust of it) IS
Enough! I have a Vision & it IS enough

"Linux 5.18 Crypto Has Arm Optimizations, AVX For SM3, Xilinx SHA3 Driver
Written by Michael Larabel in Linux Kernel on 24 March 2022 at 05:02
AM EDT. Add A Comment
LINUX KERNEL -- The crypto subsystem updates have landed in the Linux
5.18 kernel.

On the Arm side there are a number of improvements this cycle
including Arm NEON AES optimizations and accelerated crc32_be for
AArch4. The continued expansion of NEON usage within the kernel is
great to see for Arm users.

On the x86/x86_64 side, the Linux 5.18 crypto subsystem updates bring
AVX-accelerated SM3 hashing. SM3 is one of the hashing algorithms
backed by China with the Chinese Commercial Cryptography Suite. This
AVX-optimized version is showing to performance substantially faster
than the generic code path for in-kernel SM3 hashing.

Also notable with the Linux 5.18 crypto updates is the introduction of
a Xilinx SHA3 driver. This Xilinx SHA3 driver supports their ZynqMP
SoC and allows using that SoC's engine for secure hash calculations.
See this pull for the full list of crypto feature updates this cycle.

While not directly connected to the crypto pull, the Linux 5.18 kernel
also pulled in the many random number generator (RNG) updates.
However, the change around unifying /dev/random and /dev/urandom has
been backed out due to some CPU architectures not having enough source
of randomness at boot and no jitter entropy."

***** Providence *****

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
