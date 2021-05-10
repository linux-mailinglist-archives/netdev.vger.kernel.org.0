Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6F1378095
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 11:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhEJJ4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 05:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbhEJJzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 05:55:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89947C061344
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:54:12 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lg2c5-0000Jm-Rz; Mon, 10 May 2021 11:54:09 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:80ab:77d5:ac71:3f91])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A7FAA6200B9;
        Mon, 10 May 2021 07:45:56 +0000 (UTC)
Date:   Mon, 10 May 2021 09:45:55 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Patrick Menschel <menschel.p@posteo.de>
Cc:     Drew Fustini <drew@beagleboard.org>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Will C <will@macchina.cc>
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Message-ID: <20210510074555.ufojb42u5cyrmomb@pengutronix.de>
References: <20210407080118.1916040-1-mkl@pengutronix.de>
 <20210407080118.1916040-7-mkl@pengutronix.de>
 <CAPgEAj6N9d=s1a-P_P0mBe1aV2tQBQ4m6shvbPcPvX7W1NNzJw@mail.gmail.com>
 <a46b95e3-4238-a930-6de3-360f86beaf52@pengutronix.de>
 <20210507072521.3y652xz2kmibjo7d@pengutronix.de>
 <c0048a2a-2a32-00b5-f995-f30453aaeedb@posteo.de>
 <20210507082536.jgmaoyusp3papmlw@pengutronix.de>
 <7cb69acc-ee56-900b-0320-a893f687d850@posteo.de>
 <b58d4484-db27-f199-875e-ae3694cd271f@posteo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2zdw3gilkfygg52a"
Content-Disposition: inline
In-Reply-To: <b58d4484-db27-f199-875e-ae3694cd271f@posteo.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2zdw3gilkfygg52a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.05.2021 07:46:20, Patrick Menschel wrote:
> > Do I have to change my test?
>=20
> I changed my test to 1 hour and removed the sleep statement.
> Still no measurable difference for performance and no CRC Errors with
> both kernels.

See other mail about my thoughts about performance and CRC.

> Apparently the test is hard on the CPU, I have two pytest processes
> listed in htop one with 80%CPU and one with 60% CPU, approx 30% ram
> usage of 512MB. I have no clue how it reaches the CPU values, there
> should be only one CPU on the pi0w.

Interesting :)

> ### 5.10.17+ on pi0w ###
>=20
> 2021-05-09 08:02:56 [    INFO] 725649 frames in 1:00:00
> (test_socketcan.py:890)
>=20
> ### 5.10.31-performance-backports+ on pi0w ###
>=20
> 2021-05-09 09:13:32 [    INFO] 715936 frames in 1:00:00
> (test_socketcan.py:890)
>=20
> I'll switch boards to a pi3b and test again with these settings.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2zdw3gilkfygg52a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCY5LEACgkQqclaivrt
76k2KQf+IkLY0SNsKy3+XbUpDeRFI8uUkzjnPy1T3+lSSxB0uHsYbwUlcV7MoQ7n
vKnJkcqufssvXhA7Prgh72rw5+4pE9jqTPngVJ5aCDbwm2yng/1IqvWlLpaKgWIl
Mn4F4ubyVTF6hcQirvwloVPKJ9iNR+Bq0skwN3GlHCEPfFL9/tA4Bd+3jLRwsM3L
RIPcfLbUuSZN0VuNmYTuLfccLH/4pEJEVCa6qcLmwjaH0IP0bd9uoFhRA77AQLe0
FAPkI14H8+mIdDTm2/G5Nbg9b0D4tepTRuUcUs9F1tycFnQ9BDUuV0wy3y6kvO8u
48lDb4Ssxw9dGLOzSmcGjHmvF9ugxA==
=xvTR
-----END PGP SIGNATURE-----

--2zdw3gilkfygg52a--
