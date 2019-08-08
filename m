Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDEF86113
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 13:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfHHLpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 07:45:38 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:49592 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727649AbfHHLph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 07:45:37 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E357FC0144;
        Thu,  8 Aug 2019 11:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565264737; bh=BjDK0QVySYFjwMEezlSGOt1kVe3MUBopJiRUy7OiheA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=NGBuczfNdYJ5wYPoIssuzPwucIsq5XTOczQgKGQpr//bbtbqfGmYf9eMQ2IADSIgO
         xnXGQP0xjohtvFKBU26XJs1aRMmdA1TXnfA6Hxl8eyKNJJW6HmBh2o5O/nbCvlQfpu
         zFJM1VRlFrztlCBehHdi2dKVGRywEQ4mDAm3w05VNI/B9MWxRxzrR7VZ98EvUKXP+3
         5/u+/+408dL8MgIvOBURRCqsjGrApPnzjpMM+shDX/tquezVsDD+lYfEIc9oVoE+ZT
         PN6bDqOsSPbqd/ar31PNU+E7XVEj/cjJHMU4+xbrUxIvphQqbwL86q/I4yhCdySL51
         MnTHIO38jAFkQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 8D22DA0069;
        Thu,  8 Aug 2019 11:45:30 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 8 Aug 2019 04:45:30 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 8 Aug 2019 04:45:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuAPWk2U4poLCpYeWY8jGZpamPOo4IwpOFIRPaa7Xb5m9dIGgPASaEc/omLBO/UgFh8CPfpbN29jvOjguVEjZtlmY8lDHTqh4KRvpsWq8sB73CqYwHViuKnrwyEgWLNDxkIPJgHY+t+rvV7K5z0/qCNsfZw0AsXGZ9G4qHVWLwVu9o6lfNItP7z8DR6UWbaLe4SagayCouxlZvGPdJLGGOmOUwPkaoh5gr/LPiYD23x2p8LW25tqrg3G+8I9G7nlkseebGbyg4l7GTSjJK2E0xiCIhi1h+bXv5Kg64GwcdkxLV6P9NT64UlDk5tlA/7HihE7clmzB1jeOmfsrEfeRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/TzBgwCLRhq6TCFmcTMU9OrkHYgr8MNGTkVxO71Li8=;
 b=jj7pM61GHf5QjY11XQn2zwl/E7x+vKTkbhBS3fZyIzroHz055AhkbEcqEQTAD8vK638nwrkJ7qvaV6JIaNNc6GQoLW0DVE3cdDo61iOiQ7WGMv1L3yAJkC9jHVGGvWCGjKf+1AZ4WnLzvF/9+Em+R+OKoOR1Bg2s9dq03ACzkAyHOduKeVrQmdZUSiJa3kZB7svpFO8jC1HKaIO11Gt/avWSYtkcCsfYzB/SEzsOFJlfL7JXdela4IZ6bEiCGfkFL5k0kUVFNWsf07RHee7NyglSf0z4WhQ9HnPwJtFv/wYNeRqUeQ5PixuAJq+P3n1KFIpzfGfDbSyzCYvdCaKh5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/TzBgwCLRhq6TCFmcTMU9OrkHYgr8MNGTkVxO71Li8=;
 b=g/wOjlfrkMO6FI2xGZ0wrfNxTCSGTEfVm2WPndWO181BpqywZkacH1+yzm4FdZXlnQseIN0gn9uYpntjb19WXVqJiM9BdaNqCbdo0K4Hvd2l3VkXnWPBJCeBErDeyzKV20CLuT6F5FsHrgRc8NMwW+U+sOHa7VRHib4e24kwA/M=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3249.namprd12.prod.outlook.com (20.179.66.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Thu, 8 Aug 2019 11:45:29 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c%5]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 11:45:29 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: Clause 73 and USXGMII
Thread-Topic: Clause 73 and USXGMII
Thread-Index: AdVNNhg1/QU8BXytSDGOHsr0Lj0BgQAi2zcgAABcxwAAARYrkAAA5YOAAAKokGA=
Date:   Thu, 8 Aug 2019 11:45:29 +0000
Message-ID: <BN8PR12MB3266DF4F017FCB03E6ED8097D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <BN8PR12MB32662070AAC1C34BA47C0763D3D40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN8PR12MB3266A710111427071814D371D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190808082626.GB5193@shell.armlinux.org.uk>
 <BN8PR12MB32665E5465A83D5E11C7B5D6D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190808092313.GC5193@shell.armlinux.org.uk>
