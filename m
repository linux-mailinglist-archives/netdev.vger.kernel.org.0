Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187AE687964
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbjBBJqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbjBBJqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:46:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153A87D84
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:45:58 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pNW9r-0001mR-Ci; Thu, 02 Feb 2023 10:45:31 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:fff9:bfd9:c514:9ad9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 437EE16D10B;
        Thu,  2 Feb 2023 09:45:29 +0000 (UTC)
Date:   Thu, 2 Feb 2023 10:45:23 +0100
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
Subject: Re: [PATCH v3 1/2] net: fec: restore handling of PHY reset line as
 optional
Message-ID: <20230202094523.diwmp3xh47oesmai@pengutronix.de>
References: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ex7klsl5dwe2hkvu"
Content-Disposition: inline
In-Reply-To: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
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


--ex7klsl5dwe2hkvu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.02.2023 13:53:19, Dmitry Torokhov wrote:
> Conversion of the driver to gpiod API done in 468ba54bd616 ("fec:
> convert to gpio descriptor") incorrectly made reset line mandatory and
> resulted in aborting driver probe in cases where reset line was not
> specified (note: this way of specifying PHY reset line is actually
> deprecated).
>=20
> Switch to using devm_gpiod_get_optional() and skip manipulating reset
> line if it can not be located.
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

--ex7klsl5dwe2hkvu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmPbhjEACgkQvlAcSiqK
BOioUAf/VtrDO4hQX76US/UcDLkUNt4s55S8AqwPwfLmYMZ2m4BGihGN7Ec1oSvt
PFcKIvGwrfTpI3ScctjZwpU/6/MBKW+sh3cSrAYl5EEY7duN/vtOP9Ys2Lidkl+w
W3vPJ6bS3Y6nEzRPvCR3EMZLe45/1Mj22bFsqlxFYIYdxt5qkEGnNKmLWlwpPGBL
2u/V892/xJB9a93UChOJBPgXRQLojWvmNpFDq3jFko/qclqmSsLRbBBICa18YzF+
BfSB7qwo07xVaseTJB5ycT6a7HkXIVtscBkM7UnypQKrYlV5bvoloSLCe40FruqU
1wjzhIElxeteLvY2ztwXsNU4UglVdA==
=vs8x
-----END PGP SIGNATURE-----

--ex7klsl5dwe2hkvu--
