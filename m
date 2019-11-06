Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F44F1BDC
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 17:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbfKFQ7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 11:59:41 -0500
Received: from mail-eopbgr800045.outbound.protection.outlook.com ([40.107.80.45]:31451
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727894AbfKFQ7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 11:59:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FoHaUcYaHkuCgW9Rp+TLtfcNjzWcZmkX6VanELnOA+djsXtoXYJkKkUiI6rHH0Tvn/xDj0LbryA6VZ3IHJzj3/E5RHBKF+4HkZxfIEWKQ6vwXSw4uhKQCOskN5XrUF97rIxysY2ZoIgZWSxCLqVTnS6cgagb2q6POF6pXg3eYvvNZH7n3S0cg7gn6Qpka5hlaYmJTLnqdHGvz3OwmiAKE2vQwKgAHEh1RwZ0rq1owxxNTwVo9X7Ex6r0499toIIl1kEMV7DuoRMIhlv8aGbd89N3+B9aFjCKgLNco1GCVNJ7iRiXjk+dB2lmPdDvINLnT3aL0rY1d9zXnoqnR0PoLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZRWD9+IbAgYjBeRRtwEJzOrkgiDy3JyIMlKiZYfxFg=;
 b=nMLz42kWyZlHQ/SyBTzuAQnFcCQzKUu2Nn7/cq9LIcX7p4NdBodfC1h6I+99p+FymvEbRAr9b4mlzv8uuTSRYd8LiWlwkbzFnWoRTlx2p1lb6zm5k54GvkjMWlleev9b+VAcnyagSMEQcZtZJq0WZTeEiJA/iBjhzyXh2+Wy5RSreT+6+mZnVoWvu52P1N8RBlC83Osqo7BRrHagu9fAfr8UXjnHpC1AsUG7MT7VG0SWlM2S+GgdudgHHYD4RsXkKploPyI56FG9vm4yl2fxwtkQKqs2cs/2joAJAA75+pvYWn4M6mWXfz8iZv3W81802y+KM5Mxn22q8Gm/zPjUXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZRWD9+IbAgYjBeRRtwEJzOrkgiDy3JyIMlKiZYfxFg=;
 b=JnzwpGJioGOrbstA76eDaa//51kVZdXgn6uOnxUV6pgDMMpFelXs579OVa8tcPIkJgqLvuBEl0sFCVeB3Iax32bwH93dVmXqKoq6+zM/4uJPJ0Uap3ApkjyW9GGMafhZr7ZASrm+sexvDFPf8qzmNITvg+iSp5+PHPARzl0ZTLM=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6728.namprd02.prod.outlook.com (10.141.156.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Wed, 6 Nov 2019 16:59:38 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::701f:f4b3:5a98:dbf2]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::701f:f4b3:5a98:dbf2%7]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 16:59:38 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Michal Simek <michals@xilinx.com>,
        Russell King <linux@armlinux.org.uk>,
        Robert Hancock <hancock@sedsystems.ca>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH net-next] net: axienet: Fix error return code in
 axienet_probe()
Thread-Topic: [PATCH net-next] net: axienet: Fix error return code in
 axienet_probe()
Thread-Index: AQHVlLqn5FzAWnixa0CNU2pyYHx21Kd+W8Pg
Date:   Wed, 6 Nov 2019 16:59:38 +0000
Message-ID: <CH2PR02MB700031904CC37C8D5EE3435EC7790@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20191106155449.107672-1-weiyongjun1@huawei.com>
In-Reply-To: <20191106155449.107672-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [183.83.136.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f4f8170c-b582-4666-c9bc-08d762dab57a
x-ms-traffictypediagnostic: CH2PR02MB6728:|CH2PR02MB6728:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB672817D4EC2119245ED34551C7790@CH2PR02MB6728.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(189003)(199004)(13464003)(186003)(99286004)(26005)(256004)(33656002)(5660300002)(66066001)(52536014)(7696005)(53546011)(76176011)(9686003)(229853002)(66446008)(66556008)(66946007)(66476007)(64756008)(102836004)(55016002)(6116002)(3846002)(2906002)(4326008)(76116006)(6246003)(14454004)(478600001)(54906003)(110136005)(316002)(6436002)(6506007)(305945005)(74316002)(8676002)(7736002)(476003)(486006)(8936002)(25786009)(446003)(81156014)(81166006)(71190400001)(86362001)(71200400001)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6728;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hEdnIpSMA50J+1+i9d3Q0ju7/rLTv0CQnXHeSeN/jxyYezcF7DZdpPSnITVRodnzs83ZBzm5w2i6xdee21yErJo1hRdgvA7UvDUUC4DShioPAc9FYa/Ab6hv5ZbtWWxAzpCekTwgjyYMMlSMDk1EA2Tb8AIT3J9E1mJWeSeLms2xCpXpW86sfGFm7MUriFm2XUP5TBubKQRp9Iu/dgRqZHoD9EvaGjhkhmIfxSxXUJCcsFgsS3FweyBp0XNgABNA/v8c5vPQn1mGsztN6PVBTYVbrNmhzGPsVyYLGVk0xFiH6dnDn+JDr5hejNlgob6ly8mQm9Id2/k44euCt/IUSX1rI0C7xn6s23F1HdeyUbhyyBposAwuT9afo/TBd+C8giSq2m1yfh1jPtGS8UBpwCceXwMcVIe2L970L7KYKmXew5Y3Smzzgal/FHPyf3e1
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f8170c-b582-4666-c9bc-08d762dab57a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 16:59:38.2015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mzrwWh2Ab9ebPbwLvQ04dgraz44Fi2SH65jZ1+kxFJ3YJQVNtV3qGB5qI/0+ck+vp0c7q5IjJeYg7lXyeQcX9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6728
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Wei Yongjun <weiyongjun1@huawei.com>
> Sent: Wednesday, November 6, 2019 9:25 PM
> To: Radhey Shyam Pandey <radheys@xilinx.com>; Michal Simek
> <michals@xilinx.com>; Russell King <linux@armlinux.org.uk>; Robert Hancoc=
k
> <hancock@sedsystems.ca>
> Cc: Wei Yongjun <weiyongjun1@huawei.com>; netdev@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org; kernel-janitors@vger.kernel.org
> Subject: [PATCH net-next] net: axienet: Fix error return code in axienet_=
probe()
>=20
> In the DMA memory resource get failed case, the error is not
> set and 0 will be returned. Fix it by reove redundant check
:s/reove/removing

> since devm_ioremap_resource() will handle it.
>=20
> Fixes: 28ef9ebdb64c ("net: axienet: make use of axistream-connected attri=
bute
> optional")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

The rest looks fine.
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 867726d696e2..8f32db6d2c45 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1788,10 +1788,6 @@ static int axienet_probe(struct platform_device
> *pdev)
>  		/* Check for these resources directly on the Ethernet node. */
>  		struct resource *res =3D platform_get_resource(pdev,
>=20
> IORESOURCE_MEM, 1);
> -		if (!res) {
> -			dev_err(&pdev->dev, "unable to get DMA memory
> resource\n");
> -			goto free_netdev;
> -		}
>  		lp->dma_regs =3D devm_ioremap_resource(&pdev->dev, res);
>  		lp->rx_irq =3D platform_get_irq(pdev, 1);
>  		lp->tx_irq =3D platform_get_irq(pdev, 0);
>=20
>=20

