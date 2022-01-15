Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE2748F93D
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 21:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbiAOUWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 15:22:39 -0500
Received: from mxout04.lancloud.ru ([45.84.86.114]:46542 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbiAOUW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 15:22:28 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru B964D20ACF11
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
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        <linux-phy@lists.infradead.org>, Jiri Slaby <jirislaby@kernel.org>,
        <openipmi-developer@lists.sourceforge.net>,
        "David S. Miller" <davem@davemloft.net>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "Bartosz Golaszewski" <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        "William Breathitt Gray" <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        "Borislav Petkov" <bp@alien8.de>,
        Sebastian Reichel <sre@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        <platform-driver-x86@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        <linux-mediatek@lists.infradead.org>,
        "Brian Norris" <computersforpeace@gmail.com>,
        <netdev@vger.kernel.org>
References: <20220110201014.mtajyrfcfznfhyqm@pengutronix.de>
 <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <29f0c65d-77f2-e5b2-f6cc-422add8a707d@omp.ru>
 <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
 <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru>
 <20220114202226.ugzklxv4wzr6egwj@pengutronix.de>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <c9026f17-2b3f-ee94-0ea3-5630f981fbc1@omp.ru>
Date:   Sat, 15 Jan 2022 23:22:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220114202226.ugzklxv4wzr6egwj@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/22 11:22 PM, Uwe Kleine-König wrote:
> On Fri, Jan 14, 2022 at 10:14:10PM +0300, Sergey Shtylyov wrote:
>> On 1/14/22 12:25 PM, Uwe Kleine-König wrote:
>>
>>>>>>> To me it sounds much more logical for the driver to check if an
>>>>>>> optional irq is non-zero (available) or zero (not available), than to
>>>>>>> sprinkle around checks for -ENXIO. In addition, you have to remember
>>>>>>> that this one returns -ENXIO, while other APIs use -ENOENT or -ENOSYS
>>>>>>> (or some other error code) to indicate absence. I thought not having
>>>>>>> to care about the actual error code was the main reason behind the
>>>>>>> introduction of the *_optional() APIs.
>>>>>
>>>>>> No, the main benefit of gpiod_get_optional() (and clk_get_optional()) is
>>>>>> that you can handle an absent GPIO (or clk) as if it were available.
>>>>
>>>>    Hm, I've just looked at these and must note that they match 1:1 with
>>>> platform_get_irq_optional(). Unfortunately, we can't however behave the
>>>> same way in request_irq() -- because it has to support IRQ0 for the sake
>>>> of i8253 drivers in arch/...
>>>
>>> Let me reformulate your statement to the IMHO equivalent:
>>>
>>> 	If you set aside the differences between
>>> 	platform_get_irq_optional() and gpiod_get_optional(),
>>
>>    Sorry, I should make it clear this is actually the diff between a would-be
>> platform_get_irq_optional() after my patch, not the current code...
> 
> The similarity is that with your patch both gpiod_get_optional() and
> platform_get_irq_optional() return NULL and 0 on not-found. The relevant
> difference however is that for a gpiod NULL is a dummy value, while for
> irqs it's not. So the similarity is only syntactically, but not
> semantically.
> 
>>> 	platform_get_irq_optional() is like gpiod_get_optional().
>>>
>>> The introduction of gpiod_get_optional() made it possible to simplify
>>> the following code:
>>>
>>> 	reset_gpio = gpiod_get(...)
>>> 	if IS_ERR(reset_gpio):
>>> 		error = PTR_ERR(reset_gpio)
>>> 		if error != -ENDEV:
>>
>>    ENODEV?
> 
> Yes, typo.
> 
>>> 			return error
>>> 	else:
>>> 		gpiod_set_direction(reset_gpiod, INACTIVE)
>>>
>>> to
>>>
>>> 	reset_gpio = gpiod_get_optional(....)
>>> 	if IS_ERR(reset_gpio):
>>> 		return reset_gpio
>>> 	gpiod_set_direction(reset_gpiod, INACTIVE)
>>>
>>> and I never need to actually know if the reset_gpio actually exists.
>>> Either the line is put into its inactive state, or it doesn't exist and
>>> then gpiod_set_direction is a noop. For a regulator or a clk this works
>>> in a similar way.
>>>
>>> However for an interupt this cannot work. You will always have to check
>>> if the irq is actually there or not because if it's not you cannot just
>>> ignore that. So there is no benefit of an optional irq.
>>>
>>> Leaving error message reporting aside, the introduction of
>>> platform_get_irq_optional() allows to change
>>>
>>> 	irq = platform_get_irq(...);
>>> 	if (irq < 0 && irq != -ENXIO) {
>>> 		return irq;
>>> 	} else if (irq >= 0) {
>>
>>    Rather (irq > 0) actually, IRQ0 is considered invalid (but still returned).
> 
> This is a topic I don't feel strong for, so I'm sloppy here. If changing
> this is all that is needed to convince you of my point ...

   See below. :-)

>>> 		... setup irq operation ...
>>> 	} else { /* irq == -ENXIO */
>>> 		... setup polling ...
>>> 	}
>>>
>>> to
>>> 	
>>> 	irq = platform_get_irq_optional(...);
>>> 	if (irq < 0 && irq != -ENXIO) {
>>> 		return irq;
>>> 	} else if (irq >= 0) {
>>> 		... setup irq operation ...
>>> 	} else { /* irq == -ENXIO */
>>> 		... setup polling ...
>>> 	}
>>>
>>> which isn't a win. When changing the return value as you suggest, it can
>>> be changed instead to:
>>>
>>> 	irq = platform_get_irq_optional(...);
>>> 	if (irq < 0) {
>>> 		return irq;
>>> 	} else if (irq > 0) {
>>> 		... setup irq operation ...
>>> 	} else { /* irq == 0 */
>>> 		... setup polling ...
>>> 	}
>>>
>>> which is a tad nicer. If that is your goal however I ask you to also
>>> change the semantic of platform_get_irq() to return 0 on "not found".
>>
>>     Well, I'm not totally opposed to that... but would there be a considerable win?

