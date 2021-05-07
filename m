Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722D33761E5
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbhEGI0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236160AbhEGI0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 04:26:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEA9C061761
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 01:25:41 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1levnm-0002Q3-HG; Fri, 07 May 2021 10:25:38 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:1c71:1fb7:6204:3618])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 225E861EA06;
        Fri,  7 May 2021 08:25:37 +0000 (UTC)
Date:   Fri, 7 May 2021 10:25:36 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Patrick Menschel <menschel.p@posteo.de>
Cc:     Drew Fustini <drew@beagleboard.org>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Will C <will@macchina.cc>
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Message-ID: <20210507082536.jgmaoyusp3papmlw@pengutronix.de>
References: <20210407080118.1916040-1-mkl@pengutronix.de>
 <20210407080118.1916040-7-mkl@pengutronix.de>
 <CAPgEAj6N9d=s1a-P_P0mBe1aV2tQBQ4m6shvbPcPvX7W1NNzJw@mail.gmail.com>
 <a46b95e3-4238-a930-6de3-360f86beaf52@pengutronix.de>
 <20210507072521.3y652xz2kmibjo7d@pengutronix.de>
 <c0048a2a-2a32-00b5-f995-f30453aaeedb@posteo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mtr57txgwgsdjfq5"
Content-Disposition: inline
In-Reply-To: <c0048a2a-2a32-00b5-f995-f30453aaeedb@posteo.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mtr57txgwgsdjfq5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.05.2021 08:21:57, Patrick Menschel wrote:
> >>> Would it be possible for you to pull these patches into a v5.10 branch
> >>> in your linux-rpi repo [1]?
> >>
> >> Here you are:
> >>
> >> https://github.com/marckleinebudde/linux-rpi/tree/v5.10-rpi/backport-p=
erformance-improvements
> >>
> >> I've included the UINC performance enhancements, too. The branch is co=
mpiled
> >> tested only, though. I'll send a pull request to the rpi kernel after =
I've
> >> testing feedback from you.
> >=20
> > Drew, Patrick, have you tested this branch? If so I'll send a pull
> > request to the raspi kernel.
> >=20

> not yet. Thanks for reminding me. I'll start a native build on a pi0w asa=
p.
>=20
> Is there any test application or stress test that I should run?

No, not any particular, do your normal (stress) testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mtr57txgwgsdjfq5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCU+X0ACgkQqclaivrt
76kJ5QgAp8RFjNdhr5VNxrgwBm4sFZPw9ixS9OfU0gqVgIVzvMLl/xPigE7nTMjq
OIYW+JChmdpsCtS90asIcylyG9W7mCxBRjVTSvIsRYDYKu1y5XApkJnz6PMExR2J
vrVFvK0t5KeaU9PAmKMYOz/0TjBSY9UBkumT2gYGiJt3wyh/J/SE15mKMNOhxhjJ
DWmTWE8LkgUBPfXYXPARt26Rw/xgzoRphfLvp+T61GFdoePfwHfZu7qbT1aFBeJ7
vL9UsDCCr/hvMgAXP3n1i0tZn83w4+wb2Xm7u8EPdPZw7n4fKxBUQaUdioXowWBf
PUPBozLYy/48eYS1+HvZ76nRDvRMEA==
=cpS3
-----END PGP SIGNATURE-----

--mtr57txgwgsdjfq5--
