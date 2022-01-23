Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FB3497623
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 23:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiAWWtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 17:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbiAWWta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 17:49:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CAAC06173D
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 14:49:30 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nBlfq-0001GQ-BO; Sun, 23 Jan 2022 23:49:26 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9DCD72062F;
        Sun, 23 Jan 2022 22:49:25 +0000 (UTC)
Date:   Sun, 23 Jan 2022 23:49:22 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH 5/5] spi: make remove callback a void function
Message-ID: <20220123224922.hnnblbdt7ff2oiwk@pengutronix.de>
References: <20220123175201.34839-1-u.kleine-koenig@pengutronix.de>
 <20220123175201.34839-6-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rtkpivr4wsk5oybh"
Content-Disposition: inline
In-Reply-To: <20220123175201.34839-6-u.kleine-koenig@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rtkpivr4wsk5oybh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.01.2022 18:52:01, Uwe Kleine-K=C3=B6nig wrote:
> The value returned by an spi driver's remove function is mostly ignored.
> (Only an error message is printed if the value is non-zero that the
> error is ignored.)
>=20
> So change the prototype of the remove function to return no value. This
> way driver authors are not tempted to assume that passing an error to
> the upper layer is a good idea. All drivers are adapted accordingly.
> There is no intended change of behaviour, all callbacks were prepared to
> return 0 before.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/net/can/m_can/tcan4x5x-core.c                 |  4 +---
>  drivers/net/can/spi/hi311x.c                          |  4 +---
>  drivers/net/can/spi/mcp251x.c                         |  4 +---
>  drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c        |  4 +---

For the CAN changes:

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rtkpivr4wsk5oybh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHt228ACgkQqclaivrt
76nCMAgAj2xkyf4Z1Y7tvEAxM2dJ6PYPh/yY8fCaqnP+HVdp/VSxt1eE1yDvAA+9
zfYFYtXyb832KTEAZFmSZHLxHH9p9NtyZvgdoR40Hsoo0lxuDYCQccPF58CLpsof
xlHro1MvKdV3wFirAYwmR3TnoQ/NIUps0+XFw0UVoWok0XoN/bn8oYfpeO70frkM
L0/gRqclTdwM/Q/GLTiRdfYszeizj6MFUcUJaf1b8/hxOJ94EaBSYEdcx9YYnATz
Er8Jv4/BYP/Zj9sKMNJA+bddgotwMA8tVaI+uBVvXtycdwAAilJj8Q6Xq+ZVRbTY
2RMSxJwzV9g/FPqx827h1DJi1thh8g==
=IHI7
-----END PGP SIGNATURE-----

--rtkpivr4wsk5oybh--