> Well, compared to your suggestion of making platform_get_irq_optional()
> return 0 on "not-found" the considerable win would be that
> platform_get_irq_optional() and platform_get_irq() are not different

   They would really be the same function if we do that. But...

> just because platform_get_irq() is to hard to change.

   It's not just that, of course. If you make platform_get_irq() return 0
ISO -ENXIO, you'd have to add the handling of that 0 to all the callers,
and that won't be as simple as:

	if (irq < 0)
		return irq;

since we can't just propagate 0 upstream, we'd have to return something like
-ENXIO (or whatever error we see fit). Does that really scale well?

>> Anyway, we should 1st stop returning 0 for "valid" IRQs -- this is done by my patch
>> the discussed patch series are atop of.
>>
>>> Note the win is considerably less compared to gpiod_get_optional vs
>>
>>    If there's any at all... We'd basically have to touch /all/ platform_get_irq()
>> calls (and get an even larger CC list ;-)).
> 
> You got me wrong here. I meant that even if you change both
> platform_get_irq() and platform_get_irq_optional() to return 0 on
> "not-found", the win is small compared to the benefit of having both

   There's no win at all, it seems.

> clk_get() and clk_get_optional().
> 
>>> gpiod_get however. And then it still lacks the semantic of a dummy irq
>>> which IMHO forfeits the right to call it ..._optional().
>>
>>    Not quite grasping it... Why e.g. clk_get() doesn't return 0 for a not found clock?
> 
> Because NULL is not an error value for clk and when calling clk_get()
> you want a failure when the clk you asked for isn't available.
> 
> Sure you could do the following in a case where you want to insist the
> clk to be actually available:
> 
> 	clk = clk_get_optional(...)
> 	if (IS_ERR_OR_NULL(clk)) {
> 		err = PTR_ERR(clk) || -ENODEV;
> 		return dev_err_probe(dev, err, ....);
> 	}
> 
> but this is more ugly than
> 
> 	clk = clk_get(...)
> 	if (IS_ERR(clk)) {
> 		err = PTR_ERR(clk);
> 		return dev_err_probe(dev, err, ....);
> 	}
> 
> Additionally the first usage would hard-code in the drivers that NULL is
> the dummy value which you might want to consider a layer violation.

   Unfortunately, we don't have a single layer in case of IRQs... There's
no platform_request_irq() (yet? :-)).

> You have to understand that for clk (and regulator and gpiod) NULL is a
> valid descriptor that can actually be used, it just has no effect. So
> this is a convenience value for the case "If the clk/regulator/gpiod in
> question isn't available, there is nothing to do". This is what makes
> clk_get_optional() and the others really useful and justifies their
> existence. This doesn't apply to platform_get_irq_optional().

   I do understand that. However, IRQs are a different beast with their
own justifications...

> So clk_get() is sane and sensible for cases where you need the clk to be
> there. It doesn't emit an error message, because the caller knows better
> if it's worth an error message and in some cases the caller can also
> emit a better error message than clk_get() itself.

   I haven't been thinking about the IRQ error messages at all (yet?)...
And when I start thinking about it, it doesn't seem that bad, perhaps
even saves a lot of the .rodata section... :-)

> clk_get_optional() is sane and sensible for cases where the clk might be
> absent and it helps you because you don't have to differentiate between
> "not found" and "there is an actual resource".
> 
> The reason for platform_get_irq_optional()'s existence is just that
> platform_get_irq() emits an error message which is wrong or suboptimal

   I think you are very wrong here. The real reason is to simplify the
callers.

> in some cases (and IMHO is platform_get_irq() root fault). It doesn't
> simplify handling the "not found" case.

   Oh, it does... you don't have to special-case 0 when handling its result.
In my book, it's a major simplification.

> So let's not pretend by the
> choice of function names that there is a similarity between clk_get() +
> clk_get_optional() and platform_get_irq() + platform_get_irq_optional().

   OK, no similarity. But that's well justified.

> And as you cannot change platform_get_irq_optional() to return a working
> dummy value, IMHO the only sane way out is renaming it.

   Your rename really focused on the wrong aspect of the function, I think...

> Best regards
> Uwe

MBR, Sergey
