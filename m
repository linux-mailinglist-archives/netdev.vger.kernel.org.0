Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B24A43047D
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfE3WB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:01:58 -0400
Received: from ozlabs.org ([203.11.71.1]:57473 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbfE3WB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 18:01:58 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45FLsl1nFVz9s4Y;
        Fri, 31 May 2019 07:52:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1559253163;
        bh=gOBTgmZaBjxqpDUeDB6t2pE2Hbw5l3eOipRGnzHP7pY=;
        h=Date:From:To:Cc:Subject:From;
        b=vI/yXlJ9Kg2gUNdSiinuIHNmEvmSkpTp3/pZuQBUx72Lj5c2/lRxR37AUTv/wlZCd
         CgacJXRf0cfNQ57AaXcUf+an8tk0Js8H/SBK+kHfJ6ILwubtosii3uhGm+mkNfwSh0
         l+DZce03wE21SVbFQPGmmZLHvIC/6PahnBtLnoBqdHCnq2lkEIbgLd/icrRVr9R8dL
         /5ILl0P987A6lbjzzZk4R10ejU4OQGvcwvtNYkDOllGZAIhtQjqH6GYEV+h9eDA3mz
         olag97kuov6+H5ary9uK0D60SbYvD+3+/05hW4C54Mmaw+Cg1ebnDbbc5DegjSQuP2
         WcYrSAUI/e/vA==
Date:   Fri, 31 May 2019 07:52:41 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20190531075241.63c45a9a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/APS2ye.u3t/PPPabyavOeAO"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/APS2ye.u3t/PPPabyavOeAO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  9414277a5df3 ("net/mlx5: Avoid double free in fs init error unwinding pat=
h")

Fixes tag

  Fixes: 40c3eebb49e51 ("net/mlx5: Add support in RDMA RX steering")

has these problem(s):

  - Target SHA1 does not exist

Did you mean

Fixes: 905f6bd30bb6 ("net/mlx5: Avoid double free of root ns in the error f=
low path")

--=20
Cheers,
Stephen Rothwell

--Sig_/APS2ye.u3t/PPPabyavOeAO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzwUKkACgkQAVBC80lX
0Gwb6Qf/WbXbNdJOvEKybT0z9SB+Ts6v8F2pQ3rKuW3RpXSwxg1qKSHfJc7To/rg
VEdinIe7DURap+dkR5LzWHl/nN28iAENzCSPSXaAlGoMl3Rag3XDG94H7TEF8s9G
vPQ4YX98Yl2GySnO60gMPxcPRVj6AKMBk/MNtwE/0kXKy9xeUwf/bd9F7FOcQoCv
eWZv8MreB8o4CA/dYYalShE4hx+UyB8O39nv5uYa3hUZ+jjc8Hc/mQEJTIID9JVl
Qd4F85ZmdO/Cknvd4K75TRdIKjd3r8xINQez6727buS4yH4HxLEJhy9F7mOylVGe
KYBKrJM/J2fi1F7UpGkb0NudTzZRxQ==
=Iy6v
-----END PGP SIGNATURE-----

--Sig_/APS2ye.u3t/PPPabyavOeAO--
