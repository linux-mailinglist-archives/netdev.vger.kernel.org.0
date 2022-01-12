Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D04C48CDD3
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 22:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiALVch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 16:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiALVcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 16:32:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC59C06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 13:32:36 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n7lDU-0003cg-GC; Wed, 12 Jan 2022 22:31:36 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n7lDG-009xGd-W3; Wed, 12 Jan 2022 22:31:22 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n7lDF-0004hw-SN; Wed, 12 Jan 2022 22:31:21 +0100
Date:   Wed, 12 Jan 2022 22:31:21 +0100
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
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-spi <linux-spi@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        openipmi-developer@lists.sourceforge.net,
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
        Jaroslav Kysela <perex@perex.cz>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
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
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        platform-driver-x86@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Message-ID: <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
 <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de>
 <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c63mbqxqltqrb5xh"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--c63mbqxqltqrb5xh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 12, 2022 at 11:27:02AM +0100, Geert Uytterhoeven wrote:
> Hi Uwe,
>=20
> On Wed, Jan 12, 2022 at 9:51 AM Uwe Kleine-K=F6nig
> <u.kleine-koenig@pengutronix.de> wrote:
> > On Wed, Jan 12, 2022 at 09:33:48AM +0100, Geert Uytterhoeven wrote:
> > > On Mon, Jan 10, 2022 at 10:20 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > > On Mon, Jan 10, 2022 at 09:10:14PM +0100, Uwe Kleine-K=F6nig wrote:
> > > > > On Mon, Jan 10, 2022 at 10:54:48PM +0300, Sergey Shtylyov wrote:
> > > > > > This patch is based on the former Andy Shevchenko's patch:
> > > > > >
> > > > > > https://lore.kernel.org/lkml/20210331144526.19439-1-andriy.shev=
chenko@linux.intel.com/
> > > > > >
> > > > > > Currently platform_get_irq_optional() returns an error code eve=
n if IRQ
> > > > > > resource simply has not been found. It prevents the callers fro=
m being
> > > > > > error code agnostic in their error handling:
> > > > > >
> > > > > >     ret =3D platform_get_irq_optional(...);
> > > > > >     if (ret < 0 && ret !=3D -ENXIO)
> > > > > >             return ret; // respect deferred probe
> > > > > >     if (ret > 0)
> > > > > >             ...we get an IRQ...
> > > > > >
> > > > > > All other *_optional() APIs seem to return 0 or NULL in case an=
 optional
> > > > > > resource is not available. Let's follow this good example, so t=
hat the
> > > > > > callers would look like:
> > > > > >
> > > > > >     ret =3D platform_get_irq_optional(...);
> > > > > >     if (ret < 0)
> > > > > >             return ret;
> > > > > >     if (ret > 0)
> > > > > >             ...we get an IRQ...
> > > > >
> > > > > The difference to gpiod_get_optional (and most other *_optional) =
is that
> > > > > you can use the NULL value as if it were a valid GPIO.
> > > > >
> > > > > As this isn't given with for irqs, I don't think changing the ret=
urn
> > > > > value has much sense.
> > > >
> > > > We actually want platform_get_irq_optional() to look different to a=
ll
> > > > the other _optional() methods because it is not equivalent. If it
> > > > looks the same, developers will assume it is the same, and get
> > > > themselves into trouble.
> > >
> > > Developers already assume it is the same, and thus forget they have
> > > to check against -ENXIO instead of zero.

I agree that -ENXIO is unfortunate and -ENOENT would be more in line
with other functions. I assume it's insane to want to change that.

> > Is this an ack for renaming platform_get_irq_optional() to
> > platform_get_irq_silent()?
>=20
> No it isn't ;-)
>=20
> If an optional IRQ is not present, drivers either just ignore it (e.g.
> for devices that can have multiple interrupts or a single muxed IRQ),
> or they have to resort to polling. For the latter, fall-back handling
> is needed elsewhere in the driver.

I think irq are not suitable for such a dummy handling. For clocks or
GPIOs there are cases where just doing nothing in the absence of a
certain optional clock or GPIO is fine.

I checked a few users of platform_get_irq_optional() and I didn't find a
single one that doesn't need to differentiate the irq and the no-irq
case later. Do you know one? If you do, isn't that so exceptional that
it doesn't justify the idea of a dummy irq value? So until proven
otherwise I think platform_get_irq_optional() just isn't in the spirit
of clk_get_optional() and gpiod_get_optional() because there are no use
cases where a dummy value would be good enough. (Even if request_irq
would be a noop for a dummy irq value.)

The motivation why platform_get_irq_optional() was introduced was just
that platform_get_irq() started to emit an error message (in commit
7723f4c5ecdb8d832f049f8483beb0d1081cedf6) and the (proportional) few
drivers where the error message was bad needed a variant that doesn't
emit the error message. Look at
31a8d8fa84c51d3ab00bf059158d5de6178cf890, the motivation to use
platform_get_irq_optional() wasn't that it simplifies handling in the
driver, but that it doesn't emit an error message. Or
8f5783ad9eb83747471f61f94dbe209fb9fb8a7d, or
2fd276c3ee4bd42eb034f8954964a5ae74187c6b, or
55cc33fab5ac9f7e2a97aa7c564e8b35355886d5. Just look at the output of git
log -Splatform_get_irq_optional to find some more.

That convinces me, that platform_get_irq_optional() is a bad name. The
only difference to platform_get_irq is that it's silent. And returning
a dummy irq value (which would make it aligned with the other _optional
functions) isn't possible.

> To me it sounds much more logical for the driver to check if an
> optional irq is non-zero (available) or zero (not available), than to
> sprinkle around checks for -ENXIO. In addition, you have to remember
> that this one returns -ENXIO, while other APIs use -ENOENT or -ENOSYS
> (or some other error code) to indicate absence. I thought not having
> to care about the actual error code was the main reason behind the
> introduction of the *_optional() APIs.

No, the main benefit of gpiod_get_optional() (and clk_get_optional()) is
that you can handle an absent GPIO (or clk) as if it were available.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--c63mbqxqltqrb5xh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHfSKAACgkQwfwUeK3K
7AlLYgf/TzHojP4Z3A1x+jOxObpLjnDBfLk/J2fJ3fPc7MQFDJwGCubx9/Taculx
9FL859wRU0HEqwefh3A61whyx3wDxBePJWJBBvU1jVZE12XHbvfARqHXYlZH3/rs
+NUE/+WdKRh5YlDkOacjJ2x0lj7zudpEqvRquEuCaHNFX1bshPpw723FFZSyVLV3
8sZFHYevwi62q3h1gUPq6tUZib+WVnmCnladf6UYgGxgJQLu/YdvCm5+lp6N6H8u
orUVG5PWROmD0F2c504T2qCD7O0hwj+667BfsU5JBAODQJm8dB47BGxjdoU52a2F
mMckMccinC+jzqqzaJB4DTX2lMD57Q==
=ndjr
-----END PGP SIGNATURE-----

--c63mbqxqltqrb5xh--
