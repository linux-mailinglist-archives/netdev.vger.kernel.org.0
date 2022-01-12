Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE7648C06D
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351768AbiALIyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351788AbiALIyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:54:04 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D602C061748
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 00:54:04 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n7ZLN-0005mh-UE; Wed, 12 Jan 2022 09:50:57 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n7ZL6-009rFV-QA; Wed, 12 Jan 2022 09:50:40 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n7ZL5-00061g-Dl; Wed, 12 Jan 2022 09:50:39 +0100
Date:   Wed, 12 Jan 2022 09:50:09 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>, kvm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, Jiri Slaby <jirislaby@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tony Luck <tony.luck@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-serial@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
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
        Jaroslav Kysela <perex@perex.cz>,
        openipmi-developer@lists.sourceforge.net,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-spi@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
Message-ID: <20220112085009.dbasceh3obfok5dc@pengutronix.de>
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
 <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de>
 <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xmww6gsp5dtrk3ed"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xmww6gsp5dtrk3ed
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 12, 2022 at 09:33:48AM +0100, Geert Uytterhoeven wrote:
> Hi Andrew,
>=20
> On Mon, Jan 10, 2022 at 10:20 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > On Mon, Jan 10, 2022 at 09:10:14PM +0100, Uwe Kleine-K=F6nig wrote:
> > > On Mon, Jan 10, 2022 at 10:54:48PM +0300, Sergey Shtylyov wrote:
> > > > This patch is based on the former Andy Shevchenko's patch:
> > > >
> > > > https://lore.kernel.org/lkml/20210331144526.19439-1-andriy.shevchen=
ko@linux.intel.com/
> > > >
> > > > Currently platform_get_irq_optional() returns an error code even if=
 IRQ
> > > > resource simply has not been found. It prevents the callers from be=
ing
> > > > error code agnostic in their error handling:
> > > >
> > > >     ret =3D platform_get_irq_optional(...);
> > > >     if (ret < 0 && ret !=3D -ENXIO)
> > > >             return ret; // respect deferred probe
> > > >     if (ret > 0)
> > > >             ...we get an IRQ...
> > > >
> > > > All other *_optional() APIs seem to return 0 or NULL in case an opt=
ional
> > > > resource is not available. Let's follow this good example, so that =
the
> > > > callers would look like:
> > > >
> > > >     ret =3D platform_get_irq_optional(...);
> > > >     if (ret < 0)
> > > >             return ret;
> > > >     if (ret > 0)
> > > >             ...we get an IRQ...
> > >
> > > The difference to gpiod_get_optional (and most other *_optional) is t=
hat
> > > you can use the NULL value as if it were a valid GPIO.
> > >
> > > As this isn't given with for irqs, I don't think changing the return
> > > value has much sense.
> >
> > We actually want platform_get_irq_optional() to look different to all
> > the other _optional() methods because it is not equivalent. If it
> > looks the same, developers will assume it is the same, and get
> > themselves into trouble.
>=20
> Developers already assume it is the same, and thus forget they have
> to check against -ENXIO instead of zero.

Is this an ack for renaming platform_get_irq_optional() to
platform_get_irq_silent()?

And then a coccinelle or sparse or ... hook that catches people testing
the return value against 0 would be great.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--xmww6gsp5dtrk3ed
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHeljYACgkQwfwUeK3K
7AljMgf/RPunUgCLZTRo6HVoWGaeXoeKF+2cGlwuAsz4Z00TAkiSHfoaeZtHOlTi
q5shu1KHHU618Mhtt6XvXodObLXVJs41ty1v6SytKsW7BJQt5naWkyRnggT5tFWu
ggmVGMBXOmKX/wp2DCDa7dah1/SOrnFqP53whp6ZTB6oejvTyXmM97J3490sqGq5
MsUAM2Z9/yyDuSZevN858NdTs3OZGSfWvvhFoG4EurYBcNo4znZgjQ6JgBbg3L5J
/m2yKP4XrG0hiM86Q5XlzUdX3r5ERS4K78HS9ywkjsC/gmXD3i3XQGIjcG5VMN7F
HGppnegV30H+5MPW7Ws6xs2xopwryw==
=d8xy
-----END PGP SIGNATURE-----

--xmww6gsp5dtrk3ed--
