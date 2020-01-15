Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B813213B953
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 07:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgAOGCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 01:02:08 -0500
Received: from mail-mw2nam12on2041.outbound.protection.outlook.com ([40.107.244.41]:32813
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725962AbgAOGCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 01:02:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzcRRDvPoAO9vgHiNpMDmySMDp9R5Up+RQHUxPHHH8z4ZiY1Mlw39mOJ3wHWMh4/T/hVyrJfDbx0KLmQd2c3psr0RR2zx3nInMqt/09rhSUdADBS0Wr+kPu2pNY/ld/dHdpP7joTroC9nbS1Z5luuM+ZEkFTuWAzlQZZ58nJIj4kvXuY18SNZwoDGiSp5BoNk8dpaFcjQc9ujVsyKVcpj0pTKOTQelrDU6tzUe7JlBDLj7rwn2iveiJzT7oPAIkk2ibxTVs576qBglPhcISXzYntFF15JA1SWIJYe47OhRPj+vrhUH0sTS/HdTCTQFgriLn2uUuoIgaCHjO72FRW1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpxRgxJzyaHMjS87+FyGfwoC+gNy8SRFH7N2y/KkEgY=;
 b=dVz4v6ame/r9A+34iJnW2P159FOrCHfF6Z0bXKbRV+BHg5uttI4r3wm9gzW+u2QRgdXXcsH/iFrk8zQdk99e+B19rez3JyY2Dk4ZZijhKqcdtl1QXzO95wOflaKokmd4wEzsn2Twt5Em8EtDQG275WmcUojOakpQEXaor/xbPEJxdfxEakHy54xJvuXswM4bsJXinAZcvN8hJmO6GnGVUI35Xwr7a/BL+vCMf1E9alrgHI4rPiypLZPFjmaFm3Q8/5bA9RCECHmdKFORFKQe/aU/Dq5JxmQIlbfk/kFuK7tjn9gVe4aoiqJ8FsSqgqr2mc+b82snHciRJJXq8HRbzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpxRgxJzyaHMjS87+FyGfwoC+gNy8SRFH7N2y/KkEgY=;
 b=ofwnDNjhvXylPe1vWFqEee+5zlf+1kmqjyYIYqgiqa+mQPAp8f+RmYI4CtJlJzXb1msMxB0H6biX4/rwzt9oy/WOK2XVkDoX5P8TVj3IJTYgjcOY4OSg18oe7OdOqoDRHWRPBnjgy+JbHbT95H33IfRk5mgy6Mchud6qh8YyIuw=
Received: from MN2PR02MB7007.namprd02.prod.outlook.com (20.180.25.208) by
 MN2PR02MB6976.namprd02.prod.outlook.com (20.179.223.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 06:02:03 +0000
Received: from MN2PR02MB7007.namprd02.prod.outlook.com
 ([fe80::d8da:3434:fcd5:6cdc]) by MN2PR02MB7007.namprd02.prod.outlook.com
 ([fe80::d8da:3434:fcd5:6cdc%7]) with mapi id 15.20.2623.015; Wed, 15 Jan 2020
 06:02:03 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andre Przywara <andre.przywara@arm.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 12/14] net: axienet: Autodetect 64-bit DMA capability
Thread-Topic: [PATCH 12/14] net: axienet: Autodetect 64-bit DMA capability
Thread-Index: AQHVx6y+W25+wq1cpkmcd5TNSAo3EKfqY36ggAAQ7gCAAMh4AA==
Date:   Wed, 15 Jan 2020 06:02:03 +0000
Message-ID: <MN2PR02MB7007DF6B24EABA513274B489C7370@MN2PR02MB7007.namprd02.prod.outlook.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
        <20200110115415.75683-13-andre.przywara@arm.com>
        <CH2PR02MB70006450DBDCEC27CA76503AC7340@CH2PR02MB7000.namprd02.prod.outlook.com>
 <20200114174144.6e8c6387@donnerap.cambridge.arm.com>
In-Reply-To: <20200114174144.6e8c6387@donnerap.cambridge.arm.com>
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
x-ms-office365-filtering-correlation-id: 1d9184c3-dee2-49b9-e9a2-08d799807166
x-ms-traffictypediagnostic: MN2PR02MB6976:|MN2PR02MB6976:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR02MB6976AA14E2E72D75AD399A2BC7370@MN2PR02MB6976.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(199004)(189003)(6916009)(54906003)(53546011)(71200400001)(6506007)(8936002)(2906002)(81166006)(8676002)(33656002)(86362001)(7696005)(81156014)(478600001)(52536014)(5660300002)(9686003)(316002)(26005)(55016002)(186003)(64756008)(66946007)(66476007)(66446008)(66556008)(76116006)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB6976;H:MN2PR02MB7007.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /7lpJw0vAmtqvtRW0GJclPWEyQRCXcZBHzQIubGDmRJ4Syo05PfiwQ4gA6Bg3+8o5hdnuHfIuicvBXcNWz0xC9FV+oYVO5E4/wH9d8G0eNU1Es494wA6F44i0H/SCOm0QTf8hhZ2WAtizjJ0xFfj/NYbn5Og0l1n72cd72mOlwFILoubfcjvBZio0Y0pRA0OdqjoJM516z+Yzd/fsyVJ7UnaGKXAGNbtlQu9Junum3DVnPuVHauz3Zl8yuP8Z9+B1Q3PsezCNqi9hkkicMye+IHaCScz8pyk4aaQFubqrFnl1bJ5gRwKD1eGh9UERqFeX7sKa/LXw6a6Us3gMbgfunFTxJDoyWNou5O9ZopZymPv2hMRqouZmKiq0koiKz/ZX1wK3VXuvxBu+5koSr+sD4PHUe4+F2e5nZict5V4dNN3ROhaJfZLhMeJ5bkg455t
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d9184c3-dee2-49b9-e9a2-08d799807166
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 06:02:03.2224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7dME4H/hQeWSwT4TEW0fmI4fzglgIyS+BX+hi8Fo56W3DJV05X3WLF3UR1DFC4e6bRhCdqa5HGw/Twc1puiSaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6976
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andre Przywara <andre.przywara@arm.com>
> Sent: Tuesday, January 14, 2020 11:12 PM
> To: Radhey Shyam Pandey <radheys@xilinx.com>
> Cc: David S . Miller <davem@davemloft.net>; Michal Simek
> <michals@xilinx.com>; Robert Hancock <hancock@sedsystems.ca>;
> netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 12/14] net: axienet: Autodetect 64-bit DMA capability
>=20
> On Tue, 14 Jan 2020 17:03:41 +0000
> Radhey Shyam Pandey <radheys@xilinx.com> wrote:
>=20
> Hi,
>=20
> > > -----Original Message-----
> > > From: Andre Przywara <andre.przywara@arm.com>
> > > Sent: Friday, January 10, 2020 5:24 PM
> > > To: David S . Miller <davem@davemloft.net>; Radhey Shyam Pandey
> > > <radheys@xilinx.com>
> > > Cc: Michal Simek <michals@xilinx.com>; Robert Hancock
> > > <hancock@sedsystems.ca>; netdev@vger.kernel.org; linux-arm-
> > > kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > > Subject: [PATCH 12/14] net: axienet: Autodetect 64-bit DMA
> > > capability
> > >
> > > When newer revisions of the Axienet IP are configured for a 64-bit
> > > bus,
> > I assume in design axidma address width is set to 64-bits.
>=20
> So I wrote "64-bit bus" here, but really meant: "address bus wider than 3=
2 bits".
> In our case it's set to 40 bits, because that's how wide the other busses=
 in the
