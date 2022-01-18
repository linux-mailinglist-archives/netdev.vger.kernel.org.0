Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44B64930BB
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349977AbiARW13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349976AbiARW1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:27:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27884C061753
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 14:27:13 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9wvk-0000Vm-NM; Tue, 18 Jan 2022 23:26:20 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9wvY-00B4m8-19; Tue, 18 Jan 2022 23:26:07 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9wvX-0003U8-0E; Tue, 18 Jan 2022 23:26:07 +0100
Date:   Tue, 18 Jan 2022 23:26:06 +0100
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
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
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
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        platform-driver-x86@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Hans de Goede <hdegoede@redhat.com>, netdev@vger.kernel.org,
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
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
Message-ID: <20220118222606.3iwuzbenl7g6oeiq@pengutronix.de>
References: <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <29f0c65d-77f2-e5b2-f6cc-422add8a707d@omp.ru>
 <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
 <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru>
 <20220114202226.ugzklxv4wzr6egwj@pengutronix.de>
 <57af1851-9341-985e-7b28-d2ba86770ecb@omp.ru>
 <20220117084732.cdy2sash5hxp4lwo@pengutronix.de>
 <68d3bb7a-7572-7495-d295-e1d512ef509e@omp.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a7pus3gvz76yet7d"
Content-Disposition: inline
In-Reply-To: <68d3bb7a-7572-7495-d295-e1d512ef509e@omp.ru>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--a7pus3gvz76yet7d
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 18, 2022 at 11:21:45PM +0300, Sergey Shtylyov wrote:
> Hello!
>=20
> On 1/17/22 11:47 AM, Uwe Kleine-K=F6nig wrote:
>=20
> [...]
> >>>>>>>>> To me it sounds much more logical for the driver to check if an
> >>>>>>>>> optional irq is non-zero (available) or zero (not available), t=
han to
> >>>>>>>>> sprinkle around checks for -ENXIO. In addition, you have to rem=
ember
> >>>>>>>>> that this one returns -ENXIO, while other APIs use -ENOENT or -=
ENOSYS
> >>>>>>>>> (or some other error code) to indicate absence. I thought not h=
aving
> >>>>>>>>> to care about the actual error code was the main reason behind =
the
> >>>>>>>>> introduction of the *_optional() APIs.
> >>>>>>>
> >>>>>>>> No, the main benefit of gpiod_get_optional() (and clk_get_option=
al()) is
> >>>>>>>> that you can handle an absent GPIO (or clk) as if it were availa=
ble.
> >>>>>>
> >>>>>>    Hm, I've just looked at these and must note that they match 1:1=
 with
> >>>>>> platform_get_irq_optional(). Unfortunately, we can't however behav=
e the
> >>>>>> same way in request_irq() -- because it has to support IRQ0 for th=
e sake
> >>>>>> of i8253 drivers in arch/...
> >>>>>
> >>>>> Let me reformulate your statement to the IMHO equivalent:
> >>>>>
> >>>>> 	If you set aside the differences between
> >>>>> 	platform_get_irq_optional() and gpiod_get_optional(),
> >>>>
> >>>>    Sorry, I should make it clear this is actually the diff between a=
 would-be
> >>>> platform_get_irq_optional() after my patch, not the current code...
> >>>
> >>> The similarity is that with your patch both gpiod_get_optional() and
> >>> platform_get_irq_optional() return NULL and 0 on not-found. The relev=
ant
> >>> difference however is that for a gpiod NULL is a dummy value, while f=
or
> >>> irqs it's not. So the similarity is only syntactically, but not
> >>> semantically.
> >>
> >>    I have noting to say here, rather than optional IRQ could well have=
 a different
> >> meaning than for clk/gpio/etc.
> >>
> >> [...]
> >>>>> However for an interupt this cannot work. You will always have to c=
heck
> >>>>> if the irq is actually there or not because if it's not you cannot =
just
> >>>>> ignore that. So there is no benefit of an optional irq.
> >>>>>
> >>>>> Leaving error message reporting aside, the introduction of
> >>>>> platform_get_irq_optional() allows to change
> >>>>>
> >>>>> 	irq =3D platform_get_irq(...);
> >>>>> 	if (irq < 0 && irq !=3D -ENXIO) {
> >>>>> 		return irq;
> >>>>> 	} else if (irq >=3D 0) {
> >>>>
> >>>>    Rather (irq > 0) actually, IRQ0 is considered invalid (but still =
returned).
> >>>
> >>> This is a topic I don't feel strong for, so I'm sloppy here. If chang=
ing
> >>> this is all that is needed to convince you of my point ...
> >>
> >>    Note that we should absolutely (and first of all) stop returning 0 =
=66rom platform_get_irq()
> >> on a "real" IRQ0. Handling that "still good" zero absolutely doesn't s=
cale e.g. for the subsystems
> >> (like libata) which take 0 as an indication that the polling mode shou=
ld be used... We can't afford
> >> to be sloppy here. ;-)
> >=20
> > Then maybe do that really first?
>=20
>    I'm doing it first already:
>=20
> https://lore.kernel.org/all/5e001ec1-d3f1-bcb8-7f30-a6301fd9930c@omp.ru/
>=20
>    This series is atop of the above patch...

