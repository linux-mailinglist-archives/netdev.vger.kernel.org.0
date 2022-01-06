Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D3648672D
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 16:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240810AbiAFP5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 10:57:52 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:47589 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240549AbiAFP5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 10:57:52 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JV9wt44GWz4xnF;
        Fri,  7 Jan 2022 02:57:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1641484670;
        bh=ktbP9DuifnC33YkqPBnXVa42B/rSlHhfo8tfS+ObafU=;
        h=Date:From:To:Cc:Subject:From;
        b=harcKIMh6F1bS2oj6TBVdexo7cZRYLIskCagb7g6+gRVNfZ9e5B425OuPGaZO6Cu9
         vyQ9beOAUhWVkw6vhqW2lojGzrFketVgVTbmvphY/HTFFjkDLZeim8sr1KawzNhk2k
         gD1fGKMKKUJ9Nk+jrFJRSDezcGRlnCQXuF1T7R+0GaRp1DrdWhv/MFhxQOFCymI6a5
         tH6jUOdK1MkgGp3cT8FAo3/4PCufA0PL7C800JrwSVRa+eHUclN3Soy4T/NfxaUnGS
         NIwIIu7Wg21N3JIoLpDTsqh0iW1REwjnzel5MF/H5miIGGhUCOmnV5o5wA6MSitENI
         MNGKZvIzeKz6w==
Date:   Fri, 7 Jan 2022 02:57:49 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20220107025749.35eaa2c2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ZcDLKJ85=hXNyzMW=iApaUP";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ZcDLKJ85=hXNyzMW=iApaUP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/networking/devlink/mlx5.rst:13: WARNING: Error parsing conten=
t block for the "list-table" directive: uniform two-level bullet list expec=
ted, but row 2 does not contain the same number of items as row 1 (2 vs 3).

.. list-table:: Generic parameters implemented

   * - Name
     - Mode
     - Validation
   * - ``enable_roce``
     - driverinit
   * - ``io_eq_size``
     - driverinit
     - The range is between 64 and 4096.
   * - ``event_eq_size``
     - driverinit
     - The range is between 64 and 4096.
   * - ``max_macs``
     - driverinit
     - The range is between 1 and 2^31. Only power of 2 values are supporte=
d.

Introduced by commit

  0844fa5f7b89 ("net/mlx5: Let user configure io_eq_size param")

--=20
Cheers,
Stephen Rothwell

--Sig_/ZcDLKJ85=hXNyzMW=iApaUP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHXEX0ACgkQAVBC80lX
0GwTKggAl9FepAt2fg7HzYFpkSOru751SyXVjSr7e3Ztrqa/hw61waw9Hz6Abp41
i7q9Lkw8997yzGIi4D1q74svTrj5KCHAs3U4XN6+hgctnyGgT6SytQv7trFecYX4
CsOaVDvfD1IQgogf+811+5BGOGFa/E0UUkugQfYTQEtoEY/nZvzut/PEEf9T/Eks
1vTaDFZrbOTElhXIJT/SSnZM3fat9YCcGf7j/nfv+4UgLe493AJJhLEpGbd9aCsx
/9jVGqoW2StO6kq00wflPVsEaCnLNvMBr1QRCju0PZH8017vW5R78ajqpvvpXMT3
U2EmFyqOpgBghHmaLBiVKuEzYc0vCA==
=pvtx
-----END PGP SIGNATURE-----

--Sig_/ZcDLKJ85=hXNyzMW=iApaUP--
