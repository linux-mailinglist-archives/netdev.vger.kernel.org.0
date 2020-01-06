Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D9A131459
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 16:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgAFPDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 10:03:50 -0500
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:6030
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726303AbgAFPDu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 10:03:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JcFKoSwIIPNcXd3LrD6is7j5I3OqcpiFs7+aeD2TjpEz0FLMoPVcv9uifYbeBXWD+52EmvcAd39+yIKsSbUbFIZY5EKLDni4HkdxPT89/A+KYyz87Mf9nNdGjb+cSNXC650qx/LVLaJdrxl5CTO9fAGzpcAlHg9CkV9Tph2qh5Ekurdem3Y8UaqIQ/2QMWlzM5fv+VcSFa0a/o4YjtSTG5ixkeI2OF5Sij8aIRi1tA7znskwrQwoKQCpty++q4frvcEfRWInNQbsYeTzEYVQbZ8UUF4DJf8/w3Kr8v93TwVMnAWxvj61Loe61CUjHdn3CbouSLPXdNv+byBFfbZ35w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79qbcmq44EdXCv9P/W4VoPwa7jLjnHIkVr+Hj5j62G4=;
 b=fuJiLmj9OWFgtcV4CU1EAksNobGiLfmdAMjq/bCfkrMB6cNhVJOQvtLzrbXRk5vc5hC4rOR66ETFdQJZmLiMJ23VrN2vV8FI/cJsZodzI/SZGBU+FF3OMLdhZ8tdb09mTcMWub8EVJyzOlYyyKus/2Gk1XH2aamFo6IBd5pmShPRl3tyrcybD5bT8l/AfMdLpnaTU5KKqysght8HpxIfaXw5rJQq7WBHHsLQxIt/KQM6XXtnKAIFVHykOFE8oTKE1dPSBR+MpIOMVIUWZJaBjPiLekaTAWLyjKz1NoP5Ct4tJdSbKcn8L2IfEJEmGD7UAgeZUev4AwShffGc5sidiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79qbcmq44EdXCv9P/W4VoPwa7jLjnHIkVr+Hj5j62G4=;
 b=NBgZXr/ibeZcwHarAQ92bmx7fYH3pTMVAXLYcqotc7GN4UE9lIuQK9KX4KAfoSN+2dB1YukYBgUik/8JJJIWvkcJc6SWtDIVv86FNPin8Vt8s0P/Txg5GUUI9wIq9PvfnftDb9pCVpf05xWM9vHpc0/PKUAUBFCMWruxWDyHPhY=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB5657.eurprd04.prod.outlook.com (20.179.9.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Mon, 6 Jan 2020 15:03:44 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 15:03:44 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Subject: RE: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Topic: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Index: AQHVtoABZZFXn6n8UUGKWfe6RtVAuKfBtnoAgAAR9oCABd2qgIAQ9D0AgAAopQCAAAQgAIAAJ5UAgAANzwCAADOTgIAAFvEAgAQ2y6CAAEfMgIAAB5uA
Date:   Mon, 6 Jan 2020 15:03:44 +0000
Message-ID: <DB8PR04MB69858BB3EE29A90D0A74BDA3EC3C0@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223120730.GO25745@shell.armlinux.org.uk>
 <DB8PR04MB69858081021729EC70216BE3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103092718.GB25745@shell.armlinux.org.uk>
 <20200103094204.GA18808@shell.armlinux.org.uk>
 <DB8PR04MB698591AAC029ADE9F7FFF69BEC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103125310.GE25745@shell.armlinux.org.uk>
 <DB8PR04MB6985FB286A71FC6CFF04BE50EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103171952.GH25745@shell.armlinux.org.uk>
 <DB8PR04MB698500B73BDA9794D242BEDAEC3C0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200106135759.GA23820@lunn.ch>
In-Reply-To: <20200106135759.GA23820@lunn.ch>
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
x-ms-office365-filtering-correlation-id: 4634a033-6ffe-4d99-de9e-08d792b9a021
x-ms-traffictypediagnostic: DB8PR04MB5657:|DB8PR04MB5657:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB56579ACAFAB5061126E78442AD3C0@DB8PR04MB5657.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(13464003)(189003)(199004)(2906002)(26005)(66476007)(66556008)(64756008)(66946007)(66446008)(33656002)(6506007)(53546011)(54906003)(110136005)(5660300002)(7696005)(186003)(86362001)(316002)(81156014)(81166006)(9686003)(8936002)(8676002)(55016002)(52536014)(4326008)(71200400001)(478600001)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB5657;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 23//WWyzDn4IJ8rosB+8zhHts2kkydVncM1kJcMe/9JCcPFZNAtPdPu0CIPtf9AHEhcHJ9G1nGKG+IboqaVBZG73Ducv7pedCMCqe+VvRcEjmunN1FZN66BdkgeR2Why7G/OMGkI/T4DscZmte0c/nyxL1H8YuOKBz7VJ5Ai5qph4hvDWBD5nppdbzr2eTML7J/iz1W7UB3y8Ky46VDqw7bYrrrlcrioy6ZrGuk23SVkxuZuOqdCRKGUNjO6yliyc9yCv/ylfFiJDz8Lt78VfMFSEihRloKPKOvVHxmr45TFfjB6LdrTm/3ffm2FdWLvAeHETjd42oUupAHbGxqWquuJjUa3moIrCj51X2ggIkCWacZeLXF6UqBtLzMA7+IWiY0Wuc6Tj96PzM9ZzdDgMS2T1bI0ClV3GDdvVKJEnMz8o/Zb4lGlk5/cMf03uSpZdndpHgYCCxRnx7ZyC9DEediHKNV8+pm7P62mxk1efZIODS6a/qTsoMFsX4HVq6Qe
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4634a033-6ffe-4d99-de9e-08d792b9a021
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 15:03:44.7900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2MrCIS3UwD+ZjRi/+w4QnPHYsryFBzolWAZhp+QOgfasa38NFynVkg6eTdwbzWA0wsw6P66AqwwmkgaiSV7hfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5657
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, January 6, 2020 3:58 PM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>;
> devicetree@vger.kernel.org; davem@davemloft.net; netdev@vger.kernel.org;
> f.fainelli@gmail.com; hkallweit1@gmail.com; shawnguo@kernel.org
> Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
>=20
> > You missed my argument about the device tree describing the HW (thus
> the
> > wires, electrical aspects too) and not configuring a certain protocol
> (the
> > device tree does not configure HW, it describes HW).
>=20
> Hi Madalin
>=20
> You have lots of different points here. I'm just picking out one.
>=20
> I would say this is a grey area. You need to ensure both devices on
> the XFI bus are using the same protocol. There are a few ways you
> could do this:
>=20
> The MAC and the PHY tells phylink what each is capable of, and phylink
> picks a common protocol.
>=20
> Leave it to the boot loader/firmware and cross your fingers.
>=20
> Make a design decision, this board will use protocol X, and put that
> in device tree. It is describing how we expect the hardware to be
> used.
>=20
> The Marvell SERDES interfaces are pretty generic. They can be used for
> SATA, USB3, or networking. But these are all protocols running on top
> of SERDES. So would you argue we cannot describe in device tree that
> one SERDES is to be used for USB and another for SATA?
>=20
>     Andrew

That's the case with the SERDES on most (all?) SoCs nowadays. I say we
need to describe them as they are used, which, if I believe the SoC
documentation authors, the PHY documentation authors, the board
documentation author, in my case it's XFI. If it were USB3, SATA, and
a description was needed, why should you not describe it as such? I
see a difference between the XFI and the protocol on top. Not much
data will come through a system if the eye diagram is not open, although
the protocol is the same. Unless you get both right, it does not work.
In my case, the 10GBASE-R part is implicit/redundant information, the
electrical part has the potential to add some information to it. On the
other hand, it's not like someone will solder there a different PHY and
hope it will work because it says "xfi" or it says "10gbase-r" somewhere.
There are a hundred other conditions to be met: voltages, power and reset
sequencing, clock frequencies and stability and so on. It was all taken
care by the board designer, we just need to describe it so that SW can
make the best use of it.

I wanted to describe the interfaces as close to the documentation a
developer adding support for a custom board would be likely to use.
For now a blind replace "xgmii" to "10gbase-r" would be enough to get
things going as they already are and avoid a warning in the AQR probing.
But I feel that we'd still be off from the best description we can
and the above mentioned developer would be left a bit puzzled by that.

I also have the concern that this device tree parameter started life
as an MII bus type enumerator and now we say it should describe the
protocol and only that. Sure, XFI is not an MII interface type, as
it's not aligned to the MAC-PHY interface but rather a PHY sub-block
interface but its frequent use by the industry I thought could warrant
a place for it in that list, unless we decide to build something better.

While we're at it, should we have XAUI, RXAUI there or 10GBASE-X4,
10GBASE-X2?

Madalin
