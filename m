Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D964B480D01
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 21:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbhL1UTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 15:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236101AbhL1UTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 15:19:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A22C061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 12:19:33 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n2IwU-0005OP-KF; Tue, 28 Dec 2021 21:19:30 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-0257-ed27-5549-d53a.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:257:ed27:5549:d53a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7BED46CCC26;
        Tue, 28 Dec 2021 20:19:29 +0000 (UTC)
Date:   Tue, 28 Dec 2021 21:19:28 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH bpf-next] net: don't include filter.h from net/sock.h
Message-ID: <20211228201928.wnz4gebzh6abkk26@pengutronix.de>
References: <20211228192519.386913-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6kbeggljhdsk2tf5"
Content-Disposition: inline
In-Reply-To: <20211228192519.386913-1-kuba@kernel.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6kbeggljhdsk2tf5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.12.2021 11:25:19, Jakub Kicinski wrote:
> sock.h is pretty heavily used (5k objects rebuilt on x86 after
> it's touched). We can drop the include of filter.h from it and
> add a forward declaration of struct sk_filter instead.
> This decreases the number of rebuilt objects when bpf.h
> is touched from ~5k to ~1k.
>=20
> There's a lot of missing includes this was masking. Primarily
> in networking tho, this time.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[...]
>  drivers/net/can/usb/peak_usb/pcan_usb.c           | 1 +

For the CAN driver:

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6kbeggljhdsk2tf5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHLcU0ACgkQqclaivrt
76kOuQf9EQdRIRgXJ2XS/MzJ30i6jTVQmQnoHWKVDjCGDHk5F7SDTrc9wi2kP/1N
f3FNnx2bcGsi3ZcvT2Gg6+UOIRbgPGnOLC57tDHiTYlSZF7HkBY61gG3uUsOnfC3
VjkO1QlG5KmTuLf+gTr68CuhsmXXK9VLtvozxPhvMatvzjmooXaEOJ1lCsVhJPny
m8mOt6UDqU+dstoblm1XmSx+s41xVC6FczgfCUha3qZC9rC+4MyLy68DfBZQ7AQ+
JyUlXOsNeTZdT40dr/3mUCNyauLbBIwv0B9jlpn73s0rts7MKMsk13SiLui1xwUr
LdIRxIjHZmjAQBi0tl3rAnypf/aQXw==
=IOkO
-----END PGP SIGNATURE-----

--6kbeggljhdsk2tf5--
