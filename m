Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6E560C4D4
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiJYHQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiJYHQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:16:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F34B14E0
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 00:16:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onEAH-0005xX-AG; Tue, 25 Oct 2022 09:15:57 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7214C109279;
        Tue, 25 Oct 2022 07:15:55 +0000 (UTC)
Date:   Tue, 25 Oct 2022 09:15:51 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Sebastian =?utf-8?B?V8O8cmw=?= <sebastian.wuerl@ororatech.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Timo =?utf-8?B?U2NobMO8w59sZXI=?= <schluessler@krause.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] can: mcp251x: fix error handling code in
 mcp251x_can_probe
Message-ID: <20221025071551.ghj2hhcxxdfcjbcp@pengutronix.de>
References: <20221024090256.717236-1-dzm91@hust.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qfguc5tuuzqidvwz"
Content-Disposition: inline
In-Reply-To: <20221024090256.717236-1-dzm91@hust.edu.cn>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qfguc5tuuzqidvwz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.10.2022 17:02:52, Dongliang Mu wrote:
> In mcp251x_can_probe, if mcp251x_gpio_setup fails, it forgets to
> unregister the can device.
>=20
> Fix this by unregistering can device in mcp251x_can_probe.
>=20
> Fixes: 2d52dabbef60 ("can: mcp251x: add GPIO support")
> Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>

Applied to can/main.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qfguc5tuuzqidvwz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNXjSUACgkQrX5LkNig
013iJAf/TNNi8uXYP3ngYHUtPflKn8hjFygxbAR+D3nv23s1rExgBG84Wcw3y05f
J7B9UcOa7xU5wmU7Yqcf3sin1+FBVqMIRbHnHhnq12lj3BTtpN1qVLdPBHPe24uV
EjbPHEoxd5QsGXhN+/byiKIUQ7gIwYCZtvp/KDU3s7hzqct4c4mAk/lvKVwd4zwL
4FTZnA5bkJ7MeupPvKe3IXIfyuexfftIeP5Zlku2CKxYNr/fFoCiGvXm2G1F+RXT
oUmqWTPs0SLQi+5kl/7CL2B2KHFc/DuwLtJdbXI4MA/+OC+L09YRWrkHKqvXeZjE
K/UmturqbBZov7tBrAMTSzZFg/tEEg==
=32pt
-----END PGP SIGNATURE-----

--qfguc5tuuzqidvwz--
