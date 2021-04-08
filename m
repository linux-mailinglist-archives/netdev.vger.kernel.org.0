Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC060357AAF
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 05:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhDHDUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 23:20:12 -0400
Received: from ozlabs.org ([203.11.71.1]:38775 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhDHDUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 23:20:11 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FG62R37YTz9sVt;
        Thu,  8 Apr 2021 13:19:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1617851999;
        bh=V8UNQ4tLA/CI+huHa9ZOaaXjFej4UyWnGkN/d/pnZrw=;
        h=Date:From:To:Cc:Subject:From;
        b=qbEH7xGgNiolT+M3+8zj10jLZBYLU6WvUSgSqX+nAE24c0YgpGfsr5iNmavr4XVbi
         Q5axEGHncmd6guGFVdCAHe/pdIUlndyWAviC874ZewH1xqMspjQtzzb3tq/vTJN0Ys
         lNXCF6FIz+lMze0d1bieylG8oXxxaOK4arm/PK7rUf5dzTj2YeOkh1Q3InnXpYPB7u
         R5Ki3NXa/H/IUgaKfOur7iAksHC8PDrc0pIenBRlk9UEqPOylFq5ZvKJj1BJTtiEpN
         Gp24zZMImqaJoq9RqPkFwfqxXly36rCq41mSKVxWqcsVXaUjUGuZxtHIex3xxo3bc9
         MZiFC1ks7aZHA==
Date:   Thu, 8 Apr 2021 13:19:58 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Hoang Huu Le <hoang.h.le@dektech.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Xin Long <lucien.xin@gmail.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210408131958.0779430e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hDgq.2bVmj7h6NrpDWl5KcW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/hDgq.2bVmj7h6NrpDWl5KcW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/tipc/crypto.c

between commit:

  2a2403ca3add ("tipc: increment the tmp aead refcnt before attaching it")

from the net tree and commit:

  97bc84bbd4de ("tipc: clean up warnings detected by sparse")

from the net-next tree.

I fixed it up (I used the former version) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/hDgq.2bVmj7h6NrpDWl5KcW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBudl4ACgkQAVBC80lX
0GzZrwf/eE2FCS+7UwykVmjPoYU6Y0vL+CsYBDp8J3Lv+jYgYTvATTAAigFF3x+f
IetG6fMYO3Vl689SnHwWfA5IX27n4Gh+4+dgvN6tixtHNhol/gcyStIafaw+9TOL
NF5PtZMACY604IgS8INMAutdahOPhDByULlwsOw/Mwy3JVEAZPGg5KN5b3PwYeky
eRkThAWP7ZmPbt2zw7JOyuoJg7BN1kzN2YQF3y+ZRNgxFojnjTO7iCGSRoGxx59G
+7rKzXgARlAQxqiZaABvmk1qLLP8oC6aa6c5ZLNT/pxBAqJ40M0H+BhY2+LV9ams
zjcIAclDcxC+OKF9rzjzm1Cesi38Ww==
=0PE3
-----END PGP SIGNATURE-----

--Sig_/hDgq.2bVmj7h6NrpDWl5KcW--
