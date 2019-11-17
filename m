Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B33BFFB8F
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 21:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbfKQUMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 15:12:05 -0500
Received: from ozlabs.org ([203.11.71.1]:43577 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfKQUMF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Nov 2019 15:12:05 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47GNXf01wcz9sP4;
        Mon, 18 Nov 2019 07:12:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1574021522;
        bh=8VUBI5cOVihQ21oz7kmfmZxtcYLcrLCpWMhd2o7KqIw=;
        h=Date:From:To:Cc:Subject:From;
        b=gKO0cy4VBymzTN64AuRuXp1B1cblFRZjk/YQvmO7ee4Xo3d9yLLh4BffFk7KTp947
         hP6JSIemf8EBzjUigd730+pNyHokosA3vRUOEZL0Nt+OA3hxaY2b0lSg6jhu98pxPf
         LElfjqZcjFVEFjoVsFRhTQmJNGlZyw9UTrjC6L4o9iOldwl4mChLYaDTBvR5x9MuLf
         SG6qMLzwGd108JroaGQr90juTe8oUfQ09dK/uyLei/yZs4Z8/HxxFq4X+6zUP47/bo
         jP1xD/eEACa1kuTbSsYT9PMk2XlSeMtPG6Lq+meI8A8cx3k4tkOlsErhvWo4R4AvjR
         IWqn/KitQyrCQ==
Date:   Mon, 18 Nov 2019 07:11:48 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20191118071148.10ebf58c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/bdPsSmE_wU06/eu._/Nr0zO";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/bdPsSmE_wU06/eu._/Nr0zO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  34e59836565e ("net/mlx4_en: fix mlx4 ethtool -N insertion")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/bdPsSmE_wU06/eu._/Nr0zO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3RqYQACgkQAVBC80lX
0Gy6kAf8Dd+UOzY0vPjgNn18+xiD3nzk9WBSYBKyd++9Kq5nL4XodjrxHalpjxqB
oPixcCGhgyaWRbgGThDq0FBz6Ux6meG2hbI9SYMp866N1iDNtweagvGcCM7Kz0BL
cKovC7Ooyj5fgwlbWgw+TGMx04M8KNnsW4X8hdWo0sxQLI/njA8ry0RBO2K8LNEI
jx5fDMDn8D2q12z7e3jUmhDWYEhLxlDliqMSELInEn6KAjHxRsbF9ATEYzfWRuZ6
Dcn+vLx1W2KE+f86COxRQ9Tnp8I+3dg8Hn/My3XmjnwWIPW8G010CMi3B7e5axFQ
eX/9M3UNUUukT+OgvMmGEaQhevsEiQ==
=vl9C
-----END PGP SIGNATURE-----

--Sig_/bdPsSmE_wU06/eu._/Nr0zO--
