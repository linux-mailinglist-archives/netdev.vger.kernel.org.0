Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7595B526F
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 03:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiILBZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 21:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiILBZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 21:25:06 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CF1B843;
        Sun, 11 Sep 2022 18:25:03 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MQpmr6v4rz4xG7;
        Mon, 12 Sep 2022 11:25:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1662945902;
        bh=RKaxzaDfRsE6qw1SpYVOvckFVrA9MlVhRpCNQTHNX1g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u3CtstPynUvHLxd5qkzWQccXerdzjsrkFoklkjfC/0o7cr6f5buM3mLNuKi1EnXxN
         HyNpY1dydn4uyUaNyr+FKTB70++bmq12GwlL3Bd1vELVJ4hWm3b+znC0S/XXhivig7
         RKNkqMFMl6UZ3oWQuo3zB8lShb9pWQJOhNbtL88R/uTieAXC7hhLupOFl0Q888Wdhx
         pg2nJznqF0WcrvAIIcWMwI8fqFWKakR7yHFpAkxbOpsspRDOxQr2N1tes+CiD0/m7F
         8SxMrv+qAG9Ter0dxuYr02fAXc/FtfymBf6obkKOlvrR5nuaWDz1wwbW+fWviqEwDg
         Ohd7l7Aat6+6Q==
Date:   Mon, 12 Sep 2022 11:24:58 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Alex Williamson <alex.williamson@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: linux-next: manual merge of the vfio tree with the net-next
 tree
Message-ID: <20220912112458.525b054e@canb.auug.org.au>
In-Reply-To: <20220909144436.6c08b042@canb.auug.org.au>
References: <20220909144436.6c08b042@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hQ+IlOqPMDeRclybwi.gJsM";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/hQ+IlOqPMDeRclybwi.gJsM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 9 Sep 2022 14:44:36 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the vfio tree got conflicts in:
>=20
>   drivers/net/ethernet/mellanox/mlx5/core/fw.c
>   drivers/net/ethernet/mellanox/mlx5/core/main.c
>=20
> between commit:
>=20
>   8ff0ac5be144 ("net/mlx5: Add MACsec offload Tx command support")
>=20
> from the net-next tree and commit:
>=20
>   939838632b91 ("net/mlx5: Query ADV_VIRTUALIZATION capabilities")
>=20
> from the vfio tree.

This latter commit is now also in the mlx5 tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/hQ+IlOqPMDeRclybwi.gJsM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMeimoACgkQAVBC80lX
0Gz0Hwf9HVRsGpauW0eaFRprs8Bcxqj7zip7PLv96BaItfvtyEfbEnysZuQpxh8E
WByCdm3ZyPDEo2w5iRJgTodttWPGi83yKYniXqEHyhrADGMz+qpU3/FHJ99xdaQv
+bT4z2z3bkiJMIqWYyR06Xk8cXLUypfE91YkBJtwo0ylw/SGfcOJ8C5Qy3BMhjMg
E4XDOZzD3lMyVg3poCTe6K5gw7X3JZJZmnsY7/+/X02SZl6nFpq3A4BbqN0LfHrO
B1i7n+/vlMKZCBkhl8IyQBSoCJJwmxFi4Br8to8bJ/+NrpudOs/3LdE4WXITd/mL
TX48a5/cVGDdwmrtnm933/ELAV54Jw==
=R90H
-----END PGP SIGNATURE-----

--Sig_/hQ+IlOqPMDeRclybwi.gJsM--
