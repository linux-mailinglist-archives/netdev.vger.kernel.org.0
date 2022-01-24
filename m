Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB465499799
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 22:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448838AbiAXVN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 16:13:57 -0500
Received: from mxout02.lancloud.ru ([45.84.86.82]:57190 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445138AbiAXVCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:02:21 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 817A9209B103
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH] driver core: platform: Rename platform_get_irq_optional()
 to platform_get_irq_silent()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
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
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de>
 <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de>
 <YeF05vBOzkN+xYCq@smile.fi.intel.com>
 <20220115154539.j3tsz5ioqexq2yuu@pengutronix.de>
 <YehdsUPiOTwgZywq@smile.fi.intel.com>
 <20220120075718.5qtrpc543kkykaow@pengutronix.de>
 <Ye6/NgfxsZnpXE09@smile.fi.intel.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <15796e57-f7d4-9c66-3b53-0b026eaf31d8@omp.ru>
Date:   Tue, 25 Jan 2022 00:02:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Ye6/NgfxsZnpXE09@smile.fi.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 1/24/22 6:01 PM, Andy Shevchenko wrote:

>>>>>>> It'd certainly be good to name anything that doesn't correspond to one
>>>>>>> of the existing semantics for the API (!) something different rather
>>>>>>> than adding yet another potentially overloaded meaning.
>>>>>>
>>>>>> It seems we're (at least) three who agree about this. Here is a patch
>>>>>> fixing the name.
>>>>>
>>>>> And similar number of people are on the other side.
>>>>
>>>> If someone already opposed to the renaming (and not only the name) I
>>>> must have missed that.
>>>>
>>>> So you think it's a good idea to keep the name
>>>> platform_get_irq_optional() despite the "not found" value returned by it
>>>> isn't usable as if it were a normal irq number?
>>>
>>> I meant that on the other side people who are in favour of Sergey's patch.
>>> Since that I commented already that I opposed the renaming being a standalone
>>> change.
>>>
>>> Do you agree that we have several issues with platform_get_irq*() APIs?
[...]
>>> 2. The vIRQ0 handling: a) WARN() followed by b) returned value 0
>>
>> I'm happy with the vIRQ0 handling. Today platform_get_irq() and it's
>> silent variant returns either a valid and usuable irq number or a
>> negative error value. That's totally fine.
> 
> It might return 0.
> Actually it seems that the WARN() can only be issued in two cases:
> - SPARC with vIRQ0 in one of the array member
> - fallback to ACPI for GPIO IRQ resource with index 0

   You have probably missed the recent discovery that arch/sh/boards/board-aps4*.c
causes IRQ0 to be passed as a direct IRQ resource?

> But the latter is bogus, because it would mean a bug in the ACPI code.

   Worth changing >= 0 to > 0 there, maybe?

> The bottom line here is the SPARC case. Anybody familiar with the platform
> can shed a light on this. If there is no such case, we may remove warning
> along with ret = 0 case from platfrom_get_irq().

   I'm afraid you're too fast here... :-)
   We'll have a really hard time if we continue to allow IRQ0 to be returned by
platform_get_irq() -- we'll have oto fileter it out in the callers then...

>>> 3. The specific cookie for "IRQ not found, while no error happened" case
>>
>> Not sure what you mean here. I have no problem that a situation I can
>> cope with is called an error for the query function. I just do error
>> handling and continue happily. So the part "while no error happened" is
>> irrelevant to me.
> 
> I meant that instead of using special error code, 0 is very much good for
> the cases when IRQ is not found. It allows to distinguish -ENXIO from the
> low layer from -ENXIO with this magic meaning.

   I don't see how -ENXIO can trickle from the lower layers, frankly...

[...]

MBR, Sergey
