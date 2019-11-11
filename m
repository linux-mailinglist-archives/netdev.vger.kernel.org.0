Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5383F6C35
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 02:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfKKBUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 20:20:04 -0500
Received: from ozlabs.org ([203.11.71.1]:33781 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbfKKBUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 20:20:04 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47BCjD46spz9sPc;
        Mon, 11 Nov 2019 12:20:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1573435201;
        bh=1gN+tmNaC6JTtnNqUtt4PiQMifqEU4tGCw+VANOLbUk=;
        h=Date:From:To:Cc:Subject:From;
        b=YK2Ec2CnKT0NjcBXO0KYX6PGU+p3ihFqspti14xmnmQmbNPgLOHIRB/ZX308n6IAz
         6waFgvcOYlsiNz36+wQYoTCGVJutWVygiWJkFkg8Ud52GtN4qCOFQFsJ/Pv1pYBoN4
         uwessxHS2VZJX/Cgv1e4QzhxCW8iDiVtOZAO3e3mN6CAuVOffR5RmJokVYbq9A5Ssx
         uPl4tjKX/E/v/JYKXhSBoXKqAwy7yrI+doXlZy+vN/tFKN0XOu3uhnfoxlcxad8yRg
         2wlhaNBClcyozYSZcsayHmDagiSFXuGm3ZlmhfRXbWWit2OV3hCYLgMacrEwhDc/FH
         /LrBykRI0wklA==
Date:   Mon, 11 Nov 2019 12:19:53 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20191111121953.25f34810@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/XM=dO8I/FHfHL79AgS_vTWi";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/XM=dO8I/FHfHL79AgS_vTWi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (arm
multi_v7_defconfig.) produced this warning:

In file included from net/core/ethtool.c:21:
include/linux/sfp.h:566:12: warning: 'sfp_bus_add_upstream' defined but not=
 used [-Wunused-function]
  566 | static int sfp_bus_add_upstream(struct sfp_bus *bus, void *upstream,
      |            ^~~~~~~~~~~~~~~~~~~~

Introduced by commit

  727b3668b730 ("net: sfp: rework upstream interface")

--=20
Cheers,
Stephen Rothwell

--Sig_/XM=dO8I/FHfHL79AgS_vTWi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3ItzkACgkQAVBC80lX
0Gy5ZAgAo1coZmlpHy7y/rIndJdaBdF9GXGayCNfFX+Jd3HWXAsNJUDEIDIPP1FB
oi2btBODRLmHyU7FqMIdJ+TiymLKSAYTYK4wV5XgXpV9/a7QFtWWNSioPVmr3RQD
+sXYCGBkulLcYyTPTnBdIzWmso9AQPpBU1DglXB78UfCRswnpYBvnLHxnQt+fC1l
vrjB1fREmcpqpmr7z7cszNiMa0l3nFPMKmrSwD2/xhyc4gZKBfpwZFbN1RhuP7wO
AkY27yXPTQiST87KYe6Td2TyX7fFOMDyACl/tq265x2aYdy+RF7LwSMWNtkpsrox
rypNeT4kChasJoDXFefealC1+YXLrA==
=VMrM
-----END PGP SIGNATURE-----

--Sig_/XM=dO8I/FHfHL79AgS_vTWi--
