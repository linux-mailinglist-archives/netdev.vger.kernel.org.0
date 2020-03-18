Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0AE51895D2
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 07:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgCRG3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 02:29:00 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:43686
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726802AbgCRG27 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 02:28:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/9dllisX9yHsVy8iKsvUH24eWkbj1qqaB9GzphMtlQxeDfWvyggkrVL8KPxVkao+zKF/bTD7DcJSmcQ0GiOh81ThMtW8n9q8zHRn23XW6MQ1WsVOLy+NNmM/CRw40w9JT5CqKvnwi+pS9seGgbMYoLSMy99U6CSfQ//HzChOpFVPTkTKnOdCnmBPVwDozUxcHbygjLUb5VJXOTWv1kzJhRSiGZoXJb/E3EzdJ1ZMDoQYlsYLNQjeqqcHDbnzKzDjPkm5XHqoJZhg6tLHmjaPSikatHh3SKAqp3lnaAaPIdegCXQUUoKa/huIlLGYwlamPodb5bJ9G6KHwRdTQNj7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgJh1mP9b9A613RbKKjhJqPxV59CKn3x6tHTSUW9D8c=;
 b=nUhXZZGGc8m1sczBZ/fG9TuIOXN2DT81uAmZ/Ulss7sSwcpL4NigZdjKqp2RI9BLSr+oC3VvVCeHYc/yMFfg95nRFyvETXJtWNjRozakBBIzKYMIiQvOh7vNBrhBQHVycGq2sKKSqxGLbY99+pZk5eB0a4m4YNv6FIrlnYP9vD1TvS8C2CLqlrQuSVPr4HNt4TA1kfPaaoyf++3PQ5mn2qNiZcDK822J3ycIWFIbv7icSeWajw2A5uncB4TKg/mewI3kZ7ZlH0uUdsTwVXFl/GqdhrsTEIqRqcE7UKSS+qWjaO9Qd2NjpFhbzonjUtUBtZyMj3a7lt9KPhkiY4Dp6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgJh1mP9b9A613RbKKjhJqPxV59CKn3x6tHTSUW9D8c=;
 b=HUOlH0QwRC57+MhoYOdEtXumjNwb8CStNS7KCvAL9sA+QKEMxy+fBD9Na9oxPqQRR4eyVps3FKj2YGOFDnBNnIMj/+e39GkT2BH9vY8qS1l8HyXQ+h+Th79wpyBh6irpeayLBtv54tXoH6H1gyoKzTnAl1T4OyVM6ULUuTl/vUs=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB2925.eurprd04.prod.outlook.com (10.175.24.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Wed, 18 Mar 2020 06:28:55 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 06:28:55 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [EXT] [PATCH 0/4] Fix Wake on lan with FEC on i.MX6
Thread-Topic: [EXT] [PATCH 0/4] Fix Wake on lan with FEC on i.MX6
Thread-Index: AQHV/HwfH3wTHDqsi0KQfAvD/Tjc/6hN41Qg
Date:   Wed, 18 Mar 2020 06:28:55 +0000
Message-ID: <VI1PR0402MB3600DC7BB937553785165C2AFFF70@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1584463806-15788-1-git-send-email-martin.fuzzey@flowbird.group>
In-Reply-To: <1584463806-15788-1-git-send-email-martin.fuzzey@flowbird.group>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 81dafd63-3bd1-440b-5747-08d7cb05a243
x-ms-traffictypediagnostic: VI1PR0402MB2925:|VI1PR0402MB2925:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB29255678F628006AF0888A93FFF70@VI1PR0402MB2925.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(199004)(9686003)(52536014)(2906002)(55016002)(71200400001)(33656002)(5660300002)(4744005)(186003)(316002)(8676002)(81156014)(54906003)(81166006)(8936002)(4326008)(110136005)(7696005)(86362001)(76116006)(6506007)(66946007)(66476007)(66556008)(64756008)(66446008)(478600001)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2925;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pmv7Sp8Wnfk6YAx4RwHMxvCS66I8/5QWmQ/WdmCI8HQbgAn5DBlfroGxSlqdZPdvYHCIkhDRg3jsDTia2gzH6FMaF+u6UDjxqH2vvR2YykzPPZr/YQB40GBn55xAEqB6jX5ecMBVBqdQbhJSrMGUXeSPmo0xxYes0lmKkS2mVD05aGWNfe5wmLdD2nq6flReVsHaI2HCaWSbWivZdReFI5FAF5ufU+AbaDfPobMtK+hXNyJtWwelqx/z8282eUKQkAff3Ux1+O9aMrUV7bsplsU4jwBnv0yCDB8UvqoxNiY7k3089ldDLCZxMIRfncH5kohw8QGZ2IVs41tb68TPvTTB50KoIJbfgjQfamamb3lpUlZuWgFbquLQ5ZDO/ASfdhPc3ARblgaA9028Kc1r5s907Bk4HEXY8tUKHqxDQz21/V5dRm3B19cOXwC6IZ4r
x-ms-exchange-antispam-messagedata: wE1dv9o6UfmoXSpR9TBwrFOlqf1CELHpbeJ7pg+c5UiP3rO5OtCCvf8dwu2/XxuuaR2godToAXk40CnfHfWy26lWrKH2uhRVSc9Sc81SVk0r+SOYxIU+2jFKGFRsOjZ4Yf0PeZldqzeW9ZS9xa2SVw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81dafd63-3bd1-440b-5747-08d7cb05a243
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 06:28:55.3102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qJN/U8NedvBlLVqmxw+czc57GB2GePjhnh/DyczbFy7ldc8AvVyYVn76vqwjKoRrZfuil/g028EM808r9b+lUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2925
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group> Sent: Wednesday, March 1=
8, 2020 12:50 AM
> This series fixes WoL support with the FEC on i.MX6 The support was alrea=
dy
> in mainline but seems to have bitrotted somewhat.
>=20
> Only tested with i.MX6DL

The most of code is reused from nxp internal tree,
If you refer the patches from nxp kernel tree, please
keep the signed-off with original author.

>=20
>=20
> Martin Fuzzey (4):
>   net: fec: set GPR bit on suspend by DT connfiguration.
>   ARM: dts: imx6: Use gpc for FEC interrupt controller to fix wake on
>     LAN.
>   dt-bindings: fec: document the new fsl,stop-mode property
>   ARM: dts: imx6: add fsl,stop-mode property.
>=20
>  Documentation/devicetree/bindings/net/fsl-fec.txt |  5 ++
>  arch/arm/boot/dts/imx6qdl.dtsi                    |  6 +-
>  drivers/net/ethernet/freescale/fec.h              |  7 +++
>  drivers/net/ethernet/freescale/fec_main.c         | 72
> ++++++++++++++++++++---
>  4 files changed, 80 insertions(+), 10 deletions(-)
>=20
> --
> 1.9.1

