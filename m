Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CAF6BB512
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbjCONqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbjCONqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:46:30 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF36118A9D;
        Wed, 15 Mar 2023 06:46:01 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20230315134557euoutp02687217738e0e59bad747a0b03cc0dc1a~Mm7O0F6vN1055410554euoutp02S;
        Wed, 15 Mar 2023 13:45:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20230315134557euoutp02687217738e0e59bad747a0b03cc0dc1a~Mm7O0F6vN1055410554euoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1678887957;
        bh=JXRyNUIEG+gdqt/gKm16841UWvGjaQNDR6Ep6qXLvw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/vUx9VWCI/pT9omCAAx+g5TRGupfWjeoz7T/+6WzNAKtWYz7/zuuQJ3jfCi2uIcM
         klna9a4oalRtxUI7Y5vkpn1HYRqpfvFnHUXMuRYS/2MNePneBm7GVqDVZF84a8BNtt
         T4Nsj8sJdZRRpAhRJIFJwB1EgCpazV0+E1PGY2Vg=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20230315134556eucas1p257bd4f1ce90bc98b139c146d99ddcdaa~Mm7OkdKVl1259112591eucas1p2T;
        Wed, 15 Mar 2023 13:45:56 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 9F.E0.09503.41CC1146; Wed, 15
        Mar 2023 13:45:56 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20230315134556eucas1p27459c63c810443c1a94d9683ebf9aed6~Mm7OTeiFC1312413124eucas1p2T;
        Wed, 15 Mar 2023 13:45:56 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230315134556eusmtrp1091696b8b5e172317c9c7212d959e999~Mm7OSkvg02385123851eusmtrp1k;
        Wed, 15 Mar 2023 13:45:56 +0000 (GMT)
X-AuditID: cbfec7f2-ea5ff7000000251f-53-6411cc142940
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id CB.BD.08862.41CC1146; Wed, 15
        Mar 2023 13:45:56 +0000 (GMT)
Received: from localhost (unknown [106.120.51.111]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230315134556eusmtip2f92a02e0963f9395d5ed44f4b43f010a~Mm7OEhgZb2553225532eusmtip2K;
        Wed, 15 Mar 2023 13:45:56 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Cc:     <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH V6 02/15] net: Replace all spi->chip_select and
 spi->cs_gpiod references with function call
