Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4560F6D3B91
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 03:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjDCBo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 21:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjDCBoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 21:44:24 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27773903C;
        Sun,  2 Apr 2023 18:44:23 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PqYbS2PNwz4x4r;
        Mon,  3 Apr 2023 11:44:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1680486261;
        bh=DGxt2Nal4zLRCMspxliJpFL1v3UBGJJ5bihGfh5VLt4=;
        h=Date:From:To:Cc:Subject:From;
        b=QEBDaNfjhRrf7LfxYtFM+DkS3bnmHZJP5Fo1PN38Yfj2az1p59Svk4h7TGHfTr9ya
         tBaN4D6rGPOtFWmTHwktICM7AEJyaZAgRW4Xncer+0xYYd1MrjF0egFervAtZFTL9h
         7DaOtVzQ9RBqC2D2A8AEf0Pjam+e2YUz64gJzJdxUR5kbTWkAIqbSp+m7+bXD+RW+u
         uAEBP6+V6cLftS+PI5CS10WL7eUNydpawXS6f0qWlSY9fQtVssJfWm12hx1uyRlKHm
         DEU7lQyoOTl/7ENQdyroPiSeGbAVENMedp/QBf4LhhDYeKWs6g2m/fNk4Ki05VaVbt
         1tWA1NKm74nsQ==
Date:   Mon, 3 Apr 2023 11:44:18 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: linux-next: manual merge of the net-next tree with the pm tree
Message-ID: <20230403114336.51854309@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aI/YJBY0ri78BcOuECiZQbU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/aI/YJBY0ri78BcOuECiZQbU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlxsw/core_thermal.c

between commit:

  dbb0ea153401 ("thermal: Use thermal_zone_device_type() accessor")

from the pm tree and commit:

  5601ef91fba8 ("mlxsw: core_thermal: Use static trip points for transceive=
r modules")

from the net-next tree.

I fixed it up (the latter removed the code updated by the former) and
can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/aI/YJBY0ri78BcOuECiZQbU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQqL3IACgkQAVBC80lX
0Gyf+wgAk9MhmBgCMnmvTc8gAJgMHRlj6CxullLY32cedpJNNIeBKS+Xui56w03L
wAH+vp1baV2iZs5pIYsN1liqyYFhVPLaZdintoVA9eg5P480s09qYeLYr2YjYw6X
5QF/117QK7OSeLCkFN/XC4shqgWhriFFLkwLuKmm6tq6BuxRht0iEU9KRhh/cblO
JGumBckof/IfAfMp4VuWahrZrjpdW1Lv231iQcqBvGF3NGThRM6D5yhu/3Rdx0QQ
0oychvIDTfAi9YqwQJYQfiuBuPAPNsGG1bbq1OoQw4rck3uTLgGLWZYf7cB1QnxI
sBTnb/rFcxcVKSCsfPYfhj/H42ZX6Q==
=0zyY
-----END PGP SIGNATURE-----

--Sig_/aI/YJBY0ri78BcOuECiZQbU--