Ah, I missed that (probably because I didn't get the cover letter).

> > I didn't recheck, but is this what the
> > driver changes in your patch is about?
>=20
>    Partly, yes. We can afford to play with the meaning of 0 after the abo=
ve patch.

But the changes that are in patch 1 are all needed?
=20
> > After some more thoughts I wonder if your focus isn't to align
> > platform_get_irq_optional to (clk|gpiod|regulator)_get_optional, but to
> > simplify return code checking. Because with your change we have:
> >=20
> >  - < 0 -> error
> >  - =3D=3D 0 -> no irq
> >  - > 0 -> irq
>=20
>    Mainly, yes. That's why the code examples were given in the descriptio=
n.
>=20
> > For my part I'd say this doesn't justify the change, but at least I
> > could better life with the reasoning. If you start at:
> >=20
> > 	irq =3D platform_get_irq_optional(...)
> > 	if (irq < 0 && irq !=3D -ENXIO)
> > 		return irq
> > 	else if (irq > 0)
> > 		setup_irq(irq);
> > 	else
> > 		setup_polling()
> >=20
> > I'd change that to
> >=20
> > 	irq =3D platform_get_irq_optional(...)
> > 	if (irq > 0) /* or >=3D 0 ? */
>=20
>    Not >=3D 0, no...
>=20
> > 		setup_irq(irq)
> > 	else if (irq =3D=3D -ENXIO)
> > 		setup_polling()
> > 	else
> > 		return irq
> >=20
> > This still has to mention -ENXIO, but this is ok and checking for 0 just
> > hardcodes a different return value.
>=20
>    I think comparing with 0 is simpler (and shorter) than with -ENXIO, if=
 you
> consider the RISC CPUs, like e.g. MIPS...

Hmm, I don't know MIPS good enough to judge. So I created a small C
file:

	$ cat test.c
	#include <errno.h>

	int platform_get_irq_optional(void);
	void a(void);

	int func_0()
	{
		int irq =3D platform_get_irq_optional();

		if (irq =3D=3D 0)
			a();
	}

	int func_enxio()
	{
		int irq =3D platform_get_irq_optional();

		if (irq =3D=3D -ENXIO)
			a();
	}

With some cross compilers as provided by Debian doing

	$CC -c -O3 test.c
	nm --size-sort test.o

I get:

  compiler			|  size of func_0  | size of func_enxio
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D|=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
aarch64-linux-gnu-gcc		| 0000000000000024 | 0000000000000028
arm-linux-gnueabi-gcc		|         00000018 |         00000018
arm-linux-gnueabihf-gcc		|         00000010 |         00000012
i686-linux-gnu-gcc		|         0000002a |         0000002a
mips64el-linux-gnuabi64-gcc	| 0000000000000054 | 000000000000005c
powerpc-linux-gnu-gcc		|         00000058 |         00000058
s390x-linux-gnu-gcc		| 000000000000002e | 0000000000000030
x86_64-linux-gnu-gcc		| 0000000000000022 | 0000000000000022

So you save some bytes indeed.

> > Anyhow, I think if you still want to change platform_get_irq_optional
> > you should add a few patches converting some drivers which demonstrates
> > the improvement for the callers.
>=20
>    Mhm, I did include all the drivers where the IRQ checks have to be mod=
ified,
> not sure what else you want me to touch...

I somehow expected that the changes that are now necessary (or possible)
to callers makes them prettier somehow. Looking at your patch again:

 - drivers/counter/interrupt-cnt.c
   This one is strange in my eyes because it tests the return value of
   gpiod_get_optional against NULL :-(

 - drivers/edac/xgene_edac.c
   This one just wants a silent irq lookup and then throws away the
   error code returned by platform_get_irq_optional() to return -EINVAL.
   Not so nice, is it?

 - drivers/gpio/gpio-altera.c
   This one just wants a silent irq lookup. And maybe it should only
   goto skip_irq if the irq was not found, but on an other error code
   abort the probe?!

 - drivers/gpio/gpio-mvebu.c
   Similar to gpio-altera.c: Wants a silent irq and improved error
   handling.

 - drivers/i2c/busses/i2c-brcmstb.c
   A bit ugly that we now have dev->irq =3D=3D 0 if the irq isn't available,
   but if requesting the irq failed irq =3D -1 is used?

 - drivers/mmc/host/sh_mmcif.c
   Broken error handling. This one wants to abort on irq[1] < 0 (with
   your changed semantic).

I stopped here.

It seems quite common that drivers assume a value < 0 returned by
platform_get_irq means not-found and don't care for -EPROBE_DEFER (what
else can happen?) Changing a relevant function in that mess seems
unfortunate here :-\

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--a7pus3gvz76yet7d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHnPnoACgkQwfwUeK3K
7Akqngf/deJcg5Z6920bXlYUCFdp2KylFxWHucfT0qIrwGnPq8zaZFS9gHqJ0sdG
7jQQJZSuB0RvjbvoR65zpQdPHzf+L5Mt7RcHB97mz9RBI0icUJxXPyCM5R+JJztU
FwvRMasJJTaWprdySpKQ2NBP//sovxwwmoujXrWnzumTfyLR1rw66bTkDxHqwQO0
aWnbojhdu/efNMVD8vDGDRvmyeWv2jVpsINrc/BxPET+KGaMZQUKGtk2vnJSgprv
w/qDSARMcG/2W0EAD65b/kO9COe957sWbn7Pj9ylMp1Eb4kziV8OLLT8WYWtLiHw
zStNC4/q9uZn5kXN2bo45YckhIG/gg==
=ZjV7
-----END PGP SIGNATURE-----

--a7pus3gvz76yet7d--
