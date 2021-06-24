Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466CD3B38EA
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 23:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhFXVrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 17:47:41 -0400
Received: from ozlabs.org ([203.11.71.1]:58181 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232582AbhFXVrk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 17:47:40 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G9twG4vyMz9sWc;
        Fri, 25 Jun 2021 07:45:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624571119;
        bh=VWRgsKGXs+kf4/GDRzLPQ68mIjEHYRO3f7+CVc1LDWQ=;
        h=Date:From:To:Cc:Subject:From;
        b=oFYiMF8J/INuMyv8WE7t81EJWa74FqXaaYUK9E+Awuz0QCEZR344mnq5MLhisTW/q
         +su2dkXZ/4A6iRLj2VfTgEZiXhE1e6MH29BXLsrnUR28oTWz2TchGgXuBySPaHGMkv
         8YRefE1aC8OLZSHM4ph7CJVGAxiH8k7+uu2NOa52LKj3Wq3G38DvnyZs9Nupl4BqJ+
         SweSNvHAMh67g9cdx3V91e6oLUd9YP+HIbE/f//GqDZUOa6qcjet84aDUqtHjZ5w6r
         W9nVG9GXgcAJ7eFqOLGfJmpn3YSjzF6nJWlFgwlgaEb9y21YxdFS0vGd+FNrZzTTIg
         s1Kp02RFWKWIA==
Date:   Fri, 25 Jun 2021 07:45:17 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210625074517.685fb0f7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/AYD8r9ygZRo2/172wzLr+4M";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/AYD8r9ygZRo2/172wzLr+4M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  0ec13aff058a ("Revert "ibmvnic: simplify reset_long_term_buff function"")

Fixes tag

  Fixes: 1c7d45e7b2c ("ibmvnic: simplify reset_long_term_buff function")

has these problem(s):

  - SHA1 should be at least 12 digits long

This can be fixed for the future by setting core.abbrev to 12 (or more)
or (for git v2.11 or later) just making sure it is not set (or set to
"auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/AYD8r9ygZRo2/172wzLr+4M
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDU/O0ACgkQAVBC80lX
0GzhNwf+NojG313N29VJ5wIFTgpU8tivr9xiKfLduNAAhKMygb2iRFozu5F/z9+V
57qwkGjqPbqEZl9HwIsKy4JPEGtuXX/L1nKgne8ZdVkkPK+6eAGOiprbt4X0/vIE
g3nUDxzLgBJAsebLh7rFE/27nlwq9wfTitYk+s/LRIEL6RRAvZUzJlmt9reAuPAN
bEGkuHs561JIBs6lMMd4hHZtGQJoJ797DBTyeDroz8BMxw4wWXQJ6TkywGkb9DRc
kktnk3pT9awHaJ6zK50PjMgXP4cr/LJb3w3t7JX9mK6ef3KJ0ZWSxj/E3ji6ckqS
v2Hmo8bLXbCbAAPHSs2mVP2iACMd3g==
=xfRV
-----END PGP SIGNATURE-----

--Sig_/AYD8r9ygZRo2/172wzLr+4M--
