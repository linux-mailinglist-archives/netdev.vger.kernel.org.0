Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0D4691559
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 01:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjBJA1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 19:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjBJA1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 19:27:01 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468211C7CA;
        Thu,  9 Feb 2023 16:26:52 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PCZL174xSz4y0f;
        Fri, 10 Feb 2023 11:26:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1675988811;
        bh=zBxql4M31TGmmI7Kx18c6Gk+bUllwXwoKgi4aGFz61Y=;
        h=Date:From:To:Cc:Subject:From;
        b=LlKb533pKGfhPoBAlKy3XUnJY9bknZyirtL/PqxEvyL7K55Uc8ZrCOZ/PnBL5jCzg
         nORN4KRNcjxrCxe1109lv44tBiB+NR8YpHINXWGU8U5YLCTlG7COiiPCXbzm642HES
         QEfv+NgSx4idjdskCHpn1nY/INdDvUdQJonYc2szffM0eIFc8DmIlJ6NH/vscFlU2w
         DybwQ8VAy5GiAVa7FxsqpSDoudHiKmlz/Bc+/Xaowe1EQHXa/TyscuvSClRAeioL6Y
         yH0qHzdwess80BuiTGrG5C9EZ1SU/SFXRkOO4UUM+0+ysQ4nyF7WNAvHhWmAZlxIem
         KvU4NBTq4HpwA==
Date:   Fri, 10 Feb 2023 11:26:49 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: duplicate patches in the mlx5-next tree
Message-ID: <20230210112649.5cae735d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/JCaEutXFbX.q9z3ZveenMbb";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/JCaEutXFbX.q9z3ZveenMbb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The following commits are also in the net-next tree as different
commits (but the same patches):

  2fd0e75727a8 ("net/mlx5e: Propagate an internal event in case uplink netd=
ev changes")
  15edc228bebb ("RDMA/mlx5: Track netdev to avoid deadlock during netdev no=
tifier unregister")

These are commits

  c7d4e6ab3165 ("net/mlx5e: Propagate an internal event in case uplink netd=
ev changes")
  dca55da0a157 ("RDMA/mlx5: Track netdev to avoid deadlock during netdev no=
tifier unregister")

in the net-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/JCaEutXFbX.q9z3ZveenMbb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPlj0kACgkQAVBC80lX
0GyXzAgAiBjvB0BQ3+XkYgcFy01W13uQUbx44UHxjA6FZ/nlfdoyxINgFY9CKBSF
+qr+Zh0our/8e6dq57jpaPH06iKwFGB95CXRyxgYFoqR/mz9Cfg5gIh5dvR4HxbP
Yh+bKaaTV7lDLQet2DmAWmC9050JjlMh+z09VAfoiKs9+xebTXSr3jYDyB6ZJPNb
QALWTzsytyGVbbzmawo3904yks6FntLLRiB8/e4afWfXRSX3uTukhaXhikwA8itK
eEtJ05zbeGCt2d5lIoObdaEMbKyNl/Kb9lr6INv9Zi0+N+11CDPCwzXiQACTSC19
7mvLJREp224v1ZZ9UvGMadrxMjd7QA==
=Az/F
-----END PGP SIGNATURE-----

--Sig_/JCaEutXFbX.q9z3ZveenMbb--
