Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 126D96F6AC
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 01:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfGUXld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 19:41:33 -0400
Received: from ozlabs.org ([203.11.71.1]:56505 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfGUXlc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jul 2019 19:41:32 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45sLqD4m03z9s00;
        Mon, 22 Jul 2019 09:41:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1563752489;
        bh=A73xrVjphB9W4z8Lkt8lJE3bTn7LWxdCbv+O6Yr0pG4=;
        h=Date:From:To:Cc:Subject:From;
        b=sLF1CvDHQG40Lo3735avIZ7UUymwOhzDwwWiJBnng4gS9LS/mIGx837TgrFXcGGnM
         7Uoq+kF/LpS9nSKjFVm1niOcmm/Qd+5aO2qUMttUd4BAcWhXo7BeopD/YMBkR0CSlH
         M1c+qHnXS6efXCPomwu4C2nkjxLQCXXxlVmRl6iv3+y38E5nxsvcH0NvtIm6RFdIrD
         OqkwDoUCQEKaP+OqGWQJajoEXQNGRft5Fejvk0/zKWKUUBz41qHN9F/GIC3CnqThK/
         8hzk77nRQosTv3HIP2u3L49c0eFVgMIxdywCtFghyrBNiFcZJOSQ0sPnBXtRW40XEU
         9/ztVpCDQRVLQ==
Date:   Mon, 22 Jul 2019 09:41:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Jeremy Sowden <jeremy@azazel.net>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-ID: <20190722094121.432266f8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mI++v1RjvmcDc/3ttdw8FCk";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/mI++v1RjvmcDc/3ttdw8FCk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got a conflict in:

  include/Kbuild

between commit:

  67bf47452ea0 ("kbuild: update compile-test header list for v5.3-rc1")

from Linus' tree and commit:

  408d2bbbfd46 ("kbuild: add net/netfilter/nf_tables_offload.h to header-te=
st blacklist.")

from the net tree.

I fixed it up (I used the former version) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/mI++v1RjvmcDc/3ttdw8FCk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl00+CEACgkQAVBC80lX
0GxtIQf+Mf3fkJ2gN6xa1NXnQ1UVRxy1Ce12sX9GKNiiLwvToegkX0P49H9QysNh
vpfLltkMm8WXZACcol5UL2VhUF+K+8kmu3cwkRecQe2T8o505o87IcIe8DLVcmLC
JUVkzy5I+1kULwr4KyKP5NxtkzYLqPq2N4CIoVhabJKlZL8wr+skyQrf9wdU6C6L
7CIDSWrOdW5+SOGfurFiIMLFPYjWqUzPoDisd+a3XxbbDZmrCrgCH4yQrnaKlquQ
mYkme4cmXZYu9C2xyxNgb1+U8QAyx+gmwtg1iKFPb7kTs7p2Ikx+lSUcH4KB3lO+
nLlBmNVdXMfsvMBT7fqDHElEI0o6WA==
=hQAB
-----END PGP SIGNATURE-----

--Sig_/mI++v1RjvmcDc/3ttdw8FCk--
