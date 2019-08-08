Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDD985DBD
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 11:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732047AbfHHJDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 05:03:06 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:56742 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731065AbfHHJDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 05:03:04 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0E8CEC0AC5;
        Thu,  8 Aug 2019 09:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565254984; bh=hWnK+Bj7ir/cb80VTS9JdPRVCU4mgizctb4+sVWShGg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=dQOM7kySPAM+eg12010i++YsN/2FqCqPkaxCrT5zCeKnLk96qRJqQPEbOZVLTKy+0
         STYQVeSA/eNITLH3O7vFZJPFMEE3l5LwnSBXT3WF6ZHaKgzI2GzkcU8FIBKAUXtcB0
         FBdfGbEqUkpN8iS0rrDwPkAGFC9oIAkXxjaB92g4gCoWsbJ5nj2nBcTbYY/b/KgdKf
         a4+uwh0qyUVmKmVADLjAOIAE21AP7W7cp3J9lIFunpUWJx23mhARKw0dMQqZMUY1qP
         NcgO4SHXW2vPbuXoSk/YIuuUZSXwXXcRHTkWfvFOdSzT2La6BrCDu52c7bm3mZ4pn4
         ds9CC9ibxOb2w==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id DFD94A007F;
        Thu,  8 Aug 2019 09:02:59 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 8 Aug 2019 02:02:59 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 8 Aug 2019 02:02:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUS3AxsdvyKjUpwHQyV43NUJ/rzzdFDygXi/qEalSphfUx77xHgs3L2wQTNyo8razU+OrwyCd97bBxMiU5AeP8adMIsAhOd7ZUF6FbLl7hF7p5TbUoDi9X1tKNCrunwqAu1u10TD9Lvn2EhIhKswQVqDwQIAXbPsqNwtus5BGurIwthxCvvnORYzyUvtc73QuFDAhDQl3DZ7PpvQ9aiJENxhOBJiK0XjCiFIAmZNGmaBCQi72xSyx0f47S0sqxQ6n64IQSFFACN0MLHhOHwTGPu/sWS6+YHbxlO405Kadbtp8IcDd+IPl/wPKaUmdK8A5M/jGAadqBu1Eo1VLHE/Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zogs83DtLKCC62bR09cO2H8TUbIUdTo+AlBZSgemtC0=;
 b=fwDaXuhbtVpM6Kda7Qu/Blr0xtq6P9xn0E71BexmWwEdygvAgjQ1+LSLKRhorPtwka7hag5VPV6VwF/Mn2ETyLxfPvKouf6QAZVZfCY4Vk33wIe5jEB4Uj0qno0ysdq/k6ncEEy6Aza2lxL1vQlNKakfzVJCg8Z7Vx2xXZvvjcygjz7Dig0HW0uhxZQ2RBHE/tZnwpJT0FHrt7oQ2b4PgLU+5e5uZYSL58L2GahdSQFYdA84yJLNDPNYSjVDm8YA1cVuc+O84TkN8EDSv4Sl3m93xu+ci95yV2zXVG2ZztyucQTVTdMiJ5iMm3+RT41QwpGEfKnP0dF5t8F5KXYokA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zogs83DtLKCC62bR09cO2H8TUbIUdTo+AlBZSgemtC0=;
 b=h8PG2C0dLigb7VV/dXph/hGVksQCAiuqO4LXaQyZ4DQCJnenJYX9XCr2+kQXR9fbPT/kBg5NtZNJC0QkPNi8jaxcn6XtOkdHIvo71zdtrruhUKWiSw1qf6fR2edEzVrjqK0h7/naWx/BFmijm6mhR3kZR06G+136uJZRC8qdiv0=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3411.namprd12.prod.outlook.com (20.178.211.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Thu, 8 Aug 2019 09:02:57 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c%5]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 09:02:57 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: Clause 73 and USXGMII
