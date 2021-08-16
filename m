Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B9C3ED8FF
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhHPObb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhHPOba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:31:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F99C0613C1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:30:59 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mFddg-0008S1-5t; Mon, 16 Aug 2021 16:30:56 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:3272:cc96:80a9:1a01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4EC7A668425;
        Mon, 16 Aug 2021 14:30:54 +0000 (UTC)
Date:   Mon, 16 Aug 2021 16:30:52 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add
 can_tdc_const::tdc{v,o,f}_min
Message-ID: <20210816143052.3brm6ny26jy3nbkq@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr>
 <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
 <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
 <20210816122519.mme272z6tqrkyc6x@pengutronix.de>
 <20210816123309.pfa57tke5hrycqae@pengutronix.de>
 <CAMZ6RqK0vTtCkSM7Lim2TQCZyYTYvKYsFVwWDnyNaFghwqToXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="huzcw6f2bihja6yc"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqK0vTtCkSM7Lim2TQCZyYTYvKYsFVwWDnyNaFghwqToXg@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--huzcw6f2bihja6yc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.08.2021 23:10:29, Vincent MAILHOL wrote:
[...]
> After the discussion I had with Stefan, I assumed mcp251xxfd also
> used relative TDCO.  However, in the mcp15xxfd family manual,
> Equation 3-10: "Secondary Sample Point" on page 18 states that:
>=20
> | SSP =3D TDCV + TDCO
>=20
> As I commented above, this is the formula of the absolute
> TDCO. Furthermore, in the example you shared, TDCO is
> 16 (absolute), not 0 (relative).

ACK

> *BUT*, if this is the absolute TDCO, I just do not get how it can
> be negative (I already elaborated on this in the past: if you
> subtract from TDCV, you are measuring the previous bit...)
>=20
> Another thing which is misleading to me is that the mcp15xxfd
> family manual lists the min and max values for most of the
> bittiming parameters but not for TDCO.
>=20
> Finally, I did a bit of research and found that:
> http://ww1.microchip.com/downloads/en/DeviceDoc/Section_56_Controller_Are=
a_Network_with_Flexible_Data_rate_DS60001549A.pdf

Interesting. This data sheet is older than the one of the mcp2518fd.

> This is *not* the mcp25xxfd datasheet but it is still from
> Microship and as you will see, it is mostly similar to the
> mcp25xxfd except for, you guessed it, the TDCO.
>=20
> It reads:
> | TDCMOD<1:0>: Transmitter Delay Compensation Mode bits
> | Secondary Sample Point (SSP).
> | 10 =3D Auto; measure delay and add CFDxDBTCFG.TSEG1; add TDCO
> | 11 =3D Auto; measure delay and add CFDxDBTCFG.TSEG1; add TDCO
> | 01 =3D Manual; Do not measure, use TDCV plus TDCO from the register
> | 00 =3D Disable
>=20
> | TDCO<6:0>: Transmitter Delay Compensation Offset bits
> | Secondary Sample Point (SSP). Two's complement; offset can be
> positive, zero, or negative.
> | 1111111 =3D -64 x SYSCLK
> | .
> | .
> | .
> | 0111111 =3D 63 x SYSCLK
> | .
> | .
> | .
> | 0000000 =3D 0 x SYSCLK
>=20
> Here, you can clearly see that the TDCO has the exact same range
> as the one of the mcp25xxfd but the description of TDCMOD
> changes, telling us that:
>=20
> | SSP =3D TDCV (measured delay) + CFDxDBTCFG.TSEG1 (sample point) + TDCO
>=20
> Which means this is a relative TDCO.
>=20
> I just do not get how two documents from Microchip can have the
> TDCO relative range of -64..63 but use a different formula. I am
> sorry but at that point, I just do not understand what is going
> on with your controller...

Me neither. I'll ask my microchip contact.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--huzcw6f2bihja6yc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEadpkACgkQqclaivrt
76nijQf/f5cgGi+vnS1wIdty9F4nhLbpuwe1ue79JyYYwv+BgvHv7LrERh0Gd6SB
r8yrq5x7ZTXqmRci1fMH0gQF6DctKaKnzU69MV6P00CbtbOET7uXNDbvtqoX59Y8
RNNQYgNnaWXXMDgHJJeOQhiJeFzkMlStNJbNENoDU2+HJkGTVag+XAKbtgKxWE2O
33x6ejiAMRpKiSPNRruLy8HzVVYzpOc7LgGhB7oHyOsJignUiSphSa+ew/oErrqI
AwGh6CBrsq7lC+trq8GdL+vRWkMaW0YuUbgjz6zRWV4I1aH5d4wmWh9Sr1UzkcGY
vtP6s1l8k4rnaothQa1caTRRSlekOA==
=1N+4
-----END PGP SIGNATURE-----

--huzcw6f2bihja6yc--