In-Reply-To: <20190808092313.GC5193@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4409e8a1-aa75-4caf-3a28-08d71bf5e959
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3249;
x-ms-traffictypediagnostic: BN8PR12MB3249:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BN8PR12MB3249FD4BFB284F3892179496D3D70@BN8PR12MB3249.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(39860400002)(376002)(396003)(366004)(199004)(189003)(26005)(66066001)(99286004)(256004)(19627235002)(229853002)(6116002)(66556008)(3846002)(2906002)(64756008)(66946007)(14444005)(6436002)(66476007)(66446008)(81156014)(81166006)(52536014)(8676002)(478600001)(14454004)(966005)(5660300002)(9686003)(6246003)(74316002)(6306002)(8936002)(55016002)(53936002)(25786009)(7736002)(316002)(4326008)(33656002)(305945005)(7116003)(446003)(54906003)(86362001)(476003)(11346002)(71200400001)(6506007)(76116006)(102836004)(6916009)(76176011)(186003)(7696005)(71190400001)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3249;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WWRvw/smLUl5gghgYrxqy+yYPZEKBQfX++tprSKHf7CZxQu0J1Ar2YMG41VvMeVIp2TtC1475rhrjBAByg+6XI2kGT4noWBA36dWGpPCX5WSV3kdvFP2hVWAt9TRvs5MYHsuKmLtMmJfOWenBzlandtZ/poK7d88GcWwCFKEr5AeJjjjH4M6o0F7d/m9/rXKrVWb8t0t5vrX54KtmipL1HrdB7XqprwNEIFEGeeTKQ8Mvr3LW151Pc7M4QwWYTDnWF3cjErJRH7lhlSi/Np/jeC2AbIUP6dtof5w57PPuTSb61QV1eYDM5srHthTaC+HTGCh1rgeFtV0whB1DSUPvFfYu0lcHxoQy0bsC5IR8X/BE2AMSc1w6n6uEDtptHS+3L0CnEl/O2xoEHXcHMBCmlKx6RsV+QoORraQX87876A=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4409e8a1-aa75-4caf-3a28-08d71bf5e959
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 11:45:29.0681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4wk8Kz5DoYTw+aZ5OqIjaGfJzpCPW3NxabGgeWwV1n4clyIP7yStpJBGTucZF3lrdi75xIN/lhYVCCtTUXDoeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3249
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Aug/08/2019, 10:23:13 (UTC+00:00)

> On Thu, Aug 08, 2019 at 09:02:57AM +0000, Jose Abreu wrote:
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Date: Aug/08/2019, 09:26:26 (UTC+00:00)
> >=20
> > > Hi,
> > >=20
> > > Have you tried enabling debug mode in phylink (add #define DEBUG at t=
he
> > > top of the file) ?
> >=20
> > Yes:
> >=20
> > [ With > 2.5G modes removed ]
> > # dmesg | grep -i phy
> > libphy: stmmac: probed
> > stmmaceth 0000:04:00.0 enp4s0: PHY [stmmac-1:00] driver [Synopsys 10G]
> > stmmaceth 0000:04:00.0 enp4s0: phy: setting supported=20
> > 00,00000000,0002e040 advertising 00,00000000,0002e040
> > stmmaceth 0000:04:00.0 enp4s0: configuring for phy/usxgmii link mode
> > stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config:=20
> > mode=3Dphy/usxgmii/Unknown/Unknown adv=3D00,00000000,0002e040 pause=3D1=
0=20
> > link=3D0 an=3D1
> > stmmaceth 0000:04:00.0 enp4s0: phy link down usxgmii/Unknown/Unknown
>=20
> This shows that the PHY isn't reporting that the link came up.  Did
> the PHY negotiate link?  If so, why isn't it reporting that the link
> came up?  Maybe something is mis-programming the capability bits in
> the PHY?  Maybe disabling the 10G speeds disables everything faster
> than 1G?

Autoneg was started but never finishes and disabling 10G modes is=20
causing autoneg to fail.

