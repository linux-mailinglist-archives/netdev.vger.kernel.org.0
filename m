Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F252138B93
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 07:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732311AbgAMGCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 01:02:12 -0500
Received: from mail-eopbgr770050.outbound.protection.outlook.com ([40.107.77.50]:12634
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726475AbgAMGCL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 01:02:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOQ+ietlEQwLfDu997h0pyyiFuXocLgVTVD7PzyhS0say4PWLOF1UZ3dUqPW2Cq/8+gkxgvCUfgTNmW4WIn0E/+7xmArNfvS2m4X+H2YFdHJu5ICn5jxR5PkZWJ5qDNlr0+01vxmlhyVe/kG4ZNntL4mdegUmVK13KdmtD7qkyq/ki4uJOPgctZIFARBkQtJ5zDMEBpqG3mZK/aQwmbDpRxkoshzseKOecihPwZ2fWZkX3fjnidQlQfPuZhwnzKIVCw9w6ogdbeqorHiIkQ0Iab2l06p9P+TvtWVN6n77vcEbdR7K9LoPU9cN9pBKrFi5GY4F5/apynqXUNEKzBm7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFdO11OKxeoVt4iOmV+DEvFLiaBH7k429f1RnfyonLE=;
 b=k4P8kyzgW3o5JhudB1hcrkzZdhJGuV5rxvt5mLs7Z4nBl8qLFp8HQ7FiuyaP7VTD4NEZkaCxUDczNNlVtbgv7lSRIJ8UbjhybhrEV02W571X3R7MCLiuwfceMHMCXUniplJgGOMxtIW9V4h5iqZIuhYV8KBFZOr1tJfzaWbAGyATHLPzzVIbetSKDSthDAsNHLWGMzYTuUhu4NEeqst3zNZO2yHhL+QB4UM1sxdL7UljJMIyPzE2GyJfqC/krYXr2513b4Kz7CK+zeGMJ6t0WZfoz9nm3bcsoD/8z+q6EvGBu8KZb8DDjaPIPdNKEt1NLew61ofRrj7JqNY3wqhfhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFdO11OKxeoVt4iOmV+DEvFLiaBH7k429f1RnfyonLE=;
 b=akSfqgawdKoh3uVNEqPhKcv3e8LbJTtB2UppNnx7KqJBoDUhIQqL/UFh7FwTy58zthAuAV0h94bsmn6Ze6OGHiq3hTQ0ooii+U28ZNZfJCYrIbfhCsPCMWZ7GhbeD0sWIX+mPPvnbRlGxYIgCbMR8ey4iQ/Z+LBdcObV0g4lJUU=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6151.namprd02.prod.outlook.com (52.132.230.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Mon, 13 Jan 2020 06:02:06 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899%7]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 06:02:06 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andre Przywara <andre.przywara@arm.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Michal Simek <michals@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 08/14] net: axienet: Drop MDIO interrupt registers from
 ethtools dump
Thread-Topic: [PATCH 08/14] net: axienet: Drop MDIO interrupt registers from
 ethtools dump
Thread-Index: AQHVx6y7Cl3Mr7YIzE6y4oKaxbl9yafoHX0A
Date:   Mon, 13 Jan 2020 06:02:06 +0000
Message-ID: <CH2PR02MB7000F73F928C719596BF3611C7350@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-9-andre.przywara@arm.com>
In-Reply-To: <20200110115415.75683-9-andre.przywara@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e0d130ff-50ad-4d42-726a-08d797ee1e93
x-ms-traffictypediagnostic: CH2PR02MB6151:|CH2PR02MB6151:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB6151CC6117C68EEAD868DF25C7350@CH2PR02MB6151.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:513;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(189003)(199004)(4326008)(54906003)(6506007)(7696005)(316002)(53546011)(110136005)(8936002)(64756008)(66476007)(66946007)(71200400001)(86362001)(76116006)(66556008)(66446008)(2906002)(81156014)(81166006)(186003)(52536014)(478600001)(8676002)(26005)(55016002)(9686003)(5660300002)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6151;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1ZrD/D383Ufh18YMHlLbLIasokfXGZL2UE7M6Y4mCO40MUfo1LV9c4lKj+9ESk0Xp2XCR8YF2znQHbp4FFPq590JNZealkyZ6vNDrO3AmLhWm5AshWnoWYcwgueKumRuFWgY/dBnApiXTUVjEKkoks51iXyaFvZahzf9mKQGBNtpAB5rxokkwJr6dvujhMeQIK8oefzJx1lmBZb87vKr0SxD8LzW/RN0sMY6acZ+1Cs/1bofMCRj1Iympf88/L9USoxka+Mj2BVLVGzDngTa8gTy15vmF2qP6jdoEFAKWD/HCLqH4PEWnZgR+baxDFR+m6Fff7T4XwDhTls0Y5smVX+PnX6WB+At0FpI8GLstWnI4mIowJiPs9tyV+S/EdaZsFKWIwacLKhu+MxJhlLqRb3RZ36P1pkWCMYn1iAG67NPrOC52+gts89yHbGXL+GG
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0d130ff-50ad-4d42-726a-08d797ee1e93
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 06:02:06.5472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wl2DZcKfWSYLjtZYQ2XCaOPVX5NZEOLnDIRXyofENuncxC57l30QEm4WZ5gmmYftMipq6zJN8tJFvI5YL/fF1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6151
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andre Przywara <andre.przywara@arm.com>
> Sent: Friday, January 10, 2020 5:24 PM
> To: David S . Miller <davem@davemloft.net>; Radhey Shyam Pandey
> <radheys@xilinx.com>
> Cc: Michal Simek <michals@xilinx.com>; Robert Hancock
> <hancock@sedsystems.ca>; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 08/14] net: axienet: Drop MDIO interrupt registers from
> ethtools dump
>=20
> Newer revisions of the IP don't have these registers. Since we don't
> really use them, just drop them from the ethtools dump.
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index e83c7b005f50..7a747345e98e 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1239,10 +1239,6 @@ static void axienet_ethtools_get_regs(struct
> net_device *ndev,
>  	data[20] =3D axienet_ior(lp, XAE_MDIO_MCR_OFFSET);
>  	data[21] =3D axienet_ior(lp, XAE_MDIO_MWD_OFFSET);
>  	data[22] =3D axienet_ior(lp, XAE_MDIO_MRD_OFFSET);
> -	data[23] =3D axienet_ior(lp, XAE_MDIO_MIS_OFFSET);
> -	data[24] =3D axienet_ior(lp, XAE_MDIO_MIP_OFFSET);
> -	data[25] =3D axienet_ior(lp, XAE_MDIO_MIE_OFFSET);
> -	data[26] =3D axienet_ior(lp, XAE_MDIO_MIC_OFFSET);

We can also remove these #defines from the header.
Alternatively, we can cherry-pick commit f5b9e58 " net: xilinx: axiethernet=
:
Fix axiethernet register description" from xilinx tree and include it in th=
is
series.
>  	data[27] =3D axienet_ior(lp, XAE_UAW0_OFFSET);
>  	data[28] =3D axienet_ior(lp, XAE_UAW1_OFFSET);
>  	data[29] =3D axienet_ior(lp, XAE_FMI_OFFSET);
> --
> 2.17.1

