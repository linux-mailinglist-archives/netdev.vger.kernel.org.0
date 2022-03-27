Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299F44E895D
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 20:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbiC0Siz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 14:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236298AbiC0Sil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 14:38:41 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3984A40929
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 11:37:00 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id lr4so16061555ejb.11
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 11:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=vPkWPK9fcrenNX3+70MAXLkgTo7ZH+XGzuJnlJpQ+tY=;
        b=K0FOnBwPoH0sISCMEALWpe2aHrvlhzM6ps+MqZ7dum3H1lrvM3N8BGs5NpZPrmLgRG
         +SQhcFojpo6YZNqBPG5ROAgrp4wfk2/vqvAMlog0HEot6OtbZ8kXtgmlaHG+CbnPFaWq
         dSzz8HbD9VvgHsDxkcbGPnmeXTk1clpoSTAg4qmlPZAF11MNWBd0IPFZX9incy5adj8O
         ClbE4TQ8wKsPcUhpqJVoUdJsz0Z81hYukaT1GYK7JJWAgoXhn2HxzQJjgydG0nk0+h/K
         +ebttYTJCTa6636N9oVdASUHb2bztz676S9JmoEL8FwiG/mDT1rZSbjfoAGL8fVwSbdE
         1EGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vPkWPK9fcrenNX3+70MAXLkgTo7ZH+XGzuJnlJpQ+tY=;
        b=xm1K7tIA+seSPr7ywL27VR9xZuwJ6oBN5lwBcYdNJbZrnnOLKpqoCoQn0vcolMxwCj
         Kd9mt8y08Z4T78Oh2lll0NdaCJ16rMoGUOB0ENZg7qnPik0KT1AVDIwWyk5HJHYEXaXz
         NhtrZDR2zZiS4/kqyuNjKHNcGr9NH3o2e4isTELu7PWF7Hf1JB9EG3ZdIjWOUepO7xLw
         GhuahGB5icuy3cePsq1sOa7/JRJMpdwisijg5j4thVnB6WE2J3g5MSB+l6ffYU8/Nmx1
         ANN1HauykeTScsYr5QdZJIWBWZhm7xX6t5Dwg7rt7tM91MvRSsxiDP71fSDTx9hh/E0L
         +E8A==
X-Gm-Message-State: AOAM532S9sWKjrg4nLlILG3ClQmfpcd3zQCphCcQmpgOhPOzsP8m4fZl
        8PefXj5xq97fgFN8mA8CefXsk0/P/QpOjcuJzbw=
X-Google-Smtp-Source: ABdhPJwLGrFHvKqbadJlybD5vZR20nmJ1xLDZFySDZ5iPxe3wgxVdyGbVwAuQ8+Awfi9M6uo6g59KnVrCUqV8QyLfe0=
X-Received: by 2002:a17:906:1e94:b0:6cc:4382:f12e with SMTP id
 e20-20020a1709061e9400b006cc4382f12emr22844093ejj.482.1648406217735; Sun, 27
 Mar 2022 11:36:57 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Sun, 27 Mar 2022 19:36:20 +0100
Message-ID: <CAHpNFcMpMEkmWPjSNnoYuAY=9H-1Sqx-WtKqZ-SW=ipeN5BhwQ@mail.gmail.com>
Subject: (Refinement) Presenting GPRS VT2 from ViaLicensing today world wide
 RS : for ViaLicencing GPRS is quite a package, New from RS @ Via 2022
To:     press@vialicensing.com
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

*

Time differentiated : Interleave, Inversion & differentiating Elliptic curve.

We will be able to know and test the Cypher : PRINCIPLE OF INTENT TO TRUST

We know of a cypher but : (Principle RS)

We blend the cypher..
Interleaved pages of a cypher obfuscate : PAL CScam does this

Timed : Theoretically unique to you in principle for imprecision, But
we cannot really have imprecise in Crypto!

But we can have a set time & in effect Elliptic curve a transient variable T,
With this, Interleave the resulting pages (RAM Buffer Concept)

Invert them over Time Var = T

We can do all & principally this is relatively simple.

(c)RS

*

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
