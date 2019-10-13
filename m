Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B10A5D58C1
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 01:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbfJMXCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 19:02:13 -0400
Received: from ozlabs.org ([203.11.71.1]:56439 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728198AbfJMXCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Oct 2019 19:02:13 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46rxz55T1Wz9s4Y;
        Mon, 14 Oct 2019 10:02:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1571007730;
        bh=Nar0rqA/SnlefoWCoPNV28bJ3Ki7AIfaueJ7m7lPbOk=;
        h=Date:From:To:Cc:Subject:From;
        b=qKJquFfEKQfEF8ntTZTevdsnB6TbYxvDOHC7vtp67r29So0nhFvkVYN+P4PxOjcoW
         cbR5asxrGYC8BPKq6FxntPofx/zyINQ5np/rQrmGJW6yYDFDT2W40136OrRMMjWckt
         8IZk/quAj1XXT2bY5if74qqDNCTG5C1GwnBuwt5DiNUpDnRfKGM/66KG8bvvGYbPFh
         YJS06wbXVKbtqG7Taf3Cz1vdKLCjoqthKJXK5DG7GJ+GZidbaBtD7dsPE/cfnrIzhz
         cLpRNl2x3JcF3vUyzvgwnj+JSA3qriMQ031bH8F5tZsyN19SV7Boaqaugd+vOFhZD+
         PI+OoBQYXZdNw==
Date:   Mon, 14 Oct 2019 10:02:07 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20191014100207.5489ccf1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/pYMaUZ1FGCkauOlqq68IywU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/pYMaUZ1FGCkauOlqq68IywU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/netdevsim/fib.c

between commit:

  33902b4a4227 ("netdevsim: Fix error handling in nsim_fib_init and nsim_fi=
b_exit")

from the net tree and commit:

  a5facc4cac4d ("netdevsim: change fib accounting and limitations to be per=
-device")

from the net-next tree.

I fixed it up (I just used the latter version) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/pYMaUZ1FGCkauOlqq68IywU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2jrO8ACgkQAVBC80lX
0Gybnwf/U8BazCCcLu89kc+FVjWTivk0Nk9ILJeMUw2oxVqLSFEx3PzMkqjI+HgN
0+9Y/SwgqbPUe3wedtSKRIRRkZDFeVO+FnHv/yKmUk6McCCnDdl+yUSaLH5qRV3Y
O+bIr3TCi9SfgR7CSHwfapOqmGOD5svaJBGfOvuc076RBy/UGWplZ9M7YFsZ+Nt/
kUgBF8IL7d86/Scx+rn0Fu2X89IFrn97g2VAk6pXiSFKRE7Ub9Pr5Xs06nI9GpFM
iJWtmH5UZrciVkXSnj4tSmy0n2SqRegVBDC+RR4Z1KrKtxqzDWnhUI2v7/++4O2P
xy9Pjz5sXwNLnq3AjuAaMARzaWbx8g==
=FiuP
-----END PGP SIGNATURE-----

--Sig_/pYMaUZ1FGCkauOlqq68IywU--
