Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BC85B5A29
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 14:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiILMc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 08:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiILMc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 08:32:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC671193DB
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 05:32:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oXibo-0003sZ-Kf; Mon, 12 Sep 2022 14:32:16 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:75e7:62d4:691e:2f47])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9AD89E132B;
        Mon, 12 Sep 2022 12:32:15 +0000 (UTC)
Date:   Mon, 12 Sep 2022 14:32:07 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?utf-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net 1/2] Revert "fec: Restart PPS after link state change"
Message-ID: <20220912123207.khaea6rhtwgycxud@pengutronix.de>
References: <20220912070143.98153-1-francesco.dolcini@toradex.com>
 <20220912070143.98153-2-francesco.dolcini@toradex.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="if6274iewzmwvuz4"
Content-Disposition: inline
In-Reply-To: <20220912070143.98153-2-francesco.dolcini@toradex.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--if6274iewzmwvuz4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.09.2022 09:01:42, Francesco Dolcini wrote:
> This reverts commit f79959220fa5fbda939592bf91c7a9ea90419040, this is
> creating multiple issues, just not ready to be merged yet.
>=20
> Link: https://lore.kernel.org/all/20220905180542.GA3685102@roeck-us.net/
> Link: https://lore.kernel.org/all/CAHk-=3Dwj1obPoTu1AHj9Bd_BGYjdjDyPP+vT5=
WMj8eheb3A9WHw@mail.gmail.com/
> Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--if6274iewzmwvuz4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMfJsIACgkQrX5LkNig
011tmggAgG5ynh5hfYsqhF4+Lu1Tem3T7wBNeyHjdEnLRLIEJ9eonHA/B6AimQAn
Z1nDZNP1JN1KHAanWTx0Aieyq5Q43UkB7G5E2d5nIKGNFegK4QzzkwfrCVE3Qh2Z
a4lOpAk4WpahVKdeS2o+w1yHO5TydihCMEIy7VgGhscUFmxiftvWk5DgzWhgJUux
APzIlPqLNrPG9/MVlTgY6zmXtyNRlGvj+Bv6BFbBcIuAgnDBRkn/meGxu5M72Svh
BNts/NQo2BGj8FbCP2mpWRE1W9E5772T8pruM0fi7cu6gH9hTciZE1Ap15c/xtR8
nO4sQ7ip35Ql2bqdkKZHTAZYn2hPaQ==
=kUPh
-----END PGP SIGNATURE-----

--if6274iewzmwvuz4--
