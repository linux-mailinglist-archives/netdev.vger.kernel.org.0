Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC7A477B8
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 03:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfFQBkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 21:40:39 -0400
Received: from ozlabs.org ([203.11.71.1]:40139 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbfFQBkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jun 2019 21:40:39 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45Rv6r0kXyz9s3l;
        Mon, 17 Jun 2019 11:40:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1560735636;
        bh=z075AqzJURu3z3H6UUHOCRHATUz4KC/gLfVxkTIRjBU=;
        h=Date:From:To:Cc:Subject:From;
        b=DclmCGjOA0UjHaDIWM83phtIIVllMOUAZ4niwCugLE6K7F/lDdA2JHhnN5NmgL8GH
         rOfHBy2umdX18I7zy7nDPTaxep0/yzEuCyQaXmzKmDDtPlBAPuO5+HhVAHzo006yHD
         DftP7Bs8pkzc3hYY4gIp3hi2SbihxfgvbtE4r6KPm2rs7iSI7YnjEDTYn/z7OOBOc9
         bpKtczyy9ksTQshy0m7rnUKMkChWW0ZorDjrundZNq71gRIGRvGI4G1h3ogjh1QXMr
         sX4yp2ZjoikTb/6Q1vn1BctXSIP1L88DaHJ86OHIOj9cSSlm/wpfSk3uS3EgH55ZQZ
         6sEw5USQZqjlg==
Date:   Mon, 17 Jun 2019 11:40:11 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: linux-next: manual merge of the net-next tree with the sh tree
Message-ID: <20190617114011.4159295e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/W_Stg192fWHnW6s/5Aj.VWh"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/W_Stg192fWHnW6s/5Aj.VWh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  arch/sh/configs/se7712_defconfig
  arch/sh/configs/se7721_defconfig
  arch/sh/configs/titan_defconfig

between commit:

  7c04efc8d2ef ("sh: configs: Remove useless UEVENT_HELPER_PATH")

from the sh tree and commit:

  a51486266c3b ("net: sched: remove NET_CLS_IND config option")

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

diff --cc arch/sh/configs/se7712_defconfig
index 6ac7d362e106,1e116529735f..000000000000
--- a/arch/sh/configs/se7712_defconfig
+++ b/arch/sh/configs/se7712_defconfig
@@@ -63,7 -63,7 +63,6 @@@ CONFIG_NET_SCH_NETEM=3D
  CONFIG_NET_CLS_TCINDEX=3Dy
  CONFIG_NET_CLS_ROUTE4=3Dy
  CONFIG_NET_CLS_FW=3Dy
- CONFIG_NET_CLS_IND=3Dy
 -CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
  CONFIG_MTD=3Dy
  CONFIG_MTD_BLOCK=3Dy
  CONFIG_MTD_CFI=3Dy
diff --cc arch/sh/configs/se7721_defconfig
index ffd15acc2a04,c66e512719ab..000000000000
--- a/arch/sh/configs/se7721_defconfig
+++ b/arch/sh/configs/se7721_defconfig
@@@ -62,7 -62,7 +62,6 @@@ CONFIG_NET_SCH_NETEM=3D
  CONFIG_NET_CLS_TCINDEX=3Dy
  CONFIG_NET_CLS_ROUTE4=3Dy
  CONFIG_NET_CLS_FW=3Dy
- CONFIG_NET_CLS_IND=3Dy
 -CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
  CONFIG_MTD=3Dy
  CONFIG_MTD_BLOCK=3Dy
  CONFIG_MTD_CFI=3Dy
diff --cc arch/sh/configs/titan_defconfig
index 1c1c78e74fbb,171ab05ce4fc..000000000000
--- a/arch/sh/configs/titan_defconfig
+++ b/arch/sh/configs/titan_defconfig
@@@ -142,7 -142,7 +142,6 @@@ CONFIG_GACT_PROB=3D
  CONFIG_NET_ACT_MIRRED=3Dm
  CONFIG_NET_ACT_IPT=3Dm
  CONFIG_NET_ACT_PEDIT=3Dm
- CONFIG_NET_CLS_IND=3Dy
 -CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
  CONFIG_FW_LOADER=3Dm
  CONFIG_CONNECTOR=3Dm
  CONFIG_MTD=3Dm

--Sig_/W_Stg192fWHnW6s/5Aj.VWh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0G73sACgkQAVBC80lX
0GxtgAf/WqE5lK//POEnbrqY5dg2m+0Vwr9YXdQn699cclXJj2ZBhVwI1SllC/h5
y1u1MWiPNPIKnRHf2GO5Y0tVbm9wdErMwsk1CGetoSHA+6SJ7kwzPyst/k+jON5p
qKbyx3PpM+fTl6kCpKc7pq/Lrmd/uw3Stqi30/NcXW0nBx2snM7HNPsj/iwsvsgv
VUdb3EN9H9daXNXXMaZ+MK3AURgvuFDvERpbPHVRvGUwLpMDIx6IQ+VK4hEuaKIB
eBqIT6N4DB1V8PIJcoViE6wyr1EGYrlKB2pOxwo6N416hzCklK9YPZu/ysfONl4c
q3QaSIUtRWToXJR7WCqVhUWEsN3kWA==
=HrYQ
-----END PGP SIGNATURE-----

--Sig_/W_Stg192fWHnW6s/5Aj.VWh--
