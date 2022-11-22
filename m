Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0572D6338E8
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbiKVJrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbiKVJrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:47:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258C7120B0;
        Tue, 22 Nov 2022 01:47:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B662C615E3;
        Tue, 22 Nov 2022 09:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01D6C433D6;
        Tue, 22 Nov 2022 09:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669110419;
        bh=FRhndoOcferDeIuztrGP96RT7Ozf4cEJuLD549BxEBw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O8wBRVoXoLFM0Bdtanbdd1H4aj0MBq9HnKke7wOuFCjA+de3MNvhce2l7DNhiiZV+
         BABDd9UYq8zPT7Jqxl56iGI+3JBelUaZzEf7UaTWFwVrqG4cFte07Ax+upMwop53jJ
         qC+3BCEPp5I+3uWIR6EoEaNo03ejBpXHrU64Bh1KNhLJKzIRgYM5TOEuksgz5uHx6u
         80zwwgk8/9K7wPWkrvxt/HjgzX+HEQMnrc/iOylk8wG9OYZAymX6HvwsSd3iWKuH3T
         /mgDOSZD+QdZXmH9l1ljWGDFyeAntmlDejK/lwV+e6u0WXPJ5j0Ofm2ulZSLXA71yt
         /tk7ZjA6yF4+Q==
Date:   Tue, 22 Nov 2022 10:46:53 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Sujuan Chen <sujuan.chen@mediatek.com>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        linux-kernel@vger.kernel.org, Mark Lee <Mark-MC.Lee@mediatek.com>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        Bo Jiao <bo.jiao@mediatek.com>,
        linux-mediatek <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH,RESEND] net: ethernet: mtk_wed: add wcid overwritten
 support for wed v1
Message-ID: <Y3yajX0EF/aU5HJr@localhost.localdomain>
References: <217932f091aa9d9cb5e876a2e958ca25f80f80b2.1668997816.git.sujuan.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="MyQooNMZNzUlLsws"
Content-Disposition: inline
In-Reply-To: <217932f091aa9d9cb5e876a2e958ca25f80f80b2.1668997816.git.sujuan.chen@mediatek.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--MyQooNMZNzUlLsws
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> All wed versions should enable wcid overwritten feature,
> since the wcid size is controlled by the wlan driver.
>=20
> Tested-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Co-developed-by: Bo Jiao <bo.jiao@mediatek.com>
> Signed-off-by: Bo Jiao <bo.jiao@mediatek.com>
> Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_wed.c      | 9 ++++++---
>  drivers/net/ethernet/mediatek/mtk_wed_regs.h | 2 ++
>  include/linux/soc/mediatek/mtk_wed.h         | 3 +++
>  3 files changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethern=
et/mediatek/mtk_wed.c
> index 7d8842378c2b..a20093803e04 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed.c
> +++ b/drivers/net/ethernet/mediatek/mtk_wed.c
> @@ -526,9 +526,9 @@ mtk_wed_dma_disable(struct mtk_wed_device *dev)
>  			MTK_WED_WPDMA_RX_D_RX_DRV_EN);
>  		wed_clr(dev, MTK_WED_WDMA_GLO_CFG,
>  			MTK_WED_WDMA_GLO_CFG_TX_DDONE_CHK);
> -
> -		mtk_wed_set_512_support(dev, false);
>  	}
> +
> +	mtk_wed_set_512_support(dev, false);
>  }
> =20
>  static void
> @@ -1290,9 +1290,10 @@ mtk_wed_start(struct mtk_wed_device *dev, u32 irq_=
mask)
>  		if (mtk_wed_rro_cfg(dev))
>  			return;
> =20
> -		mtk_wed_set_512_support(dev, dev->wlan.wcid_512);
>  	}
> =20
> +	mtk_wed_set_512_support(dev, dev->wlan.wcid_512);
> +
>  	mtk_wed_dma_enable(dev);
>  	dev->running =3D true;
>  }
> @@ -1338,6 +1339,8 @@ mtk_wed_attach(struct mtk_wed_device *dev)
>  	dev->irq =3D hw->irq;
>  	dev->wdma_idx =3D hw->index;
>  	dev->version =3D hw->version;
> +	if (hw->version !=3D 1)
> +		dev->rev_id =3D wed_r32(dev, MTK_WED_REV_ID);

nitpick: since rev_id is valid just for hw->version > 1 and it will be used=
 by
mt76 in the future, you can move it few lines below where we already check
hw->version and get rid of the unnecessary if condition. Something like:

	if (hw->version =3D=3D 1) {
		...
	} else {
		dev->rev_id =3D wed_r32(dev, MTK_WED_REV_ID);
		ret =3D mtk_wed_wo_init(hw);
	}

Regards,
Lorenzo
> =20
>  	if (hw->eth->dma_dev =3D=3D hw->eth->dev &&
>  	    of_dma_is_coherent(hw->eth->dev->of_node))
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed_regs.h b/drivers/net/e=
thernet/mediatek/mtk_wed_regs.h
> index 9e39dace95eb..873d50b9a6e6 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed_regs.h
> +++ b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
> @@ -20,6 +20,8 @@ struct mtk_wdma_desc {
>  	__le32 info;
>  } __packed __aligned(4);
> =20
> +#define MTK_WED_REV_ID					0x004
> +
>  #define MTK_WED_RESET					0x008
>  #define MTK_WED_RESET_TX_BM				BIT(0)
>  #define MTK_WED_RESET_TX_FREE_AGENT			BIT(4)
> diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/med=
iatek/mtk_wed.h
> index 8294978f4bca..1b1ef57609f7 100644
> --- a/include/linux/soc/mediatek/mtk_wed.h
> +++ b/include/linux/soc/mediatek/mtk_wed.h
> @@ -85,6 +85,9 @@ struct mtk_wed_device {
>  	int irq;
>  	u8 version;
> =20
> +	/* used by wlan driver */
> +	u32 rev_id;
> +
>  	struct mtk_wed_ring tx_ring[MTK_WED_TX_QUEUES];
>  	struct mtk_wed_ring rx_ring[MTK_WED_RX_QUEUES];
>  	struct mtk_wed_ring txfree_ring;
> --=20
> 2.18.0
>=20

--MyQooNMZNzUlLsws
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY3yaigAKCRA6cBh0uS2t
rEr4AP9K5LW+TfRnHDcSOOOP+dKxO6PgQE0ugOWGTgAXgNlp1wEA/2aDm26mVuQz
kYSSHOserEgot90J1cmRQ3i0vhn8WAE=
=aXsx
-----END PGP SIGNATURE-----

--MyQooNMZNzUlLsws--
