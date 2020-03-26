Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67379194A84
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgCZV0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:26:51 -0400
Received: from mail-eopbgr20057.outbound.protection.outlook.com ([40.107.2.57]:42117
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726067AbgCZV0v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 17:26:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bdw7pJ6rIhCAOgdPt4aQftetcoNaipCfe22jV/vSpvc8puzAsdkn6Jdnd7ctdiK15+0fprgxx+p/AUI7rERqDPIEr8AgyJ0V7DXEKcVUBOWGEjEO8Piayp67cGogmIuxNY1QNFNYlQqF16pjM1AZf84oyqf0HSm9cQcp1uiYNJFssj4IuLkprLUVXuaG1FtlzX3jl5sTbQuVFiQjRm+30HF+hPvmls+RBa80iA1TlH43gRnF0YkLCFBuN2u+XUMv6bUePt4G8jqw7j6vxFOhK/5jC+e32NanAjFSK1PHcmZOQf07n1P5a8d0xRvu0qpO6l01KwxjlMBlN10HEkQ2UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+0nIhiDG3AuNsEk0ZFs7ErobUsZ3IMmeC1mSGa262w=;
 b=gxPEkiZ01L+kIBobgVJ/BzuJ9dNZEDE/Pa55LH3NTdEFmSx6JHhAUTCv4Ooov/TSkACtfbI5uIC1vcIZgDvvCgqqcw87Jx1QOO9QlITMPUYZjnjd1EQytFLBPo3bEDfTS6qbX37Pt8nTIO/hfeDqA+tSd6JFA89au12iSNd00IJufRzoELSA++oXbQTZl44OF3P8WIIr5vFvaiT2dnfPZrc+5YpagNWU4Qz3A8FRu0zJUbmM795TOO+Fml/saU8DI1fHW2qDps7rCP9ikVVl5p0/J3D2MNgBGX4m3MZlEcqr/wX5eZNWmeueEdMltFFvtXboJZiUMkz/gDUxFRVfQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+0nIhiDG3AuNsEk0ZFs7ErobUsZ3IMmeC1mSGa262w=;
 b=csSahE5RYqbfIgRZ8UvXOkCfI4tVR4uoeSGbCZYwMWQTKdd2oyJuqt/daa5+gWoFXNhlcH+gkpmCgU5KSKBuw6qGx5DVNJM+rlPM82GURu9D3LwFfpcp5x+VtYIvQJ2G90gK+6EwjAoxqqWs32bZ6XqjmWYigutD5WNRKbdFv34=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (52.133.240.149) by
 DB8PR04MB7097.eurprd04.prod.outlook.com (52.135.62.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.19; Thu, 26 Mar 2020 21:26:46 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::e44e:f867:d67:e901]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::e44e:f867:d67:e901%2]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 21:26:46 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leo Li <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC net-next 3/5] arm64: dts: lx2160a: add PCS MDIO nodes
Thread-Topic: [RFC net-next 3/5] arm64: dts: lx2160a: add PCS MDIO nodes
Thread-Index: AQHV/GvPzUWzrwiI5Eyn+VTY72VeyKhbbKRggAADbQCAAABWYA==
Date:   Thu, 26 Mar 2020 21:26:46 +0000
Message-ID: <DB8PR04MB682817485CBD1EFA1AA179F1E0CF0@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaS-0008JO-Po@rmk-PC.armlinux.org.uk>
 <DB8PR04MB6828FA55AA75B710BDB53BC8E0CF0@DB8PR04MB6828.eurprd04.prod.outlook.com>
 <20200326212104.GE25745@shell.armlinux.org.uk>
