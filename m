Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282C848DF0D
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 21:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbiAMUfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 15:35:48 -0500
Received: from mxout01.lancloud.ru ([45.84.86.81]:38800 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiAMUfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 15:35:43 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 09BA62097191
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
To:     Mark Brown <broonie@kernel.org>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
CC:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        KVM list <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        <linux-iio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Amit Kucheria" <amitk@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        <linux-phy@lists.infradead.org>, <netdev@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        <openipmi-developer@lists.sourceforge.net>,
        "Khuong Dinh" <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        "Lee Jones" <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "John Garry" <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        "William Breathitt Gray" <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "Sebastian Reichel" <sre@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Takashi Iwai" <tiwai@suse.com>,
        <platform-driver-x86@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
 <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de> <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <29f0c65d-77f2-e5b2-f6cc-422add8a707d@omp.ru>
Date:   Thu, 13 Jan 2022 23:35:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Yd9L9SZ+g13iyKab@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/22 12:45 AM, Mark Brown wrote:

[...]
> (Do we really need *all* the CCs here?)

   Yeah, 25 files were changed and that resulted in 75 persons/lists addressed.
I didn't expect such a wide audience myself... :-)

>> That convinces me, that platform_get_irq_optional() is a bad name. The
>> only difference to platform_get_irq is that it's silent. And returning
>> a dummy irq value (which would make it aligned with the other _optional
>> functions) isn't possible.

> There is regulator_get_optional() which is I believe the earliest of
> these APIs, it doesn't return a dummy either (and is silent too) - this

   Hm, I'm seeing it's rather noisy... :-)

> is because regulator_get() does return a dummy since it's the vastly
> common case that regulators must be physically present and them not
> being found is due to there being an error in the system description.
> It's unfortunate that we've ended up with these two different senses for
> _optional(), people frequently get tripped up by it.
> 
>>> To me it sounds much more logical for the driver to check if an
>>> optional irq is non-zero (available) or zero (not available), than to
>>> sprinkle around checks for -ENXIO. In addition, you have to remember
>>> that this one returns -ENXIO, while other APIs use -ENOENT or -ENOSYS
>>> (or some other error code) to indicate absence. I thought not having
>>> to care about the actual error code was the main reason behind the
>>> introduction of the *_optional() APIs.
> 
>> No, the main benefit of gpiod_get_optional() (and clk_get_optional()) is
>> that you can handle an absent GPIO (or clk) as if it were available.

   Hm, I've just looked at these and must note that they match 1:1 with
platform_get_irq_optional(). Unfortunately, we can't however behave the
same way in request_irq() -- because it has to support IRQ0 for the sake
of i8253 drivers in arch/...
 
> Similarly for the regulator API, kind of.

MBR, Sergey
