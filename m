Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8961A2CB232
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgLBBU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgLBBU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 20:20:57 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93A6C0613CF;
        Tue,  1 Dec 2020 17:20:16 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Cm1Nq4CNpz9sVl;
        Wed,  2 Dec 2020 12:20:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1606872012;
        bh=2BBORmO28OQrNMAKFDltjq2jGef4PCPVtyZhJEh5hMo=;
        h=Date:From:To:Cc:Subject:From;
        b=aqVZ8Blm7V3GfYEiMsNmtmb4EXNL4SjXCKN4mT7+yIwQO3+bC2YPK3XuwDAPGn9Mv
         Fmb1bT6+N1CLVPFa4LX3JqA5og/N65g2pvp1NzTVkGFy2DygL4mTUtO/GkjK4otbzS
         phUjOB2pyqkBanih10A4vPgoyhrlhMJGOpxJahtp5Gu8qxxPrxxfy/fWCPv4LH7PXU
         uP+t2HQxMRc4gtHCqvFV3Nvv+kIIqj2Cvb6kpVOzQdKURUOhfCzyR5H31tKw3OS3zB
         qYGQlYUIxglTLiN+oMUZO1DbqVplfpSMqTyxkjDck3PgGZb86wuDmumU3fvMwdy7xW
         AB7KIribUl2sw==
Date:   Wed, 2 Dec 2020 12:20:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Dwip N. Banerjee" <dnbanerg@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20201202122009.0fe25caf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jnQ5/SYgv+hnakVQmEtvnNU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/jnQ5/SYgv+hnakVQmEtvnNU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/ibm/ibmvnic.c

between commit:

  b71ec9522346 ("ibmvnic: Ensure that SCRQ entry reads are correctly ordere=
d")

from the net tree and commit:

  ec20f36bb41a ("ibmvnic: Correctly re-enable interrupts in NAPI polling ro=
utine")

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

--Sig_/jnQ5/SYgv+hnakVQmEtvnNU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/G68kACgkQAVBC80lX
0GyQOQf/TY6L+v0hZVg1AnpcXZ8P3KpGCvnrBzUD/QMxJt8HqJKXakz9XZ5dCwmK
k1zDcwjGpNlY9lAkCqMv7SY0CMR64sDhLXX5ezqse0h8aZK1PWrNYqCRJfERe9Rs
NF7EsE2j4QTQ4F6otxniNqI8royJo77TIiPd4Rhh4KxLOaQOJhUOIdpPTxnaUaFh
uP+PjSQqoZzakmO9+Ys+vJvjYNQz+HYe+Mwgj4at8+hvdYmjgS95Z3hOIByHqebK
TuVGTRbJ7JuRh5LMre7BPX8aqxpWzbT1W67zUYTIsmEdNPXH/gsDANYNvbdW3BCT
agkYLaXX2LHbYJzKcbNnUhfMTdDH/g==
=4gdj
-----END PGP SIGNATURE-----

--Sig_/jnQ5/SYgv+hnakVQmEtvnNU--