Thread-Topic: Clause 73 and USXGMII
Thread-Index: AdVNNhg1/QU8BXytSDGOHsr0Lj0BgQAi2zcgAABcxwAAARYrkA==
Date:   Thu, 8 Aug 2019 09:02:57 +0000
Message-ID: <BN8PR12MB32665E5465A83D5E11C7B5D6D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <BN8PR12MB32662070AAC1C34BA47C0763D3D40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN8PR12MB3266A710111427071814D371D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190808082626.GB5193@shell.armlinux.org.uk>
In-Reply-To: <20190808082626.GB5193@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48b5508f-3840-4eae-76ad-08d71bdf351e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3411;
x-ms-traffictypediagnostic: BN8PR12MB3411:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BN8PR12MB34117165955C5CC93A4E23E5D3D70@BN8PR12MB3411.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(346002)(366004)(376002)(199004)(189003)(71190400001)(71200400001)(229853002)(86362001)(66946007)(66476007)(74316002)(66556008)(64756008)(66446008)(446003)(11346002)(476003)(486006)(54906003)(76116006)(6436002)(8676002)(7116003)(5660300002)(19627235002)(52536014)(14444005)(256004)(305945005)(316002)(7736002)(33656002)(25786009)(102836004)(6506007)(14454004)(3846002)(6116002)(76176011)(81166006)(81156014)(7696005)(99286004)(26005)(186003)(8936002)(966005)(478600001)(9686003)(55016002)(6306002)(4326008)(6916009)(66066001)(53936002)(6246003)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3411;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Mu4l54CX0W5165B9vkwSBTqwHTcGHbdBUeSL1gC/vQ3HVHf7J/w1jne6RLxWf6greX38cEXXZU/QRDocOi+BrOvrg+yCHUYc/G3zBs7/lDwpmEbvyTNA6YjYFgQGQ4rJeSMZmgoOK+YSbFa4+nc5v1exsp+8n4VY6RnVmjsJ0GYhisqeME2fB1VtBL5nkwn7/hi9IqkXGLtM9ASiyTK9aqdCpOy8HgHTjm8XXpVrX/YatvEL6SUX6UQvUDBhDwFdwVpAX40D6kI8CNmlahsPBNgkXazHL6EN0zaQN/iG4al89oW0dxYax/orup5NlpPQNsx1MynsOAwhg6SAziaQ+ia5PvF/fdnbcxUVuO8HvDkfQD4dsGAsAMLDLbF0bvqwau+scvoI9digNst5UTYuA1Gs/aNCxINbR2mLAoLq7zA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 48b5508f-3840-4eae-76ad-08d71bdf351e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 09:02:57.7511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ojh+/d62yJfmDT5EpTNa36bAPjyQ9QRtL5339fT4O6CQVec75S5tXM2JsfnMkmNyTY7tHV31NPXfjYOHQ9fHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3411
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Aug/08/2019, 09:26:26 (UTC+00:00)

> Hi,
>=20
> Have you tried enabling debug mode in phylink (add #define DEBUG at the
> top of the file) ?

Yes:

[ With > 2.5G modes removed ]
# dmesg | grep -i phy
libphy: stmmac: probed
stmmaceth 0000:04:00.0 enp4s0: PHY [stmmac-1:00] driver [Synopsys 10G]
stmmaceth 0000:04:00.0 enp4s0: phy: setting supported=20
00,00000000,0002e040 advertising 00,00000000,0002e040
stmmaceth 0000:04:00.0 enp4s0: configuring for phy/usxgmii link mode
stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config:=20
mode=3Dphy/usxgmii/Unknown/Unknown adv=3D00,00000000,0002e040 pause=3D10=20
link=3D0 an=3D1
stmmaceth 0000:04:00.0 enp4s0: phy link down usxgmii/Unknown/Unknown

[ Without any limit ]
# dmesg | grep -i phy
libphy: stmmac: probed
stmmaceth 0000:04:00.0 enp4s0: PHY [stmmac-1:00] driver [Synopsys 10G]
stmmaceth 0000:04:00.0 enp4s0: phy: setting supported=20
00,00000000,000ee040 advertising 00,00000000,000ee040
stmmaceth 0000:04:00.0 enp4s0: configuring for phy/usxgmii link mode
stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config:=20
mode=3Dphy/usxgmii/Unknown/Unknown adv=3D00,00000000,000ee040 pause=3D10=20
link=3D0 an=3D1
stmmaceth 0000:04:00.0 enp4s0: phy link down usxgmii/Unknown/Unknown
stmmaceth 0000:04:00.0 enp4s0: phy link up usxgmii/2.5Gbps/Full
stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config:=20
mode=3Dphy/usxgmii/2.5Gbps/Full adv=3D00,00000000,00000000 pause=3D0f link=
=3D1=20
an=3D0

I'm thinking on whether this can be related with USXGMII. As link is=20
operating in 10G but I configure USXGMII for 2.5G maybe autoneg outcome=20
should always be 10G ?

