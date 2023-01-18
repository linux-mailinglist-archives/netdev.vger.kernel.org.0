Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A92F6712DB
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 05:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjAREv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 23:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjAREvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 23:51:02 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F37F58299
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 20:50:55 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id f5-20020a9d5f05000000b00684c0c2eb3fso10006280oti.10
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 20:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=landley-net.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SG5+LTqozVDaffYtP9G7OFK+ve6ONvYEcXJy7w5V5IA=;
        b=2xgQ8d7BKLcwwadPMeowlexmkVXWEsSPqpODJH4TWAS2lm5uNK8e1M4fieHPTPkveo
         t3Lm5YJJC16UElG1A8nJSUq8aPuv+wIX7jUFaPsCyMZ0mLXxDfehTsbi1smmdb1EGuaT
         L2tpYXebysql7mHXV+upGPQkDJQJJOx/ASRuVxDgfNi38V1B9FKHRpSoImfxyHLp/pbv
         vlKbflnn9ohMsaxZdz0pUDEe8gweojqFIRQG0YusgNWcxuvou7dKQnne2YnYYJgasqm9
         BCUkRc8vOcJyLuqyXj3M3gLo7s/8X06glEYeSAnOO01aHJOitT15azlYfTpK7YwyCYmr
         7Gdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SG5+LTqozVDaffYtP9G7OFK+ve6ONvYEcXJy7w5V5IA=;
        b=LHvzlNMz0Vas6UmJxTWXk2dfhOQEZnUptTXIE9HcTPUXnBVg6HYkBcxtTZaSbKCqDU
         f98qurVO46rHzAqDoU4maJ0AlrwtYDVy1lN0A2vi4jkasGjZmta0Tkhf9U8fkvMidbL2
         O0VSfvOuNJQJZLW7fm2RLm9rDupJ06zuqSv4w4Ej8SeGl8HPvRGWHlQH2FjFJ6Lv/7LO
         6H9C1lyAgTwymaASOE28jheNJ7E7WZJ6wy+Z8Erzrpnxp/Kln4Miye5/lWsA0axshz/R
         Yd9zx37AakSWZc3EnLH8QE/77FmevCPv7hVP9hCNRoK3su1fmkcuIFzca3kCkDTsTWrl
         QFpw==
X-Gm-Message-State: AFqh2kos5YtAH5BeHSP/xH8e2rK3ux8Ixs+g4hNS0qoaR3tQoh46pvaP
        ZZz1vm+WK+ByvN73rAv3nwFgiw==
X-Google-Smtp-Source: AMrXdXtkqLH4t69dzrdV9eHzMdZnM8b7Ik4ym3FFGMboYaInpocjydohLDd6MR3dBoqxRlKFDQJoKw==
X-Received: by 2002:a05:6830:6617:b0:670:9473:c376 with SMTP id cp23-20020a056830661700b006709473c376mr14568692otb.34.1674017453985;
        Tue, 17 Jan 2023 20:50:53 -0800 (PST)
Received: from [192.168.86.224] ([136.62.38.22])
        by smtp.gmail.com with ESMTPSA id ca18-20020a056830611200b0066e873e4c2csm18404797otb.45.2023.01.17.20.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 20:50:52 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------iAbKOt5glkmuQqPl0eO0N9M6"
Message-ID: <7329212f-b1a0-41eb-99b3-a56eb1d23138@landley.net>
Date:   Tue, 17 Jan 2023 23:03:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: remove arch/sh
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
References: <20230113062339.1909087-1-hch@lst.de>
 <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
 <20230116071306.GA15848@lst.de>
 <9325a949-8d19-435a-50bd-9ebe0a432012@landley.net>
 <CAMuHMdUJm5QvzH8hvqwvn9O6qSbzNOapabjw5nh9DJd0F55Zdg@mail.gmail.com>
