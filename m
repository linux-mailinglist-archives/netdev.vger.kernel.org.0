Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A82A490F3E
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243057AbiAQRQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244421AbiAQRPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:15:16 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E10C08ED78
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:08:41 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9VSt-0007f8-E9; Mon, 17 Jan 2022 18:06:43 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9VSk-00Ar9W-EE; Mon, 17 Jan 2022 18:06:33 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9VSj-0002dO-9e; Mon, 17 Jan 2022 18:06:33 +0100
Date:   Mon, 17 Jan 2022 18:06:09 +0100
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
        Hans de Goede <hdegoede@redhat.com>,
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
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
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
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
Message-ID: <20220117170609.yxaamvqdkivs56ju@pengutronix.de>
References: <29f0c65d-77f2-e5b2-f6cc-422add8a707d@omp.ru>
 <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
 <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru>
 <20220114202226.ugzklxv4wzr6egwj@pengutronix.de>
 <c9026f17-2b3f-ee94-0ea3-5630f981fbc1@omp.ru>
 <CAMuHMdXVbRudGs69f9ZzaP1PXhteDNZiXA658eMFAwP4nr9r3w@mail.gmail.com>
 <20220117092444.opoedfcf5k5u6otq@pengutronix.de>
 <CAMuHMdUgZUeraHadRAi2Z=DV+NuNBrKPkmAKsvFvir2MuquVoA@mail.gmail.com>
 <20220117114923.d5vajgitxneec7j7@pengutronix.de>
 <CAMuHMdWCKERO20R2iVHq8P=BaoauoBAtiampWzfMRYihi3Sb0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aw3dtkiiyid6id5x"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWCKERO20R2iVHq8P=BaoauoBAtiampWzfMRYihi3Sb0g@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--aw3dtkiiyid6id5x
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 17, 2022 at 02:08:19PM +0100, Geert Uytterhoeven wrote:
> Hi Uwe,
>=20
> On Mon, Jan 17, 2022 at 12:49 PM Uwe Kleine-K=F6nig
> <u.kleine-koenig@pengutronix.de> wrote:
> > On Mon, Jan 17, 2022 at 11:35:52AM +0100, Geert Uytterhoeven wrote:
> > > On Mon, Jan 17, 2022 at 10:24 AM Uwe Kleine-K=F6nig
> > > <u.kleine-koenig@pengutronix.de> wrote:
> > > > On Mon, Jan 17, 2022 at 09:41:42AM +0100, Geert Uytterhoeven wrote:
> > > > > On Sat, Jan 15, 2022 at 9:22 PM Sergey Shtylyov <s.shtylyov@omp.r=
u> wrote:
> > > > > > On 1/14/22 11:22 PM, Uwe Kleine-K=F6nig wrote:
> > > > > > > You have to understand that for clk (and regulator and gpiod)=
 NULL is a
> > > > > > > valid descriptor that can actually be used, it just has no ef=
fect. So
> > > > > > > this is a convenience value for the case "If the clk/regulato=
r/gpiod in
> > > > > > > question isn't available, there is nothing to do". This is wh=
at makes
> > > > > > > clk_get_optional() and the others really useful and justifies=
 their
> > > > > > > existence. This doesn't apply to platform_get_irq_optional().
> > > > > >
> > > > > >    I do understand that. However, IRQs are a different beast wi=
th their
> > > > > > own justifications...
> > > > >
> > > > > > > clk_get_optional() is sane and sensible for cases where the c=
lk might be
> > > > > > > absent and it helps you because you don't have to differentia=
te between
> > > > > > > "not found" and "there is an actual resource".
> > > > > > >
> > > > > > > The reason for platform_get_irq_optional()'s existence is jus=
t that
> > > > > > > platform_get_irq() emits an error message which is wrong or s=
uboptimal
> > > > > >
> > > > > >    I think you are very wrong here. The real reason is to simpl=
ify the
> > > > > > callers.
> > > > >
> > > > > Indeed.
> > > >
> > > > The commit that introduced platform_get_irq_optional() said:
> > > >
> > > >         Introduce a new platform_get_irq_optional() that works much=
 like
