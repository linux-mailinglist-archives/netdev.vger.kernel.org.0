Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FDE48F103
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 21:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244274AbiANUan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 15:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244272AbiANUam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 15:30:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CEAC061574
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 12:30:42 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n8TCl-0001fN-N3; Fri, 14 Jan 2022 21:29:47 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n8TCi-00AJbq-3s; Fri, 14 Jan 2022 21:29:43 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n8TCg-0002hC-MP; Fri, 14 Jan 2022 21:29:42 +0100
Date:   Fri, 14 Jan 2022 21:29:39 +0100
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
Message-ID: <20220114202939.5kq5ud5opfosjlyc@pengutronix.de>
References: <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de>
 <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de>
 <386a7f56-38c8-229c-4fec-4b38a77c4121@omp.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gs4ynp4fq77e5cup"
Content-Disposition: inline
In-Reply-To: <386a7f56-38c8-229c-4fec-4b38a77c4121@omp.ru>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gs4ynp4fq77e5cup
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 14, 2022 at 10:45:38PM +0300, Sergey Shtylyov wrote:
> On 1/13/22 10:43 PM, Uwe Kleine-K=F6nig wrote:
>=20
> > The subsystems regulator, clk and gpio have the concept of a dummy
> > resource. For regulator, clk and gpio there is a semantic difference
> > between the regular _get() function and the _get_optional() variant.
> > (One might return the dummy resource, the other won't. Unfortunately
> > which one implements which isn't the same for these three.) The
> > difference between platform_get_irq() and platform_get_irq_optional() is
> > only that the former might emit an error message and the later won't.
> >=20
> > To prevent people's expectations that there is a semantic difference
> > between these too, rename platform_get_irq_optional() to
> > platform_get_irq_silent() to make the actual difference more obvious.
> >=20
> > The #define for the old name can and should be removed once all patches
> > currently in flux still relying on platform_get_irq_optional() are
> > fixed.
>=20
>    Hm... I'm afraid that with this #define they would never get fixed... =
:-)

I will care for it.

> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> >=20
> > On Thu, Jan 13, 2022 at 02:45:30PM +0000, Mark Brown wrote:
> >> On Thu, Jan 13, 2022 at 12:08:31PM +0100, Uwe Kleine-K=F6nig wrote:
> >>
> >>> This is all very unfortunate. In my eyes b) is the most sensible
> >>> sense, but the past showed that we don't agree here. (The most annoyi=
ng
> >>> part of regulator_get is the warning that is emitted that regularily
> >>> makes customers ask what happens here and if this is fixable.)
> >>
> >> Fortunately it can be fixed, and it's safer to clearly specify things.
> >> The prints are there because when the description is wrong enough to
> >> cause things to blow up we can fail to boot or run messily and
> >> forgetting to describe some supplies (or typoing so they haven't done
> >> that) and people were having a hard time figuring out what might've
> >> happened.
> >=20
> > Yes, that's right. I sent a patch for such a warning in 2019 and pinged
> > occationally. Still waiting for it to be merged :-\
> > (https://lore.kernel.org/r/20190625100412.11815-1-u.kleine-koenig@pengu=
tronix.de)
> >=20
> >>> I think at least c) is easy to resolve because
> >>> platform_get_irq_optional() isn't that old yet and mechanically
> >>> replacing it by platform_get_irq_silent() should be easy and safe.
> >>> And this is orthogonal to the discussion if -ENOXIO is a sensible ret=
urn
> >>> value and if it's as easy as it could be to work with errors on irq
> >>> lookups.
> >>
> >> It'd certainly be good to name anything that doesn't correspond to one
> >> of the existing semantics for the API (!) something different rather
> >> than adding yet another potentially overloaded meaning.
> >=20
> > It seems we're (at least) three who agree about this. Here is a patch
> > fixing the name.
>=20
>    I can't say I genrally agree with this patch...

Yes, I didn't count you to the three people signaling agreement.

> [...]
> > diff --git a/include/linux/platform_device.h b/include/linux/platform_d=
evice.h
> > index 7c96f169d274..6d495f15f717 100644
> > --- a/include/linux/platform_device.h
> > +++ b/include/linux/platform_device.h
> > @@ -69,7 +69,14 @@ extern void __iomem *
> >  devm_platform_ioremap_resource_byname(struct platform_device *pdev,
> >  				      const char *name);
> >  extern int platform_get_irq(struct platform_device *, unsigned int);
> > -extern int platform_get_irq_optional(struct platform_device *, unsigne=
d int);
> > +extern int platform_get_irq_silent(struct platform_device *, unsigned =
int);
> > +
> > +/*
> > + * platform_get_irq_optional was recently renamed to platform_get_irq_=
silent.
> > + * Fixup users to not break patches that were created before the renam=
e.
> > + */
> > +#define platform_get_irq_optional(pdev, index) platform_get_irq_silent=
(pdev, index)
> > +
>=20
>    Yeah, why bother fixing if it compiles anyway?

The plan is to remove the define in one or two kernel releases. The idea
is only to not break patches that are currently in next.

>    I think an inline wrapper with an indication to gcc that the function =
is deprecated
> (I just forgot how it should look) would be better instead...

The deprecated function annotation is generally frowned upon. See
771c035372a0.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--gs4ynp4fq77e5cup
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHh3S8ACgkQwfwUeK3K
7AkDXQf/U5FAV2AAfHdpPoYhXkPobJeAf5Dqsq9HthaQ/4EsbgoDzhwXUQuRqgGp
s3l08rbKnPAXvuz91TT4s4P4EfflDVbvLMELaacliZW9A2Zubif0kRa5i7noZtww
bMiLnHbf6jZNoGKWayBhA0I+mD3ItG2bJkiZMPC9EauwofQRd5TZEOFEnf0MOQYR
WDceoBK0StFIaNP+azd2h5Mkfo+sy70ZLX3i1E5+f2X9Iac4pOldU5N65ldsgg9N
AVzKdnYk6h5IpXqZaytMAGpMn9j4OQHJGDLA8zo0jjwjnK+1JHnoGFwlJO43H0af
61XlzqllsW1diNuTEAhAtFOrNwsDYQ==
=Iw62
-----END PGP SIGNATURE-----

--gs4ynp4fq77e5cup--
