Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA72912F4D3
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 08:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgACHB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 02:01:57 -0500
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:34446
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725890AbgACHB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 02:01:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKV64Wh3KGcWfnwbYG2H/FvcQVFJ7+fWbxlweIxRDDKcq+H5ZQyzzGdpdISgclvMt2oWzHghJqWVc7PrEf0thqbicExKlj+TuWGCAXGGJhWRvRNKR6Do7g7p8ILffrZ0LKjqj0opekpMZciagKqq6K26apinfidJg7ZuaFOyDsqdLiSkJGL5XRMJMv+jiAEbKT0UNAgflReEEQTmvsKLc/c64EApuBUhufa2csuzuBo51OCzrBODSYlo2oRjaOGozDDCVmCpUvSZHstdsXRrGKMZUF2W2edhAGdqihzcMk0HxUs8oT1SR0cbfGO7GKNC4DzggRsP4YXrE4QkJOXzKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqnijH+ykrHcfcL3brGAyT7VvyIv4OUugHzeZihIfsU=;
 b=mYy4AEEXnDfoZCEhrRRGSNq2xMQlFOuWEwHmfgsWQlTBLUDNw1hFE3olg1SZiv4CN7MFbXJ6PHIimyQn3Oio/5NWlkpzXHMEcIcm1H0MrxHr8fFcm1U1uCNf2iq+wDhpoV/o/67N+b4DCeInvWICPdOTBNJImTCbVAGGe4knfgx7sET925HFdp5nYN0LBJkSYnsvX8p3VYsw+0qOr2PB+kU9pxdYsER6lLu08ku1EMWEYg9JTIsUKWEnCU+KLBpBnfIkufjhuoMwN+X6sOusfUKDEzVG0jjF01WO3NUy8rJU6fvqCjgGRba698OnekpNM0omRdgk0Se/1vboEiBiPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqnijH+ykrHcfcL3brGAyT7VvyIv4OUugHzeZihIfsU=;
 b=lADPsFlzB8a6NJzmc0fLYfWrJKVUVDY8jZHJxe1HORKjgPFaozATisfu5Y0zn/tEVxNZKERLqIMG3mAw/MWSf6/EBfjyu7fOsa2AC0Zf2XL0elffLo/ey7eOFMkPQPMuslpokQARHr8g+wpiAFgjsoT7B9d/3eV++STjx07PGt0=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6969.eurprd04.prod.outlook.com (52.133.242.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Fri, 3 Jan 2020 07:01:50 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2602.012; Fri, 3 Jan 2020
 07:01:50 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Subject: RE: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Topic: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Index: AQHVuYmNemqdPRPEmEKC7Ncoej9h46fYjBDw
Date:   Fri, 3 Jan 2020 07:01:50 +0000
Message-ID: <DB8PR04MB69858081021729EC70216BE3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223120730.GO25745@shell.armlinux.org.uk>
In-Reply-To: <20191223120730.GO25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8be1926e-4f3b-47d2-f35c-08d7901aceaa
x-ms-traffictypediagnostic: DB8PR04MB6969:
x-microsoft-antispam-prvs: <DB8PR04MB6969D9180D9E6819C898CBB3AD230@DB8PR04MB6969.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0271483E06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(13464003)(199004)(189003)(186003)(316002)(6506007)(8936002)(8676002)(53546011)(966005)(5660300002)(4326008)(26005)(478600001)(52536014)(7696005)(86362001)(2906002)(81166006)(81156014)(71200400001)(66946007)(110136005)(66446008)(76116006)(54906003)(64756008)(66556008)(66476007)(33656002)(55016002)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6969;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UIhfJL7Dh/cOw9duPGpgEh5LgCQefkzSzieUCN+Ag6t1we4rH2AmayEmS9RplXuZb0NnD0t0phtiK0MdDwg8QedfRZVNa7NHo1yD2S60tgHTYDGkOt9vBUPnQn1kZ+kKXEnE3jqILHMCxA+aNfgX2/EN8mGqbRZFDnz+2HAINbBgwE8Q/A33XiA9N0YzJA9yRYbahH26XsZjcNJwk/1cqoEwc75bK/Nqpho5hpvF3h12NyqwH6FvFeCMeyDb955qP4RZ7KQTcZqeUjqz3p6wPoJKEV+IQYd5mmNj/5rbIYV7Zv5B47I1nux+lKaDfPhuI5f/X9gpT2J08HdG3RLbhOA6va7fHeodaoCgYulbuDcQ0CdF5iXgueuyh/wPYtKlGC/Mfi2pcnibmQP+3dvOXSnJiQdPSkorQ8oGkBjqKqGdh590Y6q4zquj0L8+uEU0Eib6tY0nWSMTXDKfqb8nAz8qiEYputapdWb/2ZHq+jYTn3UbNDpueUQTWRrBdxNGsCT/JI6xDJ3JmCIEj8WYSIZJ5GrtFmCHnD2J3M95jFc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be1926e-4f3b-47d2-f35c-08d7901aceaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2020 07:01:50.5301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hojtso3hKaGxTA7QdaF6h0BZkhYIF8ZfI2lcDeTUSbFX+p8XN08QZCGHBUGGvYRNsp/6nNrzMB/oASLNqpBDVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6969
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Monday, December 23, 2019 2:08 PM
> To: Madalin Bucur <madalin.bucur@nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; andrew@lunn.ch;
> f.fainelli@gmail.com; hkallweit1@gmail.com; shawnguo@kernel.org;
> devicetree@vger.kernel.org
> Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
>=20
> On Thu, Dec 19, 2019 at 06:32:51PM +0000, Madalin Bucur wrote:
> > 10GBase-R could be used as a common nominator but just as well 10G and
> > remove the rest while we're at it. There are/may be differences in
> > features, differences in the way the HW is configured (the most
> > important aspect) and one should be able to determine what interface
> > type is in use to properly configure the HW. SFI does not have the CDR
> > function in the PMD, relying on the PMA signal conditioning vs the XFI
> > that requires this in the PMD.
>=20
> I've now found a copy of INF-8077i on the net, which seems to be the
> document that defines XFI. The definition in there seems to be very
> similar to SFI in that it is an electrical specification, not a
> protocol specification, and, just like SFI, it defines the electrical
> characteristics at the cage, not at the serdes. Therefore, the effects
> of the board layout come into play to achieve compliance with XFI.

I think we're missing the point here: we need to start from the device
tree and that is supposed to describe the board, the hardware, not to
configure the software. Please re-read the paragraph above in this key:
the device tree needs to describe the HW features, those electrical
properties you are discussing above. The fact that we use a certain
protocol over it, by choice in software, does not change the HW and it
should not change the device tree describing it.

> Just like SFI, XFI can be used with multiple different underlying
> protocols. I quote:
>=20
>   "The XFI interface is designed to support SONET OC-192,
>   IEEE.Std-802.3ae, 10GFC and G.709(OTU-2) applications."
>=20
> Therefore, to describe 10GBASE-R as "XFI" is most definitely incorrect.
> 10GBASE-R is just _one_ protocol that can be run over XFI, but it is
> not the only one.

Exactly why the chip to chip interface described by the device tree needs
to be xfi not 10GBASE-R, that would really only provide information on the
PCS block that we're not featuring in device trees. Here's a rehash of
Ethernet nomenclature sourced from [1]:

Data rate (R):
  1000 =1B$B"*=1B(B 1000 Mbps or 1 Gbps; Megabit unit is eliminated in the =
data rate reference
  10G =1B$B"*=1B(B 10 Gbps
  10/1G =1B$B"*=1B(B 10 Gbps downstream, 1 Gbps upstream
Modulation type (mTYPE): BASE =1B$B"*=1B(B Baseband
Medium types / wavelength / reach (L):
  B =1B$B"*=1B(B Bidirectional optics, with downstream (D) or upstream (U) =
asymmetric qualifiers
  C =1B$B"*=1B(B Twin axial copper
  D =1B$B"*=1B(B Parallel single mode (500 m)
  E =1B$B"*=1B(B Extra-long optical wavelength =1B$B&K=1B(B (1510/1550 nm) =
/ reach (40 km)
  F =1B$B"*=1B(B Fiber (2 km)
  K =1B$B"*=1B(B Backplane
  L =1B$B"*=1B(B Long optical wavelength =1B$B&K=1B(B (~1310 nm) / reach (1=
0 km)
  P =1B$B"*=1B(B Passive optics, with single or multiple downstream (D) or =
