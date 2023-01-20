Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB703675273
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjATKaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjATKaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:30:19 -0500
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BA41BE2;
        Fri, 20 Jan 2023 02:30:17 -0800 (PST)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20230120103014euoutp0130d602966957ba381825e74c577eb140~7-a8WKt492405724057euoutp018;
        Fri, 20 Jan 2023 10:30:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20230120103014euoutp0130d602966957ba381825e74c577eb140~7-a8WKt492405724057euoutp018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1674210614;
        bh=EGWUIr6R4nzwi9E5YCh87F69rZqdAXeorF4HoBwJy3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E23I5AT3vMbnDjaIC6VJKvykk6+mlSVc4qMgDiYSanYoAAGoObF9JFu+3w2uRbaFz
         lzMEf98mEzsNgfPDMcx3SJ3wUljjI3+0964DtX9otcCsj5DSzx+xgGU7RjSBRgFfBY
         0kx5e//pRqVtDJSreHW88v43kO2t6J4gv0Trjw9o=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20230120103014eucas1p1fd3721a0772945951c2a072770c68a12~7-a8LLcUG2297222972eucas1p1B;
        Fri, 20 Jan 2023 10:30:14 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id F9.27.13597.63D6AC36; Fri, 20
        Jan 2023 10:30:14 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20230120103014eucas1p24409332eeb60c62e22287f97339a2d91~7-a7tkgnh1427714277eucas1p2R;
        Fri, 20 Jan 2023 10:30:14 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230120103014eusmtrp1444154335c36ddfcf54f26fd2cd7a6b2~7-a7sw4Lc0840508405eusmtrp1D;
        Fri, 20 Jan 2023 10:30:14 +0000 (GMT)
X-AuditID: cbfec7f4-1f1ff7000000351d-57-63ca6d36251f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id FB.69.00518.63D6AC36; Fri, 20
        Jan 2023 10:30:14 +0000 (GMT)
Received: from localhost (unknown [106.120.51.111]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230120103014eusmtip17f3918b7c90b94d0ace155f5dfe35499~7-a7gAmnv0980609806eusmtip1o;
        Fri, 20 Jan 2023 10:30:14 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 03/13] net: Replace all spi->chip_select and
 spi->cs_gpiod references with function call
