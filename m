Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699163D8927
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbhG1H4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbhG1H4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 03:56:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AD1C061760
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 00:56:15 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m8eQA-0000sS-Kd; Wed, 28 Jul 2021 09:56:06 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:7213:487e:ab4f:842a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 99551659F8F;
        Wed, 28 Jul 2021 07:56:03 +0000 (UTC)
Date:   Wed, 28 Jul 2021 09:56:02 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        mailhol.vincent@wanadoo.fr, socketcan@hartkopp.net,
        b.krumboeck@gmail.com, haas@ems-wuensche.com, Stefan.Maetje@esd.eu,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] can: fix same memory leaks in can drivers
Message-ID: <20210728075602.egmaxiqlkch6ujvj@pengutronix.de>
References: <cover.1627311383.git.paskripkin@gmail.com>
 <cover.1627404470.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kn4lllrif7pukgb2"
Content-Disposition: inline
In-Reply-To: <cover.1627404470.git.paskripkin@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kn4lllrif7pukgb2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.07.2021 19:59:12, Pavel Skripkin wrote:
> Hi, Marc and can drivers maintainers/reviewers!
>=20
> A long time ago syzbot reported memory leak in mcba_usb can driver[1]. It=
 was
> using strange pattern for allocating coherent buffers, which was leading =
to
> memory leaks. I fixed this wrong pattern in mcba_usb driver and yesterday=
 I got
> a report, that mcba_usb stopped working since my commit. I came up with q=
uick fix
> and all started working well.
>=20
> There are at least 3 more drivers with this pattern, I decided to fix lea=
ks
> in them too, since code is actually the same (I guess, driver authors jus=
t copy pasted
> code parts). Each of following patches is combination of 91c02557174b
> ("can: mcba_usb: fix memory leak in mcba_usb") and my yesterday fix [2].
>=20
>=20
> Dear maintainers/reviewers, if You have one of these hardware pieces, ple=
ase, test
> these patches and report any errors you will find.

Added to linux-can-next/testing.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kn4lllrif7pukgb2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEBDZAACgkQqclaivrt
76kGfgf+JCMpV9+udOzCu5a3UQeqsAoFbNZyUEnFZWr8jBJZsa9kpytiMLzr1xnD
5SF643QF1VO0b99a2yIO2YbtOP2gUNz8yVHodWoi4ajqDtTd+78OeFHeqAuocdek
nsXe0Cbl5ljBOKFp6CQG+rQGw9CM6N1wT6TOCCT1IaML7b1IWF4xjdbh1YRT/WMs
U1l6HPe08bdR1E60CWYv+C70063emyNRKus7kl4GrR1KwwyQbczySenNwwNizywb
HomeMKqo+4DG7OotHrp77ethU670PaQCuZCx2mcpEoTVKImMjXluG/NmFuv5A2Cz
zTgEsOQ+z4HkmrvpPPb01CPT8UFLFQ==
=0UgU
-----END PGP SIGNATURE-----

--kn4lllrif7pukgb2--
