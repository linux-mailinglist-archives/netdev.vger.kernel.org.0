Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694D6742B7
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 02:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387688AbfGYAyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 20:54:18 -0400
Received: from ozlabs.org ([203.11.71.1]:60979 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728030AbfGYAyR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 20:54:17 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45vDHp4W94z9s4Y;
        Thu, 25 Jul 2019 10:54:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1564016055;
        bh=CtDpK/eCs/XjTXFGpNFgiwbr9oNlBKo8wVNVvbRB6RI=;
        h=Date:From:To:Cc:Subject:From;
        b=VBIC7XlqnSHdMyIIuGNivnGuXnfJWFajwdHlgO//aGD1xLRONkRV/spARLsVyIovs
         +y2dds7JTAPFgiQMCrPiOSpwcULCglo+iAK/paQGB8GonywJEfM2wb31nOupJBc1yf
         fcHvUxhzlWlrkbSPFFo/04ivlvj/XWfJw9Bpi5cyS1tJL7QPTpgdDkntbUa6uVp5vY
         HTmzQFuOi0rok8UR57LVwFHR1sW2UnVQCoLDbVesZMEmJpkguNsOOrAg3EfIfnvK0b
         IRbGn+uM/S+zDb48Jm+OoGlRcN2MsqPEfABfsUksrvX7KNL50IN/Ub6hNKhU70oOOj
         cxRWgcMqnd6og==
Date:   Thu, 25 Jul 2019 10:54:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Benjamin Poirier <bpoirier@suse.com>
Subject: linux-next: manual merge of the net-next tree with the jc_docs tree
Message-ID: <20190725105413.2e79aedb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/l=4b07mKDfUHi57GHTS8hni";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/l=4b07mKDfUHi57GHTS8hni
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  Documentation/PCI/pci-error-recovery.rst

between commit:

  4d2e26a38fbc ("docs: powerpc: convert docs to ReST and rename to *.rst")

from the jc_docs tree and commit:

  955315b0dc8c ("qlge: Move drivers/net/ethernet/qlogic/qlge/ to drivers/st=
aging/qlge/")

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

diff --cc Documentation/PCI/pci-error-recovery.rst
index e5d450df06b4,7e30f43a9659..000000000000
--- a/Documentation/PCI/pci-error-recovery.rst
+++ b/Documentation/PCI/pci-error-recovery.rst
@@@ -421,7 -421,3 +421,6 @@@ That is, the recovery API only require
     - drivers/net/ixgbe
     - drivers/net/cxgb3
     - drivers/net/s2io.c
-    - drivers/net/qlge
 +
 +The End
 +-------

--Sig_/l=4b07mKDfUHi57GHTS8hni
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl04/bUACgkQAVBC80lX
0GxFGQf/bZ+grLWvDeYd53dLGX5+i4C25MERID0fBWLYuktsEwnK2HLIFL7aQZnw
j/aid9hWbdLpdvTNystisGwCT6FUd0yBbHoJKQvGnBSiUhDhnhluinfKA29vVvEp
vIbW5wgieJNDmTKfJdM+NVBnz/rw1KTDNrS6HjztdGdNiExKeDLAhFhd+1ErDu+7
8IjD7mSyL/PPv1iKi6fbwxe5f/D20s7czrv8iJ/Po6QmMWlPVUBQiOo+29b5EPHh
e0zXiTwHHBy1aujh4mvWxWwvE+XVFFonUCSmDF/bKxPbFkLyYNbZIfNqPTz2HxtQ
id0l82+ffhR2imnGGBABWyN8Bbs2KA==
=lkdQ
-----END PGP SIGNATURE-----

--Sig_/l=4b07mKDfUHi57GHTS8hni--
