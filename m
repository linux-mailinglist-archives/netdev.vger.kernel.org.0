Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473F73386F9
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 08:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhCLH5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 02:57:34 -0500
Received: from mail-dm6nam11on2057.outbound.protection.outlook.com ([40.107.223.57]:17408
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232160AbhCLH5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 02:57:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndQRocYdYdN0CsuqvG6K8TbLmI6GWE4FDqZ+TakbcFex21xyzrDTTvn7gJfhPIgaVPZqNr+SCXuVeS892vxz9OUKbIZTA7F0whsjWqDufzlXK85FB9r3GUBXZg7bOVj/DB7069e/1BRNymrrMwW7f6H69z6SWUG833SLWSvpvrOIu4Uzxbi0x2S5t0SkwNJ+JR7hC+V1Lq46Ev1kMku3B3RpnFw+VFV+56GOQiNfedqj5Yl+fHE3V+ZcbXrO0fI5c7Ru3k1ul+/qM/XxL7+DHOX6msKJJw5nySf6L2CnugIJP6jo/hHW4lNQsyzLpcHcqCuZQRBrptZQPLC3bdmJQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xfT/YJHjV2H7bH8T3WjSEsY3CxzdJ+3REEe4mq8JRqE=;
 b=Zs94OrpwUPGm2UdeiE2/mlrzMeLDZ093ch6H/CaRaE9F5Eh3V3Rij7lz12ejW13o5HkPa5005PSumg/k1+xCZ4JE5Pt4BLU2YMPpZ0pz0XDrSWm8xKk1BQwdFBNKecyiyCfBpPZa7PcOJIlTH32tyj4iUtvLLjq0+Fmhm6ZZGD5RLqs4ZvxupDRcCGXk0AdIAbTV9S2wyx986TaBDByKq+WQmpy3PyfBfJsNES6epua+S2AmwT4VsxP2ga6p3cDNUWvhU/xEAOikou5Q7QoRclLwtoisiDbJJsuhWWW6xYIStefN6lojQ3m/N+ewtAUCGQG1Ui3hrQ5Qxd0bdtK1Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xfT/YJHjV2H7bH8T3WjSEsY3CxzdJ+3REEe4mq8JRqE=;
 b=BxvOLKE0HIWJxXuLA3qTbi+nIX7p628Lxk57cFbSA9w7tvk4nIRW/rTOVQa46z9Ctsom7Db5lsZ5FuaNpdHjv08vx/VuFc9xFSf9lE7CUOKRUcPCr02zvNIk2GngQypPqTwVQAOtYEOPQhO7lox8NMSgQQmCFfEPL00+Exq4h28=
Received: from BY5PR02MB6520.namprd02.prod.outlook.com (2603:10b6:a03:1d3::8)
 by BYAPR02MB5861.namprd02.prod.outlook.com (2603:10b6:a03:11f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Fri, 12 Mar
 2021 07:57:06 +0000
Received: from BY5PR02MB6520.namprd02.prod.outlook.com
 ([fe80::3100:8a63:1f0d:8246]) by BY5PR02MB6520.namprd02.prod.outlook.com
 ([fe80::3100:8a63:1f0d:8246%9]) with mapi id 15.20.3912.030; Fri, 12 Mar 2021
 07:57:06 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Robert Hancock <robert.hancock@calian.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Anirudha Sarangi <anirudh@xilinx.com>
Subject: RE: [PATCH net-next 1/2] dt-bindings: net: xilinx_axienet: Document
 additional clocks
Thread-Topic: [PATCH net-next 1/2] dt-bindings: net: xilinx_axienet: Document
 additional clocks
Thread-Index: AQHXFrLJ/faITA6TOUWLto76gb7+aap/+uxA
Date:   Fri, 12 Mar 2021 07:57:06 +0000
Message-ID: <BY5PR02MB652047F0D6118835C079FECAC76F9@BY5PR02MB6520.namprd02.prod.outlook.com>
References: <20210311201117.3802311-1-robert.hancock@calian.com>
 <20210311201117.3802311-2-robert.hancock@calian.com>
In-Reply-To: <20210311201117.3802311-2-robert.hancock@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: calian.com; dkim=none (message not signed)
 header.d=none;calian.com; dmarc=none action=none header.from=xilinx.com;
x-originating-ip: [149.199.50.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4e36476a-9023-41d7-a67a-08d8e52c6e32
x-ms-traffictypediagnostic: BYAPR02MB5861:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR02MB58616DE4BE3CCA8B02CD87A9C76F9@BYAPR02MB5861.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: svI+axx+lp6HfHi1lNGHvwttRJdS6BWdHaKMYUVKTzHE7IRdvqHnCbdfzcnftoflzl5rkXzNWVVJN30QIukyrtnZF5TBDKjz4UoPHXJjAFSNxSI2+ahsZ5eJZBlupY+4eFOPtegftGwnJC7HNLhGaq8Eh5XzEFvIoqsEUaQCZtC/tFwtfCS5bfd4an4YWOs8tkYB88hiyRHDpUHu2JBdrihMyVGNZ+ati+heA6NG4/kpa4eio0g998dhvPSZ7+X9sH4tEoXufixPUlCDnK0j8XxO4Fr1m6vWOqASnlmdiIceQYeWRiYKTK80l8gF2fiY48WvrpkLK8GUjl8FscxAslydAmpNmqpiRStZXet/FJeNjbCnVyYbCbDtQE92CIdfW0MF9/D6z4yPkC3lk4n5XKNWLXZx8mRgjgDwxIJGhyTOZkPlRxafp72fJhKvjw0BcoAZuWCbe/1OYNe9CSC9AWPiu/g+8YIkkl59hICRxn1NzJSavNZb+CqYJcyQyBuVRIRlMr337Yn5vTwso+049w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR02MB6520.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(8936002)(107886003)(66476007)(66446008)(64756008)(66556008)(4326008)(33656002)(55016002)(7696005)(5660300002)(9686003)(52536014)(8676002)(53546011)(6506007)(83380400001)(2906002)(110136005)(316002)(54906003)(86362001)(478600001)(186003)(76116006)(66946007)(26005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hANGnrn19WTUe2FUppBa9eWYy3kpuvDY/khrE3fJPELCzu8vh5Wj6q06sxCg?=
 =?us-ascii?Q?c+rvdXiEwhE1sqJ3NUgPEiD7o1g4jce0sFAf+M4NTCzdgjcrFPzx1pYQfh79?=
 =?us-ascii?Q?ThNck1ZKBS/fV+Dvz/ujKJqznGnKzsOn5XiU1IY3OZWIXkj5B0GGpmzq0sWI?=
 =?us-ascii?Q?ZGav8fgpqav+068ypyJOkVqMgXiy6wH0Wk9EWhGFQbpPReSVEDOYFBAuwu9u?=
 =?us-ascii?Q?SgGZC262cXKtzqFnA4/Y7vT9RtsAV+FQ7EPkV87WLMp43P+3esl2qT0/ORrr?=
 =?us-ascii?Q?nTj4AvYJbd9t3oiH8PcWG7HQPJF0OZvPUrY19YD9kKGCEAyYipPFiXHz/oJt?=
 =?us-ascii?Q?SyStMpCY3onr+fTQCUbEVw8/MWt7CdZ1JyaouxXObtjG/NaYsDJmJYqjrrg7?=
 =?us-ascii?Q?LwMFZ5fuZKmJDJUcoxB5q9CGe76DoEZ6XTodaFXvbK2sNTOOM97wbAfHTeRY?=
 =?us-ascii?Q?ef7XQmbEAkT4U83L4cqK1VqXm6EkinqRo5xRhGjy7gsdvKPcfKd0yRtLmYqJ?=
 =?us-ascii?Q?ezTU467JxmwO+W1XvrJ+KIVWicV5WWteCwh3MBDe/eRYqT31wZQpsIIEPZYP?=
 =?us-ascii?Q?Akl5eGENaze/TyUktcxt9aBKq5tY2wUe14xvC2XuXNv7VFBggtDCDBpyRq5r?=
 =?us-ascii?Q?sN7GxRtB+BCSl48M5NxKV4ZXonlCIEcvv04hQJEPY6lrGKrfgx3EWBVqlgOG?=
 =?us-ascii?Q?IJyan0IBVk/jEYsltoUo+gR0rA6zQWzUuyi2/iGaK2SGMlPyrmmXCuPHhJ56?=
 =?us-ascii?Q?DlWPUwigsNXCIdd6OWjiuPJnzDSMkFBvKvrPVL4EZgv50ZY/kKSg6LRzIaT2?=
 =?us-ascii?Q?1buKRedQZPVbbXvO0IeU1W86oBk10lQhNK1TkDrHd/riAH0qiOFkCBIPvjED?=
 =?us-ascii?Q?iNVFT2iI/vkqUWIqGqwjhyVrTe0nTQuky/6tSvrodjk5zGpYvPLFNGaGIY6n?=
 =?us-ascii?Q?xi4ngGVD/lXR9+ZZZIzyBABPttm71RoStfNPicBnV6+aIIPKTghB3H6p/W/b?=
 =?us-ascii?Q?EWMrpUWFGtoFE8jq4MlXA0OQ8imqcKMmnn4Ozgld7OVz7+bhlBLLS2G4Q4V8?=
 =?us-ascii?Q?/b/LqWGiH6H0wJYvUC4LYK/jkc8z9JqQqxlhm35QEQHjpxvNfGtY3TgodUe1?=
 =?us-ascii?Q?ByDVX7srgcM0t1HNU+MtFdQ36dEjVouNPNUvJzAi7GFdXaHO8hVd1Iagne4a?=
 =?us-ascii?Q?z20QhhiuN0G8gZhIGL7WW+94PjVN+RvWG0Mihv1tbLq8UcTu5lSnh0lFdP6q?=
 =?us-ascii?Q?pKUKO6ts6j9l7zxsmm0pBpvZ8zjeHKnW7bwC5xurIWMqYVlAnnt6MG1DhZVA?=
 =?us-ascii?Q?RCX2WYyh+kg4s9KIucfelHKM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR02MB6520.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e36476a-9023-41d7-a67a-08d8e52c6e32
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 07:57:06.1616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nvI/OwmAmlaZV2c8P00A5QprS8c4n3F/jMrO9/+4NIs+V69Fr8/qbeI3vTrv4Aa+CAZtIAa1cNghBhj5r/Nmzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the patch.

> -----Original Message-----
> From: Robert Hancock <robert.hancock@calian.com>
> Sent: Friday, March 12, 2021 1:41 AM
> To: Radhey Shyam Pandey <radheys@xilinx.com>; davem@davemloft.net;
> kuba@kernel.org
> Cc: netdev@vger.kernel.org; devicetree@vger.kernel.org; Robert Hancock
> <robert.hancock@calian.com>
> Subject: [PATCH net-next 1/2] dt-bindings: net: xilinx_axienet: Document
> additional clocks
>=20
> Update DT bindings to describe all of the clocks that the axienet driver =
will
> now be able to make use of.
>=20
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  .../bindings/net/xilinx_axienet.txt           | 23 ++++++++++++++-----
>  1 file changed, 17 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> index 2cd452419ed0..1ee1c6c5fc66 100644
> --- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> +++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> @@ -42,11 +42,21 @@ Optional properties:
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

Based on PG138 , axis_clk is AXI4-Stream clock for TXD RXD TXC and RXS inte=
rfaces.
In this patch I assume we are only adding additional clocks for 1G ethernet=
 subsystem.
For dma clocking support we need to add more clocks and better to add it in=
 separate
patch. Please refer to xilinx tree.

> +		  ref_clk: Ethernet reference clock

Better to add some more description -  used by signal delay primitives and =
transceivers.
> +		  mgt_clk: MGT reference clock (used by internal PCS/PMA
> PHY)
(used by optional internal PCS/PMA)
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
> @@ -62,7 +72,8 @@ Example:
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

