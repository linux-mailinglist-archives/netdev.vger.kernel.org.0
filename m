Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A5148F8CD
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 19:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbiAOSiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 13:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbiAOSiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 13:38:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73047C061401
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 10:38:11 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n8nvA-0003Jj-3l; Sat, 15 Jan 2022 19:37:00 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n8nux-00AUOf-7m; Sat, 15 Jan 2022 19:36:46 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n8nuv-0005gB-Q6; Sat, 15 Jan 2022 19:36:45 +0100
Date:   Sat, 15 Jan 2022 19:36:43 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>, alsa-devel@alsa-project.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        linux-phy@lists.infradead.org,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>,
        Lee Jones <lee.jones@linaro.org>,
        openipmi-developer@lists.sourceforge.net,
        Saravanan Sekar <sravanhome@gmail.com>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        kvm@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-serial@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        platform-driver-x86@vger.kernel.org, linux-pwm@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        Robert Richter <rric@kernel.org>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Corey Minyard <minyard@acm.org>, linux-pm@vger.kernel.org,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>, netdev@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-mmc@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-spi@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
 (summary)
Message-ID: <20220115183643.6zxalxqxrhkfgdfq@pengutronix.de>
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
 <20220110195449.12448-2-s.shtylyov@omp.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="j6ppxzwmobiijznr"
Content-Disposition: inline
In-Reply-To: <20220110195449.12448-2-s.shtylyov@omp.ru>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--j6ppxzwmobiijznr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I'm trying to objectively summarize the discussions in this thread in
the hope this helps finding a way that most people can live with.

First a description of the status quo:

There are several function pairs *get() and *get_optional() that however
are different in various aspects. Their relevant properties are listes
in the following table. Ideally each line had only identical entries.

					| clk_get		| gpiod_get		| platform_get_irq	| regulator_get		|
	return value			|			|			|			|			|
	on not-found			| ERR_PTR(-ENOENT)	| ERR_PTR(-ENOENT)	| -ENXIO		| dummy[1]	=
	|
	(plain get)			|			|			|			|			|
					|			|			|			|			|
	return value			|			|			|			|			|
	on not-found			| dummy[1]		| dummy[1]		| -ENXIO		| ERR_PTR(-ENOENT)	|
	(get_optional)			|			|			|			|			|
					|			|			|			|			|
	emits an error message		|			|			|			|			|
	on error (including 		| no			| no			| yes[2]		| no			|
	not-found)			|			|			|			|			|
					|			|			|			|			|
	get_optional emits an error	|			|			|			|			|
	message on error (including	| no			| no			| no			| no			|
	not-found)			|			|			|			|			|
					|			|			|			|			|
	summary:			| returning a dummy	| returning a dummy	| doesn't emit an	| ret=
urning error code	|
	*_get_optional() differs from	| on not-found		| on not-found		| error mess=
age		| on not-found		|
	*_get by:			|			|			|			|			|


	[1] the dummy value is a valid resource descriptor, the API functions
	    are a noop for this dummy value. This dummy value is NULL for
	    all three subsystems.
	[2] no error is printed for -EPROBE_DEFER.

The inversion between clk+gpio vs. regulator is unforunate, swaping one
or the other would be good for consistency, but this isn't the topic of
this thread. Only so much: It's not agreed upon which variant is the
better one and the difference is of historical origin.

There are now different suggestions to improve the situation regarding
platform_get_irq() compared to the other functions:

a) by Sergey
   platform_get_irq_optional() is changed to return 0 on not-found.

b) by Uwe
   rename platform_get_irq_optional() to platform_get_irq_silent()

The argument pro a) is:

	platform_get_irq_optional() is aligned to clk_get() and
	gpiod_get() by returning 0 on not-found.

The argument contra a)=20

	The return value 0 for platform_get_irq() is only syntactically
	nearer to the dummy value of clk_get() and gpiod_get(). A dummy
	value isn't available and probably not sensible to introduce for
	irq because most drivers have to check for the not-found
	situation anyhow to setup polling.=20

The argument pro b) is:

	The relevant difference between platform_get_irq() and its
	optional variant is that the latter is silent. This is a
	different concept for the meaning of optional compared to the
	other *_get_optional().

The argument contra b) is:

	The chosen name is bad, because driver authors might wonder what
	a silent irq is.

---- end of summary
=09
A possible compromise: We can have both. We rename
platform_get_irq_optional() to platform_get_irq_silent() (or
platform_get_irq_silently() if this is preferred) and once all users are
are changed (which can be done mechanically), we reintroduce a
platform_get_irq_optional() with Sergey's suggested semantic (i.e.
return 0 on not-found, no error message printking).

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--j6ppxzwmobiijznr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHjFDcACgkQwfwUeK3K
7Al8ywf+IeUGmQ++ZSqrHA1sy8iG93DkE7XqgEI+/OYaQABSzKpE6w55cBp0EbHJ
TXkVcUUkd5e6eFtr5FwZEgzO1/vKIlB6IkuD5jbuqXJy0oRz9whaVLAJvpYN/mmy
KTHzmFssgA4mbUBx8XRteoVSNn6k9z0UF6EGrb0Vyfu70Q4yTdZKDP2mznyAnLee
rw1Oj2UCu2Jn5QrSTg0jNrPqGbHrmEeadE08d3oZRpL/ZcO1Er30Oj3aYFDiiE1V
p0J5fzDs0GZN4r/mwNSUDyq2edsIF3F2/ILOt05pf6AsFudhufarTMh2VWIu/mz7
mMHkAm6dYTtw1VKd1mp/RwSpxhhJSw==
=6uea
-----END PGP SIGNATURE-----

--j6ppxzwmobiijznr--
