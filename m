Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6F1E9744
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 08:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfJ3HhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 03:37:12 -0400
Received: from ozlabs.org ([203.11.71.1]:38035 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbfJ3HhM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 03:37:12 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4730dx15kxz9sPj;
        Wed, 30 Oct 2019 18:37:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1572421029;
        bh=H+kCivoo/fdkkJhkIk3buQt9CJCsa6pzinINvIZthU4=;
        h=Date:From:To:Cc:Subject:From;
        b=rusQw2jNJsM02alZcjJXPg1lEnWR17cC8n+h8X+CI0Y/pJzRPuI594RpUdIuUdi5W
         9SXWGFlvQYVsTXhQsBhVrMfKj60Htou/A99ci0jZSCaQJnZlRhkfJbgldThVpyVxWV
         E3H4gMbP8i7iEwHGHKtGPZH9oPWYDFg68fpM0qJaX/O3CnR8pmOeIiRQtBKazRwdv6
         xTX77nzlXVQCH92+T6x+1C+BUflV7W9bT8gC+4afFF3ysAK6OTybR3DCZmp3IUwtqV
         7Lrmq1/vffpl2soXVbM2hDgzKOQgYPFdo3Ig+4NYdl5c0OljBkDks9vW3h200gAMjl
         V6mq82anGjL5w==
Date:   Wed, 30 Oct 2019 18:37:06 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xin Long <lucien.xin@gmail.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20191030183706.1644aec4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Mma_yey.JLjjLttMwpjFTY1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Mma_yey.JLjjLttMwpjFTY1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  2eb8d6d2910c ("erspan: fix the tun_info options_len check for erspan")

Fixes tag

  Fixes: 1a66a836da ("gre: add collect_md mode to ERSPAN tunnel")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/Mma_yey.JLjjLttMwpjFTY1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl25PaIACgkQAVBC80lX
0GyZDgf+OE2oA8QgflE2vxinfphOV4fdTxLisivhof/AzY/VuJg/2zWPvFAWRsxi
TEegh2XfT+sSWdV0+st1aNpL0lsYbbhdxacuest6LUUCPMIrefaULarBH3Q3FrxJ
twvbTDdM0C70PCFU++J1aDrYvPrysmNT7negMLCwimjA+4FWpXQEKRgBXDgSfvI5
BMtP2+8JsJ1ysUxn9BZuLgXXAInwz0KUwHE1HOVj1xzOhe77Wq85k2fAksMFaJdL
eAPGqy7o1SHk6o+0keXUH4vtUaaMSk8t10TGmkyKqI82XHC6uaDE/WUpXNnUIM+t
Tdfi5U5jRDCaIQU6WWw1Hkm+cNv39Q==
=DN7x
-----END PGP SIGNATURE-----

--Sig_/Mma_yey.JLjjLttMwpjFTY1--