Date:   Wed, 15 Mar 2023 14:45:51 +0100
In-Reply-To: <20230310173217.3429788-3-amit.kumar-mahapatra@amd.com> (Amit
        Kumar Mahapatra's message of "Fri, 10 Mar 2023 23:02:04 +0530")
Message-ID: <dleftj35661628.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsWy7djP87oiZwRTDM73m1v8WaxqcXnXHDaL
        xo832S2OLRBzYPFovfSXzePzJrkApigum5TUnMyy1CJ9uwSujCUbrjMWfLavmP+thbGB8aBZ
        FyMHh4SAiUTv0YQuRi4OIYEVjBLHFm9jg3C+MEocblnGAuF8ZpQ4MHMhaxcjJ1jHl+m3oBLL
        GSXWzHjPBJIQEngB5GyzABnLJqAnsXZtBEhYRMBc4uqS/2AlzAIxElfvfWYEKREWKJR4vF8F
        JMwioCrx8+c8RpCRnAI9jBIv5x9hAUnwAvUuX7QTbK+ogKXEn2cf2SHighInZz5hgZiZKzHz
        /BtGiNtOcEjM7iuFsF0k/t7fyAZhC0u8Or6FHcKWkTg9uQfsfgmBdkaJpisgj4E4ExglPnc0
        MUFUWUvcOfcLqttRorH/JzMkvPgkbrwVhFjMJzFp23SoMK9ER5sQRLWKxLr+PSwQtpRE76sV
        ULd5SPTt/8QECbfpjBJfn1xkmsCoMAvJP7OQ/DMLaCyzgKbE+l36EGFtiWULXzND2LYS69a9
        Z1nAyLqKUTy1tDg3PbXYMC+1XK84Mbe4NC9dLzk/dxMjMLWc/nf80w7Gua8+6h1iZOJgPMSo
        AtT8aMPqC4xSLHn5ealKIrzhLAIpQrwpiZVVqUX58UWlOanFhxilOViUxHm1bU8mCwmkJ5ak
        ZqemFqQWwWSZODilGphiA0IDtW3OG7ZGbnH4M322wawvlX4FPeaN9z4IPuMu5XUpiw41fBYm
        d/fwUW8vm5fmuw0vXXzVxzPlarJs8aX8u1Pu6O0XrRLZM+P1Y69Zxdon7J68kOz71Pb0XrzJ
        JOPCQJuoyBNvXzy9WmET+HG2w3vTO+ae+9R3Httl+OWHVsW8XVoxtptyLY4xchQH7VnFdnrl
        +Yn1bztCrj1OdVoekyvfZ5i98bBkaXqfy4/rs+R3CpVLXtAyei1bu7WGZRPz1xb3E2f3LVtd
        ctZIy79u+xce47MvjzHs/LrimrhnvSW3ifnkN24Hb3x8XPjT6+kBv+C1ptv3KDLYXZ/+WfnJ
        NWubCSnJVhkvDO4rPctQYinOSDTUYi4qTgQAQCgdEKgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e/4PV2RM4IpBkvOKVj8WaxqcXnXHDaL
        xo832S2OLRBzYPFovfSXzePzJrkApig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NY
        KyNTJX07m5TUnMyy1CJ9uwS9jCUbrjMWfLavmP+thbGB8aBZFyMnh4SAicSX6bdYuhi5OIQE
        ljJKzFv+lq2LkQMoISWxcm46RI2wxJ9rXWwgtpDAM0aJy0cyQUrYBPQk1q6NAAmLCJhLXF3y
        nwnEZhaIkdj2+z4jSImwQKHE4/0qIKaQgLPEoX+mIBUsAqoSP3/OYwRZyinQwyjxcv4RFpAE
        L9CY5Yt2soLYogKWEn+efWSHiAtKnJz5hAVifLbE19XPmScwCsxCkpqFJDULaB2zgKbE+l36
        EGFtiWULXzND2LYS69a9Z1nAyLqKUSS1tDg3PbfYUK84Mbe4NC9dLzk/dxMjMCa2Hfu5eQfj
        vFcf9Q4xMnEwHmJUAep8tGH1BUYplrz8vFQlEd5wFoEUId6UxMqq1KL8+KLSnNTiQ4ymQL9N
        ZJYSTc4HRmteSbyhmYGpoYmZpYGppZmxkjivZ0FHopBAemJJanZqakFqEUwfEwenVAPTgcpT
        LS6rvmi9m3GeSUSlRKhPqkdk2tpFzK8/bLk/T9/utcn2T587pffbm85+u4f95wXhRd+6n73Z
        J6Nmwuyf+IaXJeLVtouSm727Je9Kzgs6+EdXw6XA/tSzrO9zNyqfPfY3LnhucIk7zz0hvrcV
        5lxynj82Pgp/t+fMjpXrU4xEE9ZalMz7W8IkxGHR+/1Tdrmt2sGIaHu1yuiHOh+bzzBPmu6/
        LDTzUVP7rK4HHNEX3YNd3i/he6JvkbDK+ECu5NWwuYY8O+MuPTmQuHPmwvXfnzRtDPorw/7J
        iuHDc7W/1dNmLt8Za8cV+sX1yHn/ayWney4k/7/qrOJxaLrxyvT1bGdU+44YndkqlSKTocRS
        nJFoqMVcVJwIAN2XFfYeAwAA
X-CMS-MailID: 20230315134556eucas1p27459c63c810443c1a94d9683ebf9aed6
X-Msg-Generator: CA
X-RootMTR: 20230315134556eucas1p27459c63c810443c1a94d9683ebf9aed6
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230315134556eucas1p27459c63c810443c1a94d9683ebf9aed6
References: <20230310173217.3429788-3-amit.kumar-mahapatra@amd.com>
        <CGME20230315134556eucas1p27459c63c810443c1a94d9683ebf9aed6@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2023-03-10 pi=C4=85 23:02>, when Amit Kumar Mahapatra wrote:
> Supporting multi-cs in spi drivers would require the chip_select & cs_gpi=
od
> members of struct spi_device to be an array. But changing the type of the=
se
> members to array would break the spi driver functionality. To make the
> transition smoother introduced four new APIs to get/set the
> spi->chip_select & spi->cs_gpiod and replaced all spi->chip_select and
> spi->cs_gpiod references with get or set API calls.
> While adding multi-cs support in further patches the chip_select & cs_gpi=
od
> members of the spi_device structure would be converted to arrays & the
> "idx" parameter of the APIs would be used as array index i.e.,
> spi->chip_select[idx] & spi->cs_gpiod[idx] respectively.
>
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
> Reviewed-by: Michal Simek <michal.simek@amd.com>
> ---
>  drivers/net/ethernet/adi/adin1110.c            | 2 +-
>  drivers/net/ethernet/asix/ax88796c_main.c      | 2 +-
>  drivers/net/ethernet/davicom/dm9051.c          | 2 +-
>  drivers/net/ethernet/qualcomm/qca_debug.c      | 2 +-
>  drivers/net/ieee802154/ca8210.c                | 2 +-
>  drivers/net/wan/slic_ds26522.c                 | 2 +-
>  drivers/net/wireless/marvell/libertas/if_spi.c | 2 +-
>  drivers/net/wireless/silabs/wfx/bus_spi.c      | 2 +-
>  drivers/net/wireless/st/cw1200/cw1200_spi.c    | 2 +-
>  9 files changed, 9 insertions(+), 9 deletions(-)
>

Reviewed-by: Lukasz Stelmach <l.stelmach@samsung.com>

> diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/a=
di/adin1110.c
> index 3f316a0f4158..f5c2d7a9abc1 100644
> --- a/drivers/net/ethernet/adi/adin1110.c
> +++ b/drivers/net/ethernet/adi/adin1110.c
> @@ -515,7 +515,7 @@ static int adin1110_register_mdiobus(struct adin1110_=
priv *priv,
>  		return -ENOMEM;
>=20=20
>  	snprintf(priv->mii_bus_name, MII_BUS_ID_SIZE, "%s-%u",
> -		 priv->cfg->name, priv->spidev->chip_select);
> +		 priv->cfg->name, spi_get_chipselect(priv->spidev, 0));
>=20=20
>  	mii_bus->name =3D priv->mii_bus_name;
>  	mii_bus->read =3D adin1110_mdio_read;
> diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethe=
rnet/asix/ax88796c_main.c
> index 21376c79f671..e551ffaed20d 100644
> --- a/drivers/net/ethernet/asix/ax88796c_main.c
> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
> @@ -1006,7 +1006,7 @@ static int ax88796c_probe(struct spi_device *spi)
>  	ax_local->mdiobus->parent =3D &spi->dev;
>=20=20
>  	snprintf(ax_local->mdiobus->id, MII_BUS_ID_SIZE,
> -		 "ax88796c-%s.%u", dev_name(&spi->dev), spi->chip_select);
> +		 "ax88796c-%s.%u", dev_name(&spi->dev), spi_get_chipselect(spi, 0));
>=20=20
>  	ret =3D devm_mdiobus_register(&spi->dev, ax_local->mdiobus);
>  	if (ret < 0) {
> diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet=
/davicom/dm9051.c
> index de7105a84747..70728b2e5f18 100644
> --- a/drivers/net/ethernet/davicom/dm9051.c
> +++ b/drivers/net/ethernet/davicom/dm9051.c
> @@ -1123,7 +1123,7 @@ static int dm9051_mdio_register(struct board_info *=
db)
>  	db->mdiobus->phy_mask =3D (u32)~BIT(1);
>  	db->mdiobus->parent =3D &spi->dev;
>  	snprintf(db->mdiobus->id, MII_BUS_ID_SIZE,
> -		 "dm9051-%s.%u", dev_name(&spi->dev), spi->chip_select);
> +		 "dm9051-%s.%u", dev_name(&spi->dev), spi_get_chipselect(spi, 0));
>=20=20
>  	ret =3D devm_mdiobus_register(&spi->dev, db->mdiobus);
>  	if (ret)
> diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c b/drivers/net/ethe=
rnet/qualcomm/qca_debug.c
> index f62c39544e08..6f2fa2a42770 100644
> --- a/drivers/net/ethernet/qualcomm/qca_debug.c
> +++ b/drivers/net/ethernet/qualcomm/qca_debug.c
> @@ -119,7 +119,7 @@ qcaspi_info_show(struct seq_file *s, void *what)
>  	seq_printf(s, "SPI mode         : %x\n",
>  		   qca->spi_dev->mode);
>  	seq_printf(s, "SPI chip select  : %u\n",
> -		   (unsigned int)qca->spi_dev->chip_select);
> +		   (unsigned int)spi_get_chipselect(qca->spi_dev, 0));
>  	seq_printf(s, "SPI legacy mode  : %u\n",
>  		   (unsigned int)qca->legacy_mode);
>  	seq_printf(s, "SPI burst length : %u\n",
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8=
210.c
> index e1a569b99e4a..7093a07141bb 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -2967,7 +2967,7 @@ static int ca8210_test_interface_init(struct ca8210=
_priv *priv)
>  		sizeof(node_name),
>  		"ca8210@%d_%d",
>  		priv->spi->master->bus_num,
> -		priv->spi->chip_select
> +		spi_get_chipselect(priv->spi, 0)
>  	);
>=20=20
>  	test->ca8210_dfs_spi_int =3D debugfs_create_file(
> diff --git a/drivers/net/wan/slic_ds26522.c b/drivers/net/wan/slic_ds2652=
2.c
> index 6063552cea9b..8a51cfcff99e 100644
> --- a/drivers/net/wan/slic_ds26522.c
> +++ b/drivers/net/wan/slic_ds26522.c
> @@ -211,7 +211,7 @@ static int slic_ds26522_probe(struct spi_device *spi)
>=20=20
>  	ret =3D slic_ds26522_init_configure(spi);
>  	if (ret =3D=3D 0)
> -		pr_info("DS26522 cs%d configured\n", spi->chip_select);
> +		pr_info("DS26522 cs%d configured\n", spi_get_chipselect(spi, 0));
>=20=20
>  	return ret;
>  }
> diff --git a/drivers/net/wireless/marvell/libertas/if_spi.c b/drivers/net=
/wireless/marvell/libertas/if_spi.c
> index ff1c7ec8c450..1225fc0e3352 100644
> --- a/drivers/net/wireless/marvell/libertas/if_spi.c
> +++ b/drivers/net/wireless/marvell/libertas/if_spi.c
> @@ -1051,7 +1051,7 @@ static int if_spi_init_card(struct if_spi_card *car=
d)
>  				"spi->max_speed_hz=3D%d\n",
>  				card->card_id, card->card_rev,
>  				card->spi->master->bus_num,
> -				card->spi->chip_select,
> +				spi_get_chipselect(card->spi, 0),
>  				card->spi->max_speed_hz);
>  		err =3D if_spi_prog_helper_firmware(card, helper);
>  		if (err)
> diff --git a/drivers/net/wireless/silabs/wfx/bus_spi.c b/drivers/net/wire=
less/silabs/wfx/bus_spi.c
> index 7fb1afb8ed31..160b90114aad 100644
> --- a/drivers/net/wireless/silabs/wfx/bus_spi.c
> +++ b/drivers/net/wireless/silabs/wfx/bus_spi.c
> @@ -208,7 +208,7 @@ static int wfx_spi_probe(struct spi_device *func)
>=20=20
>  	/* Trace below is also displayed by spi_setup() if compiled with DEBUG =
*/
>  	dev_dbg(&func->dev, "SPI params: CS=3D%d, mode=3D%d bits/word=3D%d spee=
d=3D%d\n",
> -		func->chip_select, func->mode, func->bits_per_word, func->max_speed_hz=
);
> +		spi_get_chipselect(func, 0), func->mode, func->bits_per_word, func->ma=
x_speed_hz);
>  	if (func->bits_per_word !=3D 16 && func->bits_per_word !=3D 8)
>  		dev_warn(&func->dev, "unusual bits/word value: %d\n", func->bits_per_w=
ord);
>  	if (func->max_speed_hz > 50000000)
> diff --git a/drivers/net/wireless/st/cw1200/cw1200_spi.c b/drivers/net/wi=
reless/st/cw1200/cw1200_spi.c
> index fe0d220da44d..c82c0688b549 100644
> --- a/drivers/net/wireless/st/cw1200/cw1200_spi.c
> +++ b/drivers/net/wireless/st/cw1200/cw1200_spi.c
> @@ -378,7 +378,7 @@ static int cw1200_spi_probe(struct spi_device *func)
>  	func->mode =3D SPI_MODE_0;
>=20=20
>  	pr_info("cw1200_wlan_spi: Probe called (CS %d M %d BPW %d CLK %d)\n",
> -		func->chip_select, func->mode, func->bits_per_word,
> +		spi_get_chipselect(func, 0), func->mode, func->bits_per_word,
>  		func->max_speed_hz);
>=20=20
>  	if (cw1200_spi_on(plat_data)) {

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmQRzA8ACgkQsK4enJil
gBBCmQgAlXCc5LGsVIU+TBjNuqDGd+fnQffgk+zNgUXtjahrkxEArw/O3Roouwlw
pzaQmiLjxXA1R2TWihm5u3VyvJ1/V/uCd3DCLKl9xdqexmnvKpQCvUFjohVDePhU
lmCRx6jqyPkVhY8u6KkzrFNYTh4KCxU5PSyMdI/npk9PgKeqXoOGVvrl58b1c7Ta
49fiqENYiLnqyKW27JYr6QLFO0N8KS5KcXSHh+Kz9HGTNenwLPp1+jy92FcyhhFZ
wVYt12QILDfjqe857FKtLbcG5yilisFH92ZIIA06Y9W6uNLPDyFER+cg3WhphhBk
TOC+htf9rQ8++tcMNKi+uJ40X9bbdA==
=tHGA
-----END PGP SIGNATURE-----
--=-=-=--
