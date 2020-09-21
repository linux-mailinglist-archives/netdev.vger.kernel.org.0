Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F278B2722CA
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 13:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgIULlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 07:41:10 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39190 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgIULlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 07:41:06 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1A1931C0B7A; Mon, 21 Sep 2020 13:41:04 +0200 (CEST)
Date:   Mon, 21 Sep 2020 13:41:03 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     eranbe@mellanox.com, lariel@mellanox.com, saeedm@mellanox.com,
        saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: remove unreachable return
Message-ID: <20200921114103.GA21071@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The last return statement is unreachable code. I'm not sure if it will
provoke any warnings, but it looks ugly.
   =20
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/=
net/ethernet/mellanox/mlx5/core/lib/clock.c
index 2d55b7c22c03..a804f92ccf23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -431,8 +431,6 @@ static int mlx5_ptp_verify(struct ptp_clock_info *ptp, =
unsigned int pin,
 	default:
 		return -EOPNOTSUPP;
 	}
-
-	return -EOPNOTSUPP;
 }
=20
 static const struct ptp_clock_info mlx5_ptp_clock_info =3D {


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2iRTwAKCRAw5/Bqldv6
8gI9AKCEv/XK+xGPjWP3jMGNJxrsc8FO+gCgu0sAJX21FBxsJt3eSOtpdEO80WI=
=6huk
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
