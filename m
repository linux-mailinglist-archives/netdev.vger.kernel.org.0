Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB71E68FD75
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 03:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbjBIC5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 21:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjBICzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 21:55:53 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1DC34301
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 18:53:23 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-16346330067so1000887fac.3
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 18:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=landley-net.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uim76Lm5dMHI6OEZRl5dYh1Pi4k74h79vxsD8ejV228=;
        b=cGJLZWh92YeqRetjDZ7mm7cWN9+7V9DkC4NxT3TFyzxOr/dT+y9RySdTXQJoGNFodj
         Lhk5mURgRjvFpcDTTz997u4uYb5mXXSYufkvOHW16uecAigBafpKfrfPhjupqfB69TqU
         CpdJtnnu16tBfQsfiDPbx5CJt8woI9p/61QJECQkg6ib53DsbPoG/6qEIFtT82h7XZEd
         bH7zIZ7zeIu+guqsHWHH7HwzmCW5uJfaHSVq8vhoIZZxTs9cCuui2tEeecApAXxH34Kl
         VCUo/SLo54vsVKd1HLhUdcTfFi+wK+KZOUpQFgXm1zVH8Gmha3IwtqAbksT7XdA8QMjg
         0+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uim76Lm5dMHI6OEZRl5dYh1Pi4k74h79vxsD8ejV228=;
        b=OBnIcY0i0uJ4PiDIltvyumLMm/oShVFU+42nGU8qy8CZHD74ypJBNol+wTjW4vauOG
         b5jQMfHSGdDHc3kqjSSHSNF0ocggh5KPyTzuP9ZZEg9J2D0eOkecJye6AKSCcqsV/kC7
         GlIgeFS3TPQ+GYgIJeQQIg6Q30Z/wjTDVZ/WF4IZqw7sh2XHw7CmEzccGna7SAEpeilY
         jQae9pakUqthZJXTXQGvdQthlnFOLZJ7TB8Vcyp/Q/+jcmhUCJxPtGKSZbk4fhQ/3qDc
         VAci9uqgvNB4Vnh+H8MWg30CSOcM8oxWMDgtwIRPROEbAypJ7uNJOVWbsEwwbYn06uKT
         n3OQ==
X-Gm-Message-State: AO0yUKXZqATYg/Lx4GVM61dsS+C7UTuRafxDY6e2WKeBojFnYz1XPR0p
        EELLQzpuBtexY0xHL5ZDoqnIAQ==
X-Google-Smtp-Source: AK7set/IY8hpNoA4Lil9GPnYxD0kM8QMzh26dc48QApuMMt+T/W+mzLQoVZI9oh721NfnL8VF3E7Fg==
X-Received: by 2002:a05:6870:7386:b0:163:ad96:f89c with SMTP id z6-20020a056870738600b00163ad96f89cmr5551951oam.15.1675911202632;
        Wed, 08 Feb 2023 18:53:22 -0800 (PST)
Received: from [192.168.86.224] ([136.62.38.22])
        by smtp.gmail.com with ESMTPSA id v6-20020a4a5a06000000b00517b076e071sm100253ooa.47.2023.02.08.18.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 18:53:21 -0800 (PST)
Message-ID: <b394bf10-2fc5-6498-955f-a904a756e0c9@landley.net>
Date:   Wed, 8 Feb 2023 21:06:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: remove arch/sh
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     Christoph Hellwig <hch@lst.de>,
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
 <40dc1bc1-d9cd-d9be-188e-5167ebae235c@physik.fu-berlin.de>
 <20230203071423.GA24833@lst.de>
 <afd056a95d21944db1dc0c9708f692dd1f7bb757.camel@physik.fu-berlin.de>
 <20230203083037.GA30738@lst.de>
 <d10fe31b2af6cf4e03618f38ca9d3ca5c72601ed.camel@physik.fu-berlin.de>
 <CAMuHMdUitVfW088YOmqYm4kwbKwkwb22fAakHcu6boxv7dXDfQ@mail.gmail.com>
 <f6a60193-a5d1-c42c-158a-4b0bfe9c7538@infradead.org>