>=20
> > [ Without any limit ]
> > # dmesg | grep -i phy
> > libphy: stmmac: probed
> > stmmaceth 0000:04:00.0 enp4s0: PHY [stmmac-1:00] driver [Synopsys 10G]
> > stmmaceth 0000:04:00.0 enp4s0: phy: setting supported=20
> > 00,00000000,000ee040 advertising 00,00000000,000ee040
> > stmmaceth 0000:04:00.0 enp4s0: configuring for phy/usxgmii link mode
> > stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config:=20
> > mode=3Dphy/usxgmii/Unknown/Unknown adv=3D00,00000000,000ee040 pause=3D1=
0=20
> > link=3D0 an=3D1
> > stmmaceth 0000:04:00.0 enp4s0: phy link down usxgmii/Unknown/Unknown
> > stmmaceth 0000:04:00.0 enp4s0: phy link up usxgmii/2.5Gbps/Full
> > stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config:=20
> > mode=3Dphy/usxgmii/2.5Gbps/Full adv=3D00,00000000,00000000 pause=3D0f l=
ink=3D1=20
> > an=3D0
> >=20
> > I'm thinking on whether this can be related with USXGMII. As link is=20
> > operating in 10G but I configure USXGMII for 2.5G maybe autoneg outcome=
=20
> > should always be 10G ?
>=20
> As I understand USXGMII (which isn't very well, because the spec isn't
> available) I believe that it operates in a similar way to SGMII where
> data is replicated the appropriate number of times to achieve the link
> speed.  So, the USXGMII link always operates at a bit rate equivalent
> to 10G, but data is replicated twice for 5G, four times for 2.5G, ten
> times for 1G, etc.
>=20
> I notice that you don't say that you support any copper speeds, which
> brings up the question about what the PHY's media is...

I just added the speeds that XPCS supports within Clause 73=20
specification:
Technology Ability field. Indicates the supported technologies:
	A0: When this bit is set to 1, the 1000BASE-KX technology is supported
	A1: When this bit is set to 1, the 10GBASE-KX4 technology is supported
	A2: When this bit is set to 1, the 10GBASE-KR technology is supported
	A11: When this bit is set to 1, the 2.5GBASE-KX technology is supported
	A12: When this bit is set to 1, the 5GBASE-KR technology is supported

And, within USXGMII, XPCS supports the following:
	Single Port: 10G-SXGMII, 5G-SXGMII, 2.5G-SXGMII
	Dual Port: 10G-DXGMII, 5G-DXGMII
	Quad Port: 10G-XGMII

My HW is currently fixed for USXGMII at 2.5G.

>=20
> > > On Thu, Aug 08, 2019 at 08:17:29AM +0000, Jose Abreu wrote:
> > > > ++ PHY Experts
> > > >=20
> > > > From: Jose Abreu <joabreu@synopsys.com>
> > > > Date: Aug/07/2019, 16:46:23 (UTC+00:00)
> > > >=20
> > > > > Hello,
> > > > >=20
> > > > > I've some sample code for Clause 73 support using Synopsys based =
XPCS=20
> > > > > but I would like to clarify some things that I noticed.
> > > > >=20
> > > > > I'm using USXGMII as interface and a single SERDES that operates =
at 10G=20
> > > > > rate but MAC side is working at 2.5G. Maximum available bandwidth=
 is=20
