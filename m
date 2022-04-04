Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9804F20E5
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 06:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiDECj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 22:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiDECjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 22:39:47 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74354286F4C
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 18:41:48 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id d5so20521620lfj.9
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 18:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=CWwE63Uj70Dz+evqLhQ44oFva+2asIsEVowZ5R1Hj4s=;
        b=MTLi0SN2/CtQ9VsgDxb4iZw37Af+lcedVzKzwlt/rmiU3szSaf1Mv3N/u9xi3EjKW4
         As58Mj2xb6L0b04HBhREhOF8LOwlWJtKm6vySkVCOclR11PWOC6bhMTYqgE05YJhtBdb
         5OQ3jY3GywxxqaPBCQtQbevm0MzOCT72UjiWNZM4dmLvb5WJEN1gYU8dQ6hroNZA1ZCP
         S8AMDnex+b44bPoRiKsyTACN7qHEPi1mkQP3F4JZWO4U0iSsQNR5wQRuyMUb73/7G4qF
         n6uxWWdRtzpkW2SMWrnLG/oq95ZvLjK62GJT9FntZmFsCbAyqgHqvFNdWlyOAPhHY5mH
         T0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=CWwE63Uj70Dz+evqLhQ44oFva+2asIsEVowZ5R1Hj4s=;
        b=zIzDPe+deJA352SSsRWbJxyOX+FIkZK9VfY70pZuTMN+h5ZifYK85rKoEBgm6zoM/T
         MTo6y8xVY5l+qZRNu2Iz2yLjQ6ovNAYxqqqrWLJbEHlr6KkV+eJOMAeJS9ilH1/V6pjO
         fSzw7eF0TWEEffhGcR98gc8roAsJJsBURa513apyibt+WrIQ6kBG2xSMCES/uTuL9MiC
         SgwWQ8KfjA1FFSj5nhqQF+NIqMPO6eHEiQ4vixf69aZ0sHDgw1pROcigZtCwAKgkItC3
         B3LHcBoFk1I37H/2PQwEPGraM76gvmBizi4ZzsVDfsIhGl8nE1d9SRgMVojEORRA/HJu
         msFQ==
X-Gm-Message-State: AOAM531O9vv/meQwjSc8Qh7rirPf5WfX2Gghy08umh2kOCE4CEPKwgWw
        z7K3aaHbiviLWqyEgrzhistBnoeBKdCLpFO1F8n3C0S7qb+WqizC
X-Google-Smtp-Source: ABdhPJzBsKO2j9MyoYnx+NlhM7baoEAm89DrhoHnN5DW27ua2r0tUJkiTippVbrs/IZPEpxjLGP1OVm7wmko/9JjohY=
X-Received: by 2002:a05:6402:3604:b0:41c:c4e6:2988 with SMTP id
 el4-20020a056402360400b0041cc4e62988mr631649edb.157.1649115815748; Mon, 04
 Apr 2022 16:43:35 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Tue, 5 Apr 2022 00:43:24 +0100
Message-ID: <CAHpNFcPWphMzXVYiPtkyUVBUQKWUc_cW4NkG4k4xeiGbUYBHhA@mail.gmail.com>
Subject: Parallax Cryptographic Processing Unit: RS AES-CCM & AES-GCM & Other
 Cypher Modulus + CCM & GCM can be accelerated with a joint AES Crypto module
 : Modulus Dual Encrypt & Decrypt package : Processor feature
To:     torvalds@linux-foundation.org
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

