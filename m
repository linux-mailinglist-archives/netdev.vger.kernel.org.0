Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DC948A1C7
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 22:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343903AbiAJVTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 16:19:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59428 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240732AbiAJVTp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 16:19:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=+shfBCYZr6PmwOhnVqXddxKoDSg/lEauRmaiul2UEhM=; b=4o
        l3yOrRGYQHgE2pE132qpWBfvjQ+NzSSqod8/ALQpxBEieSiLNaEM0aDNpQGFsKUXcM4AN+KtkY7I0
        Dog50nem4yqnGbL4CLeiEkDbtBsos2cEho6n48/B+0syf6ABim7DNKVR/T8K8+S9x47c49e3Fsnc3
        0c7YhiasNFUCF4w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n723S-0011UU-6G; Mon, 10 Jan 2022 22:18:14 +0100
Date:   Mon, 10 Jan 2022 22:18:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>, alsa-devel@alsa-project.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        linux-phy@lists.infradead.org,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>,
        Lee Jones <lee.jones@linaro.org>,
        openipmi-developer@lists.sourceforge.net,
        Saravanan Sekar <sravanhome@gmail.com>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        kvm@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-serial@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        platform-driver-x86@vger.kernel.org, linux-pwm@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        Robert Richter <rric@kernel.org>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Corey Minyard <minyard@acm.org>, linux-pm@vger.kernel.org,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>, netdev@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-mmc@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-spi@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
Message-ID: <YdyilpjC6rtz6toJ@lunn.ch>
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
 <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220110201014.mtajyrfcfznfhyqm@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 09:10:14PM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Mon, Jan 10, 2022 at 10:54:48PM +0300, Sergey Shtylyov wrote:
> > This patch is based on the former Andy Shevchenko's patch:
> > 
> > https://lore.kernel.org/lkml/20210331144526.19439-1-andriy.shevchenko@linux.intel.com/
> > 
> > Currently platform_get_irq_optional() returns an error code even if IRQ
> > resource simply has not been found. It prevents the callers from being
> > error code agnostic in their error handling:
> > 
> > 	ret = platform_get_irq_optional(...);
> > 	if (ret < 0 && ret != -ENXIO)
> > 		return ret; // respect deferred probe
> > 	if (ret > 0)
> > 		...we get an IRQ...
> > 
> > All other *_optional() APIs seem to return 0 or NULL in case an optional
> > resource is not available. Let's follow this good example, so that the
> > callers would look like:
> > 
> > 	ret = platform_get_irq_optional(...);
> > 	if (ret < 0)
> > 		return ret;
> > 	if (ret > 0)
> > 		...we get an IRQ...
> 
> The difference to gpiod_get_optional (and most other *_optional) is that
> you can use the NULL value as if it were a valid GPIO.
> 
> As this isn't given with for irqs, I don't think changing the return
> value has much sense.

We actually want platform_get_irq_optional() to look different to all
the other _optional() methods because it is not equivalent. If it
looks the same, developers will assume it is the same, and get
themselves into trouble.

> My suggestion would be to keep the return value of
> platform_get_irq_optional() as is, but rename it to
> platform_get_irq_silent() to get rid of the expectation invoked by
> the naming similarity that motivated you to change
> platform_get_irq_optional().

This is a good idea.

     Andrew