In-Reply-To: <20200326212104.GE25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [79.115.60.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8ba33cc8-b9fc-43fe-382c-08d7d1cc630d
x-ms-traffictypediagnostic: DB8PR04MB7097:|DB8PR04MB7097:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB70971C0CE9B3204E956964E4E0CF0@DB8PR04MB7097.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(66446008)(66556008)(186003)(66946007)(66476007)(26005)(8936002)(2906002)(7696005)(6506007)(64756008)(6916009)(7416002)(52536014)(9686003)(316002)(8676002)(478600001)(44832011)(54906003)(33656002)(5660300002)(71200400001)(81156014)(86362001)(81166006)(76116006)(4326008)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB7097;H:DB8PR04MB6828.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vc04jNlYXVq7GBsfTCl7B5/qGcSbAYxk2SBUiHbZxsjWDU6Vcwl5CLHTPX6E/mIxrY8To+KYs3q2d67t6rpzU0lCvJweJuBpLZ5xxK0S6u1xQXQzQ6CmU+OjxwHTDaHcslg2MBdZ9mqbUoWKT+oR7SB9EX2sBMZv/mlMaYGaCOeqXxsWHWMxv8a8KA9keaODTp+8BNjXt+IEJelbwMRCg+Gob97m3a01pZXl0BVP0MCi8+Wcnr3TaO1bj/Uc9MC6HbOCKmCKfDs8j3FCjsqcWvxWb/vAtuYOwfn7Uh0mjXwR3zO9qLB0ge1puqQl96LEFQpbI+TFXgsuTvCuCGh2qinQUkieg0icZ5AdOp4pHJaq2fvAZvzu7ahJ5K5qIiDiGaGw1nOsYHrdolvlBRRPHM1YhhlZMOR+VhUid00NK7LK8n8akTjbBWev5P8ZE5se
x-ms-exchange-antispam-messagedata: B9nFNMhH1JrWkdfJ2oX5kBxjcvpMR/5D++EAVMNomWJxLYm5Uk0Uqunjrftcw3D+nQzbS0pl9dXRhTlWWYqZ8MzeZ9USkiv85Z6hj+DinR1V/cFAl6zcWuQc73s5xnL3RuNLPK4UdNv+Rsxv9GS7kQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba33cc8-b9fc-43fe-382c-08d7d1cc630d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 21:26:46.0941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KYYGgAWo8zHefdYZcntW3pqWBlaYkaEnuv9lm11cslA3ThvmE0F/WZF4Q1Kb7Ha0pTbHT6Rb7O5kMinyiIUpnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [RFC net-next 3/5] arm64: dts: lx2160a: add PCS MDIO nodes
>=20
> On Thu, Mar 26, 2020 at 09:14:13PM +0000, Ioana Ciornei wrote:
> > > Subject: [RFC net-next 3/5] arm64: dts: lx2160a: add PCS MDIO nodes
> > >
> > > *NOT FOR MERGING*
> > >
> > > Add PCS MDIO nodes for the LX2160A, which will be used when the MAC
> > > is in PHY mode and is using in-band negotiation.
> > >
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 144
> > > ++++++++++++++++++
> > >  1 file changed, 144 insertions(+)
> > >
> > > diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
> > > b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
> > > index e5ee5591e52b..732af33eec18 100644
> > > --- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
> > > +++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
> > > @@ -960,6 +960,132 @@
> > >  			status =3D "disabled";
> > >  		};
> > >
> > > +		pcs_mdio1: mdio@8c07000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c07000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> >
> > Are the PCS MDIO buses shareable? I am asking this because in case of Q=
SGMII
> our structure is a little bit quirky.
> > There are 4 MACs but all PCSs sit on the first MACs internal MDIO bus o=
nly. The
> other 3 internal MDIO buses are empty.
>=20
> I haven't looked at QSGMII yet, I've only considered single-lane setups a=
nd only
> implemented that. For _this_ part, it doesn't matter as this is just decl=
aring
> where the hardware is.  I think that matters more for the dpmac nodes.

Sorry for misplacing the comment.

I am going to take a look tomorrow and see how workable this approach is go=
ing to be in the long term since I have a board with QSGMII handy.


>=20
> > > +
> > > +		pcs_mdio2: mdio@8c0b000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c0b000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio3: mdio@8c0f000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c0f000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio4: mdio@8c13000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c13000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio5: mdio@8c17000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c17000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio6: mdio@8c1b000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c1b000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio7: mdio@8c1f000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c1f000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio8: mdio@8c23000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c23000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio9: mdio@8c27000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c27000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio10: mdio@8c2b000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c2b000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio11: mdio@8c2f000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c2f000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio12: mdio@8c33000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c33000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio13: mdio@8c37000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c37000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio14: mdio@8c3b000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c3b000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio15: mdio@8c3f000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c3f000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio16: mdio@8c43000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c43000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio17: mdio@8c47000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c47000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> > > +		pcs_mdio18: mdio@8c4b000 {
> > > +			compatible =3D "fsl,fman-memac-mdio";
> > > +			reg =3D <0x0 0x8c4b000 0x0 0x1000>;
> > > +			little-endian;
> > > +			status =3D "disabled";
> > > +		};
> > > +
> >
> > Please sort the nodes alphabetically.
>=20
> Huh?  The nodes in this file are already sorted according to address, and=
 this
> patch preserves that sorting.  The hex address field also happens to be
> alphabetical.
>=20
> Or do you mean the label for these modes - I've never heard of sorting by=
 label
> for a SoC file.

Uhh, I remember now. For some reason I thought this was a board file.

Ioana

[snip]
