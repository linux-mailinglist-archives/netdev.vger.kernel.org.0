Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4675748DEC1
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 21:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbiAMUSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 15:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiAMUR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 15:17:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5207CC061574;
        Thu, 13 Jan 2022 12:17:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C8F2B822B8;
        Thu, 13 Jan 2022 20:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3FDC36AE9;
        Thu, 13 Jan 2022 20:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642105076;
        bh=P+vCoi7wNnNx99gRdxFM+Ughrg6Num7mlnrxqHh626A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aTWLTeW2+US6XFjr0IeK4MW8hptcFgfTgzfAoEoi+BJwyaiRzFU6gH5hq1NL1ZlUv
         /DQwqilofY0WLFvsF8d74DdUbIpzgs0bETzZqOJzFXqM64Lz0A/Qfeh8qxrvihqmVy
         xgwPD3HPglDgErZ1Jz6iGQKBUyY3K9WksHonymEdM9xCxPTiVZtYmYrbnczDaLasWd
         yrPtAk8U7+ExUAXePSh3l6uXki2GGHwlfI/cEpOiKZ11aT9awJXMGd4nhni8BCKEn6
         OWBQwG61UMT1yA7Q8HHbxmZ9hYq2o1l8pNm+0IIwCWAjZRb04oZmTMKsZJ9SipUYqo
         hfFABLCe7UChQ==
Date:   Thu, 13 Jan 2022 20:17:39 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ulf Hansson <ulf.hansson@linaro.org>,
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
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
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
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] driver core: platform: Rename
 platform_get_irq_optional() to platform_get_irq_silent()
Message-ID: <YeCI47ltlWzjzjYy@sirena.org.uk>
References: <20220110201014.mtajyrfcfznfhyqm@pengutronix.de>
 <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de>
 <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="R/43kckW41lQLx5e"
Content-Disposition: inline
In-Reply-To: <20220113194358.xnnbhsoyetihterb@pengutronix.de>
X-Cookie: Slow day.  Practice crawling.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--R/43kckW41lQLx5e
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 13, 2022 at 08:43:58PM +0100, Uwe Kleine-K=F6nig wrote:
> The subsystems regulator, clk and gpio have the concept of a dummy
> resource. For regulator, clk and gpio there is a semantic difference
> between the regular _get() function and the _get_optional() variant.
> (One might return the dummy resource, the other won't. Unfortunately
> which one implements which isn't the same for these three.) The
> difference between platform_get_irq() and platform_get_irq_optional() is
> only that the former might emit an error message and the later won't.

Reviewed-by: Mark Brown <broonie@kernel.org>

--R/43kckW41lQLx5e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHgiOIACgkQJNaLcl1U
h9Cg3gf/W4m9gden1y/CRqXbudeIS5o86rgl7aSHGJ8sspVowtin+xIScyALL6hN
iMujjX/XY6/HIl9ExSDF2Tfn2qvHXOjYRspS4KcxU74XtxNXTkZt1hTFqDgiK6AN
sxr4uJMtFAtJVkibADtU/hN92yX3wEJPVyXbhDI0q1RCHLJEfWISOhyYGOZzO+rg
+umqMRe7HjLgYT6LcWu/fIQbm73/hxtjK1fakHcMXEj4urJTi+HF3HpYHK1UjgRH
XAnyMclm3MFYXN+hJ4tXt+oIfs/JY1DL5cPGBvF2aD/WZotIfoqehsstB2jcEjIv
U2dlHZo6p71WHH31Zeg1/3AeucLIlA==
=AUmf
-----END PGP SIGNATURE-----

--R/43kckW41lQLx5e--
