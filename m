Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7686BB4C6
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjCONfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbjCONfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:35:02 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A604D125A9;
        Wed, 15 Mar 2023 06:34:48 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20230315133447euoutp02b129aa10d95607d72f1b4c1ec19f91c1~Mmxest6t03083630836euoutp02b;
        Wed, 15 Mar 2023 13:34:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20230315133447euoutp02b129aa10d95607d72f1b4c1ec19f91c1~Mmxest6t03083630836euoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1678887287;
        bh=LLlYUXQsEgYLxFHapQub+mE4WV568RXHequuRWq1S8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNFPcfR4PtyNiG5leIVYPHPp4xa/O9mSQ3KZcx4/bsoSHCVl0HQXz5YC/gNOQSGFY
         YvddKVJx16/Jrk9LNdMHqLK4BTealXMsQ+RoryNfwaqN0z70G0uTGFB6+QtB16EPBu
         ECDw3dlL4Srz+iNx25aPqCLmrWPIj8qv4n8O0iC8=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20230315133446eucas1p170c863f52e7bb7ab1dda9cf31231d74b~MmxeTuAek0494604946eucas1p1k;
        Wed, 15 Mar 2023 13:34:46 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 86.6E.09503.679C1146; Wed, 15
        Mar 2023 13:34:46 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20230315133446eucas1p2e6acaf7a67368b99022b1dca5ef25a17~MmxeBPDeb2839828398eucas1p2t;
        Wed, 15 Mar 2023 13:34:46 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230315133446eusmtrp188925be0af5d009449d83fba095d08b5~MmxeAo6-r1697116971eusmtrp1e;
        Wed, 15 Mar 2023 13:34:46 +0000 (GMT)
X-AuditID: cbfec7f2-e8fff7000000251f-31-6411c976ee4f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id CD.59.09583.679C1146; Wed, 15
        Mar 2023 13:34:46 +0000 (GMT)
Received: from localhost (unknown [106.120.51.111]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230315133446eusmtip12befc2096e02957706115f35429d8c85~Mmxdz0MWg0839508395eusmtip1S;
        Wed, 15 Mar 2023 13:34:46 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Cc:     <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH V5 02/15] net: Replace all spi->chip_select and
 spi->cs_gpiod references with function call
