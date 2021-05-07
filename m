Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E5D376118
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 09:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhEGH03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 03:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhEGH01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 03:26:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C167C061761
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 00:25:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1leurU-00039K-76; Fri, 07 May 2021 09:25:24 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:1c71:1fb7:6204:3618])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 801CE61E95B;
        Fri,  7 May 2021 07:25:22 +0000 (UTC)
Date:   Fri, 7 May 2021 09:25:21 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Drew Fustini <drew@beagleboard.org>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        Will C <will@macchina.cc>, menschel.p@posteo.de
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Message-ID: <20210507072521.3y652xz2kmibjo7d@pengutronix.de>
References: <20210407080118.1916040-1-mkl@pengutronix.de>
 <20210407080118.1916040-7-mkl@pengutronix.de>
 <CAPgEAj6N9d=s1a-P_P0mBe1aV2tQBQ4m6shvbPcPvX7W1NNzJw@mail.gmail.com>
 <a46b95e3-4238-a930-6de3-360f86beaf52@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zgdc2i5vhwpzbjcf"
Content-Disposition: inline
In-Reply-To: <a46b95e3-4238-a930-6de3-360f86beaf52@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zgdc2i5vhwpzbjcf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.04.2021 09:18:54, Marc Kleine-Budde wrote:
> On 4/21/21 9:58 PM, Drew Fustini wrote:
> > I am encountering similar error with the 5.10 raspberrypi kernel on
> > RPi 4 with MCP2518FD:
> >=20
> >   mcp251xfd spi0.0 can0: CRC read error at address 0x0010 (length=3D4,
> > data=3D00 ad 58 67, CRC=3D0xbbfd) retrying
>=20
> What's the situation you see these errors?
>=20
> I'm not particular happy with that patch, as it only works around that one
> particular bit flip issue. If you really hammer the register, the driver =
will
> still notice CRC errors that can be explained by other bits flipping. Con=
sider
> this as the first order approximation of a higher order problem :) - the =
root
> cause is still unknown.
>=20
> > Would it be possible for you to pull these patches into a v5.10 branch
> > in your linux-rpi repo [1]?
>=20
> Here you are:
>=20
> https://github.com/marckleinebudde/linux-rpi/tree/v5.10-rpi/backport-perf=
ormance-improvements
>=20
> I've included the UINC performance enhancements, too. The branch is compi=
led
> tested only, though. I'll send a pull request to the rpi kernel after I've
> testing feedback from you.

Drew, Patrick, have you tested this branch? If so I'll send a pull
request to the raspi kernel.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zgdc2i5vhwpzbjcf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCU618ACgkQqclaivrt
76lWwggAtDF9QvyQiUgKvyA7rtoHTsb69Cj6EJw4RklI0ZoUqaLTHWF3dg4WwEWf
A73wofXFIhZ5vayfXxD4/2jZEvI5zx1GB78KNuX7HFRWgjEwLFGF9JiOQ6Hmi/NM
kqgOhBGZ7gNCKqLpEiO2AV7qw7i6FVJOWuhb/Is1CXWwrin7YuvFE72yv1Rpx2Bm
YpIgb9qPlu2YZMOgRqOEON6U0nGN+UuyeHWpxISZ2ico05dKeg31NNNhmAGjOJLF
ndpNX5ltOOXqQgivf3ofTVoD+x5BGn61tCkn6lFW2HElqT41jCwDSLGP4Vudt+xL
jBBBxf8XMeKEiXYTk09t4zU+A4GTvw==
=vCf+
-----END PGP SIGNATURE-----

--zgdc2i5vhwpzbjcf--
