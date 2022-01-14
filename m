Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D4348F0F4
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 21:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244271AbiANUZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 15:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244264AbiANUZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 15:25:43 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19573C06173E
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 12:25:43 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n8T5w-0000w6-8j; Fri, 14 Jan 2022 21:22:44 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n8T5j-00AJbK-DJ; Fri, 14 Jan 2022 21:22:30 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n8T5h-0002Jl-M3; Fri, 14 Jan 2022 21:22:29 +0100
Date:   Fri, 14 Jan 2022 21:22:26 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
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
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Sebastian Reichel <sre@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        platform-driver-x86@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
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
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
Message-ID: <20220114202226.ugzklxv4wzr6egwj@pengutronix.de>
References: <20220110201014.mtajyrfcfznfhyqm@pengutronix.de>
 <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <29f0c65d-77f2-e5b2-f6cc-422add8a707d@omp.ru>
 <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
 <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uk3tmcd6neo3zuxi"
Content-Disposition: inline
In-Reply-To: <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uk3tmcd6neo3zuxi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 14, 2022 at 10:14:10PM +0300, Sergey Shtylyov wrote:
> On 1/14/22 12:25 PM, Uwe Kleine-K=F6nig wrote:
>=20
> >>>>> To me it sounds much more logical for the driver to check if an
> >>>>> optional irq is non-zero (available) or zero (not available), than =
to
> >>>>> sprinkle around checks for -ENXIO. In addition, you have to remember
> >>>>> that this one returns -ENXIO, while other APIs use -ENOENT or -ENOS=
YS
> >>>>> (or some other error code) to indicate absence. I thought not having
> >>>>> to care about the actual error code was the main reason behind the
> >>>>> introduction of the *_optional() APIs.
> >>>
> >>>> No, the main benefit of gpiod_get_optional() (and clk_get_optional()=
) is
> >>>> that you can handle an absent GPIO (or clk) as if it were available.
> >>
> >>    Hm, I've just looked at these and must note that they match 1:1 with
> >> platform_get_irq_optional(). Unfortunately, we can't however behave the
> >> same way in request_irq() -- because it has to support IRQ0 for the sa=
ke
> >> of i8253 drivers in arch/...
> >=20
> > Let me reformulate your statement to the IMHO equivalent:
> >=20
> > 	If you set aside the differences between
> > 	platform_get_irq_optional() and gpiod_get_optional(),
>=20
>    Sorry, I should make it clear this is actually the diff between a woul=
d-be
> platform_get_irq_optional() after my patch, not the current code...

The similarity is that with your patch both gpiod_get_optional() and
platform_get_irq_optional() return NULL and 0 on not-found. The relevant
difference however is that for a gpiod NULL is a dummy value, while for
irqs it's not. So the similarity is only syntactically, but not
semantically.

> > 	platform_get_irq_optional() is like gpiod_get_optional().
> >=20
> > The introduction of gpiod_get_optional() made it possible to simplify
> > the following code:
> >=20
> > 	reset_gpio =3D gpiod_get(...)
> > 	if IS_ERR(reset_gpio):
> > 		error =3D PTR_ERR(reset_gpio)
> > 		if error !=3D -ENDEV:
>=20
>    ENODEV?

Yes, typo.

> > 			return error
> > 	else:
> > 		gpiod_set_direction(reset_gpiod, INACTIVE)
> >=20
> > to
> >=20
> > 	reset_gpio =3D gpiod_get_optional(....)
> > 	if IS_ERR(reset_gpio):
> > 		return reset_gpio
> > 	gpiod_set_direction(reset_gpiod, INACTIVE)
> >=20
> > and I never need to actually know if the reset_gpio actually exists.
> > Either the line is put into its inactive state, or it doesn't exist and
> > then gpiod_set_direction is a noop. For a regulator or a clk this works
> > in a similar way.
> >=20
> > However for an interupt this cannot work. You will always have to check
> > if the irq is actually there or not because if it's not you cannot just
> > ignore that. So there is no benefit of an optional irq.
> >=20
> > Leaving error message reporting aside, the introduction of
> > platform_get_irq_optional() allows to change
> >=20
> > 	irq =3D platform_get_irq(...);
> > 	if (irq < 0 && irq !=3D -ENXIO) {
> > 		return irq;
> > 	} else if (irq >=3D 0) {
>=20
>    Rather (irq > 0) actually, IRQ0 is considered invalid (but still retur=
ned).

This is a topic I don't feel strong for, so I'm sloppy here. If changing
this is all that is needed to convince you of my point ...

> > 		... setup irq operation ...
> > 	} else { /* irq =3D=3D -ENXIO */
> > 		... setup polling ...
> > 	}
> >=20
> > to
> > =09
> > 	irq =3D platform_get_irq_optional(...);
> > 	if (irq < 0 && irq !=3D -ENXIO) {
> > 		return irq;
> > 	} else if (irq >=3D 0) {
> > 		... setup irq operation ...
> > 	} else { /* irq =3D=3D -ENXIO */
> > 		... setup polling ...
> > 	}
> >=20
> > which isn't a win. When changing the return value as you suggest, it can
> > be changed instead to:
> >=20
> > 	irq =3D platform_get_irq_optional(...);
> > 	if (irq < 0) {
> > 		return irq;
> > 	} else if (irq > 0) {
> > 		... setup irq operation ...
> > 	} else { /* irq =3D=3D 0 */
> > 		... setup polling ...
> > 	}
> >=20
> > which is a tad nicer. If that is your goal however I ask you to also
> > change the semantic of platform_get_irq() to return 0 on "not found".
>=20
>     Well, I'm not totally opposed to that... but would there be a conside=
rable win?

