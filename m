Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A009319ADB8
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732943AbgDAOVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:21:36 -0400
Received: from mail-eopbgr140073.outbound.protection.outlook.com ([40.107.14.73]:5351
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732205AbgDAOVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 10:21:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1rruNO3/pMXmzna3M9oic47i5Lfx3/wwxOIsF7i2rY8OFqAA0VhGkF5lNwciPVMxHEv+HbH0PN1tbxFk9FSr9BhnpHxtcGBDMqjjVMeYLKOUo9D1BOKtIWG4TITp+mpAFu5JyZ7E6e9NTnxRMTn2KZf+zdjUuduY0wr5ZKA+mUntN6OYnQyyHvdyUspZtjRnhn4KNvwLvStK9dPjWERe4QgpvjN1F04L+q69Xtt7z/TPukda45AseGNawTSFDOeWLN8zBQCa4FfFoDrfT3qs+sILW56zfXjj7GUadVLzf04hJj3/uBB2g3c7Np6EMLpWSG0e8NypX3ZACK0zpQamw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jz0BGOXq0nHgoApsMEmTwGe561EMm73LmRro4EnDCk=;
 b=g3Pmf1VJL6yroo3e/XdxAvlZJWXFzUTZTjydodprk4E5fBy9wDVd+SyUpvZXaoH99hU1M3bzfozq7XjRbxznAqZ4Al4K7e17LsA9Ea9H9nbbmzvuIHRSLdaKPnDishu8Lm1R6QIzkorfibNP4+n34aHrKwuRbNRmjOWumFbjN30Er3ErOwRRvJsSB+jMQdd0bJhqfwy9IAiaLwLkKfqSMUNsi/4WaASiZ9yXiX3U/sy6pWmTJTEtiQlC9NjTRCHY0S2Ay77q3iHNYUFeT6JDuvhkOl+P4ZYsiYkQiH4cizb3PNx7elT/g13uZm9LQihKbQ1H8f+zJZkAT0I67IfiRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jz0BGOXq0nHgoApsMEmTwGe561EMm73LmRro4EnDCk=;
 b=Z+AKAFs0X3gZUBU0p7FJDPifHOZVA/Zy9dj3K509cxk/vTFisC8Z0vUTda8uPm2wehx983TTnPhTB/9C9wSywkj66gp0wURTGdFC8wO28ekOXeueDf1fS+/27SB152bMBnthkS8qv7q6oWyiJIw69wKCntsuyxLeFNH70tBkUz8=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (20.178.114.161) by
 AM0PR04MB4467.eurprd04.prod.outlook.com (52.135.151.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Wed, 1 Apr 2020 14:21:28 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::ccc:be36:aaf0:709a]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::ccc:be36:aaf0:709a%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 14:21:28 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next 6/9] net: phy: add backplane kr driver
 support
Thread-Topic: [EXT] Re: [PATCH net-next 6/9] net: phy: add backplane kr driver
 support
Thread-Index: AdYIKJUsx3bt4MTYS3+XcE5ss4tWhQABBMuAAAD8oPA=
Date:   Wed, 1 Apr 2020 14:21:28 +0000
Message-ID: <AM0PR04MB544389A6B2400335A23E4960FBC90@AM0PR04MB5443.eurprd04.prod.outlook.com>
References: <AM0PR04MB5443E8D583734C98C54C519EFBC90@AM0PR04MB5443.eurprd04.prod.outlook.com>
 <20200401135135.GA62290@lunn.ch>
