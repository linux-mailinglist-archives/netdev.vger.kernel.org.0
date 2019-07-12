Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD29F6673F
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 08:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfGLGur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 02:50:47 -0400
Received: from ozlabs.org ([203.11.71.1]:58985 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbfGLGuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 02:50:46 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45lNq748gfz9s00;
        Fri, 12 Jul 2019 16:50:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562914243;
        bh=wxQ5prL3eUEj/klD3imtcDLJYoqk1cOCEbmcHcS1czg=;
        h=Date:From:To:Cc:Subject:From;
        b=tPSL+soadodnvAE3IOXh7wQUAcnx/xh3PeuluuzW19dyEe++XkIde8V5rNbu81bOS
         /wmGP04z7MmGREPNF5dPz3VLM5k8t5rkMXFUDcLiTOjaqM13xzDf4g2rNFp7bKL8En
         gB9ZXJC9D6bHrbgekZF8or2cAofKqkMs6P+RyOlgI6buPmtKTT5J+cSwaxyS7GtOOP
         NJYHFB3mv18PnLyDvNiwGg82PnIAN17DArklJIO0e7aaWr4Tjuan+28Pd/8VVNBhu3
         RO3rZf2GuJB7jBraZx5XwXUFCz9Z7k8ClTW4cL9grrj1aCMuhIIR+JORkdOoe9sdve
         MJ+X54glNTfJQ==
Date:   Fri, 12 Jul 2019 16:50:42 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20190712165042.01745c65@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/CMnuRLcb53m8WTHo6yBCQx6"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/CMnuRLcb53m8WTHo6yBCQx6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  c93dfec10f1d ("net/mlx5e: Fix compilation error in TLS code")

Fixes tag

  Fixes: 90687e1a9a50 ("net/mlx5: Kconfig, Better organize compilation flag=
s")

has these problem(s):

  - Target SHA1 does not exist

Did you mean

Fixes: e2869fb2068b ("net/mlx5: Kconfig, Better organize compilation flags")

--=20
Cheers,
Stephen Rothwell

--Sig_/CMnuRLcb53m8WTHo6yBCQx6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0oLcIACgkQAVBC80lX
0GxPbQf/QqvHEK6jW/cbL4u3PG+puaah4GhlDeOCSvE4PJkkF84TovrOoZgqV5vH
PK+UcetrOKVha1q+A62Hwcno8ECZs2Y8evBr3xbjtnvVgZjZ7cA7vWueLA0iIwzN
Vu7CEvGE71DvbXjLPZdfxfIrdvUt68zwEKxMeJLOmeCO3AL8XFoHWUL7G0Y16o6B
Ihbgn3YMwN1ZDs5Ea6hg2ckS56Eludwn5QglJgIaYG8b2ewqRH62sAFfXIFd2YG6
q46ujBeFnTmFuGrowu5z1UCmNC0hGRy0oI/HTSxA7lWQyPQuI7t5blq3nje83IMn
yOnnHgbt2Ztr5vALEUh/ujQIeZ/Yvg==
=iBel
-----END PGP SIGNATURE-----

--Sig_/CMnuRLcb53m8WTHo6yBCQx6--