Well, compared to your suggestion of making platform_get_irq_optional()
return 0 on "not-found" the considerable win would be that
platform_get_irq_optional() and platform_get_irq() are not different
just because platform_get_irq() is to hard to change.

> Anyway, we should 1st stop returning 0 for "valid" IRQs -- this is done b=
y my patch
> the discussed patch series are atop of.
>=20
> > Note the win is considerably less compared to gpiod_get_optional vs
>=20
>    If there's any at all... We'd basically have to touch /all/ platform_g=
et_irq()
> calls (and get an even larger CC list ;-)).

You got me wrong here. I meant that even if you change both
platform_get_irq() and platform_get_irq_optional() to return 0 on
"not-found", the win is small compared to the benefit of having both
clk_get() and clk_get_optional().

> > gpiod_get however. And then it still lacks the semantic of a dummy irq
> > which IMHO forfeits the right to call it ..._optional().
>=20
>    Not quite grasping it... Why e.g. clk_get() doesn't return 0 for a not=
 found clock?

Because NULL is not an error value for clk and when calling clk_get()
you want a failure when the clk you asked for isn't available.

Sure you could do the following in a case where you want to insist the
clk to be actually available:

	clk =3D clk_get_optional(...)
	if (IS_ERR_OR_NULL(clk)) {
		err =3D PTR_ERR(clk) || -ENODEV;
		return dev_err_probe(dev, err, ....);
	}

but this is more ugly than

	clk =3D clk_get(...)
	if (IS_ERR(clk)) {
		err =3D PTR_ERR(clk);
		return dev_err_probe(dev, err, ....);
	}

Additionally the first usage would hard-code in the drivers that NULL is
the dummy value which you might want to consider a layer violation.

You have to understand that for clk (and regulator and gpiod) NULL is a
valid descriptor that can actually be used, it just has no effect. So
this is a convenience value for the case "If the clk/regulator/gpiod in
question isn't available, there is nothing to do". This is what makes
clk_get_optional() and the others really useful and justifies their
existence. This doesn't apply to platform_get_irq_optional().

So clk_get() is sane and sensible for cases where you need the clk to be
there. It doesn't emit an error message, because the caller knows better
if it's worth an error message and in some cases the caller can also
emit a better error message than clk_get() itself.

clk_get_optional() is sane and sensible for cases where the clk might be
absent and it helps you because you don't have to differentiate between
"not found" and "there is an actual resource".

The reason for platform_get_irq_optional()'s existence is just that
platform_get_irq() emits an error message which is wrong or suboptimal
in some cases (and IMHO is platform_get_irq() root fault). It doesn't
simplify handling the "not found" case. So let's not pretend by the
choice of function names that there is a similarity between clk_get() +
clk_get_optional() and platform_get_irq() + platform_get_irq_optional().

And as you cannot change platform_get_irq_optional() to return a working
dummy value, IMHO the only sane way out is renaming it.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--uk3tmcd6neo3zuxi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHh230ACgkQwfwUeK3K
7AlWNwf/bRFJlZD6u0VGoy9sl0BdPd/mUmPL35/vP2hJR8x4u+01YZ3J5DPX9kIK
pE1ufbhwUnqJgelbz3N4R/r7kog28Jsz6cHn+cw2adtMIJQfl/xpk1C2Rsk6K3bO
KHClfmbHJxl7kNt7wdN0jocSaun5fy8o5qNdvZ3+tvShyZNbWFPRHeiAhVTQxKCn
qLNOfy/yFDXAUKKLTeXBnSCb8PbfjnDYhbGZpNiXgwHirXAc3aUM2PL9LSJdJeyb
MlXBBJWUwdu7JXIo6+5KJI3txCmuKSByoERP3yu9BirMSfvEu+0QBc8IvwL1/j4z
FjtcKcDXPQ/+lDBRPl94fRT8j8cK5Q==
=uAhV
-----END PGP SIGNATURE-----

--uk3tmcd6neo3zuxi--
