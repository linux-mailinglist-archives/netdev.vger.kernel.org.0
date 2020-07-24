Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3171022BBFB
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 04:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgGXC2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 22:28:52 -0400
Received: from ozlabs.org ([203.11.71.1]:34909 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgGXC2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 22:28:51 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BCY6T0n59z9sPB;
        Fri, 24 Jul 2020 12:28:49 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595557729;
        bh=+lHtLN9mb1RQ+OsZ7B8pI105hf8EiMsgdXCmbj5M5KE=;
        h=Date:From:To:Cc:Subject:From;
        b=UWLVCzt1SNeC5nLH6z+Edb6oSxm1MmVpa7BoVhf7JApsOlsJOM+D/jbTAOjgJAZcT
         1LGcbYzPr7nnkE4O29vrCAFrdTyGuVJ4AyaYMAGEYKb6/QSvrxqL2CMXDPvfQPurQl
         4ROlYaJ9exV/oeES2DxsNmrW/U7ZsCjD/xhapVfCfAKA42Xz/u6YIi/eZ8XzFhdJ/X
         rxy2hEiB43N/5i46BNRHTYZfPCpsT5bj+0ASno14q91qFns6D08GKeJXhGqjQHa7HG
         3mXIGldxazrlzHdr4R9C5agSJE6TwCZdElA1Y97vEgeEkwEFwgZlBjwjc99pDlFZsx
         NCgMCJy1SPWEw==
Date:   Fri, 24 Jul 2020 12:28:48 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200724122848.5273805b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/0/CaStq8PsOM2rs9teGrXqu";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/0/CaStq8PsOM2rs9teGrXqu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/geneve.c

between commit:

  32818c075c54 ("geneve: fix an uninitialized value in geneve_changelink()")

from the net tree and commit:

  9e06e8596bc8 ("geneve: move all configuration under struct geneve_config")

from the net-next tree.

I fixed it up (the latter removed the code moved by the former) and can
carry the fix as necessary. This is now fixed as far as linux-next is
concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the
conflicting tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/0/CaStq8PsOM2rs9teGrXqu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8aR2AACgkQAVBC80lX
0GyflwgAjwsTSUvaLoCjCAqY362x8G2xjr+TrdmF+UxWZznVEXDSv75xNeJUgqN/
JDPiHJBREt9S27i944qPUPpGkialHxCiqsgsBvEfl+fOU1y9CWkalX79aR6ZewTI
/xTAav5a2VDNcvvrlDayXhevFgX3IGjO5BxH4cGhtk5zixxlIctZYjYiA217cLnH
gWJYxS4g6TJDbGLUkPe4dPGuUCtSub9oKBDcD5RacCBiGuv1z9iNpdP8GbRFRfr7
uhnY1zc7Lf8LGf/CHCwulzN4ktFABKTecUPhc3i8aO3ErIHTWD9IK1rV/I6B01eC
yofI8bIkDJ6Ga6e6DMSCm69n1DYV7w==
=yJBd
-----END PGP SIGNATURE-----

--Sig_/0/CaStq8PsOM2rs9teGrXqu--
