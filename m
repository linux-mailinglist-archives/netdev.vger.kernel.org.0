Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5FDA57A79
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 06:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfF0EJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 00:09:34 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45277 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbfF0EJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 00:09:34 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45Z5y20RXPz9s8m;
        Thu, 27 Jun 2019 14:09:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561608570;
        bh=LsIp4MOsb8p6EEYoMgfZs22cxz+dk7gDFUx8sf0mkdA=;
        h=Date:From:To:Cc:Subject:From;
        b=tvHKF0SWsqwGEv/46sF7wh4vP029CvmQW0vg5RmUfVA4aeL0dkUzGtiN/nm9IV7wu
         84mqme1tU6L89lGBH+BtsVLkjwuistEMh+PzFOlmAp1DQiPGfYvEmNiBWsjRN/040E
         0yWeYZYEt/G9EznXy6uv/3SuOimWwiHo04Szbt1hVP3Ol662YPvnUz6kVkK68vbshH
         jMeYL1h6ehgi+A531naEh2ZzSbiidC+sVvzxrYKbT27Ap1+ElWVPefE5WzPwzUOcYb
         p6V6crluP5IoMaQqVa4Z2Ase0ieS2GEmlRK4o3+aIov8bv5hj+7ZHMP/9gfycqqhdK
         WbgnmbpYjXc5Q==
Date:   Thu, 27 Jun 2019 14:09:29 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>
Subject: linux-next: manual merge of the mlx5-next tree with the net-next
 tree
Message-ID: <20190627140929.74ae7da6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/QoQkQBfE9+wL/NEtPF.A9T8"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/QoQkQBfE9+wL/NEtPF.A9T8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mlx5-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c

between commits:

  955858009708 ("net/mlx5e: Fix number of vports for ingress ACL configurat=
ion")
  d4a18e16c570 ("net/mlx5e: Enable setting multiple match criteria for flow=
 group")

from the net-next tree and commits:

  7445cfb1169c ("net/mlx5: E-Switch, Tag packet with vport number in VF vpo=
rts and uplink ingress ACLs")
  c01cfd0f1115 ("net/mlx5: E-Switch, Add match on vport metadata for rule i=
n fast path")

from the mlx5-next tree.

I fixed it up (I basically used the latter versions) and can carry the
fix as necessary. This is now fixed as far as linux-next is concerned,
but any non trivial conflicts should be mentioned to your upstream
maintainer when your tree is submitted for merging.  You may also want
to consider cooperating with the maintainer of the conflicting tree to
minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/QoQkQBfE9+wL/NEtPF.A9T8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0UQXkACgkQAVBC80lX
0GwLEgf/bVWJXuP70coqS1/vunI8Z7J7mRV2/FWSXyVt6F/eBGOUYxNgZdUmn+Sd
lHke3vl4fFHUI0JqVNvrnOYbAxTBaPsZFFtdyRAzMrzs8ZCKKzyYRvAzCRyvcvl/
lURKaUAL1Oj0OvEU1Eyl+lBbArTcpc16WhhPcSys3mMNmgLwhqkGJ68rry/xKOo2
oTb7smt/wAvmVqxV4RHvLILM+fXFI4q48MZEociyPn5L3wZyouk1mQe8XM20J2Al
YdJXsaTZXotWVd3I1sa7O2RiK6i4lN1RHoIU8rYmwnwBbE8hYcj7iMTNijlbIliV
SRPXhdxnmk28cDkEWD3qiMSrq9+Tfg==
=DxZn
-----END PGP SIGNATURE-----

--Sig_/QoQkQBfE9+wL/NEtPF.A9T8--
