Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3949449256F
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 13:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241345AbiARMJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 07:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241333AbiARMJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 07:09:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2264AC061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 04:09:15 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9nHg-0001Dm-Ou; Tue, 18 Jan 2022 13:08:20 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9nHT-00AzwP-Do; Tue, 18 Jan 2022 13:08:06 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9nHS-0004EX-Dv; Tue, 18 Jan 2022 13:08:06 +0100
Date:   Tue, 18 Jan 2022 13:08:06 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ulf Hansson <ulf.hansson@linaro.org>,
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
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org,
        linux-spi <linux-spi@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
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
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.com>,
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
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
Message-ID: <20220118120806.pbjsat4ulg3vnhsh@pengutronix.de>
References: <c9026f17-2b3f-ee94-0ea3-5630f981fbc1@omp.ru>
 <CAMuHMdXVbRudGs69f9ZzaP1PXhteDNZiXA658eMFAwP4nr9r3w@mail.gmail.com>
 <20220117092444.opoedfcf5k5u6otq@pengutronix.de>
 <CAMuHMdUgZUeraHadRAi2Z=DV+NuNBrKPkmAKsvFvir2MuquVoA@mail.gmail.com>
 <20220117114923.d5vajgitxneec7j7@pengutronix.de>
 <CAMuHMdWCKERO20R2iVHq8P=BaoauoBAtiampWzfMRYihi3Sb0g@mail.gmail.com>
 <20220117170609.yxaamvqdkivs56ju@pengutronix.de>
 <CAMuHMdXbuZqEpYivyS6hkaRN+CwTOGaHq_OROwVAWvDD6OXODQ@mail.gmail.com>
 <20220118090913.pjumkq4zf4iqtlha@pengutronix.de>
 <CAMuHMdUW8+Y_=uszD+JOZO3Lpa9oDayk+GO+cg276i2f2T285w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2svqigojwuu4sr3n"
Content-Disposition: inline
In-Reply-To: <CAMuHMdUW8+Y_=uszD+JOZO3Lpa9oDayk+GO+cg276i2f2T285w@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2svqigojwuu4sr3n
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Geert,

On Tue, Jan 18, 2022 at 10:37:25AM +0100, Geert Uytterhoeven wrote:
> On Tue, Jan 18, 2022 at 10:09 AM Uwe Kleine-K=F6nig
> <u.kleine-koenig@pengutronix.de> wrote:
> > For the (clk|gpiod|regulator)_get_optional() you don't have to check
> > against the magic not-found value (so no implementation detail magic
> > leaks into the caller code) and just pass it to the next API function.
> > (And my expectation would be that if you chose to represent not-found by
> > (void *)66 instead of NULL, you won't have to adapt any user, just the
> > framework internal checks. This is a good thing!)
>=20
> Ah, there is the wrong assumption: drivers sometimes do need to know
> if the resource was found, and thus do need to know about (void *)66,
> -ENODEV, or -ENXIO.  I already gave examples for IRQ and clk before.
> I can imagine these exist for gpiod and regulator, too, as soon as
> you go beyond the trivial "enable" and "disable" use-cases.

My premise is that every user who has to check for "not found"
explicitly should not use (clk|gpiod)_get_optional() but
(clk|gpiod)_get() and do proper (and explicit) error handling for
-ENODEV. (clk|gpiod)_get_optional() is only for these trivial use-cases.

> And 0/NULL vs. > 0 is the natural check here: missing, but not
> an error.

For me it it 100% irrelevant if "not found" is an error for the query
function or not. I just have to be able to check for "not found" and
react accordingly.

And adding a function

	def platform_get_irq_opional():
		ret =3D platform_get_irq()
		if ret =3D=3D -ENXIO:
			return 0
		return ret

it's not a useful addition to the API if I cannot use 0 as a dummy
because it doesn't simplify the caller enough to justify the additional
function.

The only thing I need to be able is to distinguish the cases "there is
an irq", "there is no irq" and anything else is "there is a problem I
cannot handle and so forward it to my caller". The semantic of
platform_get_irq() is able to satisfy this requirement[1], so why introduce
platform_get_irq_opional() for the small advantage that I can check for
not-found using

	if (!irq)

instead of

	if (irq !=3D -ENXIO)

? The semantic of platform_get_irq() is easier ("Either a usable
non-negative irq number or a negative error number") compared to
platform_get_irq_optional() ("Either a usable positive irq number or a
negative error number or 0 meaning not found"). Usage of
platform_get_irq() isn't harder or more expensive (neither for a human
reader nor for a maching running the resulting compiled code).
For a human reader

	if (irq !=3D -ENXIO)

is even easier to understand because for

	if (!irq)

they have to check where the value comes from, see it's
platform_get_irq_optional() and understand that 0 means not-found.

This function just adds overhead because as a irq framework user I have
to understand another function. For me the added benefit is too small to
justify the additional function. And you break out-of-tree drivers.
These are all no major counter arguments, but as the advantage isn't
major either, they still matter.

Best regards
Uwe

[1] the only annoying thing is the error message.

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--2svqigojwuu4sr3n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHmraMACgkQwfwUeK3K
7Ak1qwf6Am8XN0nqXfS0pbngp7EaV4pL4oNS8RQxKSvsObY254xYZ+ARuc9D/qcI
/twFVp0MmVPlJHmpEM8KLdVakfXpJlaJRkoNiXFxGO6FJGbPNXIQvl33fM4L9u3c
k8jyDoz2mdmZdpc6JSLgLroVyQXOl/WygxRbgqO0WCHu762nPfCuaaKUb2yzQ0I1
m+08eRtqVh8WqbbOHrpIhcpfPYzkCeRiGeaqGkO5YwvqeH6kv6eudm8RkAfo6DE9
IwzIaWANKnEqD3UzsSUPdPTmMPfqWML7RJPs6sZCdumiS+Ox36ZGrc7Ewn2ffU/V
Q83qyxKFK+RfjJQmmPycReC6KM89bw==
=RHyZ
-----END PGP SIGNATURE-----

--2svqigojwuu4sr3n--
