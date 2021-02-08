Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D70C31331B
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 14:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBHNR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 08:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhBHNRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:17:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80378C06178A
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 05:16:34 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l96Ow-0002GX-TM; Mon, 08 Feb 2021 14:16:26 +0100
Received: from hardanger.blackshift.org (unknown [IPv6:2a03:f580:87bc:d400:291f:f238:66b7:a1f0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 26D0B5D951A;
        Mon,  8 Feb 2021 13:16:25 +0000 (UTC)
Date:   Mon, 8 Feb 2021 14:16:24 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: ucan: fix alignment constraints
Message-ID: <20210208131624.y5ro74e4fibpg6rk@hardanger.blackshift.org>
References: <20210204162625.3099392-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vqkgpkmoiryi4tmg"
Content-Disposition: inline
In-Reply-To: <20210204162625.3099392-1-arnd@kernel.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vqkgpkmoiryi4tmg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.02.2021 17:26:13, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> struct ucan_message_in contains member with 4-byte alignment
> but is itself marked as unaligned, which triggers a warning:
>=20
> drivers/net/can/usb/ucan.c:249:1: warning: alignment 1 of 'struct ucan_me=
ssage_in' is less than 4 [-Wpacked-not-aligned]
>=20
> Mark the outer structure to have the same alignment as the inner
> one.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vqkgpkmoiryi4tmg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAhOaUACgkQqclaivrt
76kDsggAjBB4gmiyUKFUv3+NtVEguwHIAxA4T+/wTqPecsG+UhmBCyl6jhXUQFBM
R0NfffCr8Z7bkj3QdERp8vRSnC2jG1+/SsmuiRFK1FSXIURdIBSn/L5XeIxtLQjZ
J9BTdz3YzPp+gADYkX3Ao+IB/rX7Tb2maUzdX3IBwhZFU/eVmlWw2hMgXNBwMCyo
6BvDJBpImY/iQtCixIA+ux6KBjE3QTL5Um+/X97PfuVv/d1K/u8tNEwymeAqydHo
RmY0SK3BueFJK3vD9uqlrsX/CDvCrlSrLz8UloXmkj2Ix1QUeLnyWIqXLUtMu3aP
Y68c49Lh/0fEXWNBh6LDUWSSBStEhA==
=sk+n
-----END PGP SIGNATURE-----

--vqkgpkmoiryi4tmg--