From:   Rob Landley <rob@landley.net>
In-Reply-To: <CAMuHMdUJm5QvzH8hvqwvn9O6qSbzNOapabjw5nh9DJd0F55Zdg@mail.gmail.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------iAbKOt5glkmuQqPl0eO0N9M6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/17/23 14:26, Geert Uytterhoeven wrote:
> Hi Rob,
> 
> On Tue, Jan 17, 2023 at 8:01 PM Rob Landley <rob@landley.net> wrote:
>> On 1/16/23 01:13, Christoph Hellwig wrote:
>> > On Fri, Jan 13, 2023 at 09:09:52AM +0100, John Paul Adrian Glaubitz wrote:
>> >> I'm still maintaining and using this port in Debian.
>> >>
>> >> It's a bit disappointing that people keep hammering on it. It works fine for me.
>> >
>> > What platforms do you (or your users) use it on?
>>
>> 3 j-core boards, two sh4 boards (the sh7760 one I patched the kernel of), and an
>> sh4 emulator.
>>
>> I have multiple j-core systems (sh2 compatible with extensions, nommu, 3
>> different kinds of boards running it here). There's an existing mmu version of
>> j-core that's sh3 flavored but they want to redo it so it hasn't been publicly
>> released yet, I have yet to get that to run Linux because the mmu code would
>> need adapting, but the most recent customer projects were on the existing nommu
>> SOC, as was last year's ASIC work via sky130.
> 
> J4 still vaporware?

The 'existing mmu version' is the theoretical basis for J4 (the move from J3 to
J4 is tiny from an instruction set perspective, it was more about internal chip
architecture, primarily multi-issue with tomasulo). It exists, but we haven't
had a product that uses it and the engineer who was tasked to work on it got
reassigned during the pandemic.

The real problem is the existing implementation is a branch off of an older SOC
version so repotting it to the current tree (which among other things builds
under a different VHDL toolchain) is some work. The "conflict requiring actual
staring at" isn't the MMU, it's the instruction cancellation logic that backs
out half-finished instructions when the MMU complains partway through an
instruction that's multiple steps of microcode, so we have to back _out_ what
it's already done so it can be cleanly restarted after handling the fault.
That's got merge conflicts all over the place with the current stuff...

Not actually _hard_, but not something we've sat down and done. We spent those
cycles last year working on an ASIC implementation through Google's Sky130
OpenLane/OpenRoad stuff (see https://github.com/j-core/openlane-vhdl-build for
our in-house toolchain build for that; Google passes around a magic docker that
most people use, we trimmed off most of the dependencies and build it in a clean
debootstrap). And that was trying to make an ASIC out of the small simple
version, because Google's entire asic/skywater partnership was... fraught?

We also tried to get the previous generation of ASIC tools to work before giving
up and trying to get what Google was working on to work:

  https://landley.net/notes-2022.html#26-01-2022
  https://landley.net/notes-2022.html#28-01-2022

