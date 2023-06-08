Return-Path: <netdev+bounces-9099-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DDD97273D8
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 02:47:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E2471C20F96
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 00:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E0417F6;
	Thu,  8 Jun 2023 00:47:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F168656
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 00:47:33 +0000 (UTC)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D1526A1;
	Wed,  7 Jun 2023 17:47:31 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Qc5CP6W05z4x1R;
	Thu,  8 Jun 2023 10:47:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1686185250;
	bh=9+VBRihQC1kxiac22/SSNW7COoo/z5MKjVrsIdAYukQ=;
	h=Date:From:To:Cc:Subject:From;
	b=D8xK2VT7m0KoaEsZQ5bK/JFKIf8YFIXlm4J4UPw9v8Ev+yb78gFBgb+V5J6LtZlnu
	 61lAjXAHgDpLQlhIn+5LBK/RSQVojaIPT8P1J0tUOS1dMjNKkPZihKwMqBAmtX7B74
	 kcLmoCSIQVI7A1rZT1NEjZLGUuzeET30rxB+u0SB5H4Wcu9XFDA+07AbYEYC+OdRGQ
	 fYyahudPdG8kbV0yMOHHNAc4VjTukb+MsNh0xbBoL677OU4gGPfm0QUjCb2j3BjWLE
	 Sqmmygey6PfARRmgCnL7nbHt/l9tZIt0r0hjDe1lDgh/k0/NLGfsQAhOda6MOLJDj/
	 +dX5U4VB8jigg==
Date: Thu, 8 Jun 2023 10:47:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg
 <johan.hedberg@gmail.com>, David Miller <davem@davemloft.net>, Jakub
 Kicinski <kuba@kernel.org>
Cc: Networking <netdev@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: duplicate patches in the bluetooth tree
Message-ID: <20230608104728.0be82edd@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/m+4kYf3TIw938ig_.FVeCNi";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/m+4kYf3TIw938ig_.FVeCNi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The following commits are also in the net tree as different
commits (but the same patches):

  f014353b6737 ("Bluetooth: L2CAP: Add missing checks for invalid DCID")
  1e309a698c05 ("Bluetooth: ISO: use correct CIS order in Set CIG Parameter=
s event")
  3a6c71cd5238 ("Bluetooth: ISO: don't try to remove CIG if there are bound=
 CIS left")
  5fb7bb517c03 ("Bluetooth: Fix l2cap_disconnect_req deadlock")
  f08424123e94 ("Bluetooth: hci_qca: fix debugfs registration")
  4a3c39cbee7c ("Bluetooth: fix debugfs registration")
  49d0d4d86bfb ("Bluetooth: hci_sync: add lock to protect HCI_UNREGISTER")
  b4a17f5ec28a ("Bluetooth: Fix use-after-free in hci_remove_ltk/hci_remove=
_irk")
  695398e3d1f5 ("Bluetooth: ISO: Fix CIG auto-allocation to select configur=
able CIG")
  41ed839d161a ("Bluetooth: ISO: consider right CIS when removing CIG at cl=
eanup")

these are commits

  75767213f3d9 ("Bluetooth: L2CAP: Add missing checks for invalid DCID")
  71e9588435c3 ("Bluetooth: ISO: use correct CIS order in Set CIG Parameter=
s event")
  6c242c64a09e ("Bluetooth: ISO: don't try to remove CIG if there are bound=
 CIS left")
  02c5ea5246a4 ("Bluetooth: Fix l2cap_disconnect_req deadlock")
  47c5d829a3e3 ("Bluetooth: hci_qca: fix debugfs registration")
  fe2ccc6c29d5 ("Bluetooth: fix debugfs registration")
  1857c19941c8 ("Bluetooth: hci_sync: add lock to protect HCI_UNREGISTER")
  c5d2b6fa26b5 ("Bluetooth: Fix use-after-free in hci_remove_ltk/hci_remove=
_irk")
  e6a7a46b8636 ("Bluetooth: ISO: Fix CIG auto-allocation to select configur=
able CIG")
  31c5f9164949 ("Bluetooth: ISO: consider right CIS when removing CIG at cl=
eanup")

in the net tree

These have already caused one unnecessary conflict when merging the
bluetooth tree.
--=20
Cheers,
Stephen Rothwell

--Sig_/m+4kYf3TIw938ig_.FVeCNi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSBJSAACgkQAVBC80lX
0Gw96gf/WhNYc6pt2ZhdNcccuMrxc6jxh8Lup8XkhTf8hcJteKBF4p8ltF2VQ35y
Vu+Dl4MWZsm1wvbauzJx49N0jMZz9vdUpFmH1wOClKKt40Cxlh/BVJ0/vENMY7Ol
ZRddwtpaJav9WI7jhcGcD4dcEXIuMgzb2yPViNCXnoNeU92NHE5F9SkYMpHrO3PX
wDPQJ9DLTMgdH8zTmJcjsHje69PWQM7vWjp3SjO+p67jFHNhA0enflkiLgNOmJg7
bmWlfSkaPOTezVdnmFPveYx3jzgzTNrUovYndgrw6O5IE5S2rlCGLzvTB9/XR92v
kaWHQBzYAvPSLa3r2SkD0rzAiqrAVA==
=orrH
-----END PGP SIGNATURE-----

--Sig_/m+4kYf3TIw938ig_.FVeCNi--

