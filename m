Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9486347FB
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 21:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbiKVUSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 15:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbiKVUSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 15:18:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8EF18380
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:18:13 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oxZhX-0006Qx-Bo; Tue, 22 Nov 2022 21:17:03 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oxZhR-005v1B-UM; Tue, 22 Nov 2022 21:16:58 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oxZhS-000s7U-3N; Tue, 22 Nov 2022 21:16:58 +0100
Date:   Tue, 22 Nov 2022 21:16:54 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Jonathan Cameron <jic23@kernel.org>
Cc:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        alsa-devel@alsa-project.org, linux-staging@lists.linux.dev,
        linux-pwm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-leds@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        linux-serial@vger.kernel.org, linux-input@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-watchdog@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-actions@lists.infradead.org, linux-gpio@vger.kernel.org,
        Angel Iglesias <ang.iglesiasg@gmail.com>,
        gregkh@linuxfoundation.org, linux-rpi-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Purism Kernel Team <kernel@puri.sm>,
        patches@opensource.cirrus.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Wolfram Sang <wsa@kernel.org>, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-integrity@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 000/606] i2c: Complete conversion to i2c_probe_new
Message-ID: <20221122201654.5rdaisqho33buibj@pengutronix.de>
References: <20221118224540.619276-1-uwe@kleine-koenig.org>
 <20221122185818.3740200d@jic23-huawei>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="t3mjk627u66tfbb3"
Content-Disposition: inline
In-Reply-To: <20221122185818.3740200d@jic23-huawei>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--t3mjk627u66tfbb3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 22, 2022 at 06:58:18PM +0000, Jonathan Cameron wrote:
>=20
> Queued all of the below:
> with one tweaked as per your suggestion and the highlighted one dropped o=
n basis
> I was already carrying the equivalent - as you pointed out.
>=20
> I was already carrying the required dependency.
>=20
> Includes the IIO ones in staging.
>=20
> Thanks,
>=20
> Jonathan
>=20
> p.s. I perhaps foolishly did this in a highly manual way so as to
> also pick up Andy's RB.  So might have dropped one...

You could have done:

	H=3D$(git rev-parse @)
	b4 am -P 49-190 20221118224540.619276-1-uwe@kleine-koenig.org
	git am ...
	git filter-branch -f --msg-filter "grep -v 'Signed-off-by: Jonathan'; echo=
 'Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>'; echo '=
Signed-off-by: Jonathan Cameron <jic23@kernel.org>'" $H..

(untested, but you get the idea).

> Definitely would have been better as one patch per subsystem with
> a cover letter suitable for replies like Andy's to be picked up
> by b4.

Next time I will go for one series per subsystem which I like better
than one patch per subsystem.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--t3mjk627u66tfbb3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmN9LjMACgkQwfwUeK3K
7An96wf/RMtsCSXVJy8BDrXiXMhey9OEm8p08ulRn0lKYlG54KR8nU/s77uuMjGS
99aUfUU56Abxk02DuBv6N5Bax8nlFyIlUgkfaYPP9iN1TkF5XiucQ0Se4/haYL4A
q11UqWIcKBS+5BL3K6Bl1Cqv4dPYpRvs99X3jlU6JmhFqJPPhPgAu0p74arSvLie
kN6wgOGVdCjZTRD+Z7FxfIQPZqvVo7anPAynyk7XfgTXMSAK80JPR2UeMfvQ7yr2
W28htsacTaJSnPOb1VIrhN8OytpxASYa120EJ8augNmBXC0IzvjosWI0LZnNljAU
izPd/d6lzDCP0Mz/LU9QCBYUR1jxuQ==
=KmMu
-----END PGP SIGNATURE-----

--t3mjk627u66tfbb3--
