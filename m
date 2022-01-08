Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A26348867C
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbiAHVsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiAHVsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:48:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23DDC06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:48:00 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JZ2-000661-5h; Sat, 08 Jan 2022 22:47:52 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-6624-65e0-1d16-9a67.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:6624:65e0:1d16:9a67])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 87C246D3B64;
        Sat,  8 Jan 2022 21:47:49 +0000 (UTC)
Date:   Sat, 8 Jan 2022 22:47:48 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softingcs: Fix memleak on registration failure in
 softingcs_probe
Message-ID: <20220108214748.6sjxe6qzdv6db43y@pengutronix.de>
References: <20220108092555.17648-1-linmq006@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wdcdhssdfehwfc4b"
Content-Disposition: inline
In-Reply-To: <20220108092555.17648-1-linmq006@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wdcdhssdfehwfc4b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.01.2022 09:25:51, Miaoqian Lin wrote:
> In case device registration fails during module initialisation, the
> platform device structure needs to be freed using platform_device_put()
> to properly free all resources (e.g. the device name).
>=20
> Fixes: 0a0b7a5f7a04 ("can: add driver for Softing card")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>

Thanks for your patch, a similar one has already been posted:=20

| https://lore.kernel.org/all/20211222104843.6105-1-johan@kernel.org/

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--wdcdhssdfehwfc4b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHaBoEACgkQqclaivrt
76nZLQf/WplxQ7sJprpEyegWdcuLBeoFlM2X88LEV9qG6sOW4AkB8HV9k7G/Ublj
OoHnFxghx3mN1i4z6aUvh16NH+liY2GQlBqdvvKe0fmFL1fL1k1DPzieKjO5kANw
HXF1BhgXcwdCUzUQAGtInF5t0V5pPay3zSjlWGbfs3J0pVWcQ6Va3LYUpHhlptP5
VsQnruf824mS9w8QoVZrRLhGMhvMqqeIwf5DwsXIemi62IZ2ZeVVgdqTa0mx5l1h
IToq/f5bKqwrvDvgvb4JI9xXIeR8tKFEIymnz82ITu03E7tnSC33oIUr7y6Fi5QY
wVSzxYPt0vsSIgBa8D/Pxv9sts86gw==
=C7uj
-----END PGP SIGNATURE-----

--wdcdhssdfehwfc4b--
