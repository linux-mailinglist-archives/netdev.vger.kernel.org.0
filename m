Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76AF48E495
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 07:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbiANG5m convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jan 2022 01:57:42 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:48213 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiANG5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 01:57:38 -0500
Received: (Authenticated sender: peter@korsgaard.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 6952FFF805;
        Fri, 14 Jan 2022 06:57:08 +0000 (UTC)
Received: from peko by dell.be.48ers.dk with local (Exim 4.92)
        (envelope-from <peter@korsgaard.com>)
        id 1n8GWI-0002SW-Ku; Fri, 14 Jan 2022 07:57:06 +0100
From:   Peter Korsgaard <peter@korsgaard.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        KVM list <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, Jiri Slaby <jirislaby@kernel.org>,
        openipmi-developer@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "open list\:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
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
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Sebastian Reichel <sre@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        platform-driver-x86@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list\:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] driver core: platform: Rename platform_get_irq_optional() to platform_get_irq_silent()
References: <20220110195449.12448-2-s.shtylyov@omp.ru>
        <20220110201014.mtajyrfcfznfhyqm@pengutronix.de>
        <YdyilpjC6rtz6toJ@lunn.ch>
        <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
        <20220112085009.dbasceh3obfok5dc@pengutronix.de>
        <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
        <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
        <Yd9L9SZ+g13iyKab@sirena.org.uk>
        <20220113110831.wvwbm75hbfysbn2d@pengutronix.de>
        <YeA7CjOyJFkpuhz/@sirena.org.uk>
        <20220113194358.xnnbhsoyetihterb@pengutronix.de>
Date:   Fri, 14 Jan 2022 07:57:06 +0100
In-Reply-To: <20220113194358.xnnbhsoyetihterb@pengutronix.de> ("Uwe
        =?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Thu, 13 Jan 2022 20:43:58
 +0100")
Message-ID: <87ilum954t.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>>>> "Uwe" == Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:

 > The subsystems regulator, clk and gpio have the concept of a dummy
 > resource. For regulator, clk and gpio there is a semantic difference
 > between the regular _get() function and the _get_optional() variant.
 > (One might return the dummy resource, the other won't. Unfortunately
 > which one implements which isn't the same for these three.) The
 > difference between platform_get_irq() and platform_get_irq_optional() is
 > only that the former might emit an error message and the later won't.

 > To prevent people's expectations that there is a semantic difference
 > between these too, rename platform_get_irq_optional() to
 > platform_get_irq_silent() to make the actual difference more obvious.

 > The #define for the old name can and should be removed once all patches
 > currently in flux still relying on platform_get_irq_optional() are
 > fixed.

 > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

For i2c-ocores.c:

Acked-by: Peter Korsgaard <peter@korsgaard.com>

-- 
Bye, Peter Korsgaard
