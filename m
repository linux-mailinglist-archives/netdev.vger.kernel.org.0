Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8394307F2
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 12:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245300AbhJQKhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 06:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245288AbhJQKg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 06:36:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1886FC061765
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 03:34:50 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mc3Ux-0001EM-0d; Sun, 17 Oct 2021 12:34:35 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-11af-1534-a8a1-94ea.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:11af:1534:a8a1:94ea])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B2A4269588C;
        Sun, 17 Oct 2021 10:18:33 +0000 (UTC)
Date:   Sun, 17 Oct 2021 12:18:32 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Qing Wang <wangqing@vivo.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: can: replace snprintf in show functions with
 sysfs_emit
Message-ID: <20211017101832.undtxyggz6uemhrc@pengutronix.de>
References: <1634280624-4816-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="r4wtyintqvqolpk3"
Content-Disposition: inline
In-Reply-To: <1634280624-4816-1-git-send-email-wangqing@vivo.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--r4wtyintqvqolpk3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.10.2021 23:50:24, Qing Wang wrote:
> show() must not use snprintf() when formatting the value to be
> returned to user space.
>=20
> Fix the following coccicheck warning:
> drivers/net/can/at91_can.c:1185: WARNING: use scnprintf or sprintf.
> drivers/net/can/janz-ican3.c:1834: WARNING: use scnprintf or sprintf.
>=20
> Use sysfs_emit instead of scnprintf or sprintf makes more sense.
>=20
> Signed-off-by: Qing Wang <wangqing@vivo.com>

Added to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--r4wtyintqvqolpk3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFr+HUACgkQqclaivrt
76nCnwgAiBwsQvQVZBI76FzwuzXifXWrwSWVnd39uQefzeAW8fLzPg/8DBu7QtqV
OsqVqqOES9fHpv0L8CtqOfof4QrFitq9KBMT6AsF7eLK6W1UNaS2utZvenop3Fvv
RyHpLUnVsCV++lIo9R1+1PSuCVHfKSH07vUiB1Ckki37iMKqVe1qGaCBocwlWKJL
NlsrVwZIBzGLoNqhmJZuOmxwC3hOZJ9AofdQpnO8CZSpHIm0OlDRSYMkhwCGNwUO
wSg805lpsp4ZTNuR9wt9RtLOCP5IM0aAYWDV3aRBlfZ+DEtvj2Edl2NxETBlQs7x
aW3OeqleYWCvoA/3b4GZySi9dHb9hw==
=LwGq
-----END PGP SIGNATURE-----

--r4wtyintqvqolpk3--
