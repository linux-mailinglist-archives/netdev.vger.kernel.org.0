Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517216C74DD
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 02:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjCXBG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 21:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCXBG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 21:06:28 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D763A8F;
        Thu, 23 Mar 2023 18:06:26 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PjPDK04NWz4xDj;
        Fri, 24 Mar 2023 12:06:24 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1679619985;
        bh=Me8RCthfGau5hId2Ewwvr3hIygIlAakh6dysXcSH+QA=;
        h=Date:From:To:Cc:Subject:From;
        b=Z2LqWk33V2TrtQFBja3pqf9BvQkdsQktuMauhgW1aBcjp4OgSsT9CWoBLRaW8tIy6
         qFfEcqD34FGDWSNGYuVOSDd8FKNTBCMAOu0fNayOVjtpQMcaARyghl6BC3yTfkUI+R
         PXRYF3ze2wXhbbSloElWs3Fqc5TzX+HfiCTp0UKt1hGSvdmC1kCAvKhNJTYJhvXvak
         aEhuGaUPqk9BZlQdC9occfYt1piE2FZYMMjCSEptq7eSU3YQOQWx4VmJbhEKaM4V1Q
         q7ut7H2x/AjnHsQ4FKg9VVR+MlGKW4vzvC6vil8UH0aKk5nMNbwNTatx7Xo647oXxy
         bQJ++y07N8ILQ==
Date:   Fri, 24 Mar 2023 12:06:23 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Roy Novich <royno@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230324120623.4ebbc66f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/T7wqqOuLFDHmj1OPFGXHo=H";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/T7wqqOuLFDHmj1OPFGXHo=H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c

between commit:

  6e9d51b1a5cb ("net/mlx5e: Initialize link speed to zero")

from the net tree and commit:

  1bffcea42926 ("net/mlx5e: Add devlink hairpin queues parameters")

from the net-next tree.

I fixed it up (I used the latter version of this file and added the
following merge fix patch) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 24 Mar 2023 12:02:44 +1100
Subject: [PATCH] fix up for "net/mlx5e: Initialize link speed to zero"

interacting with "net/mlx5e: Add devlink hairpin queues parameters"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index 1ee2a472e1d2..25d1a04ef443 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -529,8 +529,8 @@ static void mlx5_devlink_hairpin_params_init_values(str=
uct devlink *devlink)
 {
 	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
 	union devlink_param_value value;
+	u32 link_speed =3D 0;
 	u64 link_speed64;
-	u32 link_speed;
=20
 	/* set hairpin pair per each 50Gbs share of the link */
 	mlx5_port_max_linkspeed(dev, &link_speed);
--=20
2.39.2

--=20
Cheers,
Stephen Rothwell

--Sig_/T7wqqOuLFDHmj1OPFGXHo=H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQc948ACgkQAVBC80lX
0GyXzwf/aODbBcm88hXTp+f42nntBFJQGgpRFjLUIy+/hoGhM5lpn8vT98JY5Ait
8iA8DO9VtOP22A0GYGAArcB1syaM9oFKsmtQ3nMW6jOADWAIs/0jDoxxo662UKpz
YRt5eZC33QHYCFhf/XKinPtMZCg9l3yv+L0dBmqSMM/X9C2G27M3b7o5k629di3R
M1CvX7NuI/GlLQO6Go8iGV2ZxIwbOfVu5iCmpOX9NNd59Bb8lDZWOHCrVI0tYRBP
oVtWLmkZkRcUVLTNMfE2I31wl2+ue0VdqVmJN04SmBVsinxcKZLrVVqWRKWHRM4C
bI56D4tBueXMeZKID7D3qbjYEDOn5Q==
=Qbq4
-----END PGP SIGNATURE-----

--Sig_/T7wqqOuLFDHmj1OPFGXHo=H--