Duke Abbaddon <duke.abbaddon@gmail.com>
Mon, Apr 4, 10:41 AM (13 hours ago)
to torvalds, bcc: heiko, bcc: guoren, bcc: atish.patra, bcc: hch, bcc:
Anup, bcc: :, bcc: Dennis, bcc: ebiggers@kernel.org, bcc: Emil, bcc:
jarkko@kernel.org, bcc: Jonathan, bcc: keyrings@vger.kernel.org, bcc:
kvalo@kernel.org, bcc: linux-crypto@vger.kernel.org, bcc:
linux-iio@vger.kernel.org, bcc: linux-integrity@vger.kernel.org, bcc:
linux-kernel@vger.kernel.org, bcc: linux-mips@vger.kernel.org, bcc:
linux-security-module@vger.kernel.org, bcc:
linux-wireless@vger.kernel.org, bcc: luto@kernel.org, bcc: Nathan,
bcc: netdev@vger.kernel.org, bcc: sultan@kerneltoast.com, bcc:
ak@linux.intel.com, bcc: Andrew, bcc: Andy, bcc:
development@linux.org, bcc: feedback@linux.org, bcc:
geert@linux-m68k.org, bcc: Greg, bcc: hostmaster+ntp@linux-ia64.org,
bcc: jejb@linux.ibm.com, bcc: kirill.shutemov@linux.intel.com, bcc:
linus@linux.org, bcc: linux-m68k@lists.linux-m68k.org, bcc:
linux-riscv@lists.infradead.org, bcc: linux@dominikbrodowski.net, bcc:
Micha=C5=82, bcc: press@linux.org, bcc: Rasmus, bcc:
sathyanarayanan.kuppuswamy@linux.intel.com, bcc: security@linux.org,
bcc: support@linux.org, bcc: torvalds@linux-foundation.org, bcc:
webmaster@linux.org, bcc: zohar@linux.ibm.com, bcc:
info@vialicensing.com, bcc: corpcomm@qualcomm.com, bcc:
rukikaire@un.org, bcc: virt-owner@lists.fedoraproject.org, bcc:
martin@strongswan.org, bcc: security@microsoft.com, bcc:
sotonino@un.org, bcc: security@ubuntu.com, bcc:
opencode@microsoft.com, bcc: moses.osani@un.org, bcc:
webmaster@playstation.com, bcc: webmaster@amazon.com, bcc:
Corporate.Secretary@amd.com, bcc: haqf@un.org, bcc:
Copyright_Agent@spe.sony.com, bcc: tremblay@un.org, bcc:
webmaster@sony.com, bcc: dujarric@un.org, bcc: consul@ps.mofa.go.jp,
bcc: press@eu.sony.com, bcc: agriculture@rusemb.org.uk, bcc:
suzuki.poulose@arm.com, bcc: grovesn@un.org, bcc: kaneko@un.org, bcc:
media.help@apple.com, bcc: security@asus.com, bcc:
visa@egyptconsulate.co.uk, bcc: help.redhat.com, bcc:
cirrus_logic@pr-tocs.co.jp, bcc: customercare@logitech.com, bcc: Logi,
bcc: logitech@feverpr.com, bcc: logitech@vertigo6.nl, bcc:
logitech@wellcom.fr, bcc: mediarelations@logitech.com, bcc:
morchard@scottlogic.co.uk, bcc: samasaki@logitech.com, bcc:
slan@logitech.com, bcc: support@logitech.com, bcc: pctech@realtek.com,
bcc: press@google.com, bcc: Nintendo, bcc: tech.support@amd.com, bcc:
Nvidia, bcc: security@intel.com, bcc: saporit@us.ibm.com, bcc:
Gabriel.Kerneis@ssi.gouv.fr, bcc: hughsient@gmail.com, bcc:
ksuzuki@polyphony.co.jp, bcc: uchimura@polyphony.co.jp, bcc:
mario.limonciello@amd.com, bcc: thomas.lendacky@amd.com, bcc:
john.allen@amd.com, bcc: herbert@gondor.apana.org.au

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

Performance Comparison of AES-CCM and AES-GCM Authenticated Encryption Mode=
s
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

ICE-SSRTP Encryption AES,Blake2, Poly ChaCha, SM4, SHA2, SHA3, GEA-1 and GE=
A-2
'Ideal for USB Dongle & Radio' in Rust RS ' Ideal for Quality TPM
Implementation'

"GEA-1 and GEA-2, which are very similar (GEA-2 is just an extension
of GEA-1 with a higher amount of processing, and apparently not
weakened) are bit-oriented stream ciphers."

IiCE-SSRTP : Interleaved Inverted Signal Send & Receive Time Crystal Protoc=
ol

Interleaved signals help Isolate noise from a Signal Send & Receive ...

Overlapping inverted waves are a profile for complex audio & FFT is the res=
ult.

Interleaved, Inverted & Compressed & a simple encryption?

*

Time differentiated : Interleave, Inversion & differentiating Elliptic curv=
e.

We will be able to know and test the Cypher : PRINCIPLE OF INTENT TO TRUST

We know of a cypher but : (Principle RS)

We blend the cypher..
Interleaved pages of a cypher obfuscate : PAL CScam does this

Timed : Theoretically unique to you in principle for imprecision, But
we cannot really have imprecise in Crypto!

But we can have a set time & in effect Elliptic curve a transient variable =
T,
With this, Interleave the resulting pages (RAM Buffer Concept)

Invert them over Time Var =3D T

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

On AES-NI & ARM Cryptographic processors; In particular PSP+PPS(ARM+) & SiM=
D ..

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

Performance Comparison of AES-CCM and AES-GCM Authenticated Encryption Mode=
s
http://worldcomp-proceedings.com/proc/p2016/SAM9746.pdf

Basic comparison of Modes for Authenticated-Encryption -IAPM, XCBC,
OCB, CCM, EAX, CWC, GCM, PCFB, CS
https://www.fi.muni.cz/~xsvenda/docs/AE_comparison_ipics04.pdf


*

Example of use:

Nostalgic TriBand : Independence RADIO : Send : Receive :Rebel-you trade ma=
rker

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

SSD & HDD Cables & does signal inversion help us? Do interleaving bands hel=
p us?

In Audio inversion would be a strange way to hear! but the inversion
does help alleviate ...

Transistor emission fatigue...

IiCE-SSRTP : Interleaved Inverted Signal Send & Receive Time Crystal Protoc=
ol

Interleaved signals help Isolate noise from a Signal Send & Receive ...

Overlapping inverted waves are a profile for complex audio & FFT is the res=
ult.

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

*

***** Dukes Of THRUST ******

Nostalgic TriBand : Independence RADIO : Send : Receive :Rebel-you trade ma=
rkerz

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

https://drive.google.com/file/d/1b_Sl1oI7qTlc6__ihLt-N601nyLsY7QU/view?usp=
=3Ddrive_web
https://drive.google.com/file/d/1yi4ERt0xdPc9ooh9vWrPY1LV_eXV-1Wc/view?usp=
=3Ddrive_web
https://drive.google.com/file/d/11dKUNl0ngouSIJzOD92lO546tfGwC0tu/view?usp=
=3Ddrive_web
https://drive.google.com/file/d/10a0E4Gh5S-itzBVh0fOaxS7JS9ru-68T/view?usp=
=3Ddrive_web

https://github.com/P1sec/gea-implementation
