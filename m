Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA6E2219B1
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 04:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgGPCAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 22:00:02 -0400
Received: from ozlabs.org ([203.11.71.1]:50913 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgGPCAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 22:00:02 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B6crv0v0Bz9sRK;
        Thu, 16 Jul 2020 11:59:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1594864799;
        bh=c8eJ93BkoRLM1MOs0ataOo/6OZXZDMFWZwOhmRDFsvM=;
        h=Date:From:To:Cc:Subject:From;
        b=NmtJMFH3kuR2PU2MyT0aOJJfLmeCuJCLZTrhDANmFJ1KgPtQRkvnRW0N4iX1pbtXE
         y0vUZm+zOFVDJw8CLQecH7F19ZWu7M8p0j+WnnJ/tplxO7SEfz4wnGUjIlltYpRctU
         J9XKotNklF5smaGNLoe0ozwOv59aRRi1bXkUUxNSBzDEjOFGMNIJuBzHBjiJuB7giS
         oivgL/qWMXK2TVkvr2aGVLxbq5st8LBlLOquXLbIJmI1kPmQVHsiCNxxoTjBK3xA5J
         UMzeMrnsKVtnZoCvsCN25+Zfo5810strd4VN47h/8pLCdnuDSXrMPTjgJTNbuv9G4u
         YN6GnewtpBfAg==
Date:   Thu, 16 Jul 2020 11:59:44 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peilin Ye <yepeilin.cs@gmail.com>, Jiri Olsa <jolsa@kernel.org>
Subject: linux-next: manual merge of the net-next tree with the bpf tree
Message-ID: <20200716115944.7bc6de65@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/K18_nA4PJr651BLxjBLrA22";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/K18_nA4PJr651BLxjBLrA22
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  kernel/bpf/btf.c

between commit:

  5b801dfb7feb ("bpf: Fix NULL pointer dereference in __btf_resolve_helper_=
id()")

from the bpf tree and commit:

  138b9a0511c7 ("bpf: Remove btf_id helpers resolving")

from the net-next tree.

I fixed it up (the latter removed the code fixed by the former) and can
carry the fix as necessary. This is now fixed as far as linux-next is
concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/K18_nA4PJr651BLxjBLrA22
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8PtJAACgkQAVBC80lX
0GywBwf/cZS3079nf4TL7JtjJvgYvGBdvf/Y/dB7yCe14m553Hjur4mzZ9tjLIgB
puUnxaC4aUxR/Wju3BhGV2vmFaHd7IukkzagntLloawDXXmQtJL++iWV4NpasaO+
BR/px/3OqeOZNaVh0UEx8BBhuGgnt/zVzfGQyIzdgdjwi7lfxQP9Wz8msbkFUmnw
fjqw63m4q7Ut0T9QLOdphxPwWON01wBZZ2OxH1Oq2ZzVKU1n8REHepmIBfE5BYIV
E8UvIHl//PVyfl3UyyJcaCq+LvKU8CTSaIi+xqLEnxTt88RQLxN9CjuBcG6fxUdJ
Bq4DJwW4sLTU2zlM2bvW4xj5uWDgXQ==
=hvLL
-----END PGP SIGNATURE-----

--Sig_/K18_nA4PJr651BLxjBLrA22--
