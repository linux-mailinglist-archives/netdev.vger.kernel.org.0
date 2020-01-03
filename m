Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BF812FA7C
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 17:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgACQdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 11:33:11 -0500
Received: from mail-eopbgr20071.outbound.protection.outlook.com ([40.107.2.71]:30798
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727859AbgACQdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 11:33:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YF+QvPTD9qz/O59ny63qpK6ei41Nbgy/qDwnIvvQhdFWKMGFFFBuQ12LlAgLjOlPYso7V4OoxajVi9k5xQjlbQ6etJuXIy2aMftsRYfP/qzOFZfFzDFL+LtYuKPvZ29exph8RSlr4bgesjxWWDDiCViGa3aeDsHbA8VwjnpeI6mcnvS15qjJ2aocuZ/aDgUaZnsIJYaOnUR1qNyzL6IaMYWJ44A35x/mJE6bgSQYlljXrSsCJubmDzAwiKCULhAkmmRxfaL9nRtSHfw9SJxqi9p1MQwa904ajARenu6Hy8qdxzleptaQIBnaEIY36++n3p+dmmqe6kDpEz3LDVIOzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKad/MN/qIeVdRcc9n5TQGSzq55nLr8wNSqLS6D0qxw=;
 b=HKDezX5glif5o6MhDOxG3/vtmC88CQr7Vfh2vjoffXRkNg7WxEDTKfO9hytqv02Tkws+BPL5nMvghY+iBSKTXpYDlzYn1h1Z0RSIf8K+XSEnMwvg5wNvY41UBaFjnJECHl6By77/7DS9ZdjTyYhs5wY1ltyrSX8q99xnY3iAeIHRSeY2NPN550gJZewDu903Q4x/q8t7EnksNqkenhixML8kIWzxT3ZoAA9xjnrSlhh9XTjtdTgwaJhXEvU9gYu4z77dqsNGwfvORvdJMAGUH+dkWTWz2yY8Ux0snxoo3AAdKBwp7in9Knk74fB+QdWfjKSkcl+cqCWp53elE/Aw3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKad/MN/qIeVdRcc9n5TQGSzq55nLr8wNSqLS6D0qxw=;
 b=loFNkKeDVhEfAlMa022bT8ZuLc7DpfchGRfxCCfWlY/25nWUnS1crZsiPj0b6rER9uQsAUI0H5T/KKaf0tpuuUCi2vmfPZ8O9tijRNkDLW/lGPE92nCCS9N7nTvxBJxEFPWpqSUTKUYkmmBfThv08tvfJgrF/sbO7FeaMcitr0Q=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB5594.eurprd04.prod.outlook.com (20.179.8.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 3 Jan 2020 16:33:05 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2602.012; Fri, 3 Jan 2020
 16:33:05 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 0/2] Fix 10G PHY interface types
Thread-Topic: [PATCH net-next 0/2] Fix 10G PHY interface types
Thread-Index: AQHVwiwrxFflOt73iU6BRITH1hAO2KfY2OpQgAAj3oCAACKCoA==
Date:   Fri, 3 Jan 2020 16:33:05 +0000
Message-ID: <DB8PR04MB698518D97251CB15938279C3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <20200103115125.GC25745@shell.armlinux.org.uk>
 <DB8PR04MB698593C7DB07A82577562348EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103141743.GC22988@lunn.ch>
In-Reply-To: <20200103141743.GC22988@lunn.ch>
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
x-ms-office365-filtering-correlation-id: 23cd7f72-2718-4896-7e8b-08d7906a9c0c
x-ms-traffictypediagnostic: DB8PR04MB5594:|DB8PR04MB5594:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5594779108C607AC7B7D36BFAD230@DB8PR04MB5594.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0271483E06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(13464003)(199004)(189003)(7696005)(2906002)(86362001)(71200400001)(6506007)(9686003)(186003)(5660300002)(53546011)(55016002)(26005)(478600001)(966005)(81156014)(4326008)(316002)(66946007)(52536014)(66556008)(33656002)(54906003)(110136005)(8936002)(66446008)(8676002)(76116006)(81166006)(64756008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB5594;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:3;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fl1+152yTY2pShAAx6PRt1S9Tj7kmCoUVbRHkg3XhIBFeEtyksU06bEEMQsED7bw0sjCtObX4DEbpTyq3sGuLRFpdAId6VmuwT7MU+1N72+GiGdKJsm/MnvY7j9zzNj+i2MoePdAp8dDNagD8Ucm1NZScOdXQTVfAZyBtPMLp8rD414/WvwuxMvh1JG4GIKwQf7J7OaBqIwZAB9UYa/JYB8B/cPMspBMdy3f0ja3GLkQI7RsSuazwO9WXlceQD8onPNQ1q5hb/t35tSUim2e2zrjyDvzeQGjZ9I8Es5h3Y9SqeF9JDLtk1jE7zB5Sx5WWp2p+s0ftecM+2YowVDUXbfXTzvGPEcnHfWZDMPxv8v7pY1dIAjTRMnu3sXickmfVK5bb/GwZwA/N/uuXWYtVnwn04CHxyk6KRuo0EnoUsbjRzrqj8+G0OjMbCBDwICNb0FafDZqRlj1yJKdI6MZLh3cpDGrIyKu9UQbi/PSwmUCAgp7SzLvYaEwmrQp3LDZMDaZUv+8BQV+ZmN9fj2dkcvLpzNti5pxaGjcU/n+ILc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23cd7f72-2718-4896-7e8b-08d7906a9c0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2020 16:33:05.3091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3j/sFGPgV5jolCTWfJZjID/eLcYpSG8trqsqfjFAG8KRijQlUE5gkCAt9Ki3CkRmhdIB9uH+D4nI2iNAkahKwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5594
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, January 3, 2020 4:18 PM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>; Florian
> Fainelli <f.fainelli@gmail.com>; Heiner Kallweit <hkallweit1@gmail.com>;
> David S. Miller <davem@davemloft.net>; Jonathan Corbet <corbet@lwn.net>;
> Kishon Vijay Abraham I <kishon@ti.com>; linux-doc@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next 0/2] Fix 10G PHY interface types
>=20
> > Describing the actual interface at chip to chip level (RGMII, SGMII,
> XAUI,
> > XFI, etc.). This may be incomplete for people trying to configure their
> HW
> > that supports multiple modes (reminder - device trees describe HW, they
> do
> > not configure SW). More details would be required and the list would
> be...
> > eclectic.
>=20
> Hi Madalin
>=20
> Please forget the existing DT binding for the moment. Please describe
> what values you need to program into your hardware to make it
> work. Please don't use the existing DT naming when describing what you
> need. Maybe use the terms from the reference manual?

Here is a PHY family document mentioning XFI:

https://www.marvell.com/documents/o67oxbpfhwx806cawedj/

And here is a LS1046A SoC document that describes XFI and 10GBASE_KR:

https://www.mouser.com/pdfdocs/LS1046A.pdf

(see sections 3.10.3 and 3.10.4).

> Once we have a list, we can figure out what could be generic, what
> could be vendor specific, and how to describe it in ACPI, DT, etc.
>=20
> At LPC 2019, Claudiu and Vladimir talked about wanting to describe the
> eye configuration for some hardware. It would be interesting if there
> is any overlap. Aquantia also have some values used to configure the
> SERDES of their PHYs. I think this is a board specific binary blob
> which is loaded into the PHY as part of the firmware. That then limits
> their firmware to a specific board, which is not so nice. But does
> that also indicate that how the MAC is configured might also depend on
> how the PHY configures its electrical properties?
>=20
>     Andrew

There are several NXP engineers addressing related issues, there is a vast
networking SoC family to support, with a large set of features, ranging
from the tried and true PPC SoCs to the new and feature rich ARM based SoC
that boast 1/2.5/10/40G Ethernet, backplane, TSN and so on. The PHY area
is often an excursion outside the direct area of responsibility but we need
to do this to get the complete systems working. Often the PHYs we use are
not as well supported upstream as we'd need so we have to get involved.

Regards,
Madalin