> system are.
> And we have memory from 2GB to 4GB, and from 34GB till 40GB, but not in-
> between (VExpress/Juno memory layout).
>=20
> > If not, please provide an overview of the design connections.
>=20
> The exact parameter name from PG021 is: "Address Width (32-64) /
> c_addr_width".
Thanks. It's right.

>=20
> > > we *need* to write to the MSB part of the an address registers,
> > > otherwise the IP won't recognise this as a DMA start condition.
> > > This is even true when the actual DMA address comes from the lower 4 =
GB.
> > >
> > > To autodetect this configuration, at probe time we write all 1's to
> > > such
> > Is reading address width axidma IP user parameter(c_addr_width) from
> > the design not sufficient to detect configured bus width?
>=20
> What do you mean by that? Reading from where? Is there a way to access th=
ose
> parameters from a running system?
Hardware design data i.e IP parameter can be accessed using hsi in-built co=
mmands.
Please refer to ug1138-generating-basic-software-platforms.pdf, chapter-4.
The same flow is used in DT,  xilinx device tree generator parses HDF and r=
ead IP=20
parameters and populate DT binding.

>=20
> Cheers,
> Andre.
>=20
> > > an MSB register, and see if any bits stick. If this is configured
> > > for a 32-bit bus, those MSB registers are RES0, so reading back 0
> > > indicates that no MSB writes are necessary.
> > > On the other hands reading anything other than 0 indicated the need
> > > to write the MSB registers, so we set the respective flag.
> > >
> > > For now this leaves the actual DMA mask at 32-bit, as we can't
> > > reliably detect the actually wired number of address lines beyond 32.
> > >
> > > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > > ---
> > >  drivers/net/ethernet/xilinx/xilinx_axienet.h  |  1 +
> > > .../net/ethernet/xilinx/xilinx_axienet_main.c | 27
> > > +++++++++++++++++++
> > >  2 files changed, 28 insertions(+)
> > >
> > > diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> > > b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> > > index 4aea4c23d3bb..4feaaa02819c 100644
> > > --- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> > > +++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> > > @@ -161,6 +161,7 @@
> > >  #define XAE_FCC_OFFSET		0x0000040C /* Flow Control
> > > Configuration */
> > >  #define XAE_EMMC_OFFSET		0x00000410 /* EMAC mode
> > > configuration */
> > >  #define XAE_PHYC_OFFSET		0x00000414 /* RGMII/SGMII
> > > configuration */
> > > +#define XAE_ID_OFFSET		0x000004F8 /* Identification register
> > > */
> > >  #define XAE_MDIO_MC_OFFSET	0x00000500 /* MII Management
> > > Config */
> > >  #define XAE_MDIO_MCR_OFFSET	0x00000504 /* MII Management
> > > Control */
> > >  #define XAE_MDIO_MWD_OFFSET	0x00000508 /* MII Management Write
> > > Data */
> > > diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > > b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > > index 133f088d797e..f7f593df0c11 100644
> > > --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > > +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > > @@ -151,6 +151,9 @@ static void axienet_dma_out_addr(struct
> > > axienet_local *lp, off_t reg,
> > >  				 dma_addr_t addr)
> > >  {
> > >  	axienet_dma_out32(lp, reg, lower_32_bits(addr));
> > > +
> > > +	if (lp->features & XAE_FEATURE_DMA_64BIT)
> > > +		axienet_dma_out32(lp, reg + 4, upper_32_bits(addr));
> > >  }
> > >
> > >  static void desc_set_phys_addr(struct axienet_local *lp, dma_addr_t
> > > addr, @@ -1934,6 +1937,30 @@ static int axienet_probe(struct
> > > platform_device
> > > *pdev)
> > >  		goto free_netdev;
> > >  	}
> > >
> > > +	/*
> > > +	 * Autodetect the need for 64-bit DMA pointers.
> > > +	 * When the IP is configured for a bus width bigger than 32 bits,
> > > +	 * writing the MSB registers is mandatory, even if they are all 0.
> > > +	 * We can detect this case by writing all 1's to one such register
> > > +	 * and see if that sticks: when the IP is configured for 32 bits
> > > +	 * only, those registers are RES0.
> > > +	 * Those MSB registers were introduced in IP v7.1, which we check f=
irst.
> > > +	 */
> > > +	if ((axienet_ior(lp, XAE_ID_OFFSET) >> 24) >=3D 0x9) {
> > > +		void __iomem *desc =3D lp->dma_regs +
> > > XAXIDMA_TX_CDESC_OFFSET + 4;
> > > +
> > > +		iowrite32(0x0, desc);
> > > +		if (ioread32(desc) =3D=3D 0) {	/* sanity check */
> > > +			iowrite32(0xffffffff, desc);
> > > +			if (ioread32(desc) > 0) {
> > > +				lp->features |=3D XAE_FEATURE_DMA_64BIT;
> > > +				dev_info(&pdev->dev,
> > > +					 "autodetected 64-bit DMA range\n");
> > > +			}
> > > +			iowrite32(0x0, desc);
> > > +		}
> > > +	}
> > > +
> > >  	/* Check for Ethernet core IRQ (optional) */
> > >  	if (lp->eth_irq <=3D 0)
> > >  		dev_info(&pdev->dev, "Ethernet core IRQ not defined\n");
> > > --
> > > 2.17.1
> >

