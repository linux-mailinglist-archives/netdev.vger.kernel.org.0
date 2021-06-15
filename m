Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9083A7B48
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 11:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhFOJ66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 05:58:58 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39724 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbhFOJ65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 05:58:57 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1F8651C0B76; Tue, 15 Jun 2021 11:56:52 +0200 (CEST)
Date:   Tue, 15 Jun 2021 11:56:51 +0200
From:   Pavel Machek <pavel@denx.de>
To:     kernel list <linux-kernel@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] cxgb4: fix wrong shift.
Message-ID: <20210615095651.GA7479@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

While fixing coverity warning, commit
dd2c79677375c37f8f9f8d663eb4708495d595ef introduced typo in shift
value. Fix that.
   =20
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/ne=
t/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 22c9ac922eba..6260b3bebd2b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -198,7 +198,7 @@ static void set_nat_params(struct adapter *adap, struct=
 filter_entry *f,
 				      WORD_MASK, f->fs.nat_lip[3] |
 				      f->fs.nat_lip[2] << 8 |
 				      f->fs.nat_lip[1] << 16 |
-				      (u64)f->fs.nat_lip[0] << 25, 1);
+				      (u64)f->fs.nat_lip[0] << 24, 1);
 		}
 	}
=20


--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYMh5YwAKCRAw5/Bqldv6
8q6tAJ0QjHLPy2qQuG/ME6jlmA1SdaBCuACeL/XHAcxqI4Pf/8WPIHZTbHpgNwg=
=6RO4
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
