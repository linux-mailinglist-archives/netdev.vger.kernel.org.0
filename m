Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756B0493D4F
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 16:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355803AbiASPfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 10:35:07 -0500
Received: from mxout03.lancloud.ru ([45.84.86.113]:36576 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238476AbiASPfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 10:35:02 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 761F020F6A92
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
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
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        <linux-phy@lists.infradead.org>, Jiri Slaby <jirislaby@kernel.org>,
        <openipmi-developer@lists.sourceforge.net>,
        "Khuong Dinh" <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        "Bartosz Golaszewski" <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "Sebastian Reichel" <sre@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        <platform-driver-x86@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        <netdev@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        "James Morse" <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        <linux-mediatek@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <29f0c65d-77f2-e5b2-f6cc-422add8a707d@omp.ru>
 <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
 <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru>
 <20220114202226.ugzklxv4wzr6egwj@pengutronix.de>
 <57af1851-9341-985e-7b28-d2ba86770ecb@omp.ru>
 <20220117084732.cdy2sash5hxp4lwo@pengutronix.de>
 <68d3bb7a-7572-7495-d295-e1d512ef509e@omp.ru>
 <20220118222606.3iwuzbenl7g6oeiq@pengutronix.de>
Organization: Open Mobile Platform
Message-ID: <b6b059bd-1491-26e2-9ba4-d34705a7106d@omp.ru>
Date:   Wed, 19 Jan 2022 18:34:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220118222606.3iwuzbenl7g6oeiq@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 1/19/22 1:26 AM, Uwe Kleine-König wrote:

[...]
>>>>>>> However for an interupt this cannot work. You will always have to check
>>>>>>> if the irq is actually there or not because if it's not you cannot just
>>>>>>> ignore that. So there is no benefit of an optional irq.
>>>>>>>
>>>>>>> Leaving error message reporting aside, the introduction of
>>>>>>> platform_get_irq_optional() allows to change
>>>>>>>
>>>>>>> 	irq = platform_get_irq(...);
>>>>>>> 	if (irq < 0 && irq != -ENXIO) {
>>>>>>> 		return irq;
>>>>>>> 	} else if (irq >= 0) {
>>>>>>
>>>>>>    Rather (irq > 0) actually, IRQ0 is considered invalid (but still returned).
>>>>>
>>>>> This is a topic I don't feel strong for, so I'm sloppy here. If changing
>>>>> this is all that is needed to convince you of my point ...
>>>>
>>>>    Note that we should absolutely (and first of all) stop returning 0 from platform_get_irq()
>>>> on a "real" IRQ0. Handling that "still good" zero absolutely doesn't scale e.g. for the subsystems
>>>> (like libata) which take 0 as an indication that the polling mode should be used... We can't afford
>>>> to be sloppy here. ;-)
>>>
>>> Then maybe do that really first?
>>
>>    I'm doing it first already:
>>
>> https://lore.kernel.org/all/5e001ec1-d3f1-bcb8-7f30-a6301fd9930c@omp.ru/
>>
>>    This series is atop of the above patch...
> 
> Ah, I missed that (probably because I didn't get the cover letter).
> 
>>> I didn't recheck, but is this what the
>>> driver changes in your patch is about?
>>
>>    Partly, yes. We can afford to play with the meaning of 0 after the above patch.
> 
> But the changes that are in patch 1 are all needed?

   Yes, they follow from the platform_get_irq_optional() changing the sense of its result...
 
[...]
>>> For my part I'd say this doesn't justify the change, but at least I
>>> could better life with the reasoning. If you start at:
>>>
>>> 	irq = platform_get_irq_optional(...)
>>> 	if (irq < 0 && irq != -ENXIO)
>>> 		return irq
>>> 	else if (irq > 0)
>>> 		setup_irq(irq);
>>> 	else
>>> 		setup_polling()
>>>
>>> I'd change that to
>>>
>>> 	irq = platform_get_irq_optional(...)
>>> 	if (irq > 0) /* or >= 0 ? */
>>
>>    Not >= 0, no...
>>
>>> 		setup_irq(irq)
>>> 	else if (irq == -ENXIO)
>>> 		setup_polling()
>>> 	else
>>> 		return irq
>>>
>>> This still has to mention -ENXIO, but this is ok and checking for 0 just
>>> hardcodes a different return value.
>>
>>    I think comparing with 0 is simpler (and shorter) than with -ENXIO, if you
>> consider the RISC CPUs, like e.g. MIPS...
> 
> Hmm, I don't know MIPS good enough to judge. So I created a small C

   MIPS has read-only register 0 (containing 0 :-)) which should simplify things. But
I'd have to check the actual object code... yeah, MIPS has a branching instruction that
compares 2 registers and branches on the result'; with -ENXIO you'd have to load an
immediate value into a register first... 

> file:
> 
> 	$ cat test.c
> 	#include <errno.h>
> 
> 	int platform_get_irq_optional(void);
> 	void a(void);
> 
> 	int func_0()
> 	{
> 		int irq = platform_get_irq_optional();
> 
> 		if (irq == 0)
> 			a();
> 	}
> 
> 	int func_enxio()
> 	{
> 		int irq = platform_get_irq_optional();
> 
> 		if (irq == -ENXIO)
> 			a();
> 	}
> 
> With some cross compilers as provided by Debian doing
> 
> 	$CC -c -O3 test.c

   Mhm, do we really use -O3 to build the kernel?

> 	nm --size-sort test.o
> 
> I get:
> 
>   compiler			|  size of func_0  | size of func_enxio
> ================================+==================|====================
> aarch64-linux-gnu-gcc		| 0000000000000024 | 0000000000000028
> arm-linux-gnueabi-gcc		|         00000018 |         00000018
> arm-linux-gnueabihf-gcc		|         00000010 |         00000012

   Hm, 2 bytes only -- perhaps Thumb mode?

> i686-linux-gnu-gcc		|         0000002a |         0000002a

   Expected.

> mips64el-linux-gnuabi64-gcc	| 0000000000000054 | 000000000000005c

   That's even more than expected -- 64-bit mode used?

> powerpc-linux-gnu-gcc		|         00000058 |         00000058

   Well, they say

> s390x-linux-gnu-gcc		| 000000000000002e | 0000000000000030
> x86_64-linux-gnu-gcc		| 0000000000000022 | 0000000000000022

   Again, as expected...

> So you save some bytes indeed.

   I see you have a lot of spare time (unlike me!). :-)

