Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1ACD6861F2
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 09:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjBAIsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 03:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjBAIsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 03:48:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4408E054
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 00:48:12 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pN8mb-0006kl-VB; Wed, 01 Feb 2023 09:47:58 +0100
Received: from pengutronix.de (hardanger-6.fritz.box [IPv6:2a03:f580:87bc:d400:8296:86a1:ae4c:835e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6EBA516C02A;
        Wed,  1 Feb 2023 08:46:22 +0000 (UTC)
Date:   Wed, 1 Feb 2023 09:46:22 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Wei Fang <wei.fang@nxp.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: fec: fix conversion to gpiod API
Message-ID: <20230201084622.5tzezlax4a6iwbip@pengutronix.de>
References: <Y9nbJJP/2gvJmpnO@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2jdoexbfryawm6tm"
Content-Disposition: inline
In-Reply-To: <Y9nbJJP/2gvJmpnO@google.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
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


--2jdoexbfryawm6tm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31.01.2023 19:23:16, Dmitry Torokhov wrote:
> The reset line is optional, so we should be using devm_gpiod_get_optional=
()
> and not abort probing if it is not available. Also, there is a quirk in
> gpiolib (introduced in b02c85c9458cdd15e2c43413d7d2541a468cde57) that
> transparently handles "phy-reset-active-high" property. Remove handling
> from the driver to avoid ending up with the double inversion/flipped
> logic.
>=20
> Fixes: 468ba54bd616 ("fec: convert to gpio descriptor")
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2jdoexbfryawm6tm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmPaJtoACgkQrX5LkNig
013fmQf+PINBDIH3rMvwngjKhbM9eQmEa6SWNdUktZ9ow7VxLzxbTlp5Q2ARIZRL
Ho/KdpyPtYZCyjBm5LX3fglaAn4E/vr1HcQ1sTl3EeIyVxXXL460c9U6uIDY6+/p
mtJbNJCrVxbeB8H5zDf4tkylg0O6n+jEo4W2JqJ2u0qNmX/9YvSYjcI+77XiUpFg
DQqbuR/VQpFPtrrFTvv/0FlxFW/2lAS5zVYQcdmZPfD+AWzwCSzQlljtJHizHiUU
vg2qaVD1rGd+sXzuIeumVcapsO+53rjlLblY52BdxT7tg5xNlc/4JFC4g/gIXCn0
bE/nGEiSl+ODGcE0RmXOwUj0qKTvHQ==
=DRin
-----END PGP SIGNATURE-----

--2jdoexbfryawm6tm--
