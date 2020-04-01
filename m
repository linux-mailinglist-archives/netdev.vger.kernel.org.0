Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF08F19AF6C
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 18:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732121AbgDAQJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 12:09:54 -0400
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:60750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbgDAQJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 12:09:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3URhhSqflaeOMmznQzujCK97cJP/XGJ75moSR5TGVtbh2EPnXLQ0XymlIZIGyPk4M1L9UwT7vkGP/Ssyhc4IwarYVUgY81Tau1Ejl7b/gv66Y9V2hk8hnmPKEYh89qmVpTrFx28RfHqWZrSSOwUfF755relYw2q1k0Zl+9grvhA94Zv5Bb5GMVRmi7yFrmdJ4BbEiaseu+/+Ck/ipzIslCeycT2gpRQVDeQS5XnxpAkPFx07hBCrvCapLd85TkOeWGBm32SEmCuZ5aF+u1WEPaPcSD+WbLyapL2UgPNujlDLZdyXwZh6PYuSelRZ1LNzBlSCLnKcJNiEknQbtFQBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPUWUm+ocYDBHkJ9iURrNLJ2xUQS9EcJILDOq0AlAqk=;
 b=lZ4CprPBdYe3ZlHRNJ++BjJv+6ji9XJy4bOXSsYc3uPv88lKDnnGMz+Ohleg2H9AMiw3SNHSHxr2z4AAcsLqWL/srXpdX4vBJlq8hV1gvZj35a7HBKrqKg4IEk5Y3S7psGi1PVIB4C87RD75Ttd5yuTEnAf9bUDUTBLS8uHxprcT8yly/yEXC1NRkzoNVx8HBTfZRpP/NLDReAl4KqcBN8RCk6qO4Y0rtIoHn7Ll/siRqmXt4ZTMECzCtrbYxWdYHSf0t4/065U7nvrlVzKn87WFf37B7hXnhNXjR8+nP7Dw+yrtnHf7C6dlvjVYwN5vW0KoLjl+lERALBuzwXNxrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPUWUm+ocYDBHkJ9iURrNLJ2xUQS9EcJILDOq0AlAqk=;
 b=hZiZ0+2B6mo0NyJ1PAt9oqPz2ilO9W6iecbV+ipQkKX93z/ToWUXAol/wX2cmWnq7ZsGsbOFcVaXQPZkte1gKAhgN08KQu4fpl75ZF5wky8TPOzDveE3OGozmtrjiGOaAAqiY7Q9Osyga5oOIqPx7c0QeefMRnVdE3dPNoCRoXk=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (52.133.240.149) by
 DB8PR04MB6857.eurprd04.prod.outlook.com (52.133.240.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Wed, 1 Apr 2020 16:09:50 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::e44e:f867:d67:e901]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::e44e:f867:d67:e901%2]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 16:09:50 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Baruch Siach <baruch@tkos.co.il>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shmuel Hazan <sh@tkos.co.il>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>
Subject: RE: [PATCH] net: phy: marvell10g: add firmware load support
Thread-Topic: [PATCH] net: phy: marvell10g: add firmware load support
Thread-Index: AQHWB4WZmiAHbtx9oEaZfhbuYbUB0ahkCkwAgAAyf4CAACtM0A==
Date:   Wed, 1 Apr 2020 16:09:50 +0000
Message-ID: <DB8PR04MB682824E5521062809F311778E0C90@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il>
 <DB8PR04MB6828927ED67036524362F369E0C90@DB8PR04MB6828.eurprd04.prod.outlook.com>
 <20200401130321.GA71179@lunn.ch>
In-Reply-To: <20200401130321.GA71179@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [5.12.96.237]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 631cc538-43ba-40ec-b146-08d7d6571b29
x-ms-traffictypediagnostic: DB8PR04MB6857:|DB8PR04MB6857:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB685764D8761F41F23859DC7AE0C90@DB8PR04MB6857.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6828.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(9686003)(478600001)(8676002)(55016002)(81156014)(8936002)(81166006)(44832011)(54906003)(5660300002)(186003)(86362001)(76116006)(71200400001)(6916009)(4326008)(64756008)(7696005)(6506007)(26005)(66446008)(66556008)(66946007)(66476007)(316002)(33656002)(2906002)(52536014);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NBTV0V7aVuw7BKIeAMi12K41srS89420k1EaW/fuWIqB2tl/Up7oDxdaGUXzH6LkMT5z0JNQR1MNCY4Jc0HqlyhJnNnwyhw3wkoeLPHUbvRuZaKlAgKVwQXvU/IFE/X2oHLn9JVwG+OijYPZn4formP12kCXuty0s1vzZoV5uwb9iCRoLAYZ277sKVVyr561o/mcrRPrDRJ1gCYHVwJm1402YIRfVfzrua8aHfLLAjyZMo+Y3yO+s1MYA3CGf8pkdj9/DhM2FU7WTPjIPivqoU5QPLBZ5ItigJnU+MVta0tksI+Arhs1ZXwrjzdZBvlMKlbXb0WedhfA45D+ke9wYwD1UMxeuWfpT4an3eQfsWLonVAB2/mSe+bkNnePMX9flqTURtMx2ybQKU4JDwngrxlm2eY9NnTbQUI8SbogPW07sGspgW/DEltfpcLy6M+f
x-ms-exchange-antispam-messagedata: 8rhWS26ZrfivTP4XhsmFGMD++n0ObIuUUAF93Ic5icnkjyRdYJS5hcRNN0Py+5A0pjB7zdhW4ad55brTxpu4foVYMyAHe6C1mtPqcmOsaSn58tiGHWqLmT4JJ+3Bwflgfo4zujehOn6dpO6gK9IaSQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631cc538-43ba-40ec-b146-08d7d6571b29
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2020 16:09:50.1514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 66NjAOWxju7ec83D/Nb04+CYyPMtDyxOjALGPK4SnLmo6bAAW7tUcgxpUM0JMs0CjYnWv/K2U+puE0muFjZudg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6857
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH] net: phy: marvell10g: add firmware load support
>=20
> Ioana
>=20
> > This is typically the case for Aquantia PHYs.
>=20
> The Aquantia is just odd. I would never use it as a generic example.
> If i remember correctly, its 'firmware' is actually made up of multiple p=
arts, only
> part of which is actual firmware. It has provisioning, which can be used =
to set
> register values. This potentially invalidates the driver, which makes ass=
umptions
> about reset values of registers. And is contains board specific data, lik=
e eye
> configuration.
>=20
> As i understand it, Aquantia customises the firmware for the specific PHY=
 on
> each board design.
>=20
> For a general purpose OS like Linux, this will have to change before we s=
upport
> firmware upload. We need generic firmware, which is the same everywhere, =
and
> then PHY specific blobs for things like the eye configuration. This basic=
 idea has
> been around a long time in the WiFi world. The Atheros WiFi chipsets need=
ed a
> board specific blod which contains calibration data, path losses on the b=
oard, in
> order that the transmit power could be tuned to prevent it sending too mu=
ch
> power out the aerial.
>=20
>     Andrew

I am just trying to understand the message, are we throwing our hands in th=
e air
and wait for the vendor to change its policy?

If we don't act on this, it doesn't mean that it's not a problem... it is, =
but it's the bootloader's.

Ioana