>>> Anyhow, I think if you still want to change platform_get_irq_optional
>>> you should add a few patches converting some drivers which demonstrates
>>> the improvement for the callers.
>>
>>    Mhm, I did include all the drivers where the IRQ checks have to be modified,
>> not sure what else you want me to touch...
> 
> I somehow expected that the changes that are now necessary (or possible)
> to callers makes them prettier somehow. Looking at your patch again:

   I think they do...

> 
>  - drivers/counter/interrupt-cnt.c
>    This one is strange in my eyes because it tests the return value of
>    gpiod_get_optional against NULL :-(

   Mhm, how is this connected with my patch? :-/

>  - drivers/edac/xgene_edac.c
>    This one just wants a silent irq lookup and then throws away the
>    error code returned by platform_get_irq_optional() to return -EINVAL.
>    Not so nice, is it?

   I have dropped this file from my (to be posted yet) v2... sorry that it
took so long...

>  - drivers/gpio/gpio-altera.c
>    This one just wants a silent irq lookup. And maybe it should only
>    goto skip_irq if the irq was not found, but on an other error code
>    abort the probe?!

  That's debatable... but anyway it's a matter of a separate (follow up)
patch...

> 
>  - drivers/gpio/gpio-mvebu.c
>    Similar to gpio-altera.c: Wants a silent irq and improved error
>    handling.

   Same as above...

>  - drivers/i2c/busses/i2c-brcmstb.c
>    A bit ugly that we now have dev->irq == 0 if the irq isn't available,
>    but if requesting the irq failed irq = -1 is used?

   This doesn't matter much really but can change to 0, if you want... :-)

> 
>  - drivers/mmc/host/sh_mmcif.c
>    Broken error handling. This one wants to abort on irq[1] < 0 (with
>    your changed semantic).

   Again, matter of a separate patch (I don't have the guily hardware anymore
but I guess Geert could help with that).

> I stopped here.

   Note that most of your complaints are about the existing driver logic --
which my patch just couldn't deal with... I currently don't have the bandwidth
for addressing all your complaints; some (more obvious) I'm goiing to address
as the time permits, the draft patches have been done already...

> It seems quite common that drivers assume a value < 0 returned by
> platform_get_irq means not-found

   Of course, before this patch -ENXIO meant IRQ-not-found, many drivers
don't bother to filter it out separately (for simplicity?).

> and don't care for -EPROBE_DEFER (what else can happen?).

   Hm, I haven't really seen a lot the probe dererral mishandling in the code
touched by at least my patch #1...

> Changing a relevant function in that mess seems unfortunate here :-\

   You seem to have some spare time and I'm getting distracted contrariwise...
want to help? :-)

> Best regards
> Uwe

MBR, Sergey
