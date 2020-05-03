Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629BE1C2D33
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 17:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgECPC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 11:02:27 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:36244 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgECPCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 11:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588518145; x=1620054145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FZMfox9UxrUTlOEaoMET7c6bkonWwE/YFGgj+9eWqik=;
  b=j+gnGg0emnBr7o0M+xlqeHKGuS+QcXw1F1PydiIaEeaLg2uDVmHAkXQR
   C8NyJP7nw1CUeLxRl6k1Ba23pRd8L6ibvKYJbepCE110DVk4XwcuQOA+e
   xuqPx0ZPK+xHzzMWbW/iJFOgfQ7kh3oIi4jaCPo37U5HBeN4g1sQ8Slz/
   fv1x//Kd8Y9U088bHplLziDPYfzjN75jg+uawED6A5G7G80f2NIxBdS6R
   AB2YOUrVXC/XDF5+KQCGtO7PaOKiEV76vu4IOYYO12ikEOvVeYSxRZA+q
   cIIvWYrqmm/dVJk3lS4JhSfwWhyW9i6mPh1x0BWRAfUFmCjt70mGjDmOB
   A==;
IronPort-SDR: gcAiNTKGQvTo6w2jhuZktK9xd7rXB5qROA9ZkUlThHVGFh9T6CKi0TplxJj7netc5OUGqZyB3S
 AvS3cDl6w73yVmACIpghblhYhp+CKD/1XJeayjRiOliAnpAIlqos3TYztKPz2rMWRegoFCpKd6
 ltKeMGB1RWvpSLxvkEVb4q+RBwTlFzYhkRVi6Vu3q1ArVQPU0p+Cq2yki/3JVFDbu7xGL+Tcq+
 z86abJmjOtjZvyg5B9EngROlVfrggdkPGSM4f3dclxzbx+jwmzOzrYLUQ+OSORlBu2SGS9j+M1
 qFI=
X-IronPort-AV: E=Sophos;i="5.73,347,1583218800"; 
   d="scan'208";a="72251558"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 May 2020 08:02:24 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 3 May 2020 08:02:24 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Sun, 3 May 2020 08:02:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNAfubywNfaeuS1ChhvMPhrwhlntwp/LEk/WXndOZhPW/fjYo8xfv+6j1BxVdAHyhpWxe2wgOII33+jloVeGxNpEcwEm2N5QluPRa/qarTqwaEnsUG1olh4IjFZlL6z1NV+c3StYVhT0r9rO4AQ+v0sRwIvSVaU0n00on5Bc4n87p1ZY/u7E1pyE9zdYz1kJsWCKomMnYTFhcRszvLUkBijDyzickCUBQJhNXAaD3nNJA8TwrVMC59EGnVX9o+buowEf/7ZuM1lb6cYu5+gxmuxY0ptrbRZWB9PGSPyRZTbmDtoIyoc+pGSZuNXYSj7k1CwYL3HVwbYgVKd7J92NHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=citaKJ/cBnAp/EO3TjW8zZ0fx/T8PvBrsl6leDFsIP4=;
 b=Xdio1G168EnIHOXNcRsWNn7wSmfHRk9ZOWB9+TbODx1uYnsxog1ax1PE1JWd086DRKpsIvcxStifFgaTKxBhOUfZe3Tv8WOdP4LvKgrXNEOMq1hKuiZIMqCsDLPCxz4kAdWt0BOboo8rgbmnESS4i2hiiIWshrp5toXUYqJVvGjwevDOsmktnFgrdTVxkkbEY6vao2gnC3xVwmHClG/bWxys19NCS0bDxobV2aediGQAWdnP1Qe+wkjchSAU2q6da5cXqKW8jdhcU0C8g3L6SDL1WoyUHpEzAWQkroRteg5DTJLzgpkgMy8helr611TJfvPgESyI+HpUDkFGdWlxlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=citaKJ/cBnAp/EO3TjW8zZ0fx/T8PvBrsl6leDFsIP4=;
 b=LOm9k5SridJ0b+oRsAg8hnvIv7UiPa1biYXyroG7CPxXC1nnG2kx1/mBdCFYnkf7uI+w4mM8RtcAaMrOEOJzCY65MuXd63p9x5SgvAxU1+uBSyJbOSbQnb0oBnQAF8KnFVx3DJ5Wpl2qBrSb5Wkld/Mkonp//kZzumvT1xpEfQA=
