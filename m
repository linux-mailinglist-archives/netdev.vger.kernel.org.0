Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2C6882CA
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfHISmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:42:46 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:38700 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726168AbfHISmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:42:45 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2C2B3C0163;
        Fri,  9 Aug 2019 18:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565376165; bh=K+Ju2gPuCehEKIyfh6UlJ5KLRuCLHJ5H1HbXwNtlER0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=OCw/86PkLPQuWw5HBJ/a0enmjDPBha6f+e7WJSna9jV2BFnCl+zJ1qMl7+YW7a4Br
         9/eK0lvNMfkmNF1THQk7HImZamfoRbkZCq6AFSG5hYP8XLhymgbMPm8M8CfCRmpIg8
         IptcMfE8buZXFzy0XOg2NJzXwMPyNuxhv/xbrc7tAW8Ao2Wxv45j/5KWTeOri4SL5C
         Seqm+/CpWhxhjpqnnA4AZMTiOy7YQcPE5Hw9v8mONh9RRbu6jQNaoE8mQNxC7cvZn4
         hNVTlgZ0rlV9+s+X58ZLTQbw3sqQghzMz28oJ6/kdH133rfHu90IWFKKBXoEAseKtj
         tFVwuPt0ZGb5A==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 74D54A006A;
        Fri,  9 Aug 2019 18:42:41 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 9 Aug 2019 11:42:41 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 9 Aug 2019 11:42:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqnlL1Sev2+WNzjT840jA+nv2KAorddWgawObvKRHIAYf2oloPoBhcIwOA9VMkoGPTj2W5YQk4WnsrqevzIRKncQ4F4gdddUiOBh/7zbfHfgN98zORVMM9nLU5QA04aCHzDJt3LDhTwzob8YYHwIx+7nWtYk1HvV/HLbkaZScwv/ZgYxBwLu2PWRyHEclvkPEu/goOz2M0QfOuiqXSCI8eNE9DMIqlipeQqr6m6Dx6J3WxSAJMx9G2iGtxZKIybIGErdVCNlckEOW7dl926HQ0P9g73n9kgMhGudZEPmVgltbGVFSs7LVRqH6V4c/EKw2Be2vhvagq5Fh0Whf2ssHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2rUOJdjlfjcYatqCydicbMyiNxaouKLslJlahn5KTQ=;
 b=fxAuqjUzaoCT/guf8okU47TTBcmxL/pCcoBHP6ILjuQ+B9yrCEVi4wHVvtc+OduvLaA3hsztPuLlehk+qeFGatL2kLb8g0WJLvVs/XrtY/XrNzvtR1vyCZzdNwljl0XRv7tnVseQThEf2V9E6MrPow0pu8RmiFfdC/hmAt53pIbSkOyT6ZXdTAvsqj4KqfVE2h1+aVi+XWO59p8kmP9Z0F9jfdggtSAYJzuKEt4/6UV7tU8eIX/Y+2nIK5IOMqfePPGcO9gXewQhLuXUqiMIv+xQugOV7uy2CQnSeHRaOIXVLSMNG8TA3N6f7jt8zY6yXbDkJJ955VBGr1wkLlksUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2rUOJdjlfjcYatqCydicbMyiNxaouKLslJlahn5KTQ=;
 b=ewcSlCxbwFzJvwxNfPgC5/2i7uMp+1K2HT1qQ2xfq+84WEUo2z59P13v7z8Mm9S9KLxz2pbSyiOcnTQp7uhbr4Rp9Qiw8JpwH+mo+p23tfzhimWVa21XrFO19TZDEd6yrwHI6mtiyAo7B/dRd+iOA2gqmXLWVgAaouIzvE35LWg=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3537.namprd12.prod.outlook.com (20.179.67.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Fri, 9 Aug 2019 18:42:39 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 18:42:39 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: Clause 73 and USXGMII
Thread-Topic: Clause 73 and USXGMII
Thread-Index: AdVNNhg1/QU8BXytSDGOHsr0Lj0BgQAi2zcgAABcxwAAARYrkAAA5YOAAAKokGAAAyIbgAA/11sw
Date:   Fri, 9 Aug 2019 18:42:39 +0000
Message-ID: <BN8PR12MB32664B2DE18A30311A19E5B8D3D60@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <BN8PR12MB32662070AAC1C34BA47C0763D3D40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN8PR12MB3266A710111427071814D371D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190808082626.GB5193@shell.armlinux.org.uk>
 <BN8PR12MB32665E5465A83D5E11C7B5D6D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190808092313.GC5193@shell.armlinux.org.uk>
 <BN8PR12MB3266DF4F017FCB03E6ED8097D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190808120903.GF5193@shell.armlinux.org.uk>
In-Reply-To: <20190808120903.GF5193@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3aa420d-ce6a-4421-7513-08d71cf95b21
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR12MB3537;
x-ms-traffictypediagnostic: BN8PR12MB3537:|BN8PR12MB3537:
x-ms-exchange-transport-forked: True
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BN8PR12MB35372F0CD55721B089C1BC0BD3D60@BN8PR12MB3537.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(136003)(346002)(396003)(39860400002)(199004)(189003)(52536014)(76116006)(305945005)(9686003)(14444005)(7736002)(4326008)(5660300002)(6306002)(8676002)(66946007)(66476007)(66556008)(64756008)(66446008)(81166006)(81156014)(478600001)(7116003)(71190400001)(446003)(11346002)(8936002)(486006)(476003)(256004)(6636002)(71200400001)(66066001)(229853002)(99286004)(74316002)(19627235002)(55016002)(966005)(76176011)(7696005)(25786009)(33656002)(316002)(14454004)(110136005)(6506007)(102836004)(186003)(26005)(54906003)(6116002)(86362001)(53936002)(6246003)(3846002)(2906002)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3537;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EXVB02sHLD2XGfMDlmoPTBWUAppYQwXywpYSOtialxvLTkKQBHwEOdgw3nprkI8MYLGrMHWSZHVs+ge/7Oxx/fH/tkUkLt71Ub8paDdLipj1lLbm2zTkizW6U/g4npNdgSXy3ZNRXxwFizvxod4DyMS5jsLnu0PE0SflhysXZ9vmcDkj/ai+WtGLijxigZH4bq5RQtpfzyz0CgDan83kiiWQaaV88V6PSDUR9RHd+ON4FfS2GjlqwS3G4wGqz4npNsVwyVx9Awd444f8vQrHPnLg0HFoeuetjCtI3cKH0t+hvJqhsb9OoQ6GEFa/DI2L4g+kVT51V1ng9zMA6Uz1sFeNAFNs1Rw9hId9Fh+g2rzyGBYa05O0u1SompAcHApeLKzVtXmhw1y0cCveuiBBADsRbHGqejPhQCIn+qKySv8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f3aa420d-ce6a-4421-7513-08d71cf95b21
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 18:42:39.6858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7sDxgGya4eLWpFMuahEgk2LWZR9j+WMIv+ZVkDsy8S+qZfxJxpzr+PrjspkqHbHDB0pG5Mcf4awOQsYbYdv5Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3537
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Aug/08/2019, 13:09:03 (UTC+00:00)

> On Thu, Aug 08, 2019 at 11:45:29AM +0000, Jose Abreu wrote:
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Date: Aug/08/2019, 10:23:13 (UTC+00:00)
> >=20
> > > On Thu, Aug 08, 2019 at 09:02:57AM +0000, Jose Abreu wrote:
> > > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > Date: Aug/08/2019, 09:26:26 (UTC+00:00)
> > > >=20
> > > > > Hi,
> > > > >=20
> > > > > Have you tried enabling debug mode in phylink (add #define DEBUG =
at the
> > > > > top of the file) ?
> > > >=20
> > > > Yes:
> > > >=20
> > > > [ With > 2.5G modes removed ]
> > > > # dmesg | grep -i phy
> > > > libphy: stmmac: probed
> > > > stmmaceth 0000:04:00.0 enp4s0: PHY [stmmac-1:00] driver [Synopsys 1=
0G]
> > > > stmmaceth 0000:04:00.0 enp4s0: phy: setting supported=20
> > > > 00,00000000,0002e040 advertising 00,00000000,0002e040
> > > > stmmaceth 0000:04:00.0 enp4s0: configuring for phy/usxgmii link mod=
e
> > > > stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config:=20
> > > > mode=3Dphy/usxgmii/Unknown/Unknown adv=3D00,00000000,0002e040 pause=
=3D10=20
> > > > link=3D0 an=3D1
> > > > stmmaceth 0000:04:00.0 enp4s0: phy link down usxgmii/Unknown/Unknow=
n
> > >=20
> > > This shows that the PHY isn't reporting that the link came up.  Did
> > > the PHY negotiate link?  If so, why isn't it reporting that the link
> > > came up?  Maybe something is mis-programming the capability bits in
> > > the PHY?  Maybe disabling the 10G speeds disables everything faster
> > > than 1G?
> >=20
> > Autoneg was started but never finishes and disabling 10G modes is=20
> > causing autoneg to fail.
> >=20
> > >=20
> > > > [ Without any limit ]
> > > > # dmesg | grep -i phy
> > > > libphy: stmmac: probed
> > > > stmmaceth 0000:04:00.0 enp4s0: PHY [stmmac-1:00] driver [Synopsys 1=
0G]
> > > > stmmaceth 0000:04:00.0 enp4s0: phy: setting supported=20
> > > > 00,00000000,000ee040 advertising 00,00000000,000ee040
> > > > stmmaceth 0000:04:00.0 enp4s0: configuring for phy/usxgmii link mod=
e
> > > > stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config:=20
> > > > mode=3Dphy/usxgmii/Unknown/Unknown adv=3D00,00000000,000ee040 pause=
=3D10=20
> > > > link=3D0 an=3D1
> > > > stmmaceth 0000:04:00.0 enp4s0: phy link down usxgmii/Unknown/Unknow=
n
> > > > stmmaceth 0000:04:00.0 enp4s0: phy link up usxgmii/2.5Gbps/Full
> > > > stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config:=20
> > > > mode=3Dphy/usxgmii/2.5Gbps/Full adv=3D00,00000000,00000000 pause=3D=
0f link=3D1=20
> > > > an=3D0
> > > >=20
> > > > I'm thinking on whether this can be related with USXGMII. As link i=
s=20
> > > > operating in 10G but I configure USXGMII for 2.5G maybe autoneg out=
come=20
> > > > should always be 10G ?
> > >=20
> > > As I understand USXGMII (which isn't very well, because the spec isn'=
t
> > > available) I believe that it operates in a similar way to SGMII where
> > > data is replicated the appropriate number of times to achieve the lin=
k
> > > speed.  So, the USXGMII link always operates at a bit rate equivalent
> > > to 10G, but data is replicated twice for 5G, four times for 2.5G, ten
> > > times for 1G, etc.
> > >=20
> > > I notice that you don't say that you support any copper speeds, which
> > > brings up the question about what the PHY's media is...
> >=20
> > I just added the speeds that XPCS supports within Clause 73=20
> > specification:
> > Technology Ability field. Indicates the supported technologies:
> > 	A0: When this bit is set to 1, the 1000BASE-KX technology is supported
> > 	A1: When this bit is set to 1, the 10GBASE-KX4 technology is supported
> > 	A2: When this bit is set to 1, the 10GBASE-KR technology is supported
> > 	A11: When this bit is set to 1, the 2.5GBASE-KX technology is supporte=
d
> > 	A12: When this bit is set to 1, the 5GBASE-KR technology is supported
> >=20
> > And, within USXGMII, XPCS supports the following:
> > 	Single Port: 10G-SXGMII, 5G-SXGMII, 2.5G-SXGMII
> > 	Dual Port: 10G-DXGMII, 5G-DXGMII
> > 	Quad Port: 10G-XGMII
> >=20
> > My HW is currently fixed for USXGMII at 2.5G.
>=20
> So what do you actually have?
>=20
> +-----+              +----------+
> | STM |    USXGMII   | Synopsis |   ????????
> | MAC | <----------> |   PHY    | <----------> ????
> |     |     link     |          |
> +-----+              +----------+ (media side)
>=20
> Does the above refer to what the STM MAC and Synopsis PHY support for
> the USXGMII link?  What about the media side?

This is my setup:

XGMAC <-> XPCS <-> Xilinx SERDES <-> SFP

I'm not sure about the media side. I use a passive SFP cable if that=20
helps ...

>=20
> If you just tell phylink what the USXGMII part is capable of, there's
> no way for the media side to do anything unless it also supports the
> capabilities that the USXGMII link supports.
>=20
> phylink doesn't do any kind of translation of capabilities of the
> MAC-PHY link to media capabilities; this is why the documentation for
> the validate callback has this note:
>=20
>  * Note that the PHY may be able to transform from one connection
>  * technology to another, so, eg, don't clear 1000BaseX just
>  * because the MAC is unable to BaseX mode. This is more about
>  * clearing unsupported speeds and duplex settings.
>=20
> To put it another way - if the link between the MAC and PHY supports
> 10G speed, the MAC should indicate that _all_ 10G ethtool link modes
> that support 10G speed are set in the supported mask.  If the link
> supports 1G speeds, then all 1G ethtool link modes that can be
> supported irrespective of technology should be set.  This is because
> the capabilities of the overall setup is the logical union of the
> capabilities of each device in the setup.
>=20
> So, if, say, the USXGMII link can support 2.5Gbps, and the PHY
> supports copper media at 2.5Gbps via the NBASE-T specifications,
> then the system as a whole can support
> ETHTOOL_LINK_MODE_2500baseT_Full_BIT.  If the MAC decides to clear
> that bit, then the system can't support 2.5Gbps even if the PHY
> does.
>=20
> Maybe what we need to do with phylink is move away from exposing
> ethtool link modes to the MAC validate callback, and instead
> devise a way for the MAC to indicate merely the speeds and duplexes
> it supports without any of the technology stuff getting in the way.
>=20
> --=20
> RMK's Patch system: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A=
__www.armlinux.org.uk_developer_patches_&d=3DDwIBAg&c=3DDPL6_X_6JkXFx7AXWqB=
0tg&r=3DWHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=3DWXDOl4mhp4Xwg4de0KT=
KH9RNulfBLbkA6MQGZ1G9_FI&s=3DDbL6asfMKlMoCCeLhWoeBLrUQ0FSIrLkJCKoVbKVEQg&e=
=3D=20
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbp=
s up
> According to speedtest.net: 11.9Mbps down 500kbps up


---
Thanks,
Jose Miguel Abreu
