Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCAE48E095
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 23:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238064AbiAMWoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 17:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238062AbiAMWoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 17:44:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9E7C061574
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 14:44:21 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n88oe-0007pY-PW; Thu, 13 Jan 2022 23:43:32 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n88oS-00A973-DR; Thu, 13 Jan 2022 23:43:19 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n88oR-0000VL-8T; Thu, 13 Jan 2022 23:43:19 +0100
Date:   Thu, 13 Jan 2022 23:43:19 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        KVM list <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-spi <linux-spi@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Zhang Rui <rui.zhang@intel.com>,
        platform-driver-x86@vger.kernel.org,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Takashi Iwai <tiwai@suse.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        openipmi-developer@lists.sourceforge.net,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] driver core: platform: Rename
 platform_get_irq_optional() to platform_get_irq_silent()
Message-ID: <20220113224319.akljsjtu7ps75vun@pengutronix.de>
References: <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de>
 <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de>
 <YeCI47ltlWzjzjYy@sirena.org.uk>
 <1df04d74-8aa2-11f1-54e9-34d0e8f4e58b@omp.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7tuoe52njhyotvsc"
Content-Disposition: inline
In-Reply-To: <1df04d74-8aa2-11f1-54e9-34d0e8f4e58b@omp.ru>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7tuoe52njhyotvsc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 13, 2022 at 11:57:43PM +0300, Sergey Shtylyov wrote:
> On 1/13/22 11:17 PM, Mark Brown wrote:
>=20
> >> The subsystems regulator, clk and gpio have the concept of a dummy
> >> resource. For regulator, clk and gpio there is a semantic difference
> >> between the regular _get() function and the _get_optional() variant.
> >> (One might return the dummy resource, the other won't. Unfortunately
> >> which one implements which isn't the same for these three.) The
> >> difference between platform_get_irq() and platform_get_irq_optional() =
is
> >> only that the former might emit an error message and the later won't.
>=20
>    This is only a current difference but I'm still going to return 0 ISO
> -ENXIO from latform_get_irq_optional(), no way I'd leave that -ENXIO there
> alone... :-)

This would address a bit of the critic in my commit log. But as 0 isn't
a dummy value like the dummy values that exist for clk, gpiod and
regulator I still think that the naming is a bad idea because it's not
in the spirit of the other *_get_optional functions.

Seeing you say that -ENXIO is a bad return value for
platform_get_irq_optional() and 0 should be used instead, I wonder why
not changing platform_get_irq() to return 0 instead of -ENXIO, too.
This question is for now only about a sensible semantic. That actually
changing platform_get_irq() is probably harder than changing
platform_get_irq_optional() is a different story.

If only platform_get_irq_optional() is changed and given that the
callers have to do something like:

	if (this_irq_exists()):
		... (e.g. request_irq)
	else:
		... (e.g. setup polling)

I really think it's a bad idea that this_irq_exists() has to be
different for platform_get_irq() vs. platform_get_irq_optional().

> > Reviewed-by: Mark Brown <broonie@kernel.org>
>=20
>    Hm... I'm seeing a tag bit not seeing the patch itself...

See https://lore.kernel.org/all/20220113194358.xnnbhsoyetihterb@pengutronix=
=2Ede/

This is just a tree-wide
s/platform_get_irq_optional/platform_get_irq_silent/ + a macro to not
break callers of platform_get_irq_optional().

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--7tuoe52njhyotvsc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHgqwMACgkQwfwUeK3K
7AlyrggAnnNuI35GvxF5VtWAxjQVEMBwQAZzFN2zmbCN56PVqEEi+hrB3o4qCrg5
RVngj3mJZBBvnB/EPzv0cg7FWq2/jPiopb8JGnPMf2HyN6pE6vQRw/vgdCAw1tSa
Z1uE/p+FA63qrrD0UrCjr+6bQaobnf20ljmXq6EmZ6oPXvcQLnTureudQD0YJdII
xZcTKIPC5wH7+yFedZzk1AovNre37jVzG74IzyB6Bbk4Jl22v8GJ8Nq3VUP7x2jE
Ps6AsNLRubU3vuJ1T43P8/yY0B7PRiyRHvXS+N/qCCf44UuRmpvKziXUP2vnspWR
9RIT5bkqqtknA+dRrLt/xWijFiViOQ==
=EM1y
-----END PGP SIGNATURE-----

--7tuoe52njhyotvsc--