Received: from SN6PR11MB2830.namprd11.prod.outlook.com (2603:10b6:805:57::21)
 by SN6PR11MB2893.namprd11.prod.outlook.com (2603:10b6:805:dc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Sun, 3 May
 2020 15:02:21 +0000
Received: from SN6PR11MB2830.namprd11.prod.outlook.com
 ([fe80::7d58:c548:530f:985e]) by SN6PR11MB2830.namprd11.prod.outlook.com
 ([fe80::7d58:c548:530f:985e%4]) with mapi id 15.20.2958.029; Sun, 3 May 2020
 15:02:21 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <zhengdejin5@gmail.com>, <davem@davemloft.net>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <yash.shah@sifive.com>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>
Subject: Re: [PATCH net v3] net: macb: fix an issue about leak related system
 resources
Thread-Topic: [PATCH net v3] net: macb: fix an issue about leak related system
 resources
Thread-Index: AQHWIVvYggk+vhGn+kWhokMBzi8iag==
Date:   Sun, 3 May 2020 15:02:20 +0000
Message-ID: <d414cfd2-f0c8-313b-1a4e-fe90a287a318@microchip.com>
References: <20200503123226.7092-1-zhengdejin5@gmail.com>
In-Reply-To: <20200503123226.7092-1-zhengdejin5@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [2a01:cb1c:8c:b200:dc20:32ba:d708:57f9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c958684-b1d5-4da7-f6ac-08d7ef72fb0a
x-ms-traffictypediagnostic: SN6PR11MB2893:
x-microsoft-antispam-prvs: <SN6PR11MB2893366F2DC5C4926EDFF8B4E0A90@SN6PR11MB2893.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0392679D18
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UXVIpuFAr1s2NSR8eH6r+Wp4xDssxYRtWu8RaOwRISXVHtImFkXcZ1rbQ9iwKXKaNRRHgfmJJztAdKZujnMaDVVWo7qL8sdQQZj7zAkyBisRv+T/SD58nU3PQWZnw5wrP/vdR7HtfdSmizU7KA2GLI1ck4kobWiF4zzYLQSyCFiTmgZhkpn1oigQgKkm/Rn6io1AIpxtR4gdQURw+gUzXQGRpEyo/PqW6vJhVuBU5cM/BsEw3xmWnyL76oijSfZe6KL9i+/3IiPJZkl1KG5sa76061AZHYmOlZG2f8yrypB1qhufmLa/xqM/Hh1kLVWwNlYdR4ZktdI4Rm3rIuY7jp2R3vPCSNNM7MKZxVV8d2sZoyRuNLchlIqHYux69GybY4QLQQNKTcGl48n/Oi4RPVe6ONiZt22k+2Vyd8+7PTGteCd/NbDEes/0j/4fsX79
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(366004)(346002)(396003)(39850400004)(8936002)(66446008)(66556008)(64756008)(6486002)(8676002)(36756003)(31686004)(110136005)(54906003)(31696002)(86362001)(316002)(2616005)(6506007)(478600001)(6512007)(71200400001)(91956017)(66946007)(5660300002)(76116006)(4326008)(66476007)(53546011)(2906002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: XmMzKjJXUkdZKHihVBamUsq0+wJVy+ojfUDjWmZaj3fki1TQ6McMZX64oiVf53xEFS7jE1m0QT4niRGQeQg0oEZPg5ZCglnO/c/0mRxBI2D1BYZTE8XYCGoplfyX0SDE47RfWzy95ZIN/t0BwDdeV47We4hD36KiUOZHg0gj5gTlQFDIgaP7yDYz/67FGtnXYu4WR8oVSASg3NhGSk8wt+r34UdtvYpJS1+LJqKvLe0GiK+Td7gJH3ePB5JdghURllcXL8AD3mRR0k/SbQNMdruUkWmZOU2X16Av+IojKV2YRKEtmEpB2wmhRlsB4a6dJvENWR7A+1cHEdPCAlxihlbC4riApN3nGSSoX3RXH1lhKDy3E+oTk1QnIMRGoOTqiqH8vhzeXZYmXv7sJp3n+e66kStvaZckcMcyh7hTrJaCmawDX0Twjud3LE1dl4PTaA9gApcl73y80mk9V/hqPL+0PXqsmBaTcGJuRftwnMAzcba0ZaeWF9ymncRcmCPHsPhDTJnnyTb6XBW3w9HAdFoptUxcUf1i3ZcfxTccxTvEPxAyQGue9Tr5C2G5hs9PxL/zdZsVyjY6XZ3G6poh9eqSmt+9t2OSSXsvXl/vcWdEgZBchZAtPBlhuHzovdnw6PrVT10kR59J63+fzjEdqX0xA6Rx782OHd1tv7uQh50GRzzLyju/23iQkeK9UTR3GQ4Qoi0jDsw2R147gkQBUyeInEz6/Gs+WaD3iLgjqyInQwXRf87iIbNwgSD544YTDtaKAsJzdkzxT/oYdhdoFejNAv6AjHzdc1dJ+gEJjyXQqfZoVeJFq/qIzdJUJak9cHTztpV0XhI8rJAp9+W/Kqqj6Q/NmHVIInLD0+B0elQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <088385B4C62AA44FBAE0D3F8507A5977@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c958684-b1d5-4da7-f6ac-08d7ef72fb0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2020 15:02:21.0046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nbXYyGsBtMhRMlERHe2ZRgYRW2vtrCF3aODdgHk3CVsCmx0p2OaUvoKCUw+q88KplxlPTgDErnsQV2hmkAQPAAunQiVoKSZWl6Zxst9U0ek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2893
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/05/2020 at 14:32, Dejin Zheng wrote:
> A call of the function macb_init() can fail in the function
> fu540_c000_init. The related system resources were not released
> then. use devm_platform_ioremap_resource() to replace ioremap()
> to fix it.
>=20
> Fixes: c218ad559020ff9 ("macb: Add support for SiFive FU540-C000")
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Reviewed-by: Yash Shah <yash.shah@sifive.com>
> Suggested-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

> Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> ---
> v2 -> v3:
>          - use IS_ERR() and PTR_ERR() for error handling by Nicolas's
>            suggestion. Thanks Nicolas!
> v1 -> v2:
>          - Nicolas and Andy suggest use devm_platform_ioremap_resource()
>            to repalce devm_ioremap() to fix this issue. Thanks Nicolas
>            and Andy.
>          - Yash help me to review this patch, Thanks Yash!
>=20
>   drivers/net/ethernet/cadence/macb_main.c | 12 +++---------
>   1 file changed, 3 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ether=
net/cadence/macb_main.c
> index a0e8c5bbabc0..f040a36d6e54 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4172,15 +4172,9 @@ static int fu540_c000_clk_init(struct platform_dev=
ice *pdev, struct clk **pclk,
>=20
>   static int fu540_c000_init(struct platform_device *pdev)
>   {
> -       struct resource *res;
> -
> -       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -       if (!res)
> -               return -ENODEV;
> -
> -       mgmt->reg =3D ioremap(res->start, resource_size(res));
> -       if (!mgmt->reg)
> -               return -ENOMEM;
> +       mgmt->reg =3D devm_platform_ioremap_resource(pdev, 1);
> +       if (IS_ERR(mgmt->reg))
> +               return PTR_ERR(mgmt->reg);
>=20
>          return macb_init(pdev);
>   }
> --
> 2.25.0
>=20


--=20
Nicolas Ferre
