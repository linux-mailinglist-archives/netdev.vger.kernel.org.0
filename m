Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25AE48F77A
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 16:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbiAOPWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 10:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiAOPWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 10:22:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136B0C061574
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 07:22:23 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n8krk-00024Z-CN; Sat, 15 Jan 2022 16:21:16 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n8kra-00ASwx-3H; Sat, 15 Jan 2022 16:21:05 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n8krY-0003aa-TV; Sat, 15 Jan 2022 16:21:04 +0100
Date:   Sat, 15 Jan 2022 16:21:02 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tony Luck <tony.luck@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
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
        Sebastian Reichel <sre@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        platform-driver-x86@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
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
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] driver core: platform: Rename
 platform_get_irq_optional() to platform_get_irq_silent()
Message-ID: <20220115152102.m47snsdrw2elagak@pengutronix.de>
References: <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de>
 <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de>
 <YeCI47ltlWzjzjYy@sirena.org.uk>
 <1df04d74-8aa2-11f1-54e9-34d0e8f4e58b@omp.ru>
 <20220113224319.akljsjtu7ps75vun@pengutronix.de>
 <CAMuHMdWjo36UGde3g5ysdXpLJn=mrPp31SDODuQNPUqoc-ARrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ocudook43fjcrvv4"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWjo36UGde3g5ysdXpLJn=mrPp31SDODuQNPUqoc-ARrQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ocudook43fjcrvv4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 14, 2022 at 10:58:51AM +0100, Geert Uytterhoeven wrote:
> Hi Uwe,
>=20
> On Thu, Jan 13, 2022 at 11:43 PM Uwe Kleine-K=F6nig
> <u.kleine-koenig@pengutronix.de> wrote:
> > On Thu, Jan 13, 2022 at 11:57:43PM +0300, Sergey Shtylyov wrote:
> > > On 1/13/22 11:17 PM, Mark Brown wrote:
> > > >> The subsystems regulator, clk and gpio have the concept of a dummy
> > > >> resource. For regulator, clk and gpio there is a semantic differen=
ce
> > > >> between the regular _get() function and the _get_optional() varian=
t.
> > > >> (One might return the dummy resource, the other won't. Unfortunate=
ly
> > > >> which one implements which isn't the same for these three.) The
> > > >> difference between platform_get_irq() and platform_get_irq_optiona=
l() is
> > > >> only that the former might emit an error message and the later won=
't.
> > >
> > >    This is only a current difference but I'm still going to return 0 =
ISO
> > > -ENXIO from latform_get_irq_optional(), no way I'd leave that -ENXIO =
there
> > > alone... :-)
> >
> > This would address a bit of the critic in my commit log. But as 0 isn't
> > a dummy value like the dummy values that exist for clk, gpiod and
> > regulator I still think that the naming is a bad idea because it's not
> > in the spirit of the other *_get_optional functions.
> >
> > Seeing you say that -ENXIO is a bad return value for
> > platform_get_irq_optional() and 0 should be used instead, I wonder why
> > not changing platform_get_irq() to return 0 instead of -ENXIO, too.
> > This question is for now only about a sensible semantic. That actually
> > changing platform_get_irq() is probably harder than changing
> > platform_get_irq_optional() is a different story.
> >
> > If only platform_get_irq_optional() is changed and given that the
> > callers have to do something like:
> >
> >         if (this_irq_exists()):
> >                 ... (e.g. request_irq)
> >         else:
> >                 ... (e.g. setup polling)
> >
> > I really think it's a bad idea that this_irq_exists() has to be
> > different for platform_get_irq() vs. platform_get_irq_optional().
>=20
> For platform_get_irq(), the IRQ being absent is an error condition,
> hence it should return an error code.
> For platform_get_irq_optional(), the IRQ being absent is not an error
> condition, hence it should not return an error code, and 0 is OK.

Please show a few examples how this simplifies the code. If it's only
that a driver has to check for =3D=3D 0 instead of =3D=3D -ENXIO, than that=
's
not a good enough motivation to make platform_get_irq_optional()
different to platform_get_irq().

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--ocudook43fjcrvv4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHi5kAACgkQwfwUeK3K
7AmxjQf+LjEMbZ2BLPsszWOOyw2Xtjn8mpuOmCBImErsT+AnE5G2nUp9a//M8hxr
OxUaITVBvGpeAOf8afjOnacEHqcvNJGUdWblNwEGdc7auyl6qSe7agtR2LDjM5ir
x233Ner1R+O8K0t4zRM2+g/LeLLNwL9Y+9y6swNJvQcsqzy0z86I7/R1ebWk9NMa
w1paYTwYlIyghKS5pAN7yXeIAJFP9DFBDy0KGZG8uA+MZn1WWTk/vwK4/NR5XcrY
WXb6zM/0lZtQWhYlKW/dcj4b3LlOo8dgfuGuu8WIqoKxY0230JDSg1E+5ZNLyKq3
7VzijyuxAzaTNhwSnAvUB2ToosLs1g==
=EUgY
-----END PGP SIGNATURE-----

--ocudook43fjcrvv4--
