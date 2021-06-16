Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8513AA677
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhFPWFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbhFPWFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 18:05:21 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B792C061574;
        Wed, 16 Jun 2021 15:03:14 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G4zhY668Rz9sSn;
        Thu, 17 Jun 2021 08:03:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1623880990;
        bh=PBzbafJJa/TmgE58XTGraEbZbZNH+nK1P0fvdvmnJas=;
        h=Date:From:To:Cc:Subject:From;
        b=kJWVRW/DU0nMAVg/TGyT6uOL6LAC+dAdCfamAcByvzBwC+J8/GHMs/KO1H78ayPAY
         j33WIlTC2ZDE3Qc5ZdgSCyB+clivgCyL7NnSjtSuq/b3YKn/nfvJiyRdL5HNJnC5c6
         YgBi3jjS98aRpTCoWr4BvPsv1RxGaBW0znhDPWYuydxgLApZwctTsmDVmiGHpb2FHZ
         i3rluSLnqSCgCyhIYCpSbPGcdNId96ZNVAbUSWECr4zxMkaDV5tiLgA+CD2pO/voS7
         GRp4OcryTRcQCIts7cgbfUlY55eoeJ9ILayfvnsnZmvxpgTNzOVXoWcgBPtM73xh3X
         ZMW7whzn4yp3w==
Date:   Thu, 17 Jun 2021 08:03:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tags need some work in the net tree
Message-ID: <20210617080307.3b1771d6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4MWStpEX3FMyjfw6UoTvq/6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/4MWStpEX3FMyjfw6UoTvq/6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  cb3cefe3f3f8 ("net: fec_ptp: add clock rate zero check")

Fixes tag

  Fixes: commit 85bd1798b24a ("net: fec: fix spin_lock dead lock")

has these problem(s):

  - leading word 'commit' unexpected

In commit

  8f269102baf7 ("net: stmmac: disable clocks in stmmac_remove_config_dt()")

Fixes tag

  Fixes: commit d2ed0a7755fe ("net: ethernet: stmmac: fix of-node and fixed=
-link-phydev leaks")

has these problem(s):

  - leading word 'commit' unexpected

--=20
Cheers,
Stephen Rothwell

--Sig_/4MWStpEX3FMyjfw6UoTvq/6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDKdRsACgkQAVBC80lX
0GwruQf+M55bvEAnSyIgHIUYDM44jDSugjhRRhfrsmQSZ7OJlmmf1RyZxNRENmYk
jvPVKUMN3xp4S9dDoAeIZ8RJfFwzO8Zg5pyelTomZ/EG1JYNb4eUgfk6TAlgavN5
Wmqcf2OIy4EjAzQgQADGC+DL7/zOGdo7TyTTHEnQQPEZR8OYPonPnpXjijmXT8YR
4qPNGv3dfNRcjUNaNb3Q1CEd+EcQdYLOOXAMwQeRGzs2oXsCZowh31DatfR8d+0o
omWu76tcfsy7LL+s7/TUIKpDsQfWO8CdqYg56ZuImWFpC1sXQRQ779xy86xWfQ+F
C39LqK6j8PNDeg3t1K+Z5MioxO/L5g==
=6kIl
-----END PGP SIGNATURE-----

--Sig_/4MWStpEX3FMyjfw6UoTvq/6--
