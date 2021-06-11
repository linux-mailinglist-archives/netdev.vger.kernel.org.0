Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C19E3A42CD
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 15:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbhFKNOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 09:14:05 -0400
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:40673
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230382AbhFKNOF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 09:14:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HglcYlyrh8vSknquvaGcVX6rbLdSslKRRzCTzczeotw5JukMZWW4ZpNpJdkMyCJ3/ivaYEMqswfaP6qVhItK63IXx3LRzLT49D/f+ZLBYQao7EIVL6427V9aRp1sX0uqUXyrZVju3DR86+fb8jAFM+J8MZtN7ppU77NrXLTs9l/nVMGt1dlCbs2G1aj42HO3FQkiy9hhqwGlaNwvuTdomRr3x7jrkAIaPI7TbD6kIwj4BwPO6WMi1ZTzBMG1sv4XygM23ZX8U28UsjIpG7RUAtNYExL7yCKT9mygZsQFDgEDouJW9FYMsyVxgUlrIzgF9mtLeyLNaEKkOEvIBRQgEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3H2o8pAKYJPGT3bqtAYWVWe574Xzl/92IokYnDxbGag=;
 b=Q3+yxx5lChMXyXvIXYbf49r8V9gn2eX7ScHLNrN384PMu/cLRpwwxV+GiN+YfyLI4/ELfO7kHLyys/Px/qe2XIx3gGBlbLemzVyPfouZQVtx6011vj3HQrFhPu0Bq7upVTCL19nbbm5vUMYj8CgV1yDWtQAkh1CUXsywPC3I4K4vv0EOtALSGOGk1dISf+rhqPmGIDgdAigYWaEtdc4py3/4fSQzL5YCf5XutN33pGtQuTFYFsTnROvSHKrsjoKpaVMxCeMrLNxFrSf/lq5OZ0AjdM29lbpy76G8eVOYKze94hd5uc9Q/09BNrypeIaufshN21yPqxpRa2/Bph/4ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3H2o8pAKYJPGT3bqtAYWVWe574Xzl/92IokYnDxbGag=;
 b=qggPTd+WL5vKDWWCr/RK4PFzIapwzU0I730owWqAaVTE2d38+WVTSFQxurTEUjlBdZ//zapdBGmLFMTOBzebKz8D6+PW7c80Qsw1x70AkZgAYx+St28clzMBAcqsjeeWLryV4+BapNdoEQ2Ck+GTIvVtT8W4WiKzZHG7757LGPI=