Date:   Fri, 20 Jan 2023 11:30:01 +0100
In-Reply-To: <20230119185342.2093323-4-amit.kumar-mahapatra@amd.com> (Amit
        Kumar Mahapatra's message of "Fri, 20 Jan 2023 00:23:32 +0530")
Message-ID: <dleftjr0vpbis6.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf1CLcRzHfbdnz57SeGypz01+VOKIELfmUtShJ/lD59w5P07THtVpK3uK
        uEM6lkY/xEkJdZGUFZk4P8+kLqEpy5zUhROFsrmQ+bH1zZ3/Xp8f78/n8/7el+KLawRSKkGd
        wmrUikQf0pWoa/jRMlumehg792yBr9xe5icvbtlPyE11OQJ5241iUt5Q4iEfbP6IlpDMgdZf
        JGO48ILH1FZmkUz/HTPJ2GonrRKsc12kZBMTtrOaOaExrvHFhm5ecq5nWmd9CZGO7kt0yIUC
        egGc1OcTThbTFQhe9UTokKuDvyLov3xGiAMbgvRcs/CfwtZyk8SF8wgG7e94OHiPoPBUJdIh
        iiLpANDr1zoF7nQQmM/+4TmZT++GjqEc5GQJvQ2+XcwZHkrQfvDTrCecc1zowwhMR4zDApFD
        bOssFzh5PL0Q7O++CHF+HDQVviXwUBUUtnxE+Lr3FGSXz8e8FArOdZGYJdDbaBhx4AXNRw8P
        LwM6E0HGs1IBDvIQ2A5m8HBXMHQ8GRpRh8Ggtop0OgN6DFg+jcOLx0B+XQEfp0VwUCvG3VOh
        OvcWgVkK2b0VI7cxMNB0QIjfugDBY/O0PDSl6D87Rf/ZKXJM5dMzoObGHJz2h/LSPj7mEKiu
        7idKkKASebKpnCqO5QLV7I4ATqHiUtVxAbFJqlrk+EfNvxu/Xkfne78EGBGPQkY01SF+fanK
        hKSEOknN+riLxtY0xopFSsXOXawmaZMmNZHljGgCRfh4ivxDmmLFdJwihd3Kssms5l+VR7lI
        03kp0RPDY155b5qb2X47vPOB0mB7+n1BmqnVLaRGV9+tX0MH7ru47dFqj1FXl9l8o2ThXZax
        Skttn24ls8arf2+MResuHM+EntA0xN8bXRGm3OIbHCEyRFo3pG3+I7N6WSctPv1cT13oSdl7
        jQriNpZ6tD6SrhCHZbjHp1p7I6NWvbTL0rxLMqdJjllUt3rupr+pn7Va8iB4p4vSc4X1WWiX
        hyjq+OQ9G+5+y25lcoao3MKwUaa89lCbnJmZZf0V8aM7klwUvpsrWy7wliVwv90MV/rWh2TZ
        1YEdpUbNQFlbVWdyhe9abZtf0ewdbe3kof1X/C8FRbtNX7xrQNsYfe/DZx+Ci1fMm8nXcIq/
        gqxcfMIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t/xu7pmuaeSDa6v47L4s1jVYs75FhaL
        C9v6WC0u75rDZnFsgZjFt9NvGB3YPFov/WXz2LLyJpPHplWdbB7v911l8/i8SS6ANUrPpii/
        tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/OJiU1J7MstUjfLkEvY86Wh0wF/eIV
        944sYGlgPCzcxcjJISFgIvH5/G62LkYuDiGBpYwS/ZtPMncxcgAlpCRWzk2HqBGW+HOtC6rm
        GaPE0o/X2EFq2AT0JNaujQCpEREwl7i65D8TiM0sUCux+Ps6dhBbWKBQ4vuaPrByIQFniQu9
        iiBhFgFVid9X17KAjOQU6GGUuDDxEFgvL9Ccz/eWsYLYogKWEn+efWSHiAtKnJz5hAVifrbE
        19XPmScwCsxCkpqFJDULaB2zgKbE+l36EGFtiWULXzND2LYS69a9Z1nAyLqKUSS1tDg3PbfY
        SK84Mbe4NC9dLzk/dxMjMJK2Hfu5ZQfjylcf9Q4xMnEwHmJUAep8tGH1BUYplrz8vFQlEV7+
        9ceThXhTEiurUovy44tKc1KLDzGaAv02kVlKNDkfGON5JfGGZgamhiZmlgamlmbGSuK8ngUd
        iUIC6YklqdmpqQWpRTB9TBycUg1M7Uv5HEqKPjL/msWUGsGffLK4cvHl0x8/t20TWnDovP7O
        BjYdnZBfx3t1FjvmLCl53N/EqauXzxz7zOX/bxOZHT6994yP8sU8/5zG9an/0e/p9pmeoqkq
        f+fMuqrxMsruQ+isJYoSJ8LWsf+tcnZaE5Ky6YXlfaOC3ed8lGO/ahu9dAyYt0eOISRJe8ez
        l/duzec1yG6R8tT5r2gUzX1ZfwL/9ZyW+5bN6UypX7yP7dR4b/SjMWfV4s0B17df2CI29W27
        Z4hhBeP7df5rj5Y2xD7nXOxekSgbmSp+9yzvzY8Xz75ln1a6uLErvSg99M6ZM7xxNySZz198
        Fvh6TUPlHOnwr3buAT97hTe1fC5QYinOSDTUYi4qTgQApoQF+jkDAAA=
X-CMS-MailID: 20230120103014eucas1p24409332eeb60c62e22287f97339a2d91
X-Msg-Generator: CA
X-RootMTR: 20230120103014eucas1p24409332eeb60c62e22287f97339a2d91
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230120103014eucas1p24409332eeb60c62e22287f97339a2d91
References: <20230119185342.2093323-4-amit.kumar-mahapatra@amd.com>
        <CGME20230120103014eucas1p24409332eeb60c62e22287f97339a2d91@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2023-01-20 pi=C4=85 00:23>, when Amit Kumar Mahapatra wrote:
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

Acked-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>

[...]

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

[...]


=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmPKbSkACgkQsK4enJil
gBDsUwf+JlOBfdINxYoBLUde8GOcfpTco1sQ2tJ4pXxJJzE1IYk/4eacyRcODetQ
sjxXXO8dBaLTCl5BzGiNsOJBsfOJ02oJxU1lz7aWMXsTVU/abG1m1wLcFn9izkZG
TE+7VmES2TdHQS1UA9ftoEEhvSme+hSPBSPZlKrEudohpq9I+AlVg9fj+2PXXgKu
h/q+bGdbS0TN2MeNqPiKOZDvhw4WXK68cEU4It9WU+eGwYBm+NTawVzU3t723rOZ
2p3QpMNUDWpW1AlY2/EP79yhkZb9IK8m9WQ4NDr6nnZijIhU9nQci6Zyfng6aVER
6dDTTnTP/eQFyP36u8w0Xsi+Q9cfcg==
=OM5C
-----END PGP SIGNATURE-----
--=-=-=--
