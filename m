Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D394E7192
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 11:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349626AbiCYKvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 06:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348288AbiCYKvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 06:51:10 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEEC21E04
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 03:49:34 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id u26so8730993eda.12
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 03:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=W1igGM1WsluVfytMkOoD9rahAF+bYDF3ee2Dn6NnyLs=;
        b=kEU9oClKPA6napY8Am9GDPR2TG7lJoyYcAWInw0td78hQGhRnFdKEVefthiagcOkAc
         1sFJWJBBn5iekSDtqQMnRQBFE9TwayysflOmGEOEc5fXLMTfYjszGZFQRV0nCWyaAQ2B
         tsIbPDwJ4RNf/ETgzPSfFD/B4F9bnj9iBarDIgIslXWarG7bP8VybJAZKnsLOvAgbyp1
         6d306tW/Tef6AfYYmJwX0F3BvrXEByOW9/R7+88DB2jbbyJMtu/aaS5+IW+L50zZcsL2
         lPEUdolyuuviJvJ8taCqktGnqN/M+I0WYSO29tYdvLn5gSdvCwBz2zzjBsnYRA6DFhJH
         iy9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=W1igGM1WsluVfytMkOoD9rahAF+bYDF3ee2Dn6NnyLs=;
        b=TFd59vj1fKuUixZyeAvA6waHx7Lgk5S4scgoJj5FVmTI8lxz9yUKkGy++6HGgfr3qw
         T3lW4sj5Idtza5+RKcJ7Ul7A9yYdA0E2vaWmWo6O1kA4b2bjiG05rMg8Qn3j4JipTDWd
         Lr9w1Ym+pT+QBHeprFahVk/EdtD5wvdcLJkX5C0gCZf0yl82fEXQswcoEiKvTA7tUApS
         BvsmzT1kyoCiPIlVeRSMgRKSREYmiOUs8nv4ccayKM8sg4cyB6FJbktlvd3YrufeoZsN
         agX9InJJMlAYDIj3Yb4FK3mV9oCTp0qRC8nWYm1hABgCTdDEVeUWHdeG/BqR/RnE0vb2
         hNmw==
X-Gm-Message-State: AOAM533ayLrVIsueDX90h1Xp/oz+gn0eotykq50xSTuAfZgF69Igox0V
        nipLOd8UNaQfJn8LeHtg+EwIv1nsqRZFpeMYtB4=
X-Google-Smtp-Source: ABdhPJwno2Me2em4RdspVO1v9jY+/EaZNxE42yqkoKVmbcDzvBXjTLLBEhPxitN/iAsM/Qu4ynVDhNoo5br7gbAnJR0=
X-Received: by 2002:a05:6402:4414:b0:419:28bc:55dc with SMTP id
 y20-20020a056402441400b0041928bc55dcmr12519198eda.130.1648205372155; Fri, 25
 Mar 2022 03:49:32 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Fri, 25 Mar 2022 10:49:18 +0000
Message-ID: <CAHpNFcNGnnGdxdxR3-0Occta0gn7LK1fdL_+uxK14v-kY1Yz1w@mail.gmail.com>
Subject: GPRS Is Basically secure with TRNG from https://pollinate.n-helix.com/
 & TPM/Jitter TimeCrystal, AS the report shows Origin /dev/random seed is a
 most important matter : 1 of 13,291 Audio, Visual & Bluetooth & Headset &
 mobile developments only go so far: https://science.n-helix.com/2022/02/visual-acuity-of-eye-replacements.html
To:     service@2-sight.com, mobile@cloudflare.com
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

GPRS Is Basically secure with TRNG from https://pollinate.n-helix.com/
& TPM/Jitter TimeCrystal, AS the report shows Origin /dev/random seed
is a most important matter : 1 of 13,291 Audio, Visual & Bluetooth &
Headset & mobile developments only go so far:
https://science.n-helix.com/2022/02/visual-acuity-of-eye-replacements.html

As https://github.com/P1sec/gea-implementation basically shows Crypto
Random Seed is the most important thing...

The code there SHALL Work.

>> RS 2022

ICE-SSRTP GEA Replacement 2022 + (c)RS

IiCE-SSR for digital channel infrastructure can help heal GPRS+ 3G+ 4G+ 5G+

Time NTP Protocols : is usable in 2G+ <> 5G+LTE Network SIM

ICE-SSRTP Encryption AES,Blake2, Poly ChaCha, SM4, SHA2, SHA3, GEA-1 and GEA-2
'Ideal for USB Dongle & Radio' in Rust RS ' Ideal for Quality TPM
Implementation'

"GEA-1 and GEA-2, which are very similar (GEA-2 is just an extension
of GEA-1 with a higher amount of processing, and apparently not
weakened) are bit-oriented stream ciphers."

