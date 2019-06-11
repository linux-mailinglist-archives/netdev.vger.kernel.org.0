Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214853C6D3
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 11:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404784AbfFKJAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 05:00:49 -0400
Received: from foss.arm.com ([217.140.110.172]:55810 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403860AbfFKJAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 05:00:49 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCA2E337;
        Tue, 11 Jun 2019 02:00:47 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0612D3F73C;
        Tue, 11 Jun 2019 02:00:42 -0700 (PDT)
Subject: Re: [PATCH] wlcore/wl18xx: Add invert-irq OF property for physically
 inverted IRQ
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Lindgren <tony@atomide.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Spyridon Papageorgiou <spapageorgiou@de.adit-jv.com>,
        Joshua Frkuska <joshua_frkuska@mentor.com>,
        "George G . Davis" <george_davis@mentor.com>,
        Andrey Gusakov <andrey.gusakov@cogentembedded.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>, eyalr@ti.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
References: <20190607172958.20745-1-erosca@de.adit-jv.com>
 <87tvcxncuq.fsf@codeaurora.org> <20190610083012.GV5447@atomide.com>
 <CAMuHMdUOc17ocqmt=oNmyN1UT_K7_y=af1pwjwr5PTgQL2o2OQ@mail.gmail.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <08bc4755-5f47-d792-8b5a-927b5fbe7619@arm.com>
Date:   Tue, 11 Jun 2019 10:00:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUOc17ocqmt=oNmyN1UT_K7_y=af1pwjwr5PTgQL2o2OQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/06/2019 09:45, Geert Uytterhoeven wrote:
> CC irqchip
> 
> Original thread at
> https://lore.kernel.org/lkml/20190607172958.20745-1-erosca@de.adit-jv.com/
> 
> On Mon, Jun 10, 2019 at 10:30 AM Tony Lindgren <tony@atomide.com> wrote:
>> * Kalle Valo <kvalo@codeaurora.org> [190610 07:01]:
>>> Eugeniu Rosca <erosca@de.adit-jv.com> writes:
>>>
>>>> The wl1837mod datasheet [1] says about the WL_IRQ pin:
>>>>
>>>>  ---8<---
>>>> SDIO available, interrupt out. Active high. [..]
>>>> Set to rising edge (active high) on powerup.
>>>>  ---8<---
>>>>
>>>> That's the reason of seeing the interrupt configured as:
>>>>  - IRQ_TYPE_EDGE_RISING on HiKey 960/970
>>>>  - IRQ_TYPE_LEVEL_HIGH on a number of i.MX6 platforms
>>>>
>>>> We assert that all those platforms have the WL_IRQ pin connected
>>>> to the SoC _directly_ (confirmed on HiKey 970 [2]).
>>>>
>>>> That's not the case for R-Car Kingfisher extension target, which carries
>>>> a WL1837MODGIMOCT IC. There is an SN74LV1T04DBVR inverter present
>>>> between the WLAN_IRQ pin of the WL18* chip and the SoC, effectively
>>>> reversing the requirement quoted from [1]. IOW, in Kingfisher DTS
>>>> configuration we would need to use IRQ_TYPE_EDGE_FALLING or
>>>> IRQ_TYPE_LEVEL_LOW.
>>>>
>>>> Unfortunately, v4.2-rc1 commit bd763482c82ea2 ("wl18xx: wlan_irq:
>>>> support platform dependent interrupt types") made a special case out
>>>> of these interrupt types. After this commit, it is impossible to provide
>>>> an IRQ configuration via DTS which would describe an inverter present
>>>> between the WL18* chip and the SoC, generating the need for workarounds
>>>> like [3].
>>>>
>>>> Create a boolean OF property, called "invert-irq" to specify that
>>>> the WLAN_IRQ pin of WL18* is connected to the SoC via an inverter.
>>>>
>>>> This solution has been successfully tested on R-Car H3ULCB-KF-M06 using
>>>> the DTS configuration [4] combined with the "invert-irq" property.
>>>>
>>>> [1] http://www.ti.com/lit/ds/symlink/wl1837mod.pdf
>>>> [2] https://www.96boards.org/documentation/consumer/hikey/hikey970/hardware-docs/
>>>> [3] https://github.com/CogentEmbedded/meta-rcar/blob/289fbd4f8354/meta-rcar-gen3-adas/recipes-kernel/linux/linux-renesas/0024-wl18xx-do-not-invert-IRQ-on-WLxxxx-side.patch
>>>> [4] https://patchwork.kernel.org/patch/10895879/
>>>>     ("arm64: dts: ulcb-kf: Add support for TI WL1837")
>>>>
>>>> Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
>>>
>>> Tony&Eyal, do you agree with this?
>>
>> Yeah if there's some hardware between the WLAN device and the SoC
>> inverting the interrupt, I don't think we have clear a way to deal
>> with it short of setting up a separate irqchip that does the
>> translation.
> 
> Yeah, inverting the interrupt type in DT works only for simple devices,
> that don't need configuration.
> A simple irqchip driver that just inverts the type sounds like a good
> solution to me. Does something like that already exists?

We already have plenty of that in the tree, the canonical example
probably being drivers/irqchip/irq-mtk-sysirq.c. It should be pretty
easy to turn this driver into something more generic.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