In-Reply-To: <20200401135135.GA62290@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
x-originating-ip: [78.96.99.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 27154afd-1b07-40ef-088b-08d7d647f7f7
x-ms-traffictypediagnostic: AM0PR04MB4467:|AM0PR04MB4467:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB4467866B87E436E12388D466FBC90@AM0PR04MB4467.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(6506007)(52536014)(71200400001)(64756008)(44832011)(9686003)(66446008)(26005)(2906002)(5660300002)(66556008)(186003)(66946007)(55016002)(76116006)(66476007)(7696005)(86362001)(81156014)(33656002)(316002)(478600001)(8936002)(81166006)(8676002)(7416002)(54906003)(6916009)(4326008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: udNBqA06JfHPR6bmj4Mm0lbv4MqDe1+H338TOYdGX4jY4K0Fvf1q335DW5VEeXFsvErRoy+eOk7ZqWvY17+O/Yd2nlhBxPiKXkMT1NULsd0l3T4k8fCbevBE4MUIEqLe0O851PKrdMn2SDmrVlBxWspnXfuzJ0PhYU2c/HwgxsO5lH0JLamLQ1DbIDerIWbkJxMNX+g9kdQYmtjyO7txbcoxV21pOHtt3tkOd0Jyg6jDQD66FXEYdZq7/fY3Sa4NquGE4snYWf6pD4peyRKqGQf0S8u69tDJtLPIk++pn+mv/MvMWnwvPKy/xpijuw3r3QUo8pneIFqkRSCOg5c57fzl2H9O7drsphtVQdn/gONYF+RlRpbwhjDTzB4YumqLxnIse+KbElsBZm7crM7s4xQwbPdULI+ftKGZNB57HQ4NMZCyQQHEDWBGNBFxlSD3
x-ms-exchange-antispam-messagedata: JoVljybq5WNWUA+6z/8kmxem5FQhw3KOVvZLIYEN0ylMgsSE8BH/M3biPDzqwVZb8HBIyi29coOU6pjOTPdQQqmR/PX8Z1MYlMBwaD7X4tw/vUekPVu0bgANgnfwLcysA0+E43ngJphBqv0OSlDrvA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27154afd-1b07-40ef-088b-08d7d647f7f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2020 14:21:28.6459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cmpjOhrcc+f55ML+ibivQdedK8D6DNVaR4pRjPvxdi9GxwDMqeeWLqWEpQiUm6FlcGUHegIHj5+Bh2tq0jukgPKWdY2894ap5TXn+McNOxU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4467
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, Apr 01, 2020 at 01:35:36PM +0000, Florinel Iordache wrote:
> > > On Thu, Mar 26, 2020 at 03:51:19PM +0200, Florinel Iordache wrote:
> > > > +static void setup_supported_linkmode(struct phy_device *bpphy) {
> > > > +     struct backplane_phy_info *bp_phy =3D bpphy->priv;
> > >
> > > I'm not sure it is a good idea to completely take over phydev->priv
> > > like this, in what is just helper code. What if the PHY driver needs
> > > memory of its own? There are a few examples of this already in other
> > > PHY drivers. Could a KR PHY contain a temperature sensor? Could it
> > > contain statistics counters which need accumulating?
> > >
> > >         Andrew
> >
> > Backplane KR driver allocates memory for structure backplane_phy_info
> > which is saved in phydev->priv. After all this is the purpose of priv
> > according to its description in phy.h: <<private data pointer For use
> > by PHYs to maintain extra state>>. Here the priv is used to maintain
> > extra state needed for backplane. This way the backplane specific data
> > becomes available for all PHY callbacks (defined in struct phy_driver)
> > that receive a pointer to phy_device structure. This initial version
> > doesn't include accumulating statistics counters but we have in plan
> > to add these in future versions. The counters will be kept in specific
> > structures as members of the main backplane data mentioned above and
> > entire support will be integrated with ethtool.
>=20
> Hi Florinel
>=20
> And what about hwmon, or anything else which a driver needs memory for?
>=20
> As far as i see it, we have two bodies of code here. There is a set of he=
lpers
> which implement most of the backplane functionality. And then there is an
> example driver for your hardware. In the future we expect other drivers t=
o be
> added for other vendors hardware.
>=20
> phydev->priv is for the driver. helpers should not assume they have
> complete control over it.
>=20
> Anyway, this may be a mute point. Lets first solve the problem of how a P=
CS is
> represented.
>=20
>   Andrew

Hi Andrew,

Backplane driver was designed as a generic backplane driver over
the PHY Abstraction Layer, containing standard implementations over
which several specific devices can be added.
(please see the diagram existent in chapter: Ethernet Backplane support
architecture, in the Documentation/networking/backplane.rst)
So according to this design, the backplane driver can use the priv pointer
provided by the layer below which is the PHY to be used as extra state
by the next upper layer which is generic backplane. On the same concept
we can provide another priv pointer in backplane main structure which is
equivalent to phy_device to be used by the specific backplane drivers on
the upper layer.
Actually for this reason, in v2 which I am currently working, I already
renamed the structure 'backplane_phy_info' to 'backplane_device'

Thank you,
Florin.
