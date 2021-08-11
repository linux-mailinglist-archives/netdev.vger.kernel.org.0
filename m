Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7529C3E87B6
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 03:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhHKBjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 21:39:54 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58395 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhHKBjv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 21:39:51 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gksth1YQGz9sWS;
        Wed, 11 Aug 2021 11:39:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1628645966;
        bh=1YFO3kHG50QhRUMhTqKTIiavineTTdtGUidN3sw8EN4=;
        h=Date:From:To:Cc:Subject:From;
        b=EpgO7dKwAafvgHWS1f5Yf0ijB5Crsp9RchQMnb5Iczaa2YYgO8oEePRW+fgzPfGan
         z2ctUbsGF4JUSl8kMUh0h/V1bqRlMEGRJEC6DIyK0c13b9az/HHvxOsV6pNuIM1Nj1
         evwmYdP4fcDSqkoA6ioOoEneJjX67idNJkfmXw2WWfoeycqpkts93XwvGsj19MzKFM
         ohVfqaai5cQGNUZhHYIxBOHasYriY3ytylWj1HnNt2vLdmZJs7gU/61CrhyW/9Olsh
         Nts/Xr8Evm/fwc0R8QGFtezT2DTjayU5t1j86aN/LGkswJQMYY/hYFSLYGi3D4Zmy2
         hdrdH/2zR9NJQ==
Date:   Wed, 11 Aug 2021 11:39:23 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Xu Liang <lxu@maxlinear.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210811113923.210a999d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/oUhMhl9BivJGe.IybsDEoPs";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/oUhMhl9BivJGe.IybsDEoPs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  MAINTAINERS

between commit:

  7b637cd52f02 ("MAINTAINERS: fix Microchip CAN BUS Analyzer Tool entry typ=
o")

from the net tree and commit:

  7d901a1e878a ("net: phy: add Maxlinear GPY115/21x/24x driver")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc MAINTAINERS
index 9d7bc544a49d,41fcfdb24a81..000000000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -11339,7 -11341,13 +11353,13 @@@ W:	https://linuxtv.or
  T:	git git://linuxtv.org/media_tree.git
  F:	drivers/media/radio/radio-maxiradio*
 =20
+ MAXLINEAR ETHERNET PHY DRIVER
+ M:	Xu Liang <lxu@maxlinear.com>
+ L:	netdev@vger.kernel.org
+ S:	Supported
+ F:	drivers/net/phy/mxl-gpy.c
+=20
 -MCAB MICROCHIP CAN BUS ANALYZER TOOL DRIVER
 +MCBA MICROCHIP CAN BUS ANALYZER TOOL DRIVER
  R:	Yasushi SHOJI <yashi@spacecubics.com>
  L:	linux-can@vger.kernel.org
  S:	Maintained

--Sig_/oUhMhl9BivJGe.IybsDEoPs
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmETKksACgkQAVBC80lX
0GwikggAg767Icug4ln02ZeanbkY2Oq8Y1QB9601jJU+9Y70roKAAT0etKxuo5lS
xxgg0+RtU8y/Y6i3pnmy2Wm+b9fi7CtobnmSD4hKKVK4V3rCiv27KlY+etx7EL66
9tC/kAD87XbF/BnOl3UcW4Rau1eEcyJ3XmcXBhjP2k4uoubQPlmazAp97yYg3/uP
mesQpfXlBu8k/UO58NOjwvC5Ib7gAcoLZlEVpQgEc8U3qsiEu0ADW/+xgxRW6Uhu
LEP5wzrLXR3APmDdyzVeQLHhA3OHCabD5FirAzAyWUrLOIoOwPGAVCTUVUcPtdJ0
rKmDZYXU7vZWAU5sAFBq9/yl8PwdZQ==
=Ju0g
-----END PGP SIGNATURE-----

--Sig_/oUhMhl9BivJGe.IybsDEoPs--
