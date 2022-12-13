Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5E764BCF5
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 20:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbiLMTOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 14:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbiLMTOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 14:14:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622B223E8D
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 11:13:16 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p5AiE-0003Uv-1n; Tue, 13 Dec 2022 20:13:10 +0100
Received: from pengutronix.de (hardanger.fritz.box [IPv6:2a03:f580:87bc:d400:154c:16df:813d:4fb3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5520A13E17F;
        Tue, 13 Dec 2022 19:13:08 +0000 (UTC)
Date:   Tue, 13 Dec 2022 20:13:07 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/11] can: tcan4x5x: Specify separate read/write
 ranges
Message-ID: <20221213191307.vw6zhkiek3talig4@pengutronix.de>
References: <20221206115728.1056014-1-msp@baylibre.com>
 <20221206115728.1056014-12-msp@baylibre.com>
 <20221206162001.3cgtod46h5d5j7fx@pengutronix.de>
 <20221212105444.cdzzh2noebni4ibj@pengutronix.de>
 <20221213171034.7fg7m5zdehj2ksmj@blmsp>
 <20221213191025.ibq4xjhxcrlmcp45@blmsp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rtgc6rh5motdd4yt"
Content-Disposition: inline
In-Reply-To: <20221213191025.ibq4xjhxcrlmcp45@blmsp>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rtgc6rh5motdd4yt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.12.2022 20:10:25, Markus Schneider-Pargmann wrote:
> > > > According to "Table 8-8" 0xc is RO, but in "8.6.1.4 Status (address=
 =3D
> > > > h000C) [reset =3D h0000000U]" it clearly says it has write 1 to cle=
ar bits
> > > > :/.
> >=20
> > I am trying to clarify this. I guess table 8-8 is not correct, but we
> > will see.
>=20
> So it is indeed a typo in table 8-8. The register is R/W.

Do you have a contact to TI to fix this?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rtgc6rh5motdd4yt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOYzsAACgkQrX5LkNig
012zVwf/ZEHatu47R6RUl7eZr0d7193qSAnXeF0IAE7KPSVngQcajhrCnuDLmsWd
wzQ2e18qUL3yjuItDQWDbQfYG0MghgdpZf13oV/DfYZFchKq3H/cKxisHVOSL5S0
d5ILENJvw+Mf0YbUx3JvQBVoqNqCQCkj8oIoS0m2fddcbtdOkiwgq3+xRezCe7rq
zSIoxDzyS7FHQMOoFf+/ecrjYoLgU3g1TkqtTq23ilfAnccjFd45CCF+1fz6HGkU
uau/edRzgHwUtGQklgYrDZZV08rQ3Wg5Se0zmrVtvbkzMtaeL1gvIXiZvwV7aAXb
68gmsucVa1j6Ss43TTMfFRo1JufoBg==
=HJQS
-----END PGP SIGNATURE-----

--rtgc6rh5motdd4yt--
