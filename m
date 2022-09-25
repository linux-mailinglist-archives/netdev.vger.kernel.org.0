Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02F15E9629
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 23:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbiIYVTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 17:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiIYVTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 17:19:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B64FB84C
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 14:19:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBFF761628
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 21:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9F2C433C1;
        Sun, 25 Sep 2022 21:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664140782;
        bh=AruArAe0wNQ1T914dTbmwSbFVqUdQdd7FYwANLQJReM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oa5LsA1bP6Qs8X6JcdAtrnCIekfV42gPkSFLKXNOJnI9CmjktyZGK8w5DYMgmcDIn
         wJlwUSnExi9EfVDkCmC+AyZ9GdLPA3/EpK+Eh1Ym7TDzOtv55w8focMGHQ12NXM2Bm
         skFkNNWrtsomt845rHBZ6MazLsGaDnTqvsdU0y6U+BaZI8oZWKNAIkXt12ZnlMvnlq
         YbIo8JciF1Krma+dMAKQaELZWzLP16qMdQywlkbrUXeAYPCb/ml9kfGhACeVCFfiFa
         aY540YR++4fcqEroLqFVHJKYHMkoe9W6bItInzBFpDdjJBs7Ft28ptWQG11QcsXERW
         CSamUDXziLAtg==
Date:   Sun, 25 Sep 2022 23:19:38 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        Sujuan Chen <sujuan.chen@mediatek.com>,
        Bo Jiao <Bo.Jiao@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chen Minqiang <ptpt52@gmail.com>
Subject: Re: [PATCH 1/2] net: ethernet: mtk_eth_soc: fix wrong use of new
 helper function
Message-ID: <YzDF6n2VX4qwX/I6@lore-desk>
References: <YzBp+Kk04CFDys4L@makrotopia.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="O7gVFbOOpcyRoGqd"
Content-Disposition: inline
In-Reply-To: <YzBp+Kk04CFDys4L@makrotopia.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--O7gVFbOOpcyRoGqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> In function mtk_foe_entry_set_vlan() the call to field accessor macro
> FIELD_GET(MTK_FOE_IB1_BIND_VLAN_LAYER, entry->ib1)
> has been wrongly replaced by
> mtk_prep_ib1_vlan_layer(eth, entry->ib1)
>=20
> Use correct helper function mtk_get_ib1_vlan_layer instead.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

>=20
> Reported-by: Chen Minqiang <ptpt52@gmail.com>
> Fixes: 03a3180e5c09e1 ("net: ethernet: mtk_eth_soc: introduce flow offloa=
ding support for mt7986")
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethern=
et/mediatek/mtk_ppe.c
> index 25f8738a062bd0..4ea2b342f252ac 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
> @@ -337,7 +337,7 @@ int mtk_foe_entry_set_vlan(struct mtk_eth *eth, struc=
t mtk_foe_entry *entry,
>  {
>  	struct mtk_foe_mac_info *l2 =3D mtk_foe_entry_l2(eth, entry);
> =20
> -	switch (mtk_prep_ib1_vlan_layer(eth, entry->ib1)) {
> +	switch (mtk_get_ib1_vlan_layer(eth, entry->ib1)) {
>  	case 0:
>  		entry->ib1 |=3D mtk_get_ib1_vlan_tag_mask(eth) |
>  			      mtk_prep_ib1_vlan_layer(eth, 1);
> --=20
> 2.37.3
>=20

--O7gVFbOOpcyRoGqd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYzDF6gAKCRA6cBh0uS2t
rKUtAQDCPZ6z3aCvFim9pn2NQseCzfSz/BP9i4XwhX5jYS/zVgEAyAn4WxsHdgnZ
yj7zp6yr+dXdWoj2O9wO8UY3bm5VQAA=
=WBfG
-----END PGP SIGNATURE-----

--O7gVFbOOpcyRoGqd--