Date:   Wed, 15 Mar 2023 14:34:37 +0100
In-Reply-To: <20230306172109.595464-3-amit.kumar-mahapatra@amd.com> (Amit
        Kumar Mahapatra's message of "Mon, 6 Mar 2023 22:50:56 +0530")
Message-ID: <dleftjwn3i16ky.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsWy7djPc7plJwVTDL6uUbH4s1jV4vKuOWwW
        jR9vslscWyDmwOLReukvm8fnTXIBTFFcNimpOZllqUX6dglcGdPOP2AueGdfcfteWQPjHrMu
        Rk4OCQETiX1LLrB0MXJxCAmsYJTY1HqUDSQhJPCFUWLl2goI+zOjxJSXOjANd34+YoVoWM4o
        cfZFPytE0QtGidO/i7oYOTjYBPQk1q6NAAmLCJhLXF3ynwnEZhaIkbh67zMjiC0sUCix9d05
        sDiLgKrE0YtHwI7gFOhilDi0ew/YTF6g5jkz5oI1iApYSvx59pEdIi4ocXLmExaIobkSM8+/
        YQRplhA4wiGxf+EOJohLXSTOL1zECGELS7w6voUdwpaROD25hwWioZ1RounKQlYIZwKjxOeO
        Jqhua4k7536xQdiOEpMv72YHeU1CgE/ixltBiM18EpO2TWeGCPNKdLQJQVSrSKzr38MCYUtJ
        9L5aAXWDh8SMUyvYICE3jVHi193P7BMYFWYheWgWkodmAY1lFtCUWL9LHyKsLbFs4WtmCNtW
        Yt269ywLGFlXMYqnlhbnpqcWG+allusVJ+YWl+al6yXn525iBKaW0/+Of9rBOPfVR71DjEwc
        jIcYVYCaH21YfYFRiiUvPy9VSYQ3nEUgRYg3JbGyKrUoP76oNCe1+BCjNAeLkjivtu3JZCGB
        9MSS1OzU1ILUIpgsEwenVANTxsmDJ3nuvk0Ibn7RxHft7MxjR1Z+616v92pBSHLFzqkHnf7t
        3ntEb2fd21eT9Zqtd3vuLqvXla48Ehf4h+O71e4X9crbQ3NsnZrehU/TWnhX79LsWLYutx4L
        tp3JMW9NjLs3smlqdqRNi+N22H32J++pFcnb53GKyHI5LefeWa3g7/L/upr7vSetX7quKc9Z
        Hs2l+NL/lZDjsVPuy5YGNxqpqP27WrQyY/P/3kh+thXPzgY51qyus7u4Slt7yZUpX/kmWB5m
        LlAtMKp89979j+E8ESH9C2py+4/e1LP3Pbnm96Tf3PLKjuwL1hq/dYo5kmP3zTtJ6u/H1qCJ
        T27p3X67PNjFeJ/u3P4m3+mPlFiKMxINtZiLihMBAdfS1qgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e/4Xd2yk4IpBl9m8lv8WaxqcXnXHDaL
        xo832S2OLRBzYPFovfSXzePzJrkApig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NY
        KyNTJX07m5TUnMyy1CJ9uwS9jGnnHzAXvLOvuH2vrIFxj1kXIyeHhICJxJ2fj1i7GLk4hASW
        Mkpcu/IKyOEASkhJrJybDlEjLPHnWhcbRM0zRonrO24xgtSwCehJrF0bAVIjImAucXXJfyYQ
        m1kgVmLjrOtgtrBAocTWd+fAbCEBJ4nFn7tYQGwWAVWJoxePsIDM5BToYpQ4tHsPK0iCF2jQ
        nBlzGUFsUQFLiT/PPrJDxAUlTs58wgKxIFvi6+rnzBMYBWYhSc1CkpoFdB6zgKbE+l36EGFt
        iWULXzND2LYS69a9Z1nAyLqKUSS1tDg3PbfYSK84Mbe4NC9dLzk/dxMjMC62Hfu5ZQfjylcf
        9Q4xMnEwHmJUAep8tGH1BUYplrz8vFQlEd5wFoEUId6UxMqq1KL8+KLSnNTiQ4ymQL9NZJYS
        Tc4HRmxeSbyhmYGpoYmZpYGppZmxkjivZ0FHopBAemJJanZqakFqEUwfEwenVAOTnKRmetWs
        Gu/0QL0ijf9BIRli56YUhNlWfDFcecSq9WeQwy4Lj0vBjof8Dy7VWzCtlsew9HqQ9+69fK/f
        H31eyGTUMuO9RIxfWshR5pqHc0I//r9pebrBdSHf+usKU1w0vjB4cCalrGeepRTda+LT7qk2
        /dVvE/enX1bOlTLmfPSW0Whdr/1hzwnzAzqd2GQucAfVZb4TKzjBt/nryuibXn4sn9Yrmr+K
        6s4yOCG96VDKV6ksm39c+zVSJNSve9zaviOz3Ytl+aJCn0dH4o8/c5WcOufbPrHp55KSjjZJ
        xcz/PX9m8/aHNZ/neyze7Ra4aUVHUYJQiLvpqcbVR9b/27WPo89XWvyNCNPmiEtKLMUZiYZa
        zEXFiQBwqwiXIAMAAA==
X-CMS-MailID: 20230315133446eucas1p2e6acaf7a67368b99022b1dca5ef25a17
X-Msg-Generator: CA
X-RootMTR: 20230315133446eucas1p2e6acaf7a67368b99022b1dca5ef25a17
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230315133446eucas1p2e6acaf7a67368b99022b1dca5ef25a17
References: <20230306172109.595464-3-amit.kumar-mahapatra@amd.com>
        <CGME20230315133446eucas1p2e6acaf7a67368b99022b1dca5ef25a17@eucas1p2.samsung.com>
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

It was <2023-03-06 pon 22:50>, when Amit Kumar Mahapatra wrote:
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
> index 0805f249fff2..aee7a98725ba 100644
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

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmQRyW0ACgkQsK4enJil
gBDJlAf/aYXd6wQmEWnzTCPS3UEyuItQ4kCQDTXXsZ6I8XpLkWZRYNRlh78OBmcq
QJWlOlnTMGAszElpaHLrncc38gA4DiZooB61wmkCsW1Za0oyT2k0ZPRAD0EOGui4
B4nUc1lmH+tkXrSfKffd2wAzQKC+B/lthb31gHfkKOe5m8zjuYhtJNFSU5F1XHGE
tJOdFkFmXdYqKS3hC62Asbm8HTeZD4TaJr0p1EpbsQzDeRn1DxG0KTC8dADi8ihQ
GqLOKli52KlzuJvnnAN6UA8aYFNIanTyyt4JwYzqYQcZR1eSEhuVzLGvFPnctyso
/d2wjHBp1xzd1tGgdo9hxdHcsgW09Q==
=xR/R
-----END PGP SIGNATURE-----
--=-=-=--
