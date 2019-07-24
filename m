Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43EC072BB6
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 11:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfGXJuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 05:50:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49665 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGXJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 05:50:19 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id CE01D8026A; Wed, 24 Jul 2019 11:50:04 +0200 (CEST)
Date:   Wed, 24 Jul 2019 11:50:15 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] marvell wireless: cleanup -- make error values consistent
Message-ID: <20190724095015.GA6592@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Surrounding code uses -ERRNO as a result, so don't pass plain -1.

Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wire=
less/marvell/mwifiex/scan.c
index 0d6d417..ddf75a5 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1243,7 +1243,7 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_ad=
apter *adapter,
 			mwifiex_dbg(adapter, ERROR,
 				    "err: InterpretIE: in processing\t"
 				    "IE, bytes left < IE length\n");
-			return -1;
+			return -EINVAL;
 		}
 		switch (element_id) {
 		case WLAN_EID_SSID:

   =20
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl04KdcACgkQMOfwapXb+vK11wCguU0JHbiXyg3ZXNo7SjMF7VAB
xQEAnAjRS3KcZwuWAd/nB0femwXZ+VJh
=QJB8
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
