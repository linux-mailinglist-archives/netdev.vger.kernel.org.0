Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1113A1387F8
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 20:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733269AbgALTvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 14:51:06 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:45273 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732957AbgALTvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 14:51:06 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47wnQb4Mvpz9s29;
        Mon, 13 Jan 2020 06:51:02 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1578858664;
        bh=YJrCAGCTW+pQ5Aa6nSfF6ttqD/5c99CvooxYkZ1k7rI=;
        h=Date:From:To:Cc:Subject:From;
        b=s+QfH5pVowiaXM4tywG/+M7If6zwgOb/MjyXy2j/qUFmgni+FKvPzcBDCfZd2q5L9
         nynP+RbvfbHgUpK2gYE3yKtv4Rjzrs5ll+E4MLMcJSdXG6cc669SoA/z+4b22BI9f6
         seQAmfWRZzP/EOcBk82fJlOZqDTe5hPfTaFt+h5X9tMmoH9BA1xKY7qUw7PkNQdeTx
         xmHzQwhzuEgAS7WX8MnnGxd1Oo3cjRnDSs6YiaYX3IX7VgeIcyTgaL7q+OLOjuAGMn
         1GavuWld8l0vILEd9jeUX0Nina7UMgy74EjccQfpmheUhrHHJLGIFf8kg+2DAzhwro
         hqiuloOW9VEXA==
Date:   Mon, 13 Jan 2020 06:50:54 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: linux-next: Fixes tags need some work in the net tree
Message-ID: <20200113065054.25c85bac@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/CvnqbAAkyhjcYWh8YyqqyGO";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/CvnqbAAkyhjcYWh8YyqqyGO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  a26ad4d5676f ("net: phy: DP83822: Update Kconfig with DP83825I support")

Fixes tag

  Fixes: 32b12dc8fde1  ("net: phy: Add DP83825I to the DP83822 driver")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 06acc17a9621 ("net: phy: Add DP83825I to the DP83822 driver")

In commit

  443180567763 ("net: phy: DP83TC811: Fix typo in Kconfig")

Fixes tag

  Fixes: 6d749428788b {"net: phy: DP83TC811: Introduce support for the DP83=
TC811 phy")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: b753a9faaf9a ("net: phy: DP83TC811: Introduce support for the DP83TC=
811 phy")

--=20
Cheers,
Stephen Rothwell

--Sig_/CvnqbAAkyhjcYWh8YyqqyGO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4beJ4ACgkQAVBC80lX
0Gyx5Af/XjIKBgM9cjcJWHgZQVHNKx9nPlblb1KgEZfAZTIk3X72akLIlxzQB2CN
NQwKRLiK3ulDnqbJGGoPan3AUXFulQCl5O7W4+Dh0zp55pdOjvSJMCrd/aDHrdhL
ub19p6H/cG08+t+tkiamIl5JTMPqwrfcFBWsxIBs1qPGX5rQRaum+hvQa0ZjMdE/
7yQhQ4Pq6pJ8rg3O48/6QnCQ3aCxWnOVnnSKTa4aJMZODPL2g4a3v2CL83O6S2qf
lLKR/dendQVHRRKoEcglqDuhYRykZlLcYIkUyDZ0PRvAmyKvAAOc1EFBswo8luN1
Q9sZJ/VgfpGJ/fLokgawkeRlyee9ew==
=iWsT
-----END PGP SIGNATURE-----

--Sig_/CvnqbAAkyhjcYWh8YyqqyGO--
