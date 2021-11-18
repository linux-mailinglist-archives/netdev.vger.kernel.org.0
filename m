Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49C5455B4A
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344589AbhKRMNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:13:50 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26623 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344590AbhKRMN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 07:13:28 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20211118121027euoutp025aff9f1e762e8769185469f988598c50~4osQM6tb60839208392euoutp02T;
        Thu, 18 Nov 2021 12:10:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20211118121027euoutp025aff9f1e762e8769185469f988598c50~4osQM6tb60839208392euoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637237427;
        bh=7irLMnJv5OBtHm39sKgVDbvTH+oUI1tVvWE4jP861FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAdozMR2rMj7pJb+2Iu6q22QENi2oENpMQc9/+ZzkuBkqCfI8vUxYQD7Ms0oLhqID
         T9cwNw312Gq0hA19iUvd5Phg1lfa/Oy5V7ckPyc58aw5DfSlrzd1wxDVGNU9iWuGeW
         fEEwYUp8bDnnvawE8kQqXK/P0N1Xw73gWIxbp6kM=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211118121027eucas1p21597ef4cd395d37dc3b4d4fcc646be3a~4osQAPe0T2858028580eucas1p2t;
        Thu, 18 Nov 2021 12:10:27 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 8E.DF.10260.3B246916; Thu, 18
        Nov 2021 12:10:27 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20211118121026eucas1p2b113b6be5644d9c2038519feecba51f5~4osPj6DFT2858028580eucas1p2s;
        Thu, 18 Nov 2021 12:10:26 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211118121026eusmtrp11bc0f90f233eba7fd07177524bb24700~4osPjNa_v1860818608eusmtrp1p;
        Thu, 18 Nov 2021 12:10:26 +0000 (GMT)
X-AuditID: cbfec7f5-bf3ff70000002814-b2-619642b32238
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 1E.22.09522.2B246916; Thu, 18
        Nov 2021 12:10:26 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20211118121026eusmtip2355b05f7a0849d45778c3b7e8f36b77f~4osPWZcKo1177211772eusmtip2D;
        Thu, 18 Nov 2021 12:10:26 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/9] net: ax88796c: don't write to
 netdev->dev_addr directly
Date:   Thu, 18 Nov 2021 13:09:52 +0100
In-Reply-To: <20211118041501.3102861-2-kuba@kernel.org> (Jakub Kicinski's
        message of "Wed, 17 Nov 2021 20:14:53 -0800")
