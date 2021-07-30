Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2521C3DB3DC
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 08:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbhG3Gse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 02:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237452AbhG3Gsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 02:48:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA0AC061765
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 23:48:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m9MJh-0003zF-Ll; Fri, 30 Jul 2021 08:48:21 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:999f:536:c369:29ed])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A2C2565B751;
        Fri, 30 Jul 2021 06:48:18 +0000 (UTC)
Date:   Fri, 30 Jul 2021 08:48:17 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Akshay Bhat <akshay.bhat@timesys.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] can: hi311x: fix a signedness bug in hi3110_cmd()
Message-ID: <20210730064817.jktiyy4rodvgjppi@pengutronix.de>
References: <20210729141246.GA1267@kili>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o4rz6babiigy7wze"
Content-Disposition: inline
In-Reply-To: <20210729141246.GA1267@kili>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--o4rz6babiigy7wze
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29.07.2021 17:12:46, Dan Carpenter wrote:
> The hi3110_cmd() is supposed to return zero on success and negative
> error codes on failure, but it was accidentally declared as a u8 when
> it needs to be an int type.
>=20
> Fixes: 57e83fb9b746 ("can: hi311x: Add Holt HI-311x CAN driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied to linux-can/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--o4rz6babiigy7wze
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEDoK8ACgkQqclaivrt
76k+sggArSfN5Qz1jEA+oE2PvBMy73+C8oCKI/tIS4bI55e2MienYaZLbKr5z4a/
xMuXRU2FQJEts0k8OCnSqR0HTdbVm8vTsK1nOS9r6cb2Wn6TSserdCg9AewBdEFY
fCxQ/VdgHeYWErNL+uWOHM45eoW1AmFVO+JCzaGsqCkj02/UomLM7LNX079pkhrb
MWM46nCWVsRGrcY0gVHf8HyX+cuDxXDfRNU/oCKnPYEopdoCktFs2hVANhaKxa/0
SrIToyAGlCqk1d1TJEZOJ38/N6uts+w9JgFUYFk3Ufn7hg23S/yllCUr9fk6h/wx
8/o2LaP3OyYPyDChsWR3ATDvXIDb6g==
=QFrE
-----END PGP SIGNATURE-----

--o4rz6babiigy7wze--
