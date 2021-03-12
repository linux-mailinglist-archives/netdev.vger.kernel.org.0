Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2BC3396C3
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 19:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbhCLSju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 13:39:50 -0500
Received: from mail-dm6nam08on2069.outbound.protection.outlook.com ([40.107.102.69]:42848
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233663AbhCLSjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 13:39:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MT/NVOX6rGtIFNW37jnfwpZHnocABiLHG3q/302PmC/RQggCSw9lDV1QMS+If9jBAgR7zUaMYbAqsZwG6L/fN06I/IezKsZaC8fz/O9GfhU0/5g3tg/6PBUvKBNXb6PF4W5VNXP1sJspqURbzH23ilPFX6z5D4s/J4gqSd0av0/aJQpJ9FUre01A/bCO26argF6wu4PtGL5Nz5KV9dsFEJrjIHZpxXOUiMbbnxQZColURDRqKxxOEfbEe1fraenNsWD5Sq4q7oeH54hBvthH4ccYvYru/+8pgxTSHtfqKdtkRS5EpJZ3MnGtLiqXo0xIoSsHUuKuZym2I5/bocrPBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLF4fSemtdYtRDyXJ1Kf4ZiuN8tBRD4sFe+7O709qYE=;
 b=XDTdSM4ykURdYrAiKC1TungOY07qGnfaMA1JXwlKR2g9IIPBP7/eIwajBWLu1kpJs+RQ3YmnOFDheuYj+gzrrtwJZct7xcEwb+3BkYZegMjU6tdHcppuuHJ/eEONNHKsr3QGv2LQ+xgWjb4q+850OS7tR/0fjVzGBz8BjdW/Iv8PfcrdfaHX0xd2IC62yZmebVoNUJe9xEcW84E6OD9U6WjUS7ZDg7JIJFqybsQJi/trcAaotBcqNZx5tnnDQQQxXyfWZpucnvXtJ9po6WYtv6mBfUdat22dZjpljV5QfuXn4heAcAnij2C7Bp0/LecjyzX6NV4Bs00cg7GHVi30pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLF4fSemtdYtRDyXJ1Kf4ZiuN8tBRD4sFe+7O709qYE=;
 b=qRyy9IK0SDa14miC8QaWDJlIvxgUFyTiOimNnbViH0CN9hspLNBsT3hG7bASYod9Fk1nkFNcr+W9D1GAdeEa9M6WvHHBJQ1eFrvRlOAvqI12jrMwAva1VqeRhpbOnn7XiTBerOmBWD68+Fzgc1UK2Y56Zg52XMsDWDcoZvJuLk8=
Received: from BY5PR02MB6520.namprd02.prod.outlook.com (2603:10b6:a03:1d3::8)
 by BY5PR02MB6866.namprd02.prod.outlook.com (2603:10b6:a03:237::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 18:39:34 +0000
Received: from BY5PR02MB6520.namprd02.prod.outlook.com
 ([fe80::3100:8a63:1f0d:8246]) by BY5PR02MB6520.namprd02.prod.outlook.com
 ([fe80::3100:8a63:1f0d:8246%9]) with mapi id 15.20.3912.030; Fri, 12 Mar 2021
 18:39:34 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Robert Hancock <robert.hancock@calian.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH net-next v2 1/2] dt-bindings: net: xilinx_axienet:
 Document additional clocks
Thread-Topic: [PATCH net-next v2 1/2] dt-bindings: net: xilinx_axienet:
 Document additional clocks
Thread-Index: AQHXF2dHizUJNgzh3ky57zPSYH/TUaqArgIA
Date:   Fri, 12 Mar 2021 18:39:34 +0000
Message-ID: <BY5PR02MB65203D654C8B9E991B8EFDC9C76F9@BY5PR02MB6520.namprd02.prod.outlook.com>
References: <20210312174326.3885532-1-robert.hancock@calian.com>
 <20210312174326.3885532-2-robert.hancock@calian.com>
In-Reply-To: <20210312174326.3885532-2-robert.hancock@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: calian.com; dkim=none (message not signed)
 header.d=none;calian.com; dmarc=none action=none header.from=xilinx.com;
x-originating-ip: [47.9.68.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 721c438e-0950-4dd9-9a47-08d8e5862ed9
x-ms-traffictypediagnostic: BY5PR02MB6866:
x-microsoft-antispam-prvs: <BY5PR02MB6866C656A9F2F7BFF49EA42FC76F9@BY5PR02MB6866.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X5cFo+n2I/KYhQ9SepVKebjiqbFCFNyyXi4Z26hMnRp/gyb6Xgs6OIEt62O87j42TnsBD4EdY+V4Q9t8OSQqMd4yfEYcKXFk4h5wRwMOs9zYLCzpEIhI5q7l5rGruy6OPdlLdH4/AYiv12MvGXMOS2cEs2r2lfU3CRQ1rFwrhGsyhxz+IR4tAw6/D4oQYsu4Ow0JecKUaLhXLd2M4MP5xp9iRyBJaEIQm1zxkDFgGY1BIuZK1cEb2Qd0GHjfD+QMtEFwaBcTBzgRyQ0I+0qyvxdEXNeieAKUrl8GM+FzGVjiC0KFuTkm12u2/cGGaKalzL55cHhPWsJEhKJWpS8+Xh6RQP8Dz3q2eUgJIu1AmgwklJ9ybiMtWwFshctF4YuryzB93vCQ26VLhEr9HXPGW11XcY8HEl4HFUiThqqJXU4pYITQ4OkIs7gjPehjP67XzcNGo+TJFYANRmmrv2JbA7JfU1UJjYbtViYxSTayh0/CXEp4zH8QewYqDWOE9/eT273D8WQtUtPaqaBnTd8zOPfLAcR5eooG9ohUSTJFYxA3fN8dilteNt7BjzRLPbs0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR02MB6520.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(55016002)(9686003)(86362001)(4326008)(33656002)(83380400001)(66946007)(478600001)(76116006)(2906002)(7696005)(64756008)(8936002)(54906003)(52536014)(66556008)(6506007)(8676002)(53546011)(186003)(71200400001)(110136005)(66476007)(26005)(5660300002)(66446008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?i4FuziNPaHLfXeWiV+W4X7unw0PVPizZ1Hr8VwRTxI7oC/YLzOeqNdfPgobx?=
 =?us-ascii?Q?JoNthBpGrbOWhY09WYYdn1b/gnZpm6NrsvlIPcm8sQhkykyEEIX2sjNa7JOP?=
 =?us-ascii?Q?dhKAblfnE1e73Qz3fRe3p10ep3CkN9LvlSk/CgQnPjy7ns9HWGLZkmKxoCVp?=
 =?us-ascii?Q?IGjReQRpYPcMb2tv2QAMlOBGvkA3Dg5omaMtGCKmdHISYHa8wvpdn/XBVDzJ?=
 =?us-ascii?Q?lVoruNYA9ivgrjvn/Ff5OMCKX6vcJppnjRuWxx+SMviCxEY8BFNOu1/GeR4p?=
 =?us-ascii?Q?eAsXni48OlVMloUEK4Uc00m0B4PWw3P8xwuRXFwIVa0wnKibwI0b9PovlPO9?=
 =?us-ascii?Q?RaV24VagJSWkcPSpYNdeBdKcD/NsKZivXRQxAMrGfJqWX52sg4QJPWNc8G5T?=
 =?us-ascii?Q?WIjECcjfXzmFMJyh3oBTMXXQxugbEgXX/lqZCzQxSwg4qeNZw+9k6QUOU4AG?=
 =?us-ascii?Q?aZXzlOR2FrLwZBYgV+cyAzxEwegkL7K2CaEdefGZJQZGun146IhKZ7gFIJ/3?=
 =?us-ascii?Q?auMQYr9/jk/WXEpmKkyxHJ4lPC638DOJ+0hxTB+XpYFuyVzq2DYXbK37IE+V?=
 =?us-ascii?Q?a/cQu15ZihnIwMWMY9hoELNuf4KFXWmitjn3zvO80iiIq4nTZD2sdpAN23I/?=
 =?us-ascii?Q?mNDEjtCGcPncqE3oOxPqAehqeiIeQlFaiY3PXOa7dKlE/zxj5/0WoVhzDgH4?=
 =?us-ascii?Q?hK0fIfaEz+DTGux5jHuvCXmwhE/eqQ2XDMZmlUYB5GmmflN2dmLcBwpXnSkK?=
 =?us-ascii?Q?T7cX3E9SzXSyGcyz/r9vLxRdvmGp/Wg0J/MucEIpWKlUOhkGchLlkzWvHk8S?=
 =?us-ascii?Q?v85yX87wDlDdbTpFFv0CY7nY7J+/JHwkFssC0r5Y655akT/1Y6Tlqz17GzhG?=
 =?us-ascii?Q?VJ1ZckmGHdY2wRPhJVUpsWZyfjAk8Ek72Er8p0PHiWAJwV3FEv9R1KMX6AaX?=
 =?us-ascii?Q?yg9vsUURAACVaAMXCmvMCGEHdGm3tRiYuPe7j/s4ryuJ/tWQJm2zBtaajJUQ?=
 =?us-ascii?Q?t2GdeSjW/pQ6FjymcANDBxqqWBynbFhpaYrCqjnwBM4GVSw6WBBcR6ZMs6TX?=
 =?us-ascii?Q?6w48k7TK+2On+1NK3LcFrDFm308f1rbrOwALGlnLKjGjF/ovTUcS074drvW3?=
 =?us-ascii?Q?OVf6Ef08o8k2pIkZVuz+tVOMQWe7aOFplHoZw14llzPvQM/vfMr3w3AbymRw?=
 =?us-ascii?Q?7sEWDNMPK0CNt2J9wG6NY/SJpoJqiKHXnjO4vAYaZMD67eSvDekuFhbUu4qB?=
 =?us-ascii?Q?p/aB+IzITZn39rb6rZyWOtwNthuVJ1yYZW3bjzHDLCIP2645VZR2Umsauh8d?=
 =?us-ascii?Q?VMA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR02MB6520.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 721c438e-0950-4dd9-9a47-08d8e5862ed9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 18:39:34.5942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /khXp8s/hZ1yGsmjcr7+1brWsbpXZwyG+BAeZa2y41OnQCrjK+eHlPqvKyvz+fddbnKL5CrFxUToPjcl4fF+ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6866
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Robert Hancock <robert.hancock@calian.com>
> Sent: Friday, March 12, 2021 11:13 PM
> To: Radhey Shyam Pandey <radheys@xilinx.com>; davem@davemloft.net;
> kuba@kernel.org
> Cc: netdev@vger.kernel.org; devicetree@vger.kernel.org; Robert Hancock
> <robert.hancock@calian.com>
> Subject: [PATCH net-next v2 1/2] dt-bindings: net: xilinx_axienet: Docume=
nt
> additional clocks
>=20
> Update DT bindings to describe all of the clocks that the axienet driver =
will
> now be able to make use of.
>=20
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  .../bindings/net/xilinx_axienet.txt           | 25 ++++++++++++++-----
>  1 file changed, 19 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> index 2cd452419ed0..5df5ba449b8f 100644
> --- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> +++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> @@ -42,11 +42,23 @@ Optional properties:
>  		  support both 1000BaseX and SGMII modes. If set, the phy-
> mode
>  		  should be set to match the mode selected on core reset
> (i.e.
>  		  by the basex_or_sgmii core input line).
> -- clocks	: AXI bus clock for the device. Refer to common clock
> bindings.
> -		  Used to calculate MDIO clock divisor. If not specified, it is
> -		  auto-detected from the CPU clock (but only on platforms
> where
> -		  this is possible). New device trees should specify this - the
> -		  auto detection is only for backward compatibility.
> +- clock-names: 	  Tuple listing input clock names. Possible clocks:
> +		  s_axi_lite_clk: Clock for AXI register slave interface
> +		  axis_clk: AXI stream clock for DMA block

Description for axis_clk should be-
axis_clk: AXI4-Stream clock for TXD RXD TXC and RXS interfaces.
In this patch I assume we are only adding additional clocks for=20
1G ethernet subsystem. For dma clocking support we need to add=20
more clocks and better to add them in a separate patch. Please refer to
xilinx tree.
> +		  ref_clk: Ethernet reference clock, used by signal delay
> +			   primitives and transceivers
> +		  mgt_clk: MGT reference clock (used by optional internal
> +			   PCS/PMA PHY)
> +
> +		  Note that if s_axi_lite_clk is not specified by name, the
> +		  first clock of any name is used for this. If that is also not
> +		  specified, the clock rate is auto-detected from the CPU
> clock
> +		  (but only on platforms where this is possible). New device
> +		  trees should specify all applicable clocks by name - the
> +		  fallbacks to an unnamed clock or to CPU clock are only for
> +		  backward compatibility.
> +- clocks: 	  Phandles to input clocks matching clock-names. Refer to
> common
> +		  clock bindings.
>  - axistream-connected: Reference to another node which contains the
> resources
>  		       for the AXI DMA controller used by this device.
>  		       If this is specified, the DMA-related resources from that
> @@ -62,7 +74,8 @@ Example:
>  		device_type =3D "network";
>  		interrupt-parent =3D <&microblaze_0_axi_intc>;
>  		interrupts =3D <2 0 1>;
> -		clocks =3D <&axi_clk>;
> +		clock-names =3D "s_axi_lite_clk", "axis_clk", "ref_clk",
> "mgt_clk";
> +		clocks =3D <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>,
> <&mgt_clk>;
>  		phy-mode =3D "mii";
>  		reg =3D <0x40c00000 0x40000 0x50c00000 0x40000>;
>  		xlnx,rxcsum =3D <0x2>;
> --
> 2.27.0

