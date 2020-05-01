Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124881C0C4E
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 04:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgEACzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 22:55:05 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:53927 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbgEACzF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 22:55:05 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49CxgV5qpBz9sRf;
        Fri,  1 May 2020 12:55:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1588301703;
        bh=+lffFgFW+TaOYl84oLwXX7B2gLQwT/P1CrdGNW3J4qk=;
        h=Date:From:To:Cc:Subject:From;
        b=D4Lm19PgPaKtoY4u2S+DL5o+zjSeo2+ynoATsogf7tHy62F0CWwsmQxztcE9JCuyL
         ffcUX2l1OBBrFK4FbxpTAtW3q5UJqoZgezCm071/NLHL+wE/WGsrGdc8ueGUYIYYe6
         l/D/fb259+9ifz9MeF3Gv8qBGHMdO2N3t24HeBByZPXQ3Fnw8UNDEV0myzJvIJP5Ut
         5bPbNXSwxtNQTLYq87Bv1h/MLE5QqYri1JvzXzMAyTaSlm/J1hSa+L7UGajZisLnBk
         4gKEupxLOqjySUFdmpEPEwZjk9hheM1LQzSDwqcmYNF4bj+fThwjOo6qsEM7o5UwUM
         DTIS9nXNJusdw==
Date:   Fri, 1 May 2020 12:55:00 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>
Subject: linux-next: manual merge of the net-next tree with the kspp-gustavo
 tree
Message-ID: <20200501125500.3e7dc414@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/TXzOp9gGRcOd.8t2hY9L0.0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/TXzOp9gGRcOd.8t2hY9L0.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c

between commit:

  3ba225b506a2 ("treewide: Replace zero-length array with flexible-array me=
mber")

from the kspp-gustavo tree and commit:

  4780dbdbd957 ("mlxsw: spectrum_span: Replace zero-length array with flexi=
ble-array member")

from the net-next tree (and further changes).

I fixed it up (they had the same effect on this file, so I used the
latter) and can carry the fix as necessary. This is now fixed as far as
linux-next is concerned, but any non trivial conflicts should be mentioned
to your upstream maintainer when your tree is submitted for merging.
You may also want to consider cooperating with the maintainer of the
conflicting tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/TXzOp9gGRcOd.8t2hY9L0.0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6rj4QACgkQAVBC80lX
0GynVQf/QRY19eOQIL5CFSxZ98lWsr73QqnN1KjYkedqIqtPbSxwP4L4BHBBv8uo
0Wd1WjABwaH5JtrWsChMH7kRQP7Dyavz24FCogo2a0U2Pc7mGsSb2SKxiGsvybLp
qGEUGxvNc3f056ifCD3CKnGvmdni6GCWsbkRz+mxdZ1YKtPDKG0BT+ImfFtNQ2ew
zr3jk8UU1hGNt7QFDCMrirRo6v3L+z/z5C8SaxdRS82Vnqu+Jphxf84jmKnlttd1
7Ph0Fm65Xj7bAzhLYKpWTMBEF8rfjQH5hILbqi/ycKQilKJaQxEPjz5sU/S8uITH
YeQRBVs9hUGIeNQNQdkINYaG2ttTZw==
=GP9u
-----END PGP SIGNATURE-----

--Sig_/TXzOp9gGRcOd.8t2hY9L0.0--