We targeted "known working SOC that we've been using a long time" to try to make
a physical silicon chip out of (and the first version isn't even the J2 2xSMP
SOC with all the cache and peripherals, it was a derivative of the ICE40 port
that's single processor running straight from SRAM with no DRAM controller), on
the theory we can always do a more complicated one later an what we were really
trying to establish here is that Google's ASIC development tools and process
could be made to work. (Which is kind of a heavy lift, they burned two shuttles
full of mostly dead chips that we know of before admitting "those timing
annotations we were talking about actually DO need to go all the way through"...
Jeff has the URLs to the bug reports in OpenLane/Road's github...)

(Sorry, one of OpenLane/OpenRoad is the DARPA project out of Sandia National
Laboratory, and the other is Google doing a large extremely complicated thing
analogous to the AOSP build on top of Darpa's work using a lot different
programming languages and FOREST of build and runtime package dependencies, and
I can never remember which is which. The Google thing is the one distributed in
a docker because it's considered impossible to build rom source by everybody
except us, because we're funny that way. And added VHDL support instead of just
Verilog so needed to rebuild from source anyway to do that.)

>> My physical sh4 boards are a Johnson Controls N40 (sh7760 chipset) and the
>> little blue one is... sh4a I think? (It can run the same userspace, I haven't
>> replaced that board's kernel since I got it, I think it's the type Glaubitz is
>> using? It's mostly in case he had an issue I couldn't reproduce on different
>> hardware, or if I spill something on my N40.)
>>
>> I also have a physical sh2 board on the shelf which I haven't touched in years
>> (used to comparison test during j2 development, and then the j2 boards replaced it).
>>
>> I'm lazy and mostly test each new sh4 build under qemu -M r2d because it's
>> really convenient: neither of my physical boards boot from SD card so replacing
>> the kernel requires reflashing soldered in flash. (They'll net mount userspace
>> but I haven't gotten either bootloader to net-boot a kernel.)
> 
> On my landisk (with boots from CompactFLASH), I boot the original 2.6.22
> kernel, and use kexec to boot-test each and every renesas-drivers
> release.  Note that this requires both the original 2.6.22 kernel
> and matching kexec-tools.

I make it a point to run _current_ kernels in all my mkroot systems, including
sh4. What I shipped was 6.1 is:

# cat /proc/version
Linux version 6.1.0 (landley@driftwood) (sh4-linux-musl-cc (GCC) 9.4.0, GNU ld
(GNU Binutils) 2.33.1) #1 Tue Jan 10 16:32:07 CST 2023

At the JCI contract where I got the N40 I forward ported the kernel version to a
release that was I think 2 back from the current release because there was a
race condition in the flash support I didn't have time to track down? (Only
showed up under sustained load so the test case took hours to run, and we had a
ship schedule...)

I've been meaning to get together with somebody to get the blue board updated,
but I've been busy with other things...


> Apparently both upstreamed kernel and
> kexec-tools support for SH are different, and incompatible with each
> other, so you cannot kexec from a contemporary kernel.

Sure you can. Using toybox's insmod and modprobe, anyway. (That's the target I
tested those on... :)

Haven't messed with signing or compression or anything yet, my insmod is just
doing syscall(SYS_finit_module) and then falling back to SYS_init_module if that
fails and either fd was 0 or errno was ENOSYS. (Don't ask me why
SYS_finit_module doesn't work on stdin...)

https://github.com/landley/toybox/blob/master/toys/other/insmod.c#L31

https://landley.net/toybox/downloads/binaries/0.8.9/toybox-sh4

> I tried working my way up from 2.6.22, but gave up around 2.6.29.
> Probably I should do this with r2d and qemu instead ;-)

I have current running there. I've had current running there for years. Config
attached...

> Both r2d and landisk are SH7751.

Cool. Shouldn't be hard to get landisk running current then.

> Probably SH7722/'23'24 (e.g. Migo-R and Ecovec boards) are also
> worth keeping.  Most on-SoC blocks have drivers with DT support,
> as they are shared with ARM.  So the hardest part is clock and
> interrupt-controller support.

J-core is using device tree already. Shouldn't be hard to do a device tree for
the qemu version, and then for landisk.

> Unfortunately I no longer have access to the (remote) Migo-R.

There's more stuff in Japan, but that's a Jeff question...

Rob
--------------iAbKOt5glkmuQqPl0eO0N9M6
Content-Type: application/gzip; name="linux-fullconfig.gz"
Content-Disposition: attachment; filename="linux-fullconfig.gz"
Content-Transfer-Encoding: base64

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
9L8AAA==
--------------iAbKOt5glkmuQqPl0eO0N9M6
Content-Type: text/plain; charset=UTF-8; name="linux-miniconfig"
Content-Disposition: attachment; filename="linux-miniconfig"
Content-Transfer-Encoding: base64

IyBtYWtlIEFSQ0g9c2ggYWxsbm9jb25maWcgS0NPTkZJR19BTExDT05GSUc9bGludXgtbWlu
aWNvbmZpZwojIG1ha2UgQVJDSD1zaCAtaiAkKG5wcm9jKQojIGJvb3QgYXJjaC9zaC9ib290
L3pJbWFnZQoKCiMgYXJjaGl0ZWN0dXJlIDAKQ09ORklHX0JJTkZNVF9FTEY9eQpDT05GSUdf
QklORk1UX1NDUklQVD15CkNPTkZJR19OT19IWj15CkNPTkZJR19ISUdIX1JFU19USU1FUlM9
eQpDT05GSUdfQkxLX0RFVj15CkNPTkZJR19CTEtfREVWX0lOSVRSRD15CkNPTkZJR19SRF9H
WklQPXkKQ09ORklHX0JMS19ERVZfTE9PUD15CkNPTkZJR19FWFQ0X0ZTPXkKQ09ORklHX0VY
VDRfVVNFX0ZPUl9FWFQyPXkKQ09ORklHX1ZGQVRfRlM9eQpDT05GSUdfRkFUX0RFRkFVTFRf
VVRGOD15CkNPTkZJR19NSVNDX0ZJTEVTWVNURU1TPXkKQ09ORklHX1NRVUFTSEZTPXkKQ09O
RklHX1NRVUFTSEZTX1hBVFRSPXkKQ09ORklHX1NRVUFTSEZTX1pMSUI9eQpDT05GSUdfREVW
VE1QRlM9eQpDT05GSUdfREVWVE1QRlNfTU9VTlQ9eQpDT05GSUdfVE1QRlM9eQpDT05GSUdf
VE1QRlNfUE9TSVhfQUNMPXkKQ09ORklHX05FVD15CkNPTkZJR19QQUNLRVQ9eQpDT05GSUdf
VU5JWD15CkNPTkZJR19JTkVUPXkKQ09ORklHX0lQVjY9eQpDT05GSUdfTkVUREVWSUNFUz15
CkNPTkZJR19ORVRfQ09SRT15CkNPTkZJR19ORVRDT05TT0xFPXkKQ09ORklHX0VUSEVSTkVU
PXkKQ09ORklHX0NPTVBBVF8zMkJJVF9USU1FPXkKQ09ORklHX0VBUkxZX1BSSU5USz15CkNP
TkZJR19JS0NPTkZJRz15CkNPTkZJR19JS0NPTkZJR19QUk9DPXkKCiMgYXJjaGl0ZWN0dXJl
IHNwZWNpZmljCkNPTkZJR19DUFVfU1VCVFlQRV9TSDc3NTFSPXkKQ09ORklHX01NVT15CkNP
TkZJR19WU1lTQ0FMTD15CkNPTkZJR19TSF9GUFU9eQpDT05GSUdfU0hfUlRTNzc1MVIyRD15
CkNPTkZJR19SVFM3NzUxUjJEX1BMVVM9eQpDT05GSUdfU0VSSUFMX1NIX1NDST15CkNPTkZJ
R19TRVJJQUxfU0hfU0NJX0NPTlNPTEU9eQpDT05GSUdfUENJPXkKQ09ORklHX05FVF9WRU5E
T1JfUkVBTFRFSz15CkNPTkZJR184MTM5Q1A9eQpDT05GSUdfUENJPXkKQ09ORklHX0JMS19E
RVZfU0Q9eQpDT05GSUdfQVRBPXkKQ09ORklHX0FUQV9TRkY9eQpDT05GSUdfQVRBX0JNRE1B
PXkKQ09ORklHX1BBVEFfUExBVEZPUk09eQpDT05GSUdfQklORk1UX0VMRl9GRFBJQz15CkNP
TkZJR19CSU5GTVRfRkxBVD15CgojIGFyY2hpdGVjdHVyZSBzcGVjaWZpYwpDT05GSUdfTU9E
VUxFUz15CkNPTkZJR19NT0RVTEVfVU5MT0FEPXkKCkNPTkZJR19GU0NBQ0hFPW0KQ09ORklH
X0NBQ0hFRklMRVM9bQoKQ09ORklHX01FTU9SWV9TVEFSVD0weDBjMDAwMDAwCg==

--------------iAbKOt5glkmuQqPl0eO0N9M6--