upstream (U) asymmetric qualifiers, as well as eXternal sourced coding (X) =
of 4B/5B or 8B/10B
  RH =1B$B"*=1B(B Red LED plastic optical fiber with PAM16 coding and diffe=
rent transmit power optics
  S =1B$B"*=1B(B Short optical wavelength =1B$B&K=1B(B (850 nm) / reach (10=
0 m)
  T =1B$B"*=1B(B Twisted pair
PCS coding (C):
  R =1B$B"*=1B(B scRambled coding (64B/66B)
  X =1B$B"*=1B(B eXternal sourced coding (4B/5B, 8B/10B)
Number of Lanes (n):
  Blank space without lane number =1B$B"*=1B(B defaults as 1-lane
  4 =1B$B"*=1B(B 4-lanes=20

There were no clear names attributed to the interfaced between the blocks
that make up the PHY, the PCS, PMA, PMD. When the MII was the clear
separation point, it was enough to describe the MII type and that was
the initial set of values for the device tree parameter: RGMII, SGMII,
XGMII. One can argue that the correct value still is XGMII, as that is
the real MAC-PHY interface for 10G. Unfortunately, as this interface
does not map to the chip to chip interfaces on our HW, it provides little
to no information on the HW. This is the reason I say we need to describe
the HW.=20

> As for CDR, INF-8077i says:
>=20
>   "The XFP module shall include a Signal Conditioner based on CDR (Clock
>   Data Recovery) technology for complete regeneration."
>=20
> Whereas for SFP modules, SFF-8472 revision 11.4 added optional support
> for CDR on the modules.
>=20
> In any case, the CDR is a matter for the module itself, not for the
> host, so it seems that isn't relevent.
>=20
> Everything that I've said concerning SFI in my previous email (in date
> order), and why we should not be defining that as a phy_interface_t
> seems to also apply to XFI from what I've read in INF-8077i, and it
> seems my original decision that we should not separately define
> XFI and SFI from 10GBASE-R is well founded.
>=20
> Given that meeting these electrical characteristics involves the
> effects of the board, and it is impractical for a board to switch
> between different electrical characteristics at runtime (routing serdes
> lanes to both a SFP+ and XFP cage is impractical due to reflections on
> unterminated paths) I really don't see any reason why we need two
> different phy_interface_t definitions for these.  As mentioned, the
> difference between XFI and SFI is electrical, and involves the board
> layout, which is a platform specific issue.

The signal integrity issues you mention are real but there are solutions
for that, there are high speed mezzanine connectors that allow that level
of flexibility.

[1] https://www.synopsys.com/designware-ip/technical-bulletin/ethernet-dwtb=
-q117.html