Message-ID: <dleftja6i1fywf.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsWy7djP87qbnaYlGtx7yGox53wLi8WFbX2s
        FscWiDkwe2xZeZPJY9OqTjaPz5vkApijuGxSUnMyy1KL9O0SuDK+LNzCVjBLoqLlWztzA+NV
        kS5GTg4JAROJe90rWLsYuTiEBFYwSuyZvw3K+cIo8eLWWnYI5zOjxNH+p4wwLW8vbYRKLGeU
        2HZtBQuE85xRYuvBHcxdjBwcbAJ6EmvXRoA0iAioSLRsnskCYjMLGEjMu32LHcQWFoiWmLul
        mRWknEVAVWLfuSCQMKdApcSdk69ZQWxeAXOJU59+MYHYogKWEn+efWSHiAtKnJz5BGpkrsTM
        82+gbjvCIXFytyeE7SKxcfsnJghbWOLV8S3sELaMxOnJPSwgayUE6iUmTzIDuV5CoAfolTk/
        WCBqrCXunPvFBmE7SrTuXcEKUc8nceOtIMRaPolJ26YzQ4R5JTrahCCqVSTW9e+BmiIl0ftq
        BdRlHhLP/v1ggwRUF6PEpU8/WCYwKsxC8s0sJN/MAhrLLKApsX6XPkRYW2LZwtfMELatxLp1
        71kWMLKuYhRPLS3OTU8tNs5LLdcrTswtLs1L10vOz93ECEwtp/8d/7qDccWrj3qHGJk4GA8x
        qgA1P9qw+gKjFEtefl6qkgivUMPURCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8In8aEoUE0hNL
        UrNTUwtSi2CyTBycUg1MQT/Ort6QHXzPMWXrp13iNzbczy3bxPxereijXd0Dxce1bY7q4ktO
        lTHOKlt3+mrnpqn8IfHhHhWMEx9dkzA/E3nicti2Z2ucfpnWWJTbHJ/csLCz1frQGeaJXUtO
        un3L+90+q0PYNLcwIshLp6kz8LINS2xOyrl/W1fKNhcLlNs3X1rwLPoep9rE0g6FjcmnWm/K
        PtjnpWMoZ23gI3lNW7jiZ9WMSkYN9msRL6WSNi2KDZSw9NpRYMd/eWVgSTTPlMSPp9xLnnZx
        bbzzPuSdfKJwyjONXNHWza5W/EyOk7/rHPi5vCubI8n86OOWk3tbnYNfc658o7re+lRHdltE
        +MLfq31UBGSXbOi7+1CJpTgj0VCLuag4EQDpGRxcqAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e/4Pd1NTtMSDdbPUbeYc76FxeLCtj5W
        i2MLxByYPbasvMnksWlVJ5vH501yAcxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbm
        sVZGpkr6djYpqTmZZalF+nYJehlfFm5hK5glUdHyrZ25gfGqSBcjJ4eEgInE20sb2bsYuTiE
        BJYySpxf2gbkcAAlpCRWzk2HqBGW+HOtiw2i5imjxO/da8Fq2AT0JNaujQCpERFQkWjZPJMF
        xGYWMJCYd/sWO4gtLBAtMXdLMyuILSRgJrHs9AlmkFYWAVWJfeeCQMKcApUSd06+BivhFTCX
        OPXpFxOILSpgKfHn2Ud2iLigxMmZT6DGZ0t8Xf2ceQKjwCwkqVlIUrOANjALaEqs36UPEdaW
        WLbwNTOEbSuxbt17lgWMrKsYRVJLi3PTc4sN9YoTc4tL89L1kvNzNzEC42LbsZ+bdzDOe/VR
        7xAjEwfjIUYVoM5HG1ZfYJRiycvPS1US4RVqmJooxJuSWFmVWpQfX1Sak1p8iNEU6LOJzFKi
        yfnAiM0riTc0MzA1NDGzNDC1NDNWEuf1LOhIFBJITyxJzU5NLUgtgulj4uCUamDS4++646zr
        EvW8QERHJunBbdcJ/m7CtZMeM5S97FGZxZ1+NNAoy2oP/2KVJ7L3jP6rqhupij/Zuv1/c8vv
        11EPl1XGqXRF7eyWUKwLDwi69qNb765OZ+nFWH9ZqfD0S8zpX+zfzFT8pPfy7I3nZjX5vC9e
        eV6JUVTf47nhjdaWv26Ntz6IbDSzWBO6S9/D8oLlv6eVLHcmn304s2cnQ8fqi09mr2X/+DDt
        ot1yxYAfJ7U/HRGRvN4WKnt+3xyDpRwJMsI74jeeb2r1OSNzaTLXu9K4TssGhtcHU1ol/c4z
        dLWVePP/czwbo3BHVa5pJuN+3/lv5rlt3yjIeHJj3W1Dn087573qXbZ4+oRbx6qVWIozEg21
        mIuKEwGZ09Q5IAMAAA==
X-CMS-MailID: 20211118121026eucas1p2b113b6be5644d9c2038519feecba51f5
X-Msg-Generator: CA
X-RootMTR: 20211118121026eucas1p2b113b6be5644d9c2038519feecba51f5
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211118121026eucas1p2b113b6be5644d9c2038519feecba51f5
References: <20211118041501.3102861-2-kuba@kernel.org>
        <CGME20211118121026eucas1p2b113b6be5644d9c2038519feecba51f5@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-11-17 =C5=9Bro 20:14>, when Jakub Kicinski wrote:
> The future is here, convert the new driver as we are about
> to make netdev->dev_addr const.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: l.stelmach@samsung.com
> ---
>  drivers/net/ethernet/asix/ax88796c_main.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>

Acked-by: Lukasz Stelmach <l.stelmach@samsung.com>

> diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethe=
rnet/asix/ax88796c_main.c
> index e230d8d0ff73..e7a9f9863258 100644
> --- a/drivers/net/ethernet/asix/ax88796c_main.c
> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
> @@ -144,12 +144,13 @@ static void ax88796c_set_mac_addr(struct net_device=
 *ndev)
>  static void ax88796c_load_mac_addr(struct net_device *ndev)
>  {
>  	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
> +	u8 addr[ETH_ALEN];
>  	u16 temp;
>=20=20
>  	lockdep_assert_held(&ax_local->spi_lock);
>=20=20
>  	/* Try the device tree first */
> -	if (!eth_platform_get_mac_address(&ax_local->spi->dev, ndev->dev_addr) =
&&
> +	if (!platform_get_ethdev_address(&ax_local->spi->dev, ndev) &&
>  	    is_valid_ether_addr(ndev->dev_addr)) {
>  		if (netif_msg_probe(ax_local))
>  			dev_info(&ax_local->spi->dev,
> @@ -159,18 +160,19 @@ static void ax88796c_load_mac_addr(struct net_devic=
e *ndev)
>=20=20
>  	/* Read the MAC address from AX88796C */
>  	temp =3D AX_READ(&ax_local->ax_spi, P3_MACASR0);
> -	ndev->dev_addr[5] =3D (u8)temp;
> -	ndev->dev_addr[4] =3D (u8)(temp >> 8);
> +	addr[5] =3D (u8)temp;
> +	addr[4] =3D (u8)(temp >> 8);
>=20=20
>  	temp =3D AX_READ(&ax_local->ax_spi, P3_MACASR1);
> -	ndev->dev_addr[3] =3D (u8)temp;
> -	ndev->dev_addr[2] =3D (u8)(temp >> 8);
> +	addr[3] =3D (u8)temp;
> +	addr[2] =3D (u8)(temp >> 8);
>=20=20
>  	temp =3D AX_READ(&ax_local->ax_spi, P3_MACASR2);
> -	ndev->dev_addr[1] =3D (u8)temp;
> -	ndev->dev_addr[0] =3D (u8)(temp >> 8);
> +	addr[1] =3D (u8)temp;
> +	addr[0] =3D (u8)(temp >> 8);
>=20=20
> -	if (is_valid_ether_addr(ndev->dev_addr)) {
> +	if (is_valid_ether_addr(addr)) {
> +		eth_hw_addr_set(ndev, addr);
>  		if (netif_msg_probe(ax_local))
>  			dev_info(&ax_local->spi->dev,
>  				 "MAC address read from ASIX chip\n");

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmGWQpEACgkQsK4enJil
gBD8Iwf9FqnatnXBXE2jFh387+ma4lJRr1C5ilXchbBR8WUDH0PySSQUWjRSGejr
Wr8BrmTiGMcWTSoWjWwWF3X+uqlNeHuGAzuROfJEmuU3B6PrsdeWf8nvBQdQ8Egy
SN91Ounhph/SAJ8ga+N6pxGl2bIaGJOa7tZrQrpDN7LqApbrA8SXRskTxKNHbq85
JJFQTFdRRk8cR3YiMgmh6mPBrBlIt1qzhynXBjZQeAJryWzmRtIgSMSGbi6Dq4/2
WnaHiz8B3laXeFlkJo9KSu1mBRvUbSlkXyj3WoQpuqlmp7ftiO1eleaQ+N4E4evN
Bawl2BdWi5FmTBHX28UDKQcAwxwxLQ==
=S1an
-----END PGP SIGNATURE-----
--=-=-=--