Received: from BY5PR02MB6520.namprd02.prod.outlook.com (2603:10b6:a03:1d3::8)
 by BY5PR02MB6518.namprd02.prod.outlook.com (2603:10b6:a03:1d6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Fri, 11 Jun
 2021 13:12:03 +0000
Received: from BY5PR02MB6520.namprd02.prod.outlook.com
 ([fe80::d880:7694:92d6:7798]) by BY5PR02MB6520.namprd02.prod.outlook.com
 ([fe80::d880:7694:92d6:7798%5]) with mapi id 15.20.4219.024; Fri, 11 Jun 2021
 13:12:03 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Rob Herring <robh@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>
Subject: RE: [RFC PATCH 2/3] dt-bindings: net: xilinx_axienet: Introduce
 dmaengine binding support
Thread-Topic: [RFC PATCH 2/3] dt-bindings: net: xilinx_axienet: Introduce
 dmaengine binding support
Thread-Index: AQHXLWwXOJwFrmMwT0GEUXL9WYgFO6qxOPoAgF3cs8A=
Date:   Fri, 11 Jun 2021 13:12:03 +0000
Message-ID: <BY5PR02MB65207E7A4C5BB958D33D4568C7349@BY5PR02MB6520.namprd02.prod.outlook.com>
References: <1617992002-38028-1-git-send-email-radhey.shyam.pandey@xilinx.com>
 <1617992002-38028-3-git-send-email-radhey.shyam.pandey@xilinx.com>
 <20210412183028.GA4156095@robh.at.kernel.org>
In-Reply-To: <20210412183028.GA4156095@robh.at.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=xilinx.com;
x-originating-ip: [149.199.50.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4cc5d5e-f55d-440a-e714-08d92cda8130
x-ms-traffictypediagnostic: BY5PR02MB6518:
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR02MB651872A598056CED1EA71A1DC7349@BY5PR02MB6518.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b/CaBoiX5icbp5NItZtO4WUtOCQ/G0PZ+BaPmrHXsAB2sj78P1qZhEVJLt1M5/o1FfotAr+bXYS00Av/yaR/EFbWm5HqeG3kaE2YYVig0HXHVUrr6hPKvv8kTCHfDGq9D4xIsJNTb40hIykn4YJAwePJUc2SPOnxIfm9mKZUhNXdjsTuGLTxP7nvBzEkFMRZh46e5J1BiUDjkDDhCAOYq9Og8cRfSi6x/V74VWh1Cc+v/JN7fdnxZhgdI2OXtSzETqzGgC2l3sN+C7sBBHL3Ai8AXaCK5QIF7BHluzw8kGVuClEYB3ggEHKy3/quvxryYd1mbCVI9fnekyKXmEGAjsSzn6DY56dovjHWM8yUyUyHztoQeAanH7/+3U5TjVJ2dp47N1iu4qqbFydT1uzpsUDX7EiGPN7isHZ4Zdxyn8g+IW/F92+EzcsDzNuCqWVYuOgnxmorHLVlBBWIzypm/CDDtCzMXINVAweB8nTBJ8xyljbxPnzR6XDuccY5GFjeRxxFPzhGhohfAm0qZ+Fw13sElh+k9TDbXkQHYEAr1pXa3JQJDjNBUuA5+HYoKT9UeNz2yHILbRn1YR0WGRAY5813y1Y+GmPqcrhrW9QMUbo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR02MB6520.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39850400004)(33656002)(26005)(71200400001)(76116006)(9686003)(55016002)(316002)(478600001)(5660300002)(54906003)(2906002)(52536014)(107886003)(4326008)(53546011)(66946007)(7696005)(8936002)(66556008)(186003)(64756008)(66446008)(8676002)(66476007)(6506007)(6916009)(38100700002)(122000001)(86362001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Sg7iogiYgtKrMy8+dmDr5PYl1zjKoWpjnWN2MYFCJXbWsm/OjP5XBfYCYoaU?=
 =?us-ascii?Q?UsMnPXM5DadN3hHcCO1ejU0OPZkruOrAyF2U14WPnXhPXPpR/pd3/oyPT8JA?=
 =?us-ascii?Q?iOv4WicFEXvcYUEkd3+YzSSUv85KOgU6DKs3f7uoizWwU/AQCZ0vkNEodbp3?=
 =?us-ascii?Q?/pqJ4TL/0EQQjhIFCINyUU/dhB2tAzqDOwuMYURUDvhI73MoffrmsKzzTVVh?=
 =?us-ascii?Q?iMzPplXRgLNl2MH4HL9YWLi9kQcqW2hFq3S02Xr2AUuWUr942MF5h2yE1Ywg?=
 =?us-ascii?Q?Hyn814Shbpa0JHHJaySFa4VgeeXgyUCfTY7HRhfsQ7/sJUdo2ojwsC/A/bQC?=
 =?us-ascii?Q?fICSqse1mQl8AuuFjKl0kmDzVt3TjZl9ymZ62Ae+H06SDKW+U6m5RAo0A9PP?=
 =?us-ascii?Q?6/h5j2XiMTMSJLzigVAxbz6fEuH/63XomEm6GZ+Y3ru1RogFQnty5+G16nxA?=
 =?us-ascii?Q?HcAoMIMYYbDhvEsJNXwD0EW+3ecA3p0AmVsjPV1+OysmfJk74d4blzD7DNHG?=
 =?us-ascii?Q?tKMLlEzkZXRnQx4mdtia1OfH016zMl+QtMS8vbAItwXiwf7zDowRdRdi/38h?=
 =?us-ascii?Q?NLhb8xkVDrtSvrcJtTckKHJdoXtEk/McPW9hGGUiDTj6e/9RI95Uj9WDVdDG?=
 =?us-ascii?Q?JqHS2VTG/EfqbjwQPWywQFRjQKZFlQKmqLufRHfK2o3HuLNI0yqk0PmZJZ3T?=
 =?us-ascii?Q?erX1Z13YWT6c4aTRES3gX/06ZhJjA1nPOpwPg3EpUvwHzQ5eRgV99okb3ew5?=
 =?us-ascii?Q?kdCYHCoPkalgAFSBu7t2V18xr1FHI39Kqb2kxaXTBeHSibjrHeC3I1HceAHu?=
 =?us-ascii?Q?4XqmUyI4gGbpdN/RZvHLtdpS6j3Gq4YdyunGZpzTkST6Wq86MS9OUfnN5buN?=
 =?us-ascii?Q?mCGs+feuJ4XQ3VotTyMPrLNlca3ofscisOVFa+Pppq0NS3C5Ndcj+c6rkp6Z?=
 =?us-ascii?Q?gTqwFH/oHFhGks4C7G5B5n56m8FgHi+n+4B4I8KTH7IyO4DWCeptLBBvqa/z?=
 =?us-ascii?Q?4/G8sb/ZQ3Fvfatu55yOgQWjCw02VmF6K1fvOosH+ikC8dMQ83OA3R47EBe7?=
 =?us-ascii?Q?LyyqItbKEiQNhOZN0BzULlTetKIugyu4/GiAwQMnsujXHZo3GNc3uhC3SBXt?=
 =?us-ascii?Q?0tg66CASH2+88gPxtj+MWwzRriGmq6Us82tSTqzXooIZIEbPo/CENPsOIhS2?=
 =?us-ascii?Q?g3aOkLkyvs7IkoAjgDRlHTL65th4HvidF/NnYwr6mW96R0Qaes/CeP1h4TOv?=
 =?us-ascii?Q?dYd5OT10inDlEMxScCAVrwFGASKETPqYZNpTzqw6VYKtKD2UdngyI/FuxzH/?=
 =?us-ascii?Q?9Wa4iuA/RdqrzrqlLtl3qLZW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR02MB6520.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4cc5d5e-f55d-440a-e714-08d92cda8130
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2021 13:12:03.0270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JHjS8IwfV907VRsZn64tnu5axm4pa7JE4oMx6aRuD83TCebA4a7Tn79HFrP1qxoY24v8DvLQgWQRK1GeqFqo/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6518
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Rob Herring <robh@kernel.org>
> Sent: Tuesday, April 13, 2021 12:00 AM
> To: Radhey Shyam Pandey <radheys@xilinx.com>
> Cc: davem@davemloft.net; kuba@kernel.org; Michal Simek
> <michals@xilinx.com>; vkoul@kernel.org; devicetree@vger.kernel.org;
> netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; git <git@xilinx.com>
> Subject: Re: [RFC PATCH 2/3] dt-bindings: net: xilinx_axienet: Introduce
> dmaengine binding support
>=20
> On Fri, Apr 09, 2021 at 11:43:21PM +0530, Radhey Shyam Pandey wrote:
> > The axiethernet driver will now use dmaengine framework to
> communicate
> > with dma controller IP instead of built-in dma programming sequence.
> >
> > To request dma transmit and receive channels the axiethernet driver
> > uses generic dmas, dma-names properties. It deprecates
> > axistream-connected
>=20
> Huh, you just added the property and now deprecating?

In the previous patch - we added the 'xlnx,axistream-connected' property
to dmaengine node.  In this patch we are deprecating axiethernet=20
axistream-connected property. So instead of custom properties the=20
ethernet client will now use generic  dmas, dma-names properties
to communicate with the dmaengine driver.

>=20
> > property, remove axidma reg and interrupt properties from the ethernet
> > node. Just to highlight that these DT changes are not backward
> > compatible due to major driver restructuring/cleanup done in adopting
> > the dmaengine framework.
>=20
> Aren't users going to care this isn't a backwards compatible change?

Yes, as it was a major design change for framework adoption and
there was no  option to support legacy usecases with this new approach.

To advertise that changes aren't backward compatible -
Should we introduce new compatibility string and raise a warning
for earlier unsupported versions?=20

>=20
> >
> > Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> > ---
> >  .../devicetree/bindings/net/xilinx_axienet.yaml    | 40 +++++++++++++-=
-----
> ---
> >  1 file changed, 24 insertions(+), 16 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.yaml
> > b/Documentation/devicetree/bindings/net/xilinx_axienet.yaml
> > index 6a00e03e8804..0ea3972fefef 100644
> > --- a/Documentation/devicetree/bindings/net/xilinx_axienet.yaml
> > +++ b/Documentation/devicetree/bindings/net/xilinx_axienet.yaml
> > @@ -14,10 +14,8 @@ description: |
> >    offloading TX/RX checksum calculation off the processor.
> >
> >    Management configuration is done through the AXI interface, while
> > payload is
> > -  sent and received through means of an AXI DMA controller. This
> > driver
> > -  includes the DMA driver code, so this driver is incompatible with
> > AXI DMA
> > -  driver.
> > -
> > +  sent and received through means of an AXI DMA controller using
> > + dmaengine  framework.
> >
> >  allOf:
> >    - $ref: "ethernet-controller.yaml#"
> > @@ -36,19 +34,13 @@ properties:
> >
> >    reg:
> >      description:
> > -      Address and length of the IO space, as well as the address
> > -      and length of the AXI DMA controller IO space, unless
> > -      axistream-connected is specified, in which case the reg
> > -      attribute of the node referenced by it is used.
> > -    maxItems: 2
> > +      Address and length of the IO space.
> > +    maxItems: 1
> >
> >    interrupts:
> >      description:
> > -      Can point to at most 3 interrupts. TX DMA, RX DMA, and optionall=
y
> Ethernet
> > -      core. If axistream-connected is specified, the TX/RX DMA interru=
pts
> should
> > -      be on that node instead, and only the Ethernet core interrupt is
> optionally
> > -      specified here.
> > -    maxItems: 3
> > +      Ethernet core interrupt.
> > +    maxItems: 1
> >
> >    phy-handle: true
> >
> > @@ -109,15 +101,29 @@ properties:
> >        for the AXI DMA controller used by this device. If this is speci=
fied,
> >        the DMA-related resources from that device (DMA registers and DM=
A
> >        TX/RX interrupts) rather than this one will be used.
> > +    deprecated: true
> >
> >    mdio: true
> >
> > +  dmas:
> > +    items:
> > +      - description: TX DMA Channel phandle and DMA request line numbe=
r
> > +      - description: RX DMA Channel phandle and DMA request line
> > + number
> > +
> > +  dma-names:
> > +    items:
> > +      - const: tx_chan0
> > +      - const: rx_chan0
> > +
> > +
> >  required:
> >    - compatible
> >    - reg
> >    - interrupts
> >    - xlnx,rxmem
> >    - phy-handle
> > +  - dmas
> > +  - dma-names
> >
> >  additionalProperties: false
> >
> > @@ -127,11 +133,13 @@ examples:
> >        compatible =3D "xlnx,axi-ethernet-1.00.a";
> >        device_type =3D "network";
> >        interrupt-parent =3D <&microblaze_0_axi_intc>;
> > -      interrupts =3D <2>, <0>, <1>;
> > +      interrupts =3D <1>;
> >        clock-names =3D "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_cl=
k";
> >        clocks =3D <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk=
>;
> >        phy-mode =3D "mii";
> > -      reg =3D <0x40c00000 0x40000>,<0x50c00000 0x40000>;
> > +      reg =3D <0x40c00000 0x40000>;
> > +      dmas =3D <&xilinx_dma 0>, <&xilinx_dma 1>;
> > +      dma-names =3D "tx_chan0", "rx_chan0";
>=20
> Is there a chan1? Typical dma-names are just 'tx' and 'rx'.
>=20
> >        xlnx,rxcsum =3D <0x2>;
> >        xlnx,rxmem =3D <0x800>;
> >        xlnx,txcsum =3D <0x2>;
> > --
> > 2.7.4
> >
