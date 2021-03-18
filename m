Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DA1340FD1
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhCRVaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:30:08 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35409 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233062AbhCRV3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 17:29:48 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F1gCT2Zw9z9sPf;
        Fri, 19 Mar 2021 08:29:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616102984;
        bh=dImQ9Q8YbnZ5lkjgluzlxpGofG/ZC41gl3FTs7zLiLE=;
        h=Date:From:To:Cc:Subject:From;
        b=Ky5YH/6ig05gpVVtockWm2iDHSUVhRkhgJXha/qEN5u8NdQBQHJEmWm2IOZJhsTdR
         3KEs2xicLNFJGGQkjJ74qqpGI6aNiGwyBX+gdnYW4LUV9MdHLojvgStPb5x21NhR0u
         y6NzanDwTf1+ayCMGHoS87ARncoagbeHZ0y0iQwc7/Ckc3OkFuiCW/PeF0yl/i0qI8
         zt+UghiWZfEdlEsF+IC8SOyq7sh/UYO8JHweSqqFkO2PqslSpMSyoJe0Iat7sfQfoz
         15dR/OAT7tRuWL6I2JGao7cx9/PNyPQfyPeVd0hatqA4LvKRcbrGHz4SVNrLefYlOz
         guMQhadyDoM+g==
Date:   Fri, 19 Mar 2021 08:29:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-ID: <20210319082939.77495e55@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4Jk=GQk2VBhorYAi6PLLpZd";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/4Jk=GQk2VBhorYAi6PLLpZd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got a conflict in:

  drivers/net/can/usb/peak_usb/pcan_usb_fd.c

between commit:

  6417f03132a6 ("module: remove never implemented MODULE_SUPPORTED_DEVICE")

from Linus' tree and commit:

  59ec7b89ed3e ("can: peak_usb: add forgotten supported devices")

from the net tree.

I fixed it up (I just removed the new MODULE_SUPPORTED_DEVICE() lines)
and can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/4Jk=GQk2VBhorYAi6PLLpZd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBTxkMACgkQAVBC80lX
0GwsdggAlsccwbdg8QLGdCJk5OrYzWfravCvmBB3WWmqg4yE8C2myLejN1avSKxe
8+3DYI+FzL2ahH6YcP7YEnSAHDl1E5wrLNR4ua9Atpt2BbLhKRfTMn79yK4HZ8Be
gMN5pay/4J1JRlHKZYUPEeZyGmSs6+1a1rxUTlMOaT2PaeN8kUGOLMbXUCp0tRPl
bb8T19nngEUDLIb/1zs8wTBINJ6zqkoiHffFTDo1Xh3vbT5+61Ek0dwuxNSHqSU2
qcebl5q9eOThwLgtGXcwGdrdT55c4qLiomfAdKp78BplvNehvy5QuX0FgQoRaPQy
TOYD/ZJlf1pJwBW6/7dpDXZPImvgEA==
=4g4C
-----END PGP SIGNATURE-----

--Sig_/4Jk=GQk2VBhorYAi6PLLpZd--
