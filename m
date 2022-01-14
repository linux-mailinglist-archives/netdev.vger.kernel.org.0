Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A000248EF89
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 18:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243998AbiANRzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 12:55:25 -0500
Received: from mxout02.lancloud.ru ([45.84.86.82]:37634 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244005AbiANRzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 12:55:17 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 02F2120606E9
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH] driver core: platform: Rename platform_get_irq_optional()
 to platform_get_irq_silent()
To:     Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@kernel.org>
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
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
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
        Tony Luck <tony.luck@intel.com>,
        "Borislav Petkov" <bp@alien8.de>,
        Sebastian Reichel <sre@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        <platform-driver-x86@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        <linux-edac@vger.kernel.org>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        "Eric Auger" <eric.auger@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
References: <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de> <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de>
 <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de>
 <745c601f-c782-0904-f786-c9bfced8f11c@gmail.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <cae0b73e-46df-a491-4a8e-415205038c2c@omp.ru>
Date:   Fri, 14 Jan 2022 20:55:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <745c601f-c782-0904-f786-c9bfced8f11c@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/22 12:42 AM, Florian Fainelli wrote:

>> The subsystems regulator, clk and gpio have the concept of a dummy
>> resource. For regulator, clk and gpio there is a semantic difference
>> between the regular _get() function and the _get_optional() variant.
>> (One might return the dummy resource, the other won't. Unfortunately
>> which one implements which isn't the same for these three.) The
>> difference between platform_get_irq() and platform_get_irq_optional() is
>> only that the former might emit an error message and the later won't.
>>
>> To prevent people's expectations that there is a semantic difference
>> between these too, rename platform_get_irq_optional() to
>> platform_get_irq_silent() to make the actual difference more obvious.
>>
>> The #define for the old name can and should be removed once all patches
>> currently in flux still relying on platform_get_irq_optional() are
>> fixed.
>>
>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
[...]
>>>> I think at least c) is easy to resolve because
>>>> platform_get_irq_optional() isn't that old yet and mechanically
>>>> replacing it by platform_get_irq_silent() should be easy and safe.
>>>> And this is orthogonal to the discussion if -ENOXIO is a sensible return
>>>> value and if it's as easy as it could be to work with errors on irq
>>>> lookups.
>>>
>>> It'd certainly be good to name anything that doesn't correspond to one
>>> of the existing semantics for the API (!) something different rather
>>> than adding yet another potentially overloaded meaning.
>>
>> It seems we're (at least) three who agree about this. Here is a patch
>> fixing the name.
> 
> From an API naming perspective this does not make much sense anymore with the name chosen,
> it is understood that whent he function is called platform_get_irq_optional(), optional applies
> to the IRQ. An optional IRQ is something people can reason about because it makes sense.

   Right! :-)

> What is a a "silent" IRQ however? It does not apply to the object it is trying to fetch to
> anymore, but to the message that may not be printed in case the resource failed to be obtained,
> because said resource is optional. Woah, that's quite a stretch.

   Right again! :-)

> Following the discussion and original 2 patches set from Sergey, it is not entirely clear to me
> anymore what is it that we are trying to fix.

   Andy and me tried to fix the platform_get_irq[_byname]_optional() value, corresponding to
a missing (optional) IRQ resource from -ENXIO to 0, in order to keep the callers error code
agnostic. This change completely aligns e.g. platform_get_irq_optional() with clk_get_optional()
and gpiod_get_optional()...
   Unforunately, we can't "fix" request_irq() and company to treat 0 as missing IRQ -- they have
to keep the ability to get called from the arch/ code (that doesn't use platform_get_irq(), etc.

> I nearly forgot, I would paint it blue, sky blue, not navy blue, not light blue ;)

   :-)

PS: Florian, something was wrong with your mail client -- I had to manually wrap your quotes,
else there were super long unbroken paragraphs...
