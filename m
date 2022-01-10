Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D189848A223
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 22:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345069AbiAJVqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 16:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345060AbiAJVqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 16:46:38 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200FBC061756
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 13:46:38 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n72TM-0001u6-SR; Mon, 10 Jan 2022 22:45:00 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n72TB-009atw-Vd; Mon, 10 Jan 2022 22:44:49 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n72TA-0003wz-UN; Mon, 10 Jan 2022 22:44:48 +0100
Date:   Mon, 10 Jan 2022 22:44:48 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>, kvm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tony Luck <tony.luck@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-serial@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        platform-driver-x86@vger.kernel.org, linux-pwm@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>, linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>, linux-gpio@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Eric Auger <eric.auger@redhat.com>,
        Takashi Iwai <tiwai@suse.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        openipmi-developer@lists.sourceforge.net,
        Jaroslav Kysela <perex@perex.cz>,
        Benson Leung <bleung@chromium.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Richard Weinberger <richard@nod.at>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
Message-ID: <20220110214448.rp4pcjlaqbjlggvj@pengutronix.de>
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
 <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de>
 <Ydyf93VD8FrV7GH+@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e2is76odjewy3gr2"
Content-Disposition: inline
In-Reply-To: <Ydyf93VD8FrV7GH+@smile.fi.intel.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--e2is76odjewy3gr2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 10, 2022 at 11:07:03PM +0200, Andy Shevchenko wrote:
> On Mon, Jan 10, 2022 at 09:10:14PM +0100, Uwe Kleine-K=F6nig wrote:
> > On Mon, Jan 10, 2022 at 10:54:48PM +0300, Sergey Shtylyov wrote:
> > > This patch is based on the former Andy Shevchenko's patch:
> > >=20
> > > https://lore.kernel.org/lkml/20210331144526.19439-1-andriy.shevchenko=
@linux.intel.com/
> > >=20
> > > Currently platform_get_irq_optional() returns an error code even if I=
RQ
> > > resource simply has not been found. It prevents the callers from being
> > > error code agnostic in their error handling:
> > >=20
> > > 	ret =3D platform_get_irq_optional(...);
> > > 	if (ret < 0 && ret !=3D -ENXIO)
> > > 		return ret; // respect deferred probe
> > > 	if (ret > 0)
> > > 		...we get an IRQ...
> > >=20
> > > All other *_optional() APIs seem to return 0 or NULL in case an optio=
nal
> > > resource is not available. Let's follow this good example, so that the
> > > callers would look like:
> > >=20
> > > 	ret =3D platform_get_irq_optional(...);
> > > 	if (ret < 0)
> > > 		return ret;
> > > 	if (ret > 0)
> > > 		...we get an IRQ...
> >=20
> > The difference to gpiod_get_optional (and most other *_optional) is that
> > you can use the NULL value as if it were a valid GPIO.
>=20
> The problem is not only there, but also in the platform_get_irq() and that
> problem is called vIRQ0. Or as Linus put it "_cookie_" for IRQ, which nev=
er
> ever should be 0.

IMHO it's best to avoid yielding zero for a value that should be
interpreted as an (virtual) irq. Then callers don't even have to
consider if it's a valid value or not.

> > As this isn't given with for irqs, I don't think changing the return
> > value has much sense. In my eyes the problem with platform_get_irq() and
> > platform_get_irq_optional() is that someone considered it was a good
> > idea that a global function emits an error message. The problem is,
> > that's only true most of the time. (Sometimes the caller can handle an
> > error (here: the absence of an irq) just fine, sometimes the generic
> > error message just isn't as good as a message by the caller could be.
> > (here: The caller could emit "TX irq not found" which is a much nicer
> > message than "IRQ index 5 not found".)
> >=20
> > My suggestion would be to keep the return value of
> > platform_get_irq_optional() as is, but rename it to
> > platform_get_irq_silent() to get rid of the expectation invoked by the
> > naming similarity that motivated you to change
> > platform_get_irq_optional().
>=20
> This won't fix the issue with vIRQ0.

Is the patch about vIRQ0, or did you only start to consider it when I
said that for gpio NULL is a dummy value? If the former, the commit log
should better mention that.

Anyhow, I still think renaming platform_get_irq_optional() to
platform_get_irq_silent() is a good idea and the patches in this thread
are not.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--e2is76odjewy3gr2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHcqM0ACgkQwfwUeK3K
7Amxygf+NmX8BzaqLoc9m8fsv49CkQqQKbXt9a0l2gES1hAm8NL2nbgjydEJDcPs
QJ5X1TL08pb9wPoYcUF7uSwjJx2Vp0f+FEiMtDk2kj5xI38T+86tnyuQw1tNg4Ss
52foCYQJVIIgIAeMyIvWk14oUMsy4JV/SuT+GZImMq+aM/5+wIF02NZoGzXofThL
mUNzp+vgTNNhZpF7c0D4orD7SDOCOn2fA/uu2UGk1Nh6m+lgW5qIw5Z0KFPTalKH
kU/JuEOBD6kdEr84D9EM6SB2l+dOBVJ20F5DL1JItM4qkAK9thM+3ecLPF610K1e
+N5e1XZXSLS6gpWGBjS9bxMbdZ6Qpg==
=FQR4
-----END PGP SIGNATURE-----

--e2is76odjewy3gr2--
