Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27ED5492F3D
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349185AbiARUWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:22:02 -0500
Received: from mxout03.lancloud.ru ([45.84.86.113]:41690 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiARUV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:21:56 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 291BD20A4270
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
CC:     Andrew Lunn <andrew@lunn.ch>, Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        KVM list <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        <linux-iio@vger.kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        "ALSA Development Mailing List" <alsa-devel@alsa-project.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        <linux-phy@lists.infradead.org>, <netdev@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Kishon Vijay Abraham I" <kishon@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Zhang Rui <rui.zhang@intel.com>,
        <platform-driver-x86@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        "Saravanan Sekar" <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Takashi Iwai <tiwai@suse.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        "William Breathitt Gray" <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        "Borislav Petkov" <bp@alien8.de>, Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <openipmi-developer@lists.sourceforge.net>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "Linux ARM" <linux-arm-kernel@lists.infradead.org>,
        <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Richard Weinberger <richard@nod.at>,
        "Mun Yew Tham" <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        "James Morse" <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        "Sebastian Reichel" <sre@kernel.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        <linux-mediatek@lists.infradead.org>,
        "Brian Norris" <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <29f0c65d-77f2-e5b2-f6cc-422add8a707d@omp.ru>
 <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
 <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru>
 <20220114202226.ugzklxv4wzr6egwj@pengutronix.de>
 <57af1851-9341-985e-7b28-d2ba86770ecb@omp.ru>
 <20220117084732.cdy2sash5hxp4lwo@pengutronix.de>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <68d3bb7a-7572-7495-d295-e1d512ef509e@omp.ru>
Date:   Tue, 18 Jan 2022 23:21:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220117084732.cdy2sash5hxp4lwo@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 1/17/22 11:47 AM, Uwe Kleine-König wrote:

[...]
>>>>>>>>> To me it sounds much more logical for the driver to check if an
>>>>>>>>> optional irq is non-zero (available) or zero (not available), than to
>>>>>>>>> sprinkle around checks for -ENXIO. In addition, you have to remember
>>>>>>>>> that this one returns -ENXIO, while other APIs use -ENOENT or -ENOSYS
>>>>>>>>> (or some other error code) to indicate absence. I thought not having
>>>>>>>>> to care about the actual error code was the main reason behind the
>>>>>>>>> introduction of the *_optional() APIs.
>>>>>>>
>>>>>>>> No, the main benefit of gpiod_get_optional() (and clk_get_optional()) is
>>>>>>>> that you can handle an absent GPIO (or clk) as if it were available.
>>>>>>
>>>>>>    Hm, I've just looked at these and must note that they match 1:1 with
>>>>>> platform_get_irq_optional(). Unfortunately, we can't however behave the
>>>>>> same way in request_irq() -- because it has to support IRQ0 for the sake
>>>>>> of i8253 drivers in arch/...
>>>>>
>>>>> Let me reformulate your statement to the IMHO equivalent:
>>>>>
>>>>> 	If you set aside the differences between
>>>>> 	platform_get_irq_optional() and gpiod_get_optional(),
>>>>
>>>>    Sorry, I should make it clear this is actually the diff between a would-be
>>>> platform_get_irq_optional() after my patch, not the current code...
>>>
>>> The similarity is that with your patch both gpiod_get_optional() and
>>> platform_get_irq_optional() return NULL and 0 on not-found. The relevant
>>> difference however is that for a gpiod NULL is a dummy value, while for
>>> irqs it's not. So the similarity is only syntactically, but not
>>> semantically.
>>
>>    I have noting to say here, rather than optional IRQ could well have a different
>> meaning than for clk/gpio/etc.
>>
>> [...]
>>>>> However for an interupt this cannot work. You will always have to check
>>>>> if the irq is actually there or not because if it's not you cannot just
>>>>> ignore that. So there is no benefit of an optional irq.
>>>>>
>>>>> Leaving error message reporting aside, the introduction of
>>>>> platform_get_irq_optional() allows to change
>>>>>
>>>>> 	irq = platform_get_irq(...);
>>>>> 	if (irq < 0 && irq != -ENXIO) {
>>>>> 		return irq;
>>>>> 	} else if (irq >= 0) {
>>>>
>>>>    Rather (irq > 0) actually, IRQ0 is considered invalid (but still returned).
>>>
>>> This is a topic I don't feel strong for, so I'm sloppy here. If changing
>>> this is all that is needed to convince you of my point ...
>>
>>    Note that we should absolutely (and first of all) stop returning 0 from platform_get_irq()
>> on a "real" IRQ0. Handling that "still good" zero absolutely doesn't scale e.g. for the subsystems
>> (like libata) which take 0 as an indication that the polling mode should be used... We can't afford
>> to be sloppy here. ;-)
> 
> Then maybe do that really first?

   I'm doing it first already:

https://lore.kernel.org/all/5e001ec1-d3f1-bcb8-7f30-a6301fd9930c@omp.ru/

   This series is atop of the above patch...

> I didn't recheck, but is this what the
> driver changes in your patch is about?

   Partly, yes. We can afford to play with the meaning of 0 after the above patch.

> After some more thoughts I wonder if your focus isn't to align
> platform_get_irq_optional to (clk|gpiod|regulator)_get_optional, but to
> simplify return code checking. Because with your change we have:
> 
>  - < 0 -> error
>  - == 0 -> no irq
>  - > 0 -> irq

   Mainly, yes. That's why the code examples were given in the description.

> For my part I'd say this doesn't justify the change, but at least I
> could better life with the reasoning. If you start at:
> 
> 	irq = platform_get_irq_optional(...)
> 	if (irq < 0 && irq != -ENXIO)
> 		return irq
> 	else if (irq > 0)
> 		setup_irq(irq);
> 	else
> 		setup_polling()
> 
> I'd change that to
> 
> 	irq = platform_get_irq_optional(...)
> 	if (irq > 0) /* or >= 0 ? */

   Not >= 0, no...

> 		setup_irq(irq)
> 	else if (irq == -ENXIO)
> 		setup_polling()
> 	else
> 		return irq
> 
> This still has to mention -ENXIO, but this is ok and checking for 0 just
> hardcodes a different return value.

   I think comparing with 0 is simpler (and shorter) than with -ENXIO, if you
consider the RISC CPUs, like e.g. MIPS...

> Anyhow, I think if you still want to change platform_get_irq_optional
> you should add a few patches converting some drivers which demonstrates
> the improvement for the callers.

   Mhm, I did include all the drivers where the IRQ checks have to be modified,
not sure what else you want me to touch...

> Best regards
> Uwe

MBR, Sergey