IiCE-SSRTP : Interleaved Inverted Signal Send & Receive Time Crystal Protocol

Interleaved signals help Isolate noise from a Signal Send & Receive ...

Overlapping inverted waves are a profile for complex audio & FFT is the result.

Interleaved, Inverted & Compressed & a simple encryption?

Example of use:

Nostalgic TriBand : Independence RADIO : Send : Receive :Rebel-you trade marker

Nostalgic TriBand 5hz banding 2 to 5 bands, Close proximity..
Interleaved channel BAND.

Microchip clock and 50Mhz Risc Rio processor : 8Bit : 16Bit : 18Bit
Coprocessor digital channel selector &

channel Key selection based on unique..

Crystal time Quartz with Synced Tick (Regulated & modular)

All digital interface and resistor ring channel & sync selector with
micro band tuning firmware.

(c)Rupert S

*

Good for cables ? and noise ?

Presenting :  IiCE-SSR for digital channel infrastructure & cables
<Yes Even The Internet &+ Ethernet 5 Band>

So the question of interleaved Bands & or signal inversion is a simple
question but we have,

SSD & HDD Cables & does signal inversion help us? Do interleaving bands help us?

In Audio inversion would be a strange way to hear! but the inversion
does help alleviate ...

Transistor emission fatigue...

IiCE-SSRTP : Interleaved Inverted Signal Send & Receive Time Crystal Protocol

Interleaved signals help Isolate noise from a Signal Send & Receive ...

Overlapping inverted waves are a profile for complex audio & FFT is the result.

Interleaved, Inverted & Compressed & a simple encryption?

Good for cables ? and noise ?

Presenting : IiCE for digital channel infrastructure & cables <Yes
Even The Internet &+ Ethernet 5 Band>

(c) Rupert S

https://science.n-helix.com/2018/12/rng.html

https://science.n-helix.com/2022/02/rdseed.html

https://science.n-helix.com/2017/04/rng-and-random-web.html

https://science.n-helix.com/2022/02/interrupt-entropy.html

https://science.n-helix.com/2021/11/monticarlo-workload-selector.html

https://science.n-helix.com/2022/03/security-aspect-leaf-hash-identifiers.html


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

*

***** Dukes Of THRUST ******

Nostalgic TriBand : Independence RADIO : Send : Receive :Rebel-you trade markerz

Nostalgic TriBand 5hz banding 2 to 5 bands, Close proximity..
Interleaved channel BAND.

Microchip clock and 50Mhz Risc Rio processor : 8Bit : 16Bit : 18Bit
Coprocessor digital channel selector &

channel Key selection based on unique..

Crystal time Quartz with Synced Tick (Regulated & modular)

All digital interface and resistor ring channel & sync selector with
micro band tuning firmware.

(c)Rupert S

Dev/Random : Importance

Dev/Random : Importance : Our C/T/RNG Can Help GEA-2 Open Software
implementation of 3 Bits (T/RNG) Not 1 : We need Chaos : GEA-1 and
GEA-2 Implementations we will improve with our /Dev/Random

Our C/T/RNG Can Help GEA-2 Open Software implementation of 3 Bits
(T/RNG) Not 1 : We need Chaos : GEA-1 and GEA-2 Implementations we
will improve with our /Dev/Random

We can improve GPRS 2G to 5G networks still need to save power, GPRS
Doubles a phones capacity to run all day,

Code can and will be improved, Proposals include:

Blake2
ChaCha
SM4
SHA2
SHA3

Elliptic Encipher
AES
Poly ChaCha

Firstly we need a good solid & stable /dev/random

So we can examine the issue with a true SEED!

Rupert S https://science.n-helix.com/2022/02/interrupt-entropy.html

TRNG Samples & Method DRAND Proud!

https://drive.google.com/file/d/1b_Sl1oI7qTlc6__ihLt-N601nyLsY7QU/view?usp=drive_web
https://drive.google.com/file/d/1yi4ERt0xdPc9ooh9vWrPY1LV_eXV-1Wc/view?usp=drive_web
https://drive.google.com/file/d/11dKUNl0ngouSIJzOD92lO546tfGwC0tu/view?usp=drive_web
https://drive.google.com/file/d/10a0E4Gh5S-itzBVh0fOaxS7JS9ru-68T/view?usp=drive_web

https://github.com/P1sec/gea-implementation

"GEA-1 and GEA-2, which are very similar (GEA-2 is just an extension
of GEA-1 with a higher amount of processing, and apparently not
weakened) are bit-oriented stream ciphers."

"A stream cipher, such as the well-known RC4 or GEA-1, usually works
through using the Xor operation against a plaintext. The Xor operation
being symmetrical, this means that encrypting should be considered the
same operation as decrypting: GEA-1 and GEA-2 are basically
pseudo-random data generators, taking a seed (the key, IV and
direction bit of the GPRS data, which are concatenated),

