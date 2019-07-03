Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B7B5E004
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 10:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfGCIkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 04:40:21 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:41477 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbfGCIkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 04:40:21 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45dvgj2YDcz9s8m;
        Wed,  3 Jul 2019 18:40:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562143218;
        bh=1gdQY+IG37Chq420+xnxxU0x3yvGw0besHVydkYixH4=;
        h=Date:From:To:Cc:Subject:From;
        b=HINRG2JQoHY9GVjqahdxAuuFzhyzOAo5HhLsFHRB4ZupHGU0BmNpGu8jAtwB67Syg
         23bbY2+0qxDShlz8mms7EBk9Un5csxOTUQh4z16iNf7v5F6y+BWX60JwGjVwt8uIPA
         AVzZeCJJUYtfbuKFiyl4vpcgM4Uauspy2E9GwhzBEd0YG4lsHditpdhF5nE7LGqI4I
         1n94hB0TSiQMAImSaseEX7JAtxp3ZdH/W0HJVgCuxwvKqNsh4Pm7xXlAd7mFMDINoA
         qyhUtSYTYLeTxhZP1xOtDfwS+ZNnCsc1TH1lrOwB2dlgZtix+wsJHqqQgDUCws27ef
         4b65rQQa87b7Q==
Date:   Wed, 3 Jul 2019 18:40:15 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Subject: linux-next: manual merge of the akpm-current tree with the net-next
 tree
Message-ID: <20190703184015.61a8f998@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/4R+rc6xvUJpW.8x1EQPYfk7"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/4R+rc6xvUJpW.8x1EQPYfk7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm-current tree got a conflict in:

  lib/Makefile

between commit:

  509e56b37cc3 ("blackhole_dev: add a selftest")

from the net-next tree and commit:

  c86f3a66de9a ("lib: introduce test_meminit module")

from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc lib/Makefile
index 0c3c197a7801,05980c802500..000000000000
--- a/lib/Makefile
+++ b/lib/Makefile
@@@ -91,7 -91,7 +91,8 @@@ obj-$(CONFIG_TEST_DEBUG_VIRTUAL) +=3D tes
  obj-$(CONFIG_TEST_MEMCAT_P) +=3D test_memcat_p.o
  obj-$(CONFIG_TEST_OBJAGG) +=3D test_objagg.o
  obj-$(CONFIG_TEST_STACKINIT) +=3D test_stackinit.o
 +obj-$(CONFIG_TEST_BLACKHOLE_DEV) +=3D test_blackhole_dev.o
+ obj-$(CONFIG_TEST_MEMINIT) +=3D test_meminit.o
 =20
  obj-$(CONFIG_TEST_LIVEPATCH) +=3D livepatch/
 =20

--Sig_/4R+rc6xvUJpW.8x1EQPYfk7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0cae8ACgkQAVBC80lX
0Gy3AggApB/d89kJt8k4S0magqHTtThobbRxQS/Eokve8980MKdI2SylS1g1SHxk
b3yXfswf08n8YNr63UlzlBuBTWc6TVWeu4xqz5Mja8jHwHOt9e5OjcnQL2BUDZE5
XsLipIx8OpUYJLZ2rTgQUuexv3fl4kS8LJfChcnjSR2uqQFGmGT9UPTWHWRq+VeF
6mEVd2sOC/ljN5J+NSwukifSynMGYNHR8vHb08/KJKzANtG8Fxg4r9WbQCu1EVuk
6iLhv8y4QjK9QUiDAjMqJZ4S44LdN3K3W72sPnEMRfFCzS01vmxDpFRHSxH+/QO1
3ors+tI/7ezFS0hT0L5MmGaMnvCd2g==
=eUEy
-----END PGP SIGNATURE-----

--Sig_/4R+rc6xvUJpW.8x1EQPYfk7--
