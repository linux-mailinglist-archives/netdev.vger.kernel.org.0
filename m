Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584BD4F22B6
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 07:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiDEFue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 01:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiDEFuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 01:50:32 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6545B3C7
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 22:48:27 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bg10so24396828ejb.4
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 22:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=UDHAMxs9mV1EMuLwtCxTt6T4FIB57N3ZOKBk0SEX43I=;
        b=QaFSLDRdIAu5jQgFLWMNCpzMa5yvS6h8MbRbV6I0PLoNleptEM54m2gTYRdrZBPAct
         HAEbYcso3gv2WMCfxwtzTA4rktsHyJBulhlxBvBiCLnV5KS6Bg9btgh4L6UFwwPpCdY1
         niTjGdTQ9D2/sYFebCy34OmN7lfL5Bu2yTbiBv9KtslnWEjP9b3bXILHA5TBJI9qfqWY
         jf652FCx3cAeRyFl8wIlI8G+3/F3W0AclggEj3xWO/3BKetis2VTcf9XCL9D09TySmS6
         FEJO5JS8grk9ppcmyTXVxxsHeAnnfoRKlylvzkuIoQKkRLe5FX8r9t3ytVH2nYLTNknl
         wK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=UDHAMxs9mV1EMuLwtCxTt6T4FIB57N3ZOKBk0SEX43I=;
        b=QxJJsfCSgeq8f/7tv61F8ryeSIyuxt2/TG0RgPQZ5wVrYi0Fpt0NSYkeqZIErdjvGr
         0ytG17H3vZDiTm7MwcQFNZ7eNSWdBp+cozm54QeqfArLYKP6V97bJjcmquawBp5l6ZgK
         EfDkO7jqzTqmK/DezZqFgc3QKrVPb8fBv/DpNlEavV0N/AeVRUDNkkCLjU0Tbvy7BsDC
         SvgZOtuh8SaDvleBKCsouNMOK86iikNFvNqYkiyA/dLdXzbmJ716zwaEfx28AJ9NUX7N
         NMZPMlUy4/cb02uKwU3hBZeWLIekauwwgTgT37Gf+Djxt7Kz0FP1+pYiSL7rHj/RYOw+
         fnCQ==
X-Gm-Message-State: AOAM533nRDwsy3MEJ/Fw7fWzBU7egm3R3w2eujotsRiHGAnfBdqlCuyR
        G/FsybCIZZrNRg9hyxK2M4d/mfpcmTW/rmvyStk=
X-Google-Smtp-Source: ABdhPJyZyVtRY0qmb1cHAXrDsY6J0hmABrGvKcpsHaHvh5isaDs9Pm82ZSa9uDWiwoTP46TQzvh3SdK+tIut+hmGEpE=
X-Received: by 2002:a17:907:d13:b0:6e0:b799:8fcc with SMTP id
 gn19-20020a1709070d1300b006e0b7998fccmr1836715ejc.11.1649137705679; Mon, 04
 Apr 2022 22:48:25 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Tue, 5 Apr 2022 06:48:09 +0100
Message-ID: <CAHpNFcO-iDrRSVvgogwQgkxXOogBuiLKPkQ4XQ4X0x1d9CS-MQ@mail.gmail.com>
Subject: Secure-Enable PSP + SGX + Initiator Security Virtualise 2022
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

Secure-Enable PSP + SGX + Initiator Security Virtualise 2022

Proper initiation requires at least a basic permission statement
before kernel load:RS

<VMaWare Initiator>
Firmware, bios load <init>1 }
Boot Loader <init>2         } Enclave 1
Kernel Jack on safe boot <init>3 : Enclave 2
Core Modules <init>4 Enclave 3
System <init><init><init><init><init>

(c)Rupert S https://bit.ly/VESA_BT

> > + * Some 'Enable PSP + SGX' functions require that no cached linear-to-physical address
> > + * mappings are present before they can succeed. Collaborate with
> > + * hardware via ENCLS[ETRACK] to ensure that all cached
> > + * linear-to-physical address mappings belonging to all threads of
> > + * the enclave are cleared. See sgx_encl_cpumask() for details.

Cache Buffer can hide locations from direct attack! <VERUALISE LOC>
But do involve a potential page break if not aligned

> > + * Return valid permission fields from a secinfo structure provided by
> > + * user space. The secinfo structure is required to only have bits in
> > + * the permission fields set.

Virtualise buffer can lazy IO & Lazy DMA #Thread mate DT

> > + * Ensure enclave is ready for SGX2 functions. Readiness is checked
> > + * by ensuring the hardware supports SGX2 and the enclave is initialized
> > + * and thus able to handle requests to modify pages within it.

Boot time check can validate SGX & PSP & YES Cache a relocatable table,
Direct Read required INT & IO Activations & is not Cache permitted one
presumes. DT

> > Changes since V2:
> > - Include the sgx_ioc_sgx2_ready() utility
> >   that previously was in "x86/sgx: Support relaxing of enclave page
> >   permissions" that is removed from the next version.
> > - Few renames requested >

Broken Alignment DT
Separated BASE Code DT

Strict Code Align =1
Buffer RELOC = 1
Security permission Buffer = 751

Enable PSP + SGX

https://lkml.org/lkml/2022/4/5/29
https://lkml.org/lkml/2022/4/5/27
https://lkml.org/lkml/2022/4/5/25

*****

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
