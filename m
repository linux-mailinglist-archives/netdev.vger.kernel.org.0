Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE39268DE7
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 16:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgINOhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 10:37:18 -0400
Received: from mail-db8eur05on2075.outbound.protection.outlook.com ([40.107.20.75]:22621
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbgINOfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 10:35:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hi89aEVT2EZy5ZyJ4rJKjGrzjeyGTsRocyuxVYcZepBcp3epRcfU32Ym6wI2HlZ0Dsr8177X4at0Ssfggq0NA4zGOA/xcMgi6qV3Ar2S6y3gDD7uMP6OUAzKTeAANjg+0jZtitMzAHpd56gP3tdNLIusKbFVco6bembAYPoJpLqDfEFV5n2P+c9erNXU/5kM5wLNO5zeYaMcOvz65yWZ4H/GvRLQTPLny9PxhyV++iSntKiJI7FNDLfHXIVjL/2UaEAdsaK2Aj/1NMudh3o1Kx2GGmkaQQ1/BU56SuQuUSH4VN/J0uvKlXzHSrhdcerdWpq+T3Zrv6hibjbAjSYMBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTQdSaPt+QqPjJLzIwyP16qbAjyJTPY/zv5P7EqHf+k=;
 b=BTs3BWJktQXSbZ+X/psrBIJZcbrvPN5tWUjwKZCduqjLHLEHZdZuShatNyBJzbunziIG2ZzRqaR2jDcz7a9Pk9kFlmUomQlNumaeluNhRIjcBH1O7w6QSchF86gWTVD+qi59QyHoc/98t2hnRVelBwgvbzc/GpluxGKo2LFYTdztaVQEfiBpuuRAvHEkm6QnwbGSsqhTwKftaHCVdZRmd7w5scbPbpm9dN9St9HNQSTWO32J7K0nbnq6mcFMHy5lPjiUG7OoaWpQ7zX4vPrLumny2zDfMqBa/Co6016DUmVTjt9eh/49E7eBAaDfCjqWlJ6zJ5eBLKkLWAhmM5j0vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTQdSaPt+QqPjJLzIwyP16qbAjyJTPY/zv5P7EqHf+k=;
 b=q2qHV2SGaVtoZY4j7fmx5s7LcJIbwCe43srndDPnPLjAEWFcVgNSxP2WMsvUqmha0eF/cJNrMUQktjdZEDoHW+xtZ3Slkw/Cpw1LfgDKwGqYCUvy1dfwkHjKT12Ac3A8A7YldyuP/kEC5OZ9qGxDOXCCBksJV5bGWVhQ56/0WDo=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM0PR0402MB3476.eurprd04.prod.outlook.com (2603:10a6:208:25::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Mon, 14 Sep
 2020 14:35:38 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::c10b:eaf9:da9a:966e]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::c10b:eaf9:da9a:966e%7]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 14:35:38 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: fec: ptp: remove unused variable 'ns' in
 fec_time_keep()
Thread-Topic: [PATCH net-next] net: fec: ptp: remove unused variable 'ns' in
 fec_time_keep()
