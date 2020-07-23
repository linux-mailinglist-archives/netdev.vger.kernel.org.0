Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7491B22A514
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 04:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387631AbgGWCLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 22:11:16 -0400
Received: from ozlabs.org ([203.11.71.1]:45451 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387507AbgGWCLP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 22:11:15 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BBwmd2c0gz9sQt;
        Thu, 23 Jul 2020 12:11:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595470273;
        bh=A37GXGZO/G07PD5xLdfQgTdvZttPTzrDiDiTp1JgNqY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e+11SRtsmplKUb36ytWKO4IWsGoXUDwb3t/jlY1ApnpspEJrbwVACJhWwgrWeOtM/
         YBTR7y1I2AKr7f2diemwWdQIJbpY8Y/oBsa0aMCLYvk5YFfgIGcX2+VbvgKHBFMMkV
         ANT8G2uvIllSUHaFeg+89BzIWwCAISPeC8zgSb4C/FSO9l/1G0DrCxYreQ9okPDGSG
         JEg7b31Zlxg5tXL/+q4dha4sIasZR8lChe1tUANUzZoqtcyZbidvWRvdyQMuGmJDPp
         xsfn4OfBICA2eZLluJfkED9bhEjXoJFBWFzPR61zE2h+pdeBuh+v2uiaEQiAZ5ZPDA
         23zsaRm3i3lsw==
Date:   Thu, 23 Jul 2020 12:11:12 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the net tree
Message-ID: <20200723121112.5f15950a@canb.auug.org.au>
In-Reply-To: <20200722132143.700a5ccc@canb.auug.org.au>
References: <20200722132143.700a5ccc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5NxRTxRPvP1Wo+AK+ehag8l";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/5NxRTxRPvP1Wo+AK+ehag8l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 22 Jul 2020 13:21:43 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the bpf-next tree got conflicts in:
>=20
>   net/ipv4/udp.c
>   net/ipv6/udp.c
>=20
> between commit:
>=20
>   efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
>=20
> from the net tree and commits:
>=20
>   7629c73a1466 ("udp: Extract helper for selecting socket from reuseport =
group")
>   2a08748cd384 ("udp6: Extract helper for selecting socket from reuseport=
 group")
>=20
> from the bpf-next tree.
>=20
> I fixed it up (I wasn't sure how to proceed, so I used the latter
> version) and can carry the fix as necessary. This is now fixed as far
> as linux-next is concerned, but any non trivial conflicts should be
> mentioned to your upstream maintainer when your tree is submitted for
> merging.  You may also want to consider cooperating with the maintainer
> of the conflicting tree to minimise any particularly complex conflicts.

This is now a conflict between the net-next and net trees.

--=20
Cheers,
Stephen Rothwell

--Sig_/5NxRTxRPvP1Wo+AK+ehag8l
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8Y8cAACgkQAVBC80lX
0GzmJgf7B1AFdysAL1i/A9EV/L7pepztzwwDbq54rjgPa6ChZ4W+bYHIchRJhvnw
spckjzhV1NYTJI2khUnN0UiG9+Htm/Qken3sZG1C2c2lkqFnZ0HT07o++Sn8DWD2
Xw59Tqs1UYK08n01xDr1AhVFkySbXn4BGtjALDXKBDyr5ssJ2C3dv8t0h/A9qmJF
5hCi91/5pooXjXsuiWFF9CDuLoolIFt3bN5gmQouGBdY3qIHZA6OiUp1gNkbj4Cn
6Iww2RePvjIOwX/Ow1vh3f3W5UkIAlNm8x9yIoYE6euSNfHGb8eWG5HkWYfDAsqw
6dP7RcvvEZlcWZuQYuTug+f4ar93Jg==
=ZxI+
-----END PGP SIGNATURE-----

--Sig_/5NxRTxRPvP1Wo+AK+ehag8l--