The generated random data (the keystream) is xored with the clear-text
data (the plaintext) for encrypting. Then, later, the keystream is
xored with the encrypted data (the ciphertext) for decrypting. That is
why the functions called in the target library for decrypting and
encrypting are the same.

GEA-1 and GEA-2 are bit-oriented, unlike RC4 which is byte-oriented,
because their algorithms generate only one bit of pseudo-random data
at once (derived from their internal state), while algorithms like RC4
generate no less than one byte at once (in RC4's case, derived from

permutation done in its internal state). Even though the keystream
bits are put together by the current encryption / decryption C and
Rust libraries into bytes in order to generate usable keystream,
obviously.

Based on this, you can understand that GEA-1 and GEA-2 are LFSR:
Linear Feedback Shift Register-oriented ciphers, because their
internal state is stored into fixed-size registers. This includes the
S and W registers which serve for initialization / key scheduling
purposes and are respectively 64 and 97-bit wide registers, and the A,
B, C (and for GEA-2 only D) registers which serve for the purpose of
keystream generation, which are respectively 31, 32, 33 and 29-bit
wide registers.

On each iteration of the keystream generation, each register is
bit-wise rotated by one position, while the bit being rotated from the
left towards the right side (or conversely depending on in which bit
order you internally represent your registers) is fed back to the
algorithm and mutated depending on given conditions. Hence, the

shifted-out bit is derived from other processing, and reinserted,
while being for this reason possibly flipped depending on conditions
depending on bits present at the other side of the given register.

This is the explanation for the name of linear feedback shift register
(shift because of the shift operation required for the rotation, and
linear feedback because of the constant-time transform operation
involved).

The rest of the register may also be mutated at each iteration steps,
as in the case of the GEA-1 and 2, whole fixed Xor sequences (which
differ for each register) may be applied depending on whether the
rotated bit is a 0 or a 1.

Note that a step where the register iterates is called clocking (the
register is clocked), and that the fixed points where the register may
be Xor'ed when the rotated bit becomes a 1 are called taps. The linear
function which may transmute the rotated bit at the clocking step
(taking several bits of the original register as an input) is called
the F function.

Those kind of bit-oriented LFSR algorithms, such as GEA-1 and 2 (for
GPRS) and A5/1 and 2 (for GSM), were designed this way for optimal
hardware implementations in the late 80's and early 90's."

*****

IiCE-SSRTP : Interleaved Inverted Signal Send & Receive Time Crystal Protocol

Interleaved signals help Isolate noise from a Signal Send & Receive ...

Overlapping inverted waves are a profile for complex audio & FFT is the result.

Interleaved, Inverted & Compressed & a simple encryption?

Good for cables ? and noise ?

Presenting :  IiCE-SSR for digital channel infrastructure & cables
<Yes Even The Internet &+ Ethernet 5 Band>

So the question of interleaved Bands & or signal inversion is a simple
question but we have,

SSD & HDD Cables & does signal inversion help us? Do interleaving bands help us?

In Audio inversion would be a strange way to hear! but the inversion
does help alleviate ...

Transistor emission fatigue...

IiCE-SSRTP : Interleaved Inverted Signal Send & Receive Time Crystal Protocol

Interleaved signals help Isolate noise from a Signal Send & Receive ...

Overlapping inverted waves are a profile for complex audio & FFT is the result.

Interleaved, Inverted & Compressed & a simple encryption?

Good for cables ? and noise ?

Presenting : IiCE for digital channel infrastructure & cables <Yes
Even The Internet &+ Ethernet 5 Band>

(c) Rupert S


***** Dukes Of THRUST ******

Autism, Deafness & the hard of hearing : In need of ANC & Active audio
clarification or correction 2022-01

Sony & a few others make noise cancelling headphones that are suitable
for people with Acute disfunction to brain function for ear drums ...
Attention deficit or Autism,
The newer Sony headsets are theoretically enablers of a clear
confusion free world for Autistic people..
Reaching out to a larger audience of people simply annoyed by a
confusing world; While they listen to music..
Can and does protect a small percentage of people who are confused &
harassed by major discord located in all jurisdictions of life...

Crazy noise levels, Or simply drowned in HISSING Static:

Search for active voice enhanced noise cancellation today.

Rupert S https://science.n-helix.com


https://science.n-helix.com/2021/11/wave-focus-anc.html

https://science.n-helix.com/2021/10/noise-violation-technology-bluetooth.html


https://www.orosound.com/

https://www.consumerreports.org/noise-canceling-headphone/best-noise-canceling-headphones-of-the-year-a1166868524/