> > > > > therefore 2.5Gbps.
> > > > >=20
> > > > > So, I configure USXGMII for 2.5G mode and it works but if I try t=
o limit=20
> > > > > the autoneg abilities to 2.5G max then it never finishes:
> > > > > # ethtool enp4s0
> > > > > Settings for enp4s0:
> > > > > 	Supported ports: [ ]
> > > > > 	Supported link modes:   1000baseKX/Full=20
> > > > > 	                        2500baseX/Full=20
> > > > > 	Supported pause frame use: Symmetric Receive-only
> > > > > 	Supports auto-negotiation: Yes
> > > > > 	Supported FEC modes: Not reported
> > > > > 	Advertised link modes:  1000baseKX/Full=20
> > > > > 	                        2500baseX/Full=20
> > > > > 	Advertised pause frame use: Symmetric Receive-only
> > > > > 	Advertised auto-negotiation: Yes
> > > > > 	Advertised FEC modes: Not reported
> > > > > 	Speed: Unknown!
> > > > > 	Duplex: Unknown! (255)
> > > > > 	Port: MII
> > > > > 	PHYAD: 0
> > > > > 	Transceiver: internal
> > > > > 	Auto-negotiation: on
> > > > > 	Supports Wake-on: ug
> > > > > 	Wake-on: d
> > > > > 	Current message level: 0x0000003f (63)
> > > > > 			       drv probe link timer ifdown ifup
> > > > > 	Link detected: no
> > > > >=20
> > > > > When I do not limit autoneg and I say that maximum limit is 10G t=
hen I=20
> > > > > get Link Up and autoneg finishes with this outcome:
> > > > > # ethtool enp4s0
> > > > > Settings for enp4s0:
> > > > > 	Supported ports: [ ]
> > > > > 	Supported link modes:   1000baseKX/Full=20
> > > > > 	                        2500baseX/Full=20
> > > > > 	                        10000baseKX4/Full=20
> > > > > 	                        10000baseKR/Full=20
> > > > > 	Supported pause frame use: Symmetric Receive-only
> > > > > 	Supports auto-negotiation: Yes
> > > > > 	Supported FEC modes: Not reported
> > > > > 	Advertised link modes:  1000baseKX/Full=20
> > > > > 	                        2500baseX/Full=20
> > > > > 	                        10000baseKX4/Full=20
> > > > > 	                        10000baseKR/Full=20
> > > > > 	Advertised pause frame use: Symmetric Receive-only
> > > > > 	Advertised auto-negotiation: Yes
> > > > > 	Advertised FEC modes: Not reported
> > > > > 	Link partner advertised link modes:  1000baseKX/Full=20
> > > > > 	                                     2500baseX/Full=20
> > > > > 	                                     10000baseKX4/Full=20
> > > > > 	                                     10000baseKR/Full=20
> > > > > 	Link partner advertised pause frame use: Symmetric Receive-only
> > > > > 	Link partner advertised auto-negotiation: Yes
> > > > > 	Link partner advertised FEC modes: Not reported
> > > > > 	Speed: 2500Mb/s
> > > > > 	Duplex: Full
> > > > > 	Port: MII <- Never mind this, it's a SW issue
> > > > > 	PHYAD: 0
> > > > > 	Transceiver: internal
> > > > > 	Auto-negotiation: on
> > > > > 	Supports Wake-on: ug
> > > > > 	Wake-on: d
> > > > > 	Current message level: 0x0000003f (63)
> > > > > 			       drv probe link timer ifdown ifup
> > > > > 	Link detected: yes
> > > > >=20
> > > > > I was expecting that, as MAC side is limited to 2.5G, I should se=
t in=20
> > > > > phylink the correct capabilities and then outcome of autoneg woul=
d only=20
> > > > > have up to 2.5G modes. Am I wrong ?
> > > > >=20
> > > > > ---
> > > > > Thanks,
> > > > > Jose Miguel Abreu
> > > >=20
> > > >=20
> > > > ---
> > > > Thanks,
> > > > Jose Miguel Abreu
> > > >=20
> > >=20
> > > --=20
> > > RMK's Patch system: https://urldefense.proofpoint.com/v2/url?u=3Dhttp=
s-3A__www.armlinux.org.uk_developer_patches_&d=3DDwIBAg&c=3DDPL6_X_6JkXFx7A=
XWqB0tg&r=3DWHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=3D1MdSlPrmzsMMCJb=
bLcDYTNuPq1njfusBRjcRz3UD4Dg&s=3D_30hwSYkGf9DfyCG48mnh7lXP8iiULXpfAP_6agUJn=
o&e=3D=20
> > > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 62=
2kbps up
> > > According to speedtest.net: 11.9Mbps down 500kbps up
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
0tg&r=3DWHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=3Dd_Og5QaTJOl1WoLi43Z=
AlCMajHnZp4mGg8Npwlaa2pk&s=3Dbs6ws6HmZNKiutYWGFPy1ztnEQBuhtWyjiE0Hr1_URo&e=
=3D=20
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbp=
s up
> According to speedtest.net: 11.9Mbps down 500kbps up


---
Thanks,
Jose Miguel Abreu
