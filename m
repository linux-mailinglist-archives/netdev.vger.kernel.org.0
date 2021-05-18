Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD02238835E
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 01:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhERX5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 19:57:52 -0400
Received: from ozlabs.org ([203.11.71.1]:44615 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232153AbhERX5v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 19:57:51 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FlCZh3Vy2z9sW1;
        Wed, 19 May 2021 09:56:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1621382191;
        bh=3rf0qZX3Nn/RoMbAO+/jBG2pUP8lT0uHr4bYKwv2jf4=;
        h=Date:From:To:Cc:Subject:From;
        b=OwsTSRG7C+EyXepEsl4piz6IURvAsj+yqlbVFqF5zeT9GnSiD7yDWdQIHzltiLd8r
         i6j2zIv12rgRsoPy+PRw3y2bs60WqRNsJlY2G+qmkn/P5ksg31pnVrJ1uxtUXhsgvu
         NlwM8+byFiWJC9HThrLWUsThl+aW95/fpBw6ZsJt5gnB4XGIkJNX6lgt6egDFpM3GL
         hwUDV3OLeadHybkvzE8frks7mdmL4M3FnGDp22OeezbdS1ZP9yot0h2UQYaGfnFixm
         6ti8vH3/U/5/0GSkU1lo2G2675dVlDoLqRFWakfYHORE90n761Dy3b6Ak39ON8DsoK
         FAabl87NDY34Q==
Date:   Wed, 19 May 2021 09:56:27 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: linux-next: manual merge of the netfilter-next tree with the net
 tree
Message-ID: <20210519095627.7697ff12@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ZrdEgz5d6.3D2BnwYH.gAdq";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ZrdEgz5d6.3D2BnwYH.gAdq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the netfilter-next tree got a conflict in:

  net/netfilter/nft_set_pipapo.c

between commit:

  f0b3d338064e ("netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() check=
, fallback to non-AVX2 version")

from the net tree and commit:

  b1bc08f6474f ("netfilter: nf_tables: prefer direct calls for set lookups")

from the netfilter-next tree.

I fixed it up (I just used the latter) and can carry the fix as necessary. =
This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/ZrdEgz5d6.3D2BnwYH.gAdq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCkVCsACgkQAVBC80lX
0GzTswf+JZ2W8O9XQDa4xYLwQF5eBjb5aIHl2P9t0iQIbVgoa/20FqujmP3Za6vk
S2uSKOu6EjOelZt/Jf5dSTXjGfK2/h7iZ5fgk6t/SoOPwHMwVhPU6Qnw29G7PWtB
7/IMBpCC/4njlGaDA5YTCzkmxBdia8PTwhGWlTlFNswyIdPl0jcdfp3ft6ML68ps
ygIcNOgsEq87Quk3HuqvQniaz+SDrX/jm+eRH2aksVi7jKEU1v1FqJ/4aDUz0LJJ
KYEv7eZS1FXJnTWu1HZkoRlspo+WjRMM17HbeyP3ekugh9x2u7+FEWo7jSybhuXk
qevBkpNmQFamK8EBRASkEqe/YY0ulg==
=9c6I
-----END PGP SIGNATURE-----

--Sig_/ZrdEgz5d6.3D2BnwYH.gAdq--