> On Thu, Aug 08, 2019 at 08:17:29AM +0000, Jose Abreu wrote:
> > ++ PHY Experts
> >=20
> > From: Jose Abreu <joabreu@synopsys.com>
> > Date: Aug/07/2019, 16:46:23 (UTC+00:00)
> >=20
> > > Hello,
> > >=20
> > > I've some sample code for Clause 73 support using Synopsys based XPCS=
=20
> > > but I would like to clarify some things that I noticed.
> > >=20
> > > I'm using USXGMII as interface and a single SERDES that operates at 1=
0G=20
> > > rate but MAC side is working at 2.5G. Maximum available bandwidth is=
=20
> > > therefore 2.5Gbps.
> > >=20
> > > So, I configure USXGMII for 2.5G mode and it works but if I try to li=
mit=20
> > > the autoneg abilities to 2.5G max then it never finishes:
> > > # ethtool enp4s0
> > > Settings for enp4s0:
> > > 	Supported ports: [ ]
> > > 	Supported link modes:   1000baseKX/Full=20
> > > 	                        2500baseX/Full=20
> > > 	Supported pause frame use: Symmetric Receive-only
> > > 	Supports auto-negotiation: Yes
> > > 	Supported FEC modes: Not reported
> > > 	Advertised link modes:  1000baseKX/Full=20
> > > 	                        2500baseX/Full=20
> > > 	Advertised pause frame use: Symmetric Receive-only
> > > 	Advertised auto-negotiation: Yes
> > > 	Advertised FEC modes: Not reported
> > > 	Speed: Unknown!
> > > 	Duplex: Unknown! (255)
> > > 	Port: MII
> > > 	PHYAD: 0
> > > 	Transceiver: internal
> > > 	Auto-negotiation: on
> > > 	Supports Wake-on: ug
> > > 	Wake-on: d
> > > 	Current message level: 0x0000003f (63)
> > > 			       drv probe link timer ifdown ifup
> > > 	Link detected: no
> > >=20
> > > When I do not limit autoneg and I say that maximum limit is 10G then =
I=20
> > > get Link Up and autoneg finishes with this outcome:
> > > # ethtool enp4s0
> > > Settings for enp4s0:
> > > 	Supported ports: [ ]
> > > 	Supported link modes:   1000baseKX/Full=20
> > > 	                        2500baseX/Full=20
> > > 	                        10000baseKX4/Full=20
> > > 	                        10000baseKR/Full=20
> > > 	Supported pause frame use: Symmetric Receive-only
> > > 	Supports auto-negotiation: Yes
> > > 	Supported FEC modes: Not reported
> > > 	Advertised link modes:  1000baseKX/Full=20
> > > 	                        2500baseX/Full=20
> > > 	                        10000baseKX4/Full=20
> > > 	                        10000baseKR/Full=20
> > > 	Advertised pause frame use: Symmetric Receive-only
> > > 	Advertised auto-negotiation: Yes
> > > 	Advertised FEC modes: Not reported
> > > 	Link partner advertised link modes:  1000baseKX/Full=20
> > > 	                                     2500baseX/Full=20
> > > 	                                     10000baseKX4/Full=20
> > > 	                                     10000baseKR/Full=20
> > > 	Link partner advertised pause frame use: Symmetric Receive-only
> > > 	Link partner advertised auto-negotiation: Yes
> > > 	Link partner advertised FEC modes: Not reported
> > > 	Speed: 2500Mb/s
> > > 	Duplex: Full
> > > 	Port: MII <- Never mind this, it's a SW issue
> > > 	PHYAD: 0
> > > 	Transceiver: internal
> > > 	Auto-negotiation: on
> > > 	Supports Wake-on: ug
> > > 	Wake-on: d
> > > 	Current message level: 0x0000003f (63)
> > > 			       drv probe link timer ifdown ifup
> > > 	Link detected: yes
> > >=20
> > > I was expecting that, as MAC side is limited to 2.5G, I should set in=
=20
> > > phylink the correct capabilities and then outcome of autoneg would on=
ly=20
> > > have up to 2.5G modes. Am I wrong ?
> > >=20
> > > ---
> > > Thanks,
> > > Jose Miguel Abreu
> >=20
> >=20
> > ---
> > Thanks,
> > Jose Miguel Abreu
> >=20
>=20
> --=20
> RMK's Patch system: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A=
__www.armlinux.org.uk_developer_patches_&d=3DDwIBAg&c=3DDPL6_X_6JkXFx7AXWqB=
0tg&r=3DWHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=3D1MdSlPrmzsMMCJbbLcD=
YTNuPq1njfusBRjcRz3UD4Dg&s=3D_30hwSYkGf9DfyCG48mnh7lXP8iiULXpfAP_6agUJno&e=
=3D=20
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbp=
s up
> According to speedtest.net: 11.9Mbps down 500kbps up


---
Thanks,
Jose Miguel Abreu
