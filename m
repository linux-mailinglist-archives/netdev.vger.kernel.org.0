Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0084F2112
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 06:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiDEEIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 00:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiDEEIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 00:08:47 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE7B21C
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 21:06:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id c42so5984161edf.3
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 21:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=k33GZGWU+w9uUOgE7RI/0gXQX1NT8yDgH8ann6GGs8w=;
        b=bxGBiyEIZStrtD3+4iQ1HCM1sWxhlXV10+iqEn/qlNsNX+5jYs2oeIrAi38GhH3C/S
         c4jmU83itAIPmrqzQsT48+z9H0vZrIhLoIvwKeWHiAcWWZh6Rg0n8hISzOGzlrM8qjss
         GUH0oG8ecLJJgWZesSFb6l0iqdc7YCTiHwoTZ+UwPKDeDaddbqwYkO+PhnucQWqqOI5z
         aXQuqLdPO5kq9uzkL7RUjUz6OOsmFI8eWqAFhel/n5OnlxRJSpL34TAzn+pq0PyA+dVp
         SntH10wmVLUg7gRuVFaDTOSkTQXEU5W3v4ZPNRSzW+wAc7bhj7EjZGWtG2NJu4+Z+vzc
         Xt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=k33GZGWU+w9uUOgE7RI/0gXQX1NT8yDgH8ann6GGs8w=;
        b=AjSmLKB3oC8d1UVvvftuYnpNnNXh73BuQkvZ6OH95D9Vh8ZZ1DTRQekZjlyIlj/7yz
         Y2OVqG5cSPSKGoYMGT2AiGrI6NW7UITGh8a7e5rryIGZtPFZAWK33YPWu9Ws+f5Xdven
         79s3bUBhXckXgGU5Xi5yyCMtG7L+27ZWVjKBIhcHkdNQA7pkKIjIulHglDx8lNAylHpl
         0bqSvpv6DtTFWZHfhvYqmynGe07j0E91pticLhatGqGhQkT/5pD5iftrlrI80UIeVs6/
         vAqlkEGtkG41J3YrbmcvbMr/ak6ZpeY0UV/I4/b1JdQl5aG+pOJw5v4BCpjJ7M7GUFaI
         RnTw==
X-Gm-Message-State: AOAM531e6a8xQmtHiDYi/LZtG295mvHE8bxxCcmrT0Ol3WuEaPzEFhEa
        IV6LX9DgM/MHHaBXzE2LR0oheki+iGTDIbvOt5M=
X-Google-Smtp-Source: ABdhPJzIwxH2Bdxpe3kP5X875Mjtstqa6tDNBqcHYydSExz556mCkxa77yqXPypcDIe5L5yfy2+OGnvw8Xqzcr2Wdek=
X-Received: by 2002:a05:6402:3604:b0:41c:c4e6:2988 with SMTP id
 el4-20020a056402360400b0041cc4e62988mr1477962edb.157.1649131602779; Mon, 04
 Apr 2022 21:06:42 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Tue, 5 Apr 2022 05:06:31 +0100
Message-ID: <CAHpNFcMO+-rxX=T4GPX9C8hb81AfMP8KhEaxiozFx3URRcf89Q@mail.gmail.com>
Subject: Device Cache Align 'code align also speeds up prefetch' RS 128Bit
 Buffer to Cache Align = Pure, 32Bit,64Bit,128Bit Align Quads & Float Quads -
 HDD,SSD & Subject: Hardware Dual Encrypt & Decrypt : Hardware Accelerators
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

DMAC yep Security Align 128Bits to Cache Array
Align that 128Bit Buffer to Cache Align = Pure, 32Bit,64Bit,128Bit
Align Quads & Float Quads -
HDD,SDD normally have the EIDD DDI Equivalent
Device Cache Align 'code align also speeds up prefetch' Radio AKA Wifi
is also aligned & Internet protocols

RS

https://lkml.org/lkml/2022/4/4/1254
https://lore.kernel.org/all/20220404194510.9206-2-mario.limonciello@amd.com/

Subject: Hardware Dual Encrypt & Decrypt : Hardware Accelerators


(indirect) - Plan & method RS

Modulus Dual Encrypt & Decrypt package : Processor feature (c)RS

AES-CCM & AES-GCM & Other Cypher Modulus + CCM & GCM can be
accelerated with a joint AES Crypto module,

Processor feature & package : Module list:

2 Decryption pipelines working in parallel,
With a Shared cache & RAM Module
Modulus & Semi-parallel modulating decryption & Encryption combined
with Encapsulation Cypher IP Protocol packet

Parallax Cryptographic Processing Unit: RS

The capacity To Multiply decryption on specific hardware in situations
such as lower Bit precision is to be implemented as follows:

On AES-NI & ARM Cryptographic processors; In particular PPS(ARM+) & SiMD ..

The capacity to exploit the fact that the nonce is 16Bit to 64Bit &
full float upto 128Bit for legal decryption (client) means there is a
simple method to use:

In situations that a AES-NI & ARM Cryptographic unit can process 2
threads on a 256Bit Function we can do both the main 128Bit/192Bit &
the nonce 16Bit to 64Bit & Enable a single instruction Roll to
Synchronise both The main HASH & Nonce.

AES & Crypto hardware can utilise the CPU/GPU/Processor FPU & SiMD to
decrypt the nonce (smaller so fast) & in the same 8bto to 64Bits of
code; Inline & parallax the cryptographic function.

With a 256Bit AES-NI & Cryptographic unit : Parallel Decryption &
Return Encryption by using 2x 128Bit & a Processor Enciphered Nonce.

(c)Rupert S

*reference* https://bit.ly/VESA_BT

Dual Encrypt & Decrypt : Hardware Accelerators (indirect)
https://lkml.org/lkml/2022/4/4/1153
https://lore.kernel.org/linux-crypto/20220223080400.139367-1-gilad@benyossef.com/T/#u,

Performance Comparison of AES-CCM and AES-GCM Authenticated Encryption Modes
http://worldcomp-proceedings.com/proc/p2016/SAM9746.pdf

Basic comparison of Modes for Authenticated-Encryption -IAPM, XCBC,
OCB, CCM, EAX, CWC, GCM, PCFB, CS
https://www.fi.muni.cz/~xsvenda/docs/AE_comparison_ipics04.pdf

*****

ICE-SSRTP GEA Replacement 2022 + (c)RS

"GEA-1 and GEA-2, which are very similar (GEA-2 is just an extension
of GEA-1 with a higher amount of processing, and apparently not
weakened) are bit-oriented stream ciphers."

GEA-2 > GEA-3 is therefor 64Bit Safe (Mobile calls) & 128Bit Safe
(Reasonable security)
SHA2, SHA3therefor 128Bit Safe (Reasonable security Mobile) ++
AES & PolyChaCha both provide a premise of 128Bit++

So by reason alone GEA has a place in our hearts.

*

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

Modulus Dual Encrypt & Decrypt package : Processor feature (c)RS

AES-CCM & AES-GCM & Other Cypher Modulus + CCM & GCM can be
accelerated with a joint AES Crypto module,

Processor feature & package : Module list:

2 Decryption pipelines working in parallel,
With a Shared cache & RAM Module
Modulus & Semi-parallel modulating decryption & Encryption combined
with Encapsulation Cypher IP Protocol packet

Parallax Cryptographic Processing Unit: RS

The capacity To Multiply decryption on specific hardware in situations
such as lower Bit precision is to be implemented as follows:

On AES-NI & ARM Cryptographic processors; In particular PSP+PPS(ARM+) & SiMD ..

The capacity to exploit the fact that the nonce is 16Bit to 64Bit &
full float upto 128Bit for legal decryption (client) means there is a
simple method to use:

In situations that a AES-NI & ARM Cryptographic unit can process 2
threads on a 256Bit Function we can do both the main 128Bit/192Bit &
the nonce 16Bit to 64Bit & Enable a single instruction Roll to
Synchronise both The main HASH & Nonce.

AES & Crypto hardware can utilise the CPU/GPU/Processor FPU & SiMD to
decrypt the nonce (smaller so fast) & in the same 8bto to 64Bits of
code; Inline & parallax the cryptographic function.

With a 256Bit AES-NI & Cryptographic unit : Parallel Decryption &
Return Encryption by using 2x 128Bit & a Processor Enciphered Nonce.

(c)Rupert S

*reference*

Performance Comparison of AES-CCM and AES-GCM Authenticated Encryption Modes
http://worldcomp-proceedings.com/proc/p2016/SAM9746.pdf

Basic comparison of Modes for Authenticated-Encryption -IAPM, XCBC,
OCB, CCM, EAX, CWC, GCM, PCFB, CS
https://www.fi.muni.cz/~xsvenda/docs/AE_comparison_ipics04.pdf


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
