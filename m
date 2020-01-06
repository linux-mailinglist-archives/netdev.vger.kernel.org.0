Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6394F130F8A
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 10:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgAFJec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 04:34:32 -0500
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:44259
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725446AbgAFJeb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 04:34:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgCW7oxYjNczMIdea02SP9ycJvPuXZc/To895whQnrQ/mdcO/c+gIiRBgAMTj0qb2HTC/C1TfI5aCbfXhnRszr6kG8x4soRxmARXNF/joz1KjpNnFv2FYpQ5vpu/YTWniNz8B1+5akjzCtiHkHQWtXt/1lTxipen31F001/RXENmjM5SU48pbcTnOmDyYNpeVsel/27pB7ngfGpJiiQSz6i1fgT4lEc0of9AZld8y8vnHp6csfgEc0Du5wOfRM6BAqWUMmC60XlnLK6XXITBVvWGhopL64NK8dKY4nTWXhmVtb3qapAwg7OJ0gF6nx2Xo4ueLlPPcu0FHtEE77C6lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BGukoHNJO1IYEH9A4GrGlMgTKz0foqPmAt9hT6U9hg=;
 b=g2PYT4mAOuzmpIiKlL29p7/00za550iHpgfu8LZIB7nmgf6SW3x4rMPOESDVAp+EnSJsgRXfRrt/6yRWrKtKtAoC1ZfqZ2mM0RNQ1iXjqkiQPQqklCD83yODN9F8pqf39eit/JsATBrPrJ9rBDZKE4ubT5T2HM94xcnd0vZkR0KPamFlnOrARzk8jb/3qzC5a2SPTphDMKEF4YsimYDvzq52N2HhAXVDjhaDT6BBFeZH1u5EZPkK4w6SwcW+Q4bbWPsPxGqFlmMJVxOhKyLLvqTUDXdVIgo1z6sH/W/+3crvVCvZJ/rrTEtF2io2YiqMKYJ6YbwgPOMkgFRQq0tgiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BGukoHNJO1IYEH9A4GrGlMgTKz0foqPmAt9hT6U9hg=;
 b=cnjj3zlDMfYc+4H3ODWxciTBYTNoS3zlHzmkRTDZATqXEGISKNjd1vyvl4A3EJEq87lWTuHK9a8yIwRlxPbOM8xpQuJtLQ8ZlNPeAkwVZMvbO+zcn8OOBCIBQQKD1uzVFZ8v9LGFffvFQox/VvaskuCP91CQXP/oajn4vgfHMwo=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6988.eurprd04.prod.outlook.com (52.133.241.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Mon, 6 Jan 2020 09:34:26 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 09:34:26 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Subject: RE: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Topic: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Index: AQHVtoABZZFXn6n8UUGKWfe6RtVAuKfBtnoAgAAR9oCABd2qgIAQ9D0AgAAopQCAAAQgAIAAJ5UAgAANzwCAAAvMgIAAKI7wgAAVdICABDDPQA==
Date:   Mon, 6 Jan 2020 09:34:26 +0000
Message-ID: <DB8PR04MB6985C2E02037BA90F2479BD6EC3C0@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223120730.GO25745@shell.armlinux.org.uk>
 <DB8PR04MB69858081021729EC70216BE3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103092718.GB25745@shell.armlinux.org.uk>
 <20200103094204.GA18808@shell.armlinux.org.uk>
 <DB8PR04MB698591AAC029ADE9F7FFF69BEC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103125310.GE25745@shell.armlinux.org.uk>
 <20200103133523.GA22988@lunn.ch>
 <DB8PR04MB6985AD897CC0159E324DF992EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103171719.GM1397@lunn.ch>
In-Reply-To: <20200103171719.GM1397@lunn.ch>
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
x-ms-office365-filtering-correlation-id: 0444ade9-cec6-45a2-5e58-08d7928b9f59
x-ms-traffictypediagnostic: DB8PR04MB6988:|DB8PR04MB6988:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6988A8D6AC6D8CCA79C8E683AD3C0@DB8PR04MB6988.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(199004)(189003)(13464003)(9686003)(33656002)(4326008)(110136005)(54906003)(52536014)(478600001)(86362001)(55016002)(7696005)(66946007)(76116006)(5660300002)(66556008)(64756008)(66476007)(66446008)(71200400001)(966005)(53546011)(8676002)(81166006)(26005)(6506007)(2906002)(8936002)(186003)(316002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6988;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ia9xscAQvIa8ZwseiNjTUPHEj+tVzMD6TYDU7gMOy4rbpbkTJNBe1+QtZkt8mqBj9W719e16GLhAv1EhsoA7sVuXyQRjzZrBKbyAUD6G1lcWfCJnslNk8w7urWplgjOeDRfhyW7hSqfytQrHmDkExzeI/Vzv12elH573iwmU2jgihk/RzE1VMOPiNNeIApSGMSMVaGuX4m+94uSt10DrYISx5Rzn05j0rf3HQfDhDiFkue8tlwQLv7+P9Z58rQ8LZkij7uZw6W0xP7H7VZqp/Tqk4kl5V0PWamtpxtfVOg6a7WwMjanAGjOEEDfcYW3Ds2QGMNYg3lTMmF7kEqDE6pYZw1pho4S0ro06jZiqTsr4R2cSQYCUdHtleDnLBoX364xV+Woa9OqKl8O43Xw243KcSlzsMAXSpLObcbKngI8dJhTmmszi9BBsRmM8HDu9lyitdrYQ4XNTJWAEQ0S3FLZrvIwzEkA/+k7Id6HYXe++FcOngnTfIltgyYAU3wtU5EwdcNSxX9iJ+IamEvRzooixKjW9E5DPw7VIs669nj4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0444ade9-cec6-45a2-5e58-08d7928b9f59
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 09:34:26.5866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qJ1C/Q9rsjeEF4jqNZRThpOYslCqzjmmuDbnBGrCqWE3qPqX3MmTPH5rMayKkyswSvzsoQ63OuBNN8VORTIMCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6988
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, January 3, 2020 7:17 PM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>;
> devicetree@vger.kernel.org; davem@davemloft.net; netdev@vger.kernel.org;
> f.fainelli@gmail.com; hkallweit1@gmail.com; shawnguo@kernel.org
> Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
>=20
> > There are many things pushed down to u-boot so the Linux driver has
> less
> > work to do, that's one of the reasons there is little left there.
>=20
> I prefer barebox. Which is a problem, since it sounds like Ethernet
> will be broken on your boards if i swap to it.

It may be, but customers had success porting that support of various
other bootloaders. Most of this is loading the firmware and device-tree
fix-ups but there may be some minor tweaks of the platforms done in
u-boot that need porting.

> If you are going to offload setting up the hardware, please do it to
> firmware. That is independent of the bootloader. The Marvell SoCs do
> this for their low level SERDES setup, making SMC calls into the
> firmware.
>=20
> https://patchwork.kernel.org/cover/10880297/

Firmware has the (dis)advantage of usually being closed source, having
settings done in open source code makes everyone's life easier, but the
one's who needs to send that upstream :)
Firmware does allow any hacks to go unnoticed so it may be preferable by
some in that respect. Ideally it should all be done in the drivers, in
plain sight, imho.
=20
> > Ideally this dependency should be removed but then we'd need to make
> > a clearer distinction. As you've noticed, currently I don't even
> > need to distinguish XFI from SFI because for basic scenarios the
> > code does the same thing.  Problem is, if I select a common
> > denominator now, and later I need to make this distinction, I'll
> > need to update device trees, code, etc. Just like "xgmii" was just
> > fine as a placeholder until recently. I'd rather use a correct
> > description now.
>=20
> So it seems like you need two properties. You need a property to tell
> your bootloader how to configure the electrical properties of the
> SERDES, XFI, SFI, etc.

That's what the RCW (reset configuration word) does, it's the first thing
read from FLASH by the SoC on boot (you can consider it a sort of firmware)=
.

>=20
> And you need a property to configure the protocol running over the
> SERDES, which is phy-mode.
>=20
> 	Andrew

The protocol is clear and related to the speed, some other aspects we do
need to control, such as AN on the system interface, that we need to
disable for 2500Gbps Ethernet, or to know which PCS we need to talk to
in case of QSGMII and so on. Also many resources (FIFOs, internal controlle=
r
tasks, DMAs) are sized accordingly to the interface type by SW. The protoco=
l
is the least of my concerns here. I'm using the electrical interface type
to derive a series of parameters for the SW (including what PCS block I tal=
k
to). Used to be "xgmii" (incorrect), today it may be just as well "10gbase-=
kr"
(still incorrect), tomorrow it may be "10gbase-r" (incomplete, it says noth=
ing
about the HW) or "xfi" (sufficient for this particular HW, maybe incomplete=
 for
others). So we do need to decide if we are going to separate the HW/electri=
cal
description that has a place in the device tree and the SW configuration th=
at
has no place there.

Regards,
Madalin
