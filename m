Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9563F383D
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 05:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhHUDJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 23:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhHUDJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 23:09:02 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F658C061575;
        Fri, 20 Aug 2021 20:08:24 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gs3Nf130pz9sW8;
        Sat, 21 Aug 2021 13:08:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629515300;
        bh=mEhJjhXS+qMda3U7FwpADzeee1VExK11iy0O7hbSvZo=;
        h=Date:From:To:Cc:Subject:From;
        b=vBzPXamOxihY1Fl3SbNh+ZYp2HaegQrh5PMQadAFw71TEBrgewwRy5RpLCASl8gok
         +kdWsbwBJB67mng9XACTmNzyYPqlROAyGrIrwHD/Y2Dw+IBj4CnL0tdkdpoyaXwzou
         Adl28mM6dfF02E2eWpwWBWW0gKDEGPlDpiooqYBb+EKcDEMdwSijz8TzLTgBABNCBm
         SdgTvvcCktjSa9ZShvGn4tIUFDF/2piS41bVeaP/y0IwTMVi9u1YXMqnaKy4YcjJUv
         3yIh/L/4fSmZ9UkpEtDf2bClc6zuV3ts3OFKHzy95O98Xe0CaoMGB5IoH9F69FK+LS
         sxeLDZbSoqTAw==
Date:   Sat, 21 Aug 2021 13:08:15 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commits in the net-next tree
Message-ID: <20210821130815.22b5cfc3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/CA.HyUEqCjRIq9lItb9qTcl";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/CA.HyUEqCjRIq9lItb9qTcl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commits

  3202ea65f85c ("net/mlx5: E-switch, Add QoS tracepoints")
  0fe132eac38c ("net/mlx5: E-switch, Allow to add vports to rate groups")
  f47e04eb96e0 ("net/mlx5: E-switch, Allow setting share/max tx rate limits=
 of rate groups")
  1ae258f8b343 ("net/mlx5: E-switch, Introduce rate limiting groups API")
  ad34f02fe2c9 ("net/mlx5: E-switch, Enable devlink port tx_{share|max} rat=
e control")
  2d116e3e7e49 ("net/mlx5: E-switch, Move QoS related code to dedicated fil=
e")
  71d41c09f1fa ("batman-adv: Move IRC channel to hackint.org")

are missing a Signed-off-by from their committers.

--=20
Cheers,
Stephen Rothwell

--Sig_/CA.HyUEqCjRIq9lItb9qTcl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEgbh8ACgkQAVBC80lX
0GwqWgf8D1+t0P9Z9FAdzzF53G4cG26V8P323a+0hs8SVQvUWIZN+1tZ0siaVeE4
pcSnIZ6Qz9UN7EKqF/4RHRyPPHyMuPXraVc4v9rXTpY+LlyxSe3slJfJLMcBuU7Z
TG/l7m3bffS28r+5nLGzOHxMbrd9++xVFTp8cq0WumnO61FrzvrYS3giW8WncpvD
8QrDBrhIpLW/xEF33G7RwYf3YC+aUtrcvrAJyMuy5bVCJg1OA1jKmH7AIzbHPWv7
bXpqkwXJI9OOcFhPTP33xwF8c8diSkYQPkljCksb+ayHC7nWLnC06vtmWcfvIWRm
m+eB1lXHk77CYxxO/RPLslLd6pydqA==
=MnGt
-----END PGP SIGNATURE-----

--Sig_/CA.HyUEqCjRIq9lItb9qTcl--
