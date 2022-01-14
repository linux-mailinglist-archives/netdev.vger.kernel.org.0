Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1157048F05F
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 20:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244109AbiANTOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 14:14:25 -0500
Received: from mxout01.lancloud.ru ([45.84.86.81]:38262 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244089AbiANTOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 14:14:20 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 96891205E49F
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
CC:     Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        KVM list <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        <linux-iio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Amit Kucheria" <amitk@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Jaroslav Kysela <perex@perex.cz>,
        "Guenter Roeck" <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "MTD Maling List" <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        <linux-phy@lists.infradead.org>, Jiri Slaby <jirislaby@kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Lee Jones" <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
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
        Borislav Petkov <bp@alien8.de>,
        Eric Auger <eric.auger@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <openipmi-developer@lists.sourceforge.net>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "Linux ARM" <linux-arm-kernel@lists.infradead.org>,
        <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Richard Weinberger <richard@nod.at>,
        "Mun Yew Tham" <mun.yew.tham@intel.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        "James Morse" <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        "Sebastian Reichel" <sre@kernel.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        <linux-mediatek@lists.infradead.org>,
        "Brian Norris" <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
 <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de> <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <29f0c65d-77f2-e5b2-f6cc-422add8a707d@omp.ru>
 <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
Organization: Open Mobile Platform
Message-ID: <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru>
Date:   Fri, 14 Jan 2022 22:14:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/22 12:25 PM, Uwe Kleine-König wrote:

>>>>> To me it sounds much more logical for the driver to check if an
>>>>> optional irq is non-zero (available) or zero (not available), than to
>>>>> sprinkle around checks for -ENXIO. In addition, you have to remember
>>>>> that this one returns -ENXIO, while other APIs use -ENOENT or -ENOSYS
>>>>> (or some other error code) to indicate absence. I thought not having
>>>>> to care about the actual error code was the main reason behind the
>>>>> introduction of the *_optional() APIs.
>>>
>>>> No, the main benefit of gpiod_get_optional() (and clk_get_optional()) is
>>>> that you can handle an absent GPIO (or clk) as if it were available.
>>
>>    Hm, I've just looked at these and must note that they match 1:1 with
>> platform_get_irq_optional(). Unfortunately, we can't however behave the
>> same way in request_irq() -- because it has to support IRQ0 for the sake
>> of i8253 drivers in arch/...
> 
> Let me reformulate your statement to the IMHO equivalent:
> 
> 	If you set aside the differences between
> 	platform_get_irq_optional() and gpiod_get_optional(),

   Sorry, I should make it clear this is actually the diff between a would-be
platform_get_irq_optional() after my patch, not the current code...

> 	platform_get_irq_optional() is like gpiod_get_optional().
> 
> The introduction of gpiod_get_optional() made it possible to simplify
> the following code:
> 
> 	reset_gpio = gpiod_get(...)
> 	if IS_ERR(reset_gpio):
> 		error = PTR_ERR(reset_gpio)
> 		if error != -ENDEV:

   ENODEV?

> 			return error
> 	else:
> 		gpiod_set_direction(reset_gpiod, INACTIVE)
> 
> to
> 
> 	reset_gpio = gpiod_get_optional(....)
> 	if IS_ERR(reset_gpio):
> 		return reset_gpio
> 	gpiod_set_direction(reset_gpiod, INACTIVE)
> 
> and I never need to actually know if the reset_gpio actually exists.
> Either the line is put into its inactive state, or it doesn't exist and
> then gpiod_set_direction is a noop. For a regulator or a clk this works
> in a similar way.
> 
> However for an interupt this cannot work. You will always have to check
> if the irq is actually there or not because if it's not you cannot just
> ignore that. So there is no benefit of an optional irq.
> 
> Leaving error message reporting aside, the introduction of
> platform_get_irq_optional() allows to change
> 
> 	irq = platform_get_irq(...);
> 	if (irq < 0 && irq != -ENXIO) {
> 		return irq;
> 	} else if (irq >= 0) {

   Rather (irq > 0) actually, IRQ0 is considered invalid (but still returned).

> 		... setup irq operation ...
> 	} else { /* irq == -ENXIO */
> 		... setup polling ...
> 	}
> 
> to
> 	
> 	irq = platform_get_irq_optional(...);
> 	if (irq < 0 && irq != -ENXIO) {
> 		return irq;
> 	} else if (irq >= 0) {
> 		... setup irq operation ...
> 	} else { /* irq == -ENXIO */
> 		... setup polling ...
> 	}
> 
> which isn't a win. When changing the return value as you suggest, it can
> be changed instead to:
> 
> 	irq = platform_get_irq_optional(...);
> 	if (irq < 0) {
> 		return irq;
> 	} else if (irq > 0) {
> 		... setup irq operation ...
> 	} else { /* irq == 0 */
> 		... setup polling ...
> 	}
> 
> which is a tad nicer. If that is your goal however I ask you to also
> change the semantic of platform_get_irq() to return 0 on "not found".

    Well, I'm not totally opposed to that... but would there be a considerable win?
Anyway, we should 1st stop returning 0 for "valid" IRQs -- this is done by my patch
the discussed patch series are atop of.

> Note the win is considerably less compared to gpiod_get_optional vs

   If there's any at all... We'd basically have to touch /all/ platform_get_irq()
calls (and get an even larger CC list ;-)).

> gpiod_get however. And then it still lacks the semantic of a dummy irq
> which IMHO forfeits the right to call it ..._optional().

   Not quite grasping it... Why e.g. clk_get() doesn't return 0 for a not found clock?

> Now I'm unwilling to continue the discussion unless there pops up a
> suggestion that results in a considerable part (say > 10%) of the
> drivers using platform_get_irq_optional not having to check if the
> return value corresponds to "not found".

   Note that many actual drivers don't follow the pattern prescribed in the comment to
platform_get_irq_optional() and their check for an optional IRQ look like irq < 0
(and, after my patches, irq <= 0). Maybe we shouldn't even bother returning the error
codes and just return 0 for all kinds of misfortunes instead? :-)

> Best regards
> Uwe

MBR, Sergey