From:   Rob Landley <rob@landley.net>
In-Reply-To: <f6a60193-a5d1-c42c-158a-4b0bfe9c7538@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/23 09:57, Randy Dunlap wrote:
> Hi--
> 
> On 2/3/23 02:33, Geert Uytterhoeven wrote:
>> Hi Adrian,
>> 
>> On Fri, Feb 3, 2023 at 11:29 AM John Paul Adrian Glaubitz
>> <glaubitz@physik.fu-berlin.de> wrote:
>>> On Fri, 2023-02-03 at 09:30 +0100, Christoph Hellwig wrote:
>>>> On Fri, Feb 03, 2023 at 09:24:46AM +0100, John Paul Adrian Glaubitz wrote:
>>>>> Since this is my very first time stepping up as a kernel maintainer, I was hoping
>>>>> to get some pointers on what to do to make this happen.
>>>>>
>>>>> So far, we have set up a new kernel tree and I have set up a local development and
>>>>> test environment for SH kernels using my SH7785LCR board as the target platform.
>>>>>
>>>>> Do I just need to send a patch asking to change the corresponding entry in the
>>>>> MAINTAINERS file?
>>>>
>>>> I'm not sure a there is a document, but:
>>>>
>>>>  - add the MAINTAINERS change to your tree
>>>>  - ask Stephen to get your tree included in linux-next
>>>>
>>>> then eventually send a pull request to Linus with all of that.  Make
>>>> sure it's been in linux-next for a while.
>>>
>>> OK, thanks for the pointers! Will try to get this done by next week.
>>>
>>> We're still discussing among SuperH developer community whether there will be a second
>>> maintainer, so please bear with us a few more days. I will collect patches in the
>>> meantime.
>> 
>> Thanks a lot!
>> 
>> If you need any help with process, setup, ... don't hesitate to ask
>> (on e.g. #renesas-soc on Libera).
> 
> While Adrian and Geert are reading this, I have a question:
> 
> Is this "sh64" still accurate and applicable?

I hadn't noticed it was there... Randy Dunlap added that in 2018 (commit
09b1565324cba). I wonder why?

> from Documentation/kbuild/kbuild.rst:

There isn't an active 64 bit superh architecture for the moment: sh5 was a
prototype that never shipped in volume, and support was removed in commit
37744feebc08. From the j-core side j64 hasn't shipped yet either (still planned
last I heard, but j-core went downmarket first instead due to customer demand,
and multi-issue is on the roadmap before 64 bit address space).

The general trend in linux kernel architectures has been to merge 32 and 64 bit
anyway, and just have the .config set CONFIG_64BIT to distinguish: arch/x86 was
created by merging arch/i386 and arch/x86_64 in 2007, arch/powerpc merged the 32
and 64 bit directories in 2005, arch/s390 and s390x are in the same dir,
arch/mips... (For some reason arm and arm64 are still split, but that might be
fallout from Arm Ltd trying to distinguish aarrcchh6644 from "arm" for some
reason? Dunno.)

I wonder why is this going the other way? I thought $ARCH mostly just specified
the subdirectory under arch/ with a few historical aliases in the top level
Makefile:

# Additional ARCH settings for x86
ifeq ($(ARCH),i386)
        SRCARCH := x86
endif
ifeq ($(ARCH),x86_64)
        SRCARCH := x86
endif

# Additional ARCH settings for sparc
ifeq ($(ARCH),sparc32)
       SRCARCH := sparc
endif
ifeq ($(ARCH),sparc64)
       SRCARCH := sparc
endif

# Additional ARCH settings for parisc
ifeq ($(ARCH),parisc64)
       SRCARCH := parisc
endif

But you could always just specify the correct ARCH directory directly and it
would work. (Always did when I tried it, although I haven't built sparc in years
because there's no musl-libc support, and never built parisc64 because I
couldn't get it to work with uClibc even before musl. I _am_ still building both
32 bit and 64 bit x86 with ARCH=x86 both times...)

> But some architectures such as x86 and sparc have aliases.
> 
> - x86: i386 for 32 bit, x86_64 for 64 bit
> - sh: sh for 32 bit, sh64 for 64 bit <<<<<<<<<<<<<<<
> - sparc: sparc32 for 32 bit, sparc64 for 64 bit

Randy also added the sparc alias in commit 5ba800962a80. That at least exists in
the top level Makefile.

Did he mean parisc64 and typoed sh64? Because that's the only other alias in the
top level Makefile...

In any case, these are historical aliases for old builds, which can probably get
yanked because it should be a trivial fix to use the right ARCH= value for
modern builds? (I'd think?)

You'd even be able to build a 64 bit version of ARCH=i386 just fine if it wasn't
for the ONE place in arch/x86/Kconfig that actually checks:

config 64BIT
        bool "64-bit kernel" if "$(ARCH)" = "x86"
        default "$(ARCH)" != "i386"

Same for arch/sparc/Kconfig:

config 64BIT
        bool "64-bit kernel" if "$(ARCH)" = "sparc"
        default "$(ARCH)" = "sparc64"

Nothing else anywhere seems to care...

> Thanks.

Rob