Thread-Index: AQHWipki3XCTRnqQD0iUbmkKhFWiuqloMy5A
Date:   Mon, 14 Sep 2020 14:35:38 +0000
Message-ID: <AM8PR04MB7315343612D0F76F6D6EB8CAFF230@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <1600089264-21910-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1600089264-21910-1-git-send-email-zhangchangzhong@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c6d7bd9f-3a87-416e-04e9-08d858bb72f1
x-ms-traffictypediagnostic: AM0PR0402MB3476:
x-microsoft-antispam-prvs: <AM0PR0402MB3476579CADC0B63F09D59DF3FF230@AM0PR0402MB3476.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:46;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a8qfY+gs17/9lU/tDEGLjR9S9ODgfPzCjFRVR7Z7tgJ7bgG80MM0AMtR4FHe2r3+ClbwhPFarnVk4Jvc6c/F1f9mkugTeYRV0TeGSWSyWZBk3qRYlU8SJw1SvMb9+NuCJzeueVIMq+6tEWRfd3JkbPVvX6lIkb/wbqF3Q5vBt3ehyrC6GJO4l7ZhZAxS3VVu9ezCwN67OypNDHL23eG8b1L8rymXQbImCIPFWFxs7qNpL31HQS2vdeLh3tutocHnQsiRilxkYT/auO+Chr5vqo6axW4ezRb68zGeaQ6NEpido3ZncIEtgvw3+fa7Kcr56wA1O0noAzPq+0VdHyClgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(64756008)(66556008)(66446008)(7696005)(76116006)(478600001)(86362001)(83380400001)(2906002)(186003)(55016002)(8676002)(6506007)(71200400001)(26005)(52536014)(8936002)(5660300002)(9686003)(316002)(66476007)(66946007)(110136005)(33656002)(54906003)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: l1n/2z4o8igW3CMkoU4Uno83B65UClvXayW+li2LReEAB5NeJr/OX96TYYTJ8oZ519obGMUqMbaw/Mao7X8xGmMcFzVMRK+RQy3jaOpIPGwTNHl8rjQG4b3CX9TEvmvKd5tPum6ULngYZbPmPOYDQjnR7UAXGSBWJ/mvt2XGGtuDUhTERsutcyuFLNRqPkm8wWdlCOwbB7mF2YrzkkrQcE+1HIG3WXR5RLb/ZS13cANeGP1GWIDTvXfD0h237TyA0STcUjGuQv2AO/jioiWO1Y5Gqc3RKoI/mYN5HIs1k65dfQQ5dFnYakpQWVQHUMqiIvisZl6cwrIU0CKPMGKZS/ILQuQBi1Spq+/7u9qPDudliESdKShvKjaAKTgPqYHcmb5RyZgRFmXTImQfPlsBS4xGfbRi4/7SWGBUxo/vhS5XH1KHD2/m2fPC7czQLwJqZfZlRTFsta5DCVMGItPK37PdenyLm0zV3mUv2wnjQ2Sr0xoFJnc+aKIKGoN0NOAsoxEYaBsS3B3ijCKvjfRCp+qYoiNFjo7zvkgKLboXzo6OfxOcbb1pOV3v+tIdqryKEpl/6I98uQECl/tSKPSZEWIpFGZWz9VJ6shMnQb+gT+m2uVD+aOZQrU3esKwqdxbmFz7MPT2jOVimqgtrt2IZg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d7bd9f-3a87-416e-04e9-08d858bb72f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 14:35:38.3013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cbNqqI2cuoa03T1Pl6zOTUPRujG7Rqr4qDIPiSLu/fFBWqMjrEMJDwwNmguQWG+j5KHDsXE4BwzW3TaKztW+KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3476
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com> Sent: Monday, September=
 14, 2020 9:14 PM
> Fixes the following W=3D1 kernel build warning(s):
>=20
> drivers/net/ethernet/freescale/fec_ptp.c:523:6: warning:
>  variable 'ns' set but not used [-Wunused-but-set-variable]
>   523 |  u64 ns;
>       |      ^~
>=20
> After commit 6605b730c061 ("FEC: Add time stamping code and a PTP
> hardware clock"), variable 'ns' is never used in fec_time_keep(), so remo=
ving it
> to avoid build warning.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Acked-by: Fugang Duan <fugang.duan@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_ptp.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c
> b/drivers/net/ethernet/freescale/fec_ptp.c
> index a0c1f44..0405a39 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -520,13 +520,12 @@ static void fec_time_keep(struct work_struct *work)
> {
>  	struct delayed_work *dwork =3D to_delayed_work(work);
>  	struct fec_enet_private *fep =3D container_of(dwork, struct
> fec_enet_private, time_keep);
> -	u64 ns;
>  	unsigned long flags;
>=20
>  	mutex_lock(&fep->ptp_clk_mutex);
>  	if (fep->ptp_clk_on) {
>  		spin_lock_irqsave(&fep->tmreg_lock, flags);
> -		ns =3D timecounter_read(&fep->tc);
> +		timecounter_read(&fep->tc);
>  		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
>  	}
>  	mutex_unlock(&fep->ptp_clk_mutex);
> --
> 2.9.5