> > > >         platform_get_irq() but does not output an error on failure =
to
> > > >         find the interrupt.
> > > >
> > > > So the author of 8973ea47901c81a1912bd05f1577bed9b5b52506 failed to
> > > > mention the real reason? Or look at
> > > > 31a8d8fa84c51d3ab00bf059158d5de6178cf890:
> > > >
> > > >         [...] use platform_get_irq_optional() to get second/third I=
RQ
> > > >         which are optional to avoid below error message during prob=
e:
> > > >         [...]
> > > >
> > > > Look through the output of
> > > >
> > > >         git log -Splatform_get_irq_optional
> > > >
> > > > to find several more of these.
> > >
> > > Commit 8973ea47901c81a1 ("driver core: platform: Introduce
> > > platform_get_irq_optional()") and the various fixups fixed the ugly
> > > printing of error messages that were not applicable.
> > > In hindsight, probably commit 7723f4c5ecdb8d83 ("driver core:
> > > platform: Add an error message to platform_get_irq*()") should have
> > > been reverted instead, until a platform_get_irq_optional() with proper
> > > semantics was introduced.
> >
> > ack.
> >
> > > But as we were all in a hurry to kill the non-applicable error
> > > message, we went for the quick and dirty fix.
> > >
> > > > Also I fail to see how a caller of (today's) platform_get_irq_optio=
nal()
> > > > is simpler than a caller of platform_get_irq() given that there is =
no
> > > > semantic difference between the two. Please show me a single
> > > > conversion from platform_get_irq to platform_get_irq_optional that
> > > > yielded a simplification.
> > >
> > > That's exactly why we want to change the latter to return 0 ;-)
> >
> > OK. So you agree to my statement "The reason for
> > platform_get_irq_optional()'s existence is just that platform_get_irq()
> > emits an error message [...]". Actually you don't want to oppose but
> > say: It's unfortunate that the silent variant of platform_get_irq() took
> > the obvious name of a function that could have an improved return code
> > semantic.
> >
> > So my suggestion to rename todays platform_get_irq_optional() to
> > platform_get_irq_silently() and then introducing
> > platform_get_irq_optional() with your suggested semantic seems
> > intriguing and straigt forward to me.
>=20
> I don't really see the point of needing platform_get_irq_silently(),
> unless as an intermediary step, where it's going to be removed again
> once the conversion has completed.

We agree that one of the two functions is enough, just differ in which
of the two we want to have. :-)

If you think platform_get_irq_silently() is a good intermediate step for
your goal, then we agree to rename platform_get_irq_optional(). So I
suggest you ack my patch.

> Still, the rename would touch all users at once anyway.

It would be more easy to keep the conversion regression-free however. A
plain rename is simple to verify. And then converting to the new
platform_get_irq_optional() can be done individually and without the
need to do everything in a single step.

> > Another thought: platform_get_irq emits an error message for all
> > problems. Wouldn't it be consistent to let platform_get_irq_optional()
> > emit an error message for all problems but "not found"?
> > Alternatively remove the error printk from platform_get_irq().
>=20
> Yes, all problems but not found are real errors.

If you want to make platform_get_irq and its optional variant more
similar to the others, dropping the error message is the way to go.

> > > > So you need some more effort to convince me of your POV.
> > > >
> > > > > Even for clocks, you cannot assume that you can always blindly use
> > > > > the returned dummy (actually a NULL pointer) to call into the clk
> > > > > API.  While this works fine for simple use cases, where you just
> > > > > want to enable/disable an optional clock (clk_prepare_enable() and
> > > > > clk_disable_unprepare()), it does not work for more complex use c=
ases.
> > > >
> > > > Agreed. But for clks and gpiods and regulators the simple case is q=
uite
> > > > usual. For irqs it isn't.
> > >
> > > It is for devices that can have either separate interrupts, or a sing=
le
> > > multiplexed interrupt.
> > >
> > > The logic in e.g. drivers/tty/serial/sh-sci.c and
> > > drivers/spi/spi-rspi.c could be simplified and improved (currently
> > > it doesn't handle deferred probe) if platform_get_irq_optional()
> > > would return 0 instead of -ENXIO.
> >
> > Looking at sh-sci.c the irq handling logic could be improved even
> > without a changed platform_get_irq_optional():
> >
> > diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
> > index 968967d722d4..c7dc9fb84844 100644
> > --- a/drivers/tty/serial/sh-sci.c
> > +++ b/drivers/tty/serial/sh-sci.c
> > @@ -2873,11 +2873,13 @@ static int sci_init_single(struct platform_devi=
ce *dev,
> >          * interrupt ID numbers, or muxed together with another interru=
pt.
> >          */
> >         if (sci_port->irqs[0] < 0)
> > -               return -ENXIO;
> > +               return sci_port->irqs[0];
> >
> > -       if (sci_port->irqs[1] < 0)
> > +       if (sci_port->irqs[1] =3D=3D -ENXIO)
> >                 for (i =3D 1; i < ARRAY_SIZE(sci_port->irqs); i++)
> >                         sci_port->irqs[i] =3D sci_port->irqs[0];
> > +       else if (sci_port->irqs[1] < 0)
> > +               return sci_port->irqs[1];
> >
> >         sci_port->params =3D sci_probe_regmap(p);
> >         if (unlikely(sci_port->params =3D=3D NULL))
> >
> > And then the code flow is actively irritating. sci_init_single() copies
> > irqs[0] to all other irqs[i] and then sci_request_irq() loops over the
> > already requested irqs and checks for duplicates. A single place that
> > identifies the exact set of required irqs would already help a lot.
>=20
> Yeah, it's ugly and convoluted, like the wide set of hardware the
> driver supports.
>=20
> > Also for spi-rspi.c I don't see how platform_get_irq_byname_optional()
> > returning 0 instead of -ENXIO would help. Please talk in patches.
>=20
> --- a/drivers/spi/spi-rspi.c
> +++ b/drivers/spi/spi-rspi.c
> @@ -1420,17 +1420,25 @@ static int rspi_probe(struct platform_device *pde=
v)
>         ctlr->max_native_cs =3D rspi->ops->num_hw_ss;
>=20
>         ret =3D platform_get_irq_byname_optional(pdev, "rx");
> -       if (ret < 0) {
> +       if (ret < 0)
> +               goto error2;
> +
> +       if (!ret) {
>                 ret =3D platform_get_irq_byname_optional(pdev, "mux");
> -               if (ret < 0)
> +               if (!ret)
>                         ret =3D platform_get_irq(pdev, 0);
> +               if (ret < 0)
> +                       goto error2;
> +
>                 if (ret >=3D 0)
>                         rspi->rx_irq =3D rspi->tx_irq =3D ret;
>         } else {
>                 rspi->rx_irq =3D ret;
>                 ret =3D platform_get_irq_byname(pdev, "tx");
> -               if (ret >=3D 0)
> -                       rspi->tx_irq =3D ret;
> +               if (ret < 0)
> +                       goto error2;
> +
> +               rspi->tx_irq =3D ret;
>         }
>=20
>         if (rspi->rx_irq =3D=3D rspi->tx_irq) {

This is not a simplification, just looking at the line count and the
added gotos. That's because it also improves error handling and so the
effect isn't easily spotted.

> I like it when the "if (ret < ) ..." error handling is the first check to=
 do.

That's a relevant difference between us.

> With -ENXIO, it becomes more convoluted. and looks less nice (IMHO).
>=20
> > Preferably first simplify in-driver logic to make the conversion to the
> > new platform_get_irq_optional() actually reviewable.
>=20
> So I have to choose between
>=20
>     if (ret < 0 && ret !=3D -ENXIO)
>             return ret;
>=20
>     if (ret) {
>             ...
>     }
>=20
> and
>=20
>     if (ret =3D=3D -ENXIO) {
>             ...
>     } else if (ret < 0)
>             return ret;
>     }

I would do the latter, then it's in the normal order for error handling

	handle some specific errors;
	forward unhandled errors up the stack;
	handle success;

but it seems you prefer to not call "not found" an error. Actually I
think it's an advantage that the driver has to mention -ENXIO, feels
like proper error handling to me. I guess we won't agree about that
though.

What about the following idea (in pythonic pseudo code for simplicity):

	# the rspi device either has two irqs, one for rx and one for
	# tx, or a single one for both together.

	def muxed_hander(irq):
		status =3D readl(STATUS)
		if status & IF_RX:
			rx_handler()
		if status & IF_TX:
			tx_handler()

	def probe_muxed_irq():
		irq =3D platform_get_irq_by_name("mux")
		if irq < 0:
			return irq;

		request_irq(irq, muxed_handler)

	def probe_separate_irqs():
		txirq =3D platform_get_irq_by_name("tx")
		if txirq < 0:
			return txirq

		rxirq =3D platform_get_irq_by_name("rx")
		if rxirq < 0:
			return rxirq

		request_irq(txirq, tx_handler)
		request_irq(rxirq, rx_handler)

	def probe():
		ret =3D probe_separate_irqs()
		if ret =3D=3D -ENXIO:
			ret =3D probe_muxed_irq()

		if ret < 0:
			return ret

looks clean (to me that is) and allows to skip the demuxing in
tx_handler and rx_handler (which might or might not yield improved
runtime behaviour). Maybe a bit more verbose, but simpler to grasp for a
human, isn't it?

> with the final target being
>=20
>     if (ret < 0)
>             return ret;
>=20
>     if (ret) {
>             ...
>     }
>=20
> So the first option means the final change is smaller, but it looks less
> nice than the second option (IMHO).
> But the second option means more churn.
>=20
> > > So there are three reasons: because the absence of an optional IRQ
> > > is not an error, and thus that should not cause (a) an error code
> > > to be returned, and (b) an error message to be printed, and (c)
> > > because it can simplify the logic in device drivers.
> >
> > I don't agree to (a). If the value signaling not-found is -ENXIO or 0
> > (or -ENODEV) doesn't matter much. I wouldn't deviate from the return
> > code semantics of platform_get_irq() just for having to check against 0
> > instead of -ENXIO. Zero is then just another magic value.
>=20
> Zero is a natural magic value (also for pointers).
> Errors are always negative.
> Positive values are cookies (or pointers) associated with success.

Yeah, the issue where we don't agree is if "not-found" is special enough
to deserve the natural magic value. For me -ENXIO is magic enough to
handle the absence of an irq line. I consider it even the better magic
value.

> > (c) still has to be proven, see above.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--aw3dtkiiyid6id5x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHlof4ACgkQwfwUeK3K
7Aniewf+MoaFo3EYfzYPpJGODkMHLkkxMbHUg8vSMqRQM6WJsf8c9vxwcsWAL4ve
Et7WTI1iMsw9uc3Wiag0LUt2KFm0pxr+OCAyIEsfQ/5exnZOmiPovOmrt8eNPe8c
hTXRJzXnsS9aZP/mJjPEqSZKaBTA/0WYUaKJUQsHq0cxBBtQCeUlMtXmCgCcRUFZ
NK/trtp/5N3W9bLhTFaZ+tCe0aYS5iQAihlnquEZNjJjeTyuZfN/pCbeiAZdDFv1
S85HGZU7QsH9jV00tdrlAze2aLGJ11VXdnibbL3l5ITXHpJKBdpBFZHGazA0P5iG
b1PnP722liY900ec+sr8AE7Gyb3swA==
=kGnZ
-----END PGP SIGNATURE-----

--aw3dtkiiyid6id5x--
