Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC43C48E0BE
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 00:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbiAMXHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 18:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238121AbiAMXHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 18:07:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F80FC061574
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 15:07:20 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n89An-0001YX-LN; Fri, 14 Jan 2022 00:06:25 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n89Ai-00A99J-Gv; Fri, 14 Jan 2022 00:06:19 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n89Ah-0001rZ-FS; Fri, 14 Jan 2022 00:06:19 +0100
Date:   Fri, 14 Jan 2022 00:06:19 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
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
        Sergey Shtylyov <s.shtylyov@omp.ru>,
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
Message-ID: <20220113230619.m736tqd6u44vhuu5@pengutronix.de>
References: <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de>
 <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de>
 <745c601f-c782-0904-f786-c9bfced8f11c@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ea4rbv6vfrsr5m67"
Content-Disposition: inline
In-Reply-To: <745c601f-c782-0904-f786-c9bfced8f11c@gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ea4rbv6vfrsr5m67
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 13, 2022 at 01:42:57PM -0800, Florian Fainelli wrote:
>=20
>=20
> On 1/13/2022 11:43 AM, Uwe Kleine-K=F6nig wrote:
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
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> >=20
> > On Thu, Jan 13, 2022 at 02:45:30PM +0000, Mark Brown wrote:
> > > On Thu, Jan 13, 2022 at 12:08:31PM +0100, Uwe Kleine-K=F6nig wrote:
> > >=20
> > > > This is all very unfortunate. In my eyes b) is the most sensible
> > > > sense, but the past showed that we don't agree here. (The most anno=
ying
> > > > part of regulator_get is the warning that is emitted that regularily
> > > > makes customers ask what happens here and if this is fixable.)
> > >=20
> > > Fortunately it can be fixed, and it's safer to clearly specify things.
> > > The prints are there because when the description is wrong enough to
> > > cause things to blow up we can fail to boot or run messily and
> > > forgetting to describe some supplies (or typoing so they haven't done
> > > that) and people were having a hard time figuring out what might've
> > > happened.
> >=20
> > Yes, that's right. I sent a patch for such a warning in 2019 and pinged
> > occationally. Still waiting for it to be merged :-\
> > (https://lore.kernel.org/r/20190625100412.11815-1-u.kleine-koenig@pengu=
tronix.de)
> >=20
> > > > I think at least c) is easy to resolve because
> > > > platform_get_irq_optional() isn't that old yet and mechanically
> > > > replacing it by platform_get_irq_silent() should be easy and safe.
> > > > And this is orthogonal to the discussion if -ENOXIO is a sensible r=
eturn
> > > > value and if it's as easy as it could be to work with errors on irq
> > > > lookups.
> > >=20
> > > It'd certainly be good to name anything that doesn't correspond to one
> > > of the existing semantics for the API (!) something different rather
> > > than adding yet another potentially overloaded meaning.
> >=20
> > It seems we're (at least) three who agree about this. Here is a patch
> > fixing the name.
>=20
> From an API naming perspective this does not make much sense anymore with
> the name chosen, it is understood that whent he function is called
> platform_get_irq_optional(), optional applies to the IRQ. An optional IRQ=
 is
> something people can reason about because it makes sense.

The problem I see is that the semantic is different to the other
available *_get_optional() functions. And this isn't fixable for irqs.
So better don't use that naming scheme.

> What is a a "silent" IRQ however? It does not apply to the object it is
> trying to fetch to anymore, but to the message that may not be printed in
> case the resource failed to be obtained, because said resource is optiona=
l.
> Woah, that's quite a stretch.

I'm surprised that the semantic isn't obvious, but ok, I can accept
that.Can you maek a constructive suggestion here? What name pair would
you choose for the two functions functions under discussion?

(BTW, my favourite would be that platform_get_irq() doesn't emit an
error message and the caller is reliable for emitting that. But I think
it's too late for this approach.)

> Following the discussion and original 2 patches set from Sergey, it is not
> entirely clear to me anymore what is it that we are trying to fix.

(I think) Sergey's focus is:

	platform_get_irq_optional() returning -ENXIO is ugly, other
	functions return -ENOENT and other *_get_optional() functions
	return NULL for "This resource doesn't exist". So let's return 0
	in this case.

My focus is:

	There cannot be an "optional irq" where the driver doesn't have
	to care if the irq actually exist or not. So the pattern with
	*_get_optional() isn't sensible for irqs and if changing the
	returned value meaning "This resource doesn't exist" is sensible
	for platform_get_irq_optional(), I claim it's sensible for
	platform_get_irq(), too.

	So the semantic difference between platform_get_irq() and
	platform_get_irq_optional() is only that one emits an error
	message and the other doesn't. So this function pair should use
	a different naming than get + get_optional as this naming evokes
	expectations that must be wrong as there cannot be a dummy irq
	value.

> I nearly forgot, I would paint it blue, sky blue, not navy blue, not light
> blue ;)

no way. green is the ultimate blue for platform_get_irq() :-)

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--ea4rbv6vfrsr5m67
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHgsGcACgkQwfwUeK3K
7AmCGgf+KUjAbnx/+md2hoJgWXkf2TARYfElER6NhM1xxoNKhleR2n9Y2SomZoh7
GcsuunNU5jXbVHMH53qA3p34MwFiUjtH8qugReIosuYo9kAjJHcR/uAXVZVx8a5W
593KJ+wnpGGjBIajlW4L9XKhKUGIgCjx5n9pZTnS/9TD0T5RY7pvpN1XdyHhqHzO
owFdQFBvf7vN9Md4mdzl3usr15hf3ZFkobzBuDjMwour/CoOVu6yOVe+ihkXfa4o
SQua8+L+ooV6dgRrG0kq9oYU/xDTMEPJCK1Ap8ff2rb9KDCaRwljavHmmk6Thff9
7uYWNCwmj3gTXd6TD4b3BK+FIBMfSQ==
=oNtc
-----END PGP SIGNATURE-----

--ea4rbv6vfrsr5m67--
