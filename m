Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38D9492238
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 10:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240565AbiARJKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 04:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234599AbiARJKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 04:10:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA9AC06161C
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 01:10:30 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9kUa-0004vq-CT; Tue, 18 Jan 2022 10:09:28 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9kUO-00AyFG-5e; Tue, 18 Jan 2022 10:09:15 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9kUN-0002sb-15; Tue, 18 Jan 2022 10:09:15 +0100
Date:   Tue, 18 Jan 2022 10:09:13 +0100
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
        linux-phy@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        openipmi-developer@lists.sourceforge.net,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
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
        Hans de Goede <hdegoede@redhat.com>,
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
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
Message-ID: <20220118090913.pjumkq4zf4iqtlha@pengutronix.de>
References: <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru>
 <20220114202226.ugzklxv4wzr6egwj@pengutronix.de>
 <c9026f17-2b3f-ee94-0ea3-5630f981fbc1@omp.ru>
 <CAMuHMdXVbRudGs69f9ZzaP1PXhteDNZiXA658eMFAwP4nr9r3w@mail.gmail.com>
 <20220117092444.opoedfcf5k5u6otq@pengutronix.de>
 <CAMuHMdUgZUeraHadRAi2Z=DV+NuNBrKPkmAKsvFvir2MuquVoA@mail.gmail.com>
 <20220117114923.d5vajgitxneec7j7@pengutronix.de>
 <CAMuHMdWCKERO20R2iVHq8P=BaoauoBAtiampWzfMRYihi3Sb0g@mail.gmail.com>
 <20220117170609.yxaamvqdkivs56ju@pengutronix.de>
 <CAMuHMdXbuZqEpYivyS6hkaRN+CwTOGaHq_OROwVAWvDD6OXODQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bm2t43tlpbmr2x5i"
Content-Disposition: inline
In-Reply-To: <CAMuHMdXbuZqEpYivyS6hkaRN+CwTOGaHq_OROwVAWvDD6OXODQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bm2t43tlpbmr2x5i
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Geert,

On Tue, Jan 18, 2022 at 09:25:01AM +0100, Geert Uytterhoeven wrote:
> On Mon, Jan 17, 2022 at 6:06 PM Uwe Kleine-K=F6nig
> <u.kleine-koenig@pengutronix.de> wrote:
> > On Mon, Jan 17, 2022 at 02:08:19PM +0100, Geert Uytterhoeven wrote:
> > > On Mon, Jan 17, 2022 at 12:49 PM Uwe Kleine-K=F6nig
> > > <u.kleine-koenig@pengutronix.de> wrote:
> > > > > So there are three reasons: because the absence of an optional IRQ
> > > > > is not an error, and thus that should not cause (a) an error code
> > > > > to be returned, and (b) an error message to be printed, and (c)
> > > > > because it can simplify the logic in device drivers.
> > > >
> > > > I don't agree to (a). If the value signaling not-found is -ENXIO or=
 0
> > > > (or -ENODEV) doesn't matter much. I wouldn't deviate from the return
> > > > code semantics of platform_get_irq() just for having to check again=
st 0
> > > > instead of -ENXIO. Zero is then just another magic value.
> > >
> > > Zero is a natural magic value (also for pointers).
> > > Errors are always negative.
> > > Positive values are cookies (or pointers) associated with success.
> >
> > Yeah, the issue where we don't agree is if "not-found" is special enough
> > to deserve the natural magic value. For me -ENXIO is magic enough to
> > handle the absence of an irq line. I consider it even the better magic
> > value.
>=20
> It differs from other subsystems (clk, gpio, reset), which do return
> zero on not found.

IMHO it doesn't matter at all that the return value is zero, relevant is
the semantic of the returned value. For clk, gpio, reset and regulator
NULL is a usable dummy, for irqs it's not. So what you do with the value
returned by platform_get_irq_whatever() is: you compare it with the
(magic?) not-found value, and if it matches, you enter a suitable
if-block.

For the (clk|gpiod|regulator)_get_optional() you don't have to check
against the magic not-found value (so no implementation detail magic
leaks into the caller code) and just pass it to the next API function.
(And my expectation would be that if you chose to represent not-found by
(void *)66 instead of NULL, you won't have to adapt any user, just the
framework internal checks. This is a good thing!)

> What's the point in having *_optional() APIs if they just return the
> same values as the non-optional ones?

The upside is that functions with a similar name have similar semantics.
But I agree, having platform_get_irq_optional() with the same return
value for not-found is bad. Changing the return semantic is only one way
to cope with that, renaming such the actual semantic difference is
obvious from the function name is another (IMHO better one).=20

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--bm2t43tlpbmr2x5i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHmg7YACgkQwfwUeK3K
7Amhogf/dAjmJCBciWgz5NV3TfnJ8zBdFusKYKkLMRX6hggDS981lVDd/+0J/CXt
OTZ/mg6pMVEdM4ZgmE7oLUUXSj26rQAXG0Tn0LElJNjNi2w6+jApwXacf1NIrjdY
xuNSbiN94DwWHsG5fgK6ij9XQ1Y0VM23PBPhfBFJUBh2uwTWa/N2akSLPpO4xpcI
qRk9h8QiaRxs+68qmLL5RA1wkp7oyAigMEUcgBr3qUFhTdSGAENP2ZWfgy1ONoFr
ajWgfvPfJ0DAwLiGwyrLebtzFgmd1NwSqNEVsBLdDSkGDq1ysDF6kccVIYnJmWdD
ioq82+vTregbKeZC6dz5wBLZ/E1KSA==
=u/8Z
-----END PGP SIGNATURE-----

--bm2t43tlpbmr2x5i--
