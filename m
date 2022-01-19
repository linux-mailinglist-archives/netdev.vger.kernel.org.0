Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B83493998
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 12:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354181AbiASLfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 06:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354184AbiASLfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 06:35:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31813C061749
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 03:35:47 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nA9DT-0000wY-2d; Wed, 19 Jan 2022 12:33:27 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nA9DH-00BAYF-T8; Wed, 19 Jan 2022 12:33:15 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nA9DG-00031i-Rx; Wed, 19 Jan 2022 12:33:14 +0100
Date:   Wed, 19 Jan 2022 12:33:14 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>, kvm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>, alsa-devel@alsa-project.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, linux-spi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        openipmi-developer@lists.sourceforge.net,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-serial@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>, linux-pwm@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>, linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>, linux-gpio@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Sebastian Reichel <sre@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        platform-driver-x86@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>, netdev@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-mmc@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
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
 (summary)
Message-ID: <20220119113314.tpqfdgi6nurmzfun@pengutronix.de>
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
 <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220115183643.6zxalxqxrhkfgdfq@pengutronix.de>
 <YeQpWu2sUVOSaT9I@kroah.com>
 <20220118091819.zzxpffrxbckoxiys@pengutronix.de>
 <b6038ec2-da4a-de92-b845-cac2be0efcd1@omp.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hygdbs7bafily54q"
Content-Disposition: inline
In-Reply-To: <b6038ec2-da4a-de92-b845-cac2be0efcd1@omp.ru>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hygdbs7bafily54q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Sergey,

On Wed, Jan 19, 2022 at 01:56:12PM +0300, Sergey Shtylyov wrote:
> On 1/18/22 12:18 PM, Uwe Kleine-K=F6nig wrote:
> > On Sun, Jan 16, 2022 at 03:19:06PM +0100, Greg Kroah-Hartman wrote:
> >> On Sat, Jan 15, 2022 at 07:36:43PM +0100, Uwe Kleine-K=F6nig wrote:
> >>> A possible compromise: We can have both. We rename
> >>> platform_get_irq_optional() to platform_get_irq_silent() (or
> >>> platform_get_irq_silently() if this is preferred) and once all users =
are
> >>> are changed (which can be done mechanically), we reintroduce a
> >>> platform_get_irq_optional() with Sergey's suggested semantic (i.e.
> >>> return 0 on not-found, no error message printking).
> >>
> >> Please do not do that as anyone trying to forward-port an old driver
> >> will miss the abi change of functionality and get confused.  Make
> >> build-breaking changes, if the way a function currently works is
> >> changed in order to give people a chance.
> >=20
> > Fine for me. I assume this is a Nack for Sergey's patch?
>=20
>    Which patch do you mean? I'm starting to get really muddled... :-(

I'm talking about "[PATCH 1/2] platform: make
platform_get_irq_optional() optional" because "trying to forward-port an
old driver will miss the abi" applies to it.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--hygdbs7bafily54q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHn9vcACgkQwfwUeK3K
7Anutgf9H+FHDCwHTQEg3PqL/MwBWEgm2ezhN3NYztqf3gciss+k2d18HSOoYC3U
FVex76yzow2RaobKMmgXEqSv3MLbHgTm5YExNMaYIM5QuLAVJka/5uiXKJFMEsbE
GvlbYU/QbcQ/pUw5PTRvi07XghgBpKALgy+DTeK/4cOMQSsHBG8z8q2PSA5T/YX4
vqrrdvv7F0rIJR0pMUIVWZ0c15DeKt6fy53S9JW/ZQnBS/I7v1mJvP3kKo2+eEo6
nmF3qMmYbnrzxpAXhhWoB67zMIC+fhq6cYyhS5LuiHRcyM/xej00L+S/ZfXHpRR3
VTjGawN4GYEia7SPEAsh/CHlO3t4Vw==
=2ru9
-----END PGP SIGNATURE-----

--hygdbs7bafily54q--
