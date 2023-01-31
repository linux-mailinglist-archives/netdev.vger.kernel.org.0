Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62ED06831B7
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 16:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbjAaPjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 10:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbjAaPjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 10:39:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA11530EE
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 07:39:14 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pMsip-0003AW-G5; Tue, 31 Jan 2023 16:38:59 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:29f7:a2fc:d3f6:7550])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 430E116A532;
        Tue, 31 Jan 2023 15:38:57 +0000 (UTC)
Date:   Tue, 31 Jan 2023 16:38:51 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Wei Fang <wei.fang@nxp.com>, Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ore@pengutronix.de, kernel@pengutronix.de
Subject: Re: [PATCH] [v2] fec: convert to gpio descriptor
Message-ID: <20230131153851.ua57vy7vc2xdasup@pengutronix.de>
References: <20230126210648.1668178-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zy7tm2hvwiyorecs"
Content-Disposition: inline
In-Reply-To: <20230126210648.1668178-1-arnd@kernel.org>
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


--zy7tm2hvwiyorecs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.01.2023 22:05:59, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The driver can be trivially converted, as it only triggers the gpio
> pin briefly to do a reset, and it already only supports DT.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

On current net-next/main 6a8ab436831d ("Merge branch
'add-support-for-the-the-vsc7512-internal-copper-phys'") this causes the
riot board (arch/arm/boot/dts/imx6dl-riotboard.dts) to not probe the
fec:

| Jan 31 16:32:12 riot kernel: fec 2188000.ethernet: error -ENOENT: failed =
to get phy-reset-gpios
| Jan 31 16:32:12 riot kernel: fec: probe of 2188000.ethernet failed with e=
rror -2

reverting 468ba54bd616 ("fec: convert to gpio descriptor") solves the
problem.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zy7tm2hvwiyorecs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmPZNggACgkQrX5LkNig
01358Af+MUiH2K0uM45xSjCGqBLdDwmDH3hIqbN7YOmbRY078ZN0+8MY6rKY3iyE
vToSnRFKHe8jyWCnqVdNSJGt2O/jsZ6QmAk731rHccG04ZZijLfowpnZWAMteq7t
nEmF9HitPx3l2cKYRORxoxBPqdUisrW/CrN8Xed6rvvrW75CXbYDQ/44Zq0WeNSf
E0QHDOkHoEpb+p8C0n+fJ2iMnK4P3973C6Z8FyxGUBHI/0xnaJkCvS3Tf5vlrtd9
DImCP4MjnP/LsNZuR1nO6xcCel4QF3q9h3Rzvtjc5CHNdehA1D1cw6aywelddDdB
oGgvo1StDSAEnyZB0hhGnGKIXQtajw==
=b7eA
-----END PGP SIGNATURE-----

--zy7tm2hvwiyorecs--
