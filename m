Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6502B75AB
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 06:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgKRFUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 00:20:03 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:50351 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgKRFUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 00:20:03 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CbWN05PVgz9sPB;
        Wed, 18 Nov 2020 16:20:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1605676801;
        bh=EkSoM0/Wd+2ehIJc7wy2iQ4BVO0YgFF2ZxrRg4aYSYY=;
        h=Date:From:To:Cc:Subject:From;
        b=FbHmYj/uInpQX8WCOKn1yn5CQ67YzXZLjNZZa7MR340CpHRJFYoN/bTqU4NWb2ydH
         2SArDkzUX6HjX05IvApPsVP0HpIMp/rI5POPseG+zKt08XFNGo2wAK75+31hRwh930
         SncDk7rxuoApCmBKvG5JywxNczPlKe6mdXab5FJ3CFyRp6EgIlw1quBW1XVH4sbz8H
         HUXD7Ao2GxSStAi2T3Qk6XjY/4i00XfRArugjp2prtxYY6LmyFHAIe4DTMtWZH++ZU
         4IiTK/5LNbz/FUHpa4sZZQMg89rEcRZr6npDeliyIp07Xb0r7idjLmjxHyk2eWDc6l
         E5CNG0LL0lxcQ==
Date:   Wed, 18 Nov 2020 16:19:59 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Xie He <xie.he.0141@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20201118161959.1537d7cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fX96wqYl5Ivf/vW9uXDf.0B";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fX96wqYl5Ivf/vW9uXDf.0B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/networking/index.rst:6: WARNING: toctree contains reference t=
o nonexisting document 'networking/framerelay'

Introduced by commit

  f73659192b0b ("net: wan: Delete the DLCI / SDLA drivers")

--=20
Cheers,
Stephen Rothwell

--Sig_/fX96wqYl5Ivf/vW9uXDf.0B
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+0rv8ACgkQAVBC80lX
0Gw/LAf9FUHGJfv/zm+KkX/jeVQ4FXaGqWGj2uJcecfRYy6f6H1+MN5Oy3LFlMkB
CXVe2P4KKdIrVm7KDaKjD0E5UFEYTAa5jutGJrj970dCbyhe4phEk4qMal5xUfsP
7yK+bGCZFlGrOjFSD/YPvYgmoJG8pOCu19AQ05rftglkWp4tt6mWOEZPiRFeLuHm
xj/mWnyNXkQRWj0t1J2AONJ2vCuD3gbO4qIwHOVdJ0kGl0cym1H8/g8IsYyMT8/E
T/unpw7W34mwzYETbmfjRx4AKIS2f4BYG08l07C94k19d6kQFJEMEv1aOD4CNUVU
4266HJCOXJ7PDz81C3WZmQp/unPqsA==
=nj91
-----END PGP SIGNATURE-----

--Sig_/fX96wqYl5Ivf/vW9uXDf.0B--
