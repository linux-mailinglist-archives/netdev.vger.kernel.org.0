Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFE74948F9
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 08:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357693AbiATH6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 02:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345455AbiATH6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 02:58:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E56C061748
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 23:58:40 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nASK7-0002RI-3O; Thu, 20 Jan 2022 08:57:35 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nASJu-00BJom-IA; Thu, 20 Jan 2022 08:57:21 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nASJt-000Bvo-3V; Thu, 20 Jan 2022 08:57:21 +0100
Date:   Thu, 20 Jan 2022 08:57:18 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
Subject: Re: [PATCH] driver core: platform: Rename
 platform_get_irq_optional() to platform_get_irq_silent()
Message-ID: <20220120075718.5qtrpc543kkykaow@pengutronix.de>
References: <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de>
 <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de>
 <YeF05vBOzkN+xYCq@smile.fi.intel.com>
 <20220115154539.j3tsz5ioqexq2yuu@pengutronix.de>
 <YehdsUPiOTwgZywq@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vtmtr3soi3npiqhl"
Content-Disposition: inline
In-Reply-To: <YehdsUPiOTwgZywq@smile.fi.intel.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vtmtr3soi3npiqhl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 19, 2022 at 08:51:29PM +0200, Andy Shevchenko wrote:
> On Sat, Jan 15, 2022 at 04:45:39PM +0100, Uwe Kleine-K=F6nig wrote:
> > On Fri, Jan 14, 2022 at 03:04:38PM +0200, Andy Shevchenko wrote:
> > > On Thu, Jan 13, 2022 at 08:43:58PM +0100, Uwe Kleine-K=F6nig wrote:
> > > > > It'd certainly be good to name anything that doesn't correspond t=
o one
> > > > > of the existing semantics for the API (!) something different rat=
her
> > > > > than adding yet another potentially overloaded meaning.
> > > >=20
> > > > It seems we're (at least) three who agree about this. Here is a pat=
ch
> > > > fixing the name.
> > >=20
> > > And similar number of people are on the other side.
> >=20
> > If someone already opposed to the renaming (and not only the name) I
> > must have missed that.
> >=20
> > So you think it's a good idea to keep the name
> > platform_get_irq_optional() despite the "not found" value returned by it
> > isn't usable as if it were a normal irq number?
>=20
> I meant that on the other side people who are in favour of Sergey's patch.
> Since that I commented already that I opposed the renaming being a standa=
lone
> change.
>=20
> Do you agree that we have several issues with platform_get_irq*() APIs?
>=20
> 1. The unfortunate naming

unfortunate naming for the currently implemented semantic, yes.

> 2. The vIRQ0 handling: a) WARN() followed by b) returned value 0

I'm happy with the vIRQ0 handling. Today platform_get_irq() and it's
silent variant returns either a valid and usuable irq number or a
negative error value. That's totally fine.

> 3. The specific cookie for "IRQ not found, while no error happened" case

Not sure what you mean here. I have no problem that a situation I can
cope with is called an error for the query function. I just do error
handling and continue happily. So the part "while no error happened" is
irrelevant to me.

Additionally I see the problems:

4. The semantic as implemented in Sergey's patch isn't better than the
current one. platform_get_irq*() is still considerably different from
(clk|gpiod)_get* because the not-found value for the _optional variant
isn't usuable for the irq case. For clk and gpio I get rid of a whole if
branch, for irq I only change the if-condition. (And if that change is
considered good or bad seems to be subjective.)

For the idea to add a warning to platform_get_irq_optional for all but
-ENXIO (and -EPROBE_DEFER), I see the problem:

5. platform_get_irq*() issuing an error message is only correct most of
the time and given proper error handling in the caller (which might be
able to handle not only -ENXIO but maybe also -EINVAL[1]) the error message
is irritating. Today platform_get_irq() emits an error message for all
but -EPROBE_DEFER. As soon as we find a driver that handles -EINVAL we
need a function platform_get_irq_variant1 to be silent for -EINVAL,
-EPROBE_DEFER and -ENXIO (or platform_get_irq_variant2 that is only
silent for -EINVAL and -EPROBE_DEFER?)

IMHO a query function should always be silent and let the caller do the
error handling. And if it's only because

	mydev: IRQ index 0 not found

is worse than

	mydev: neither TX irq not a muxed RX/TX irq found

=2E Also "index 0" is irritating for devices that are expected to have
only a single irq (i.e. the majority of all devices).

Yes, I admit, we can safe some code by pushing the error message in a
query function. But that doesn't only have advantages.

Best regards
Uwe

[1] Looking through the source I wonder: What are the errors that can happen
    in platform_get_irq*()? (calling everything but a valid irq number
    an error) Looking at many callers, they only seem to expect "not
    found" and some "probe defer" (even platform_get_irq() interprets
    everything but -EPROBE_DEFER as "IRQ index %u not found\n".)
    IMHO before we should consider to introduce a platform_get_irq*()
    variant with improved semantics, some cleanup in the internals of
    the irq lookup are necessary.

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--vtmtr3soi3npiqhl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHpFdoACgkQwfwUeK3K
7AlpCwf8CIVWD1ztALs4saPfU+hCAXGdHPMYsVb4ZTfj+uT0g5uOPF3Vn08Dfosw
tyqmKEnwGKIMZpavCJ+pScDwmT2FfANDq+R3xZzWj1hEcEvhjMFWB/IDU+s33/IB
9pbnCAE8Oa/2PGjM3+FGf5OA6q8vCcuO8XHluolGQqPqvajsCulKZytLIFnnTc9t
UXm+5HxATeIlvcxF5NHMcNFRt2ADkTGVGj0zrEOxinsiT3edhaWLDR5/vSnbXySV
NKWnnkWO/T3Huohcr85IS2dVfqbqxuMmfU6RyQKdMat7ZUzOqtffi2I6KdXRRjog
OHR+PLT7KSOdf6ODGMs+9P8AMEotwg==
=El6G
-----END PGP SIGNATURE-----

--vtmtr3soi3npiqhl--
