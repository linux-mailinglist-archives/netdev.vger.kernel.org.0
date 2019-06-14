Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D82EA462B1
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbfFNP1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:27:35 -0400
Received: from mail-eopbgr60069.outbound.protection.outlook.com ([40.107.6.69]:54599
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725951AbfFNP1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 11:27:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+H8zWYboVCAJCbhyZI9lDfU55BqKQm520nfnwrdjpc=;
 b=kPpDxBYErDs6O/Z1+gZJHT4Mg3O1UZNQMsN/Fm6EOt681a65tS0UaC3y2yGQ3tDY5H/6UuNCXQx6UNL9tc8WvrxkFcBlwtjdYv32Z6r+jcnxuEOwCN4WGoH7l167JwREUCc35iyftzTPQwO8im/qX7kDg6uMYhIF99Dvajpzwuk=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3519.eurprd04.prod.outlook.com (52.134.4.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Fri, 14 Jun 2019 15:26:50 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188%3]) with mapi id 15.20.1987.012; Fri, 14 Jun 2019
 15:26:50 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: RE: [PATCH RFC 0/6] DPAA2 MAC Driver
Thread-Topic: [PATCH RFC 0/6] DPAA2 MAC Driver
Thread-Index: AQHVIkOgplQrO8lQ6EKT7iwFb8kSXaaa5m0AgABLgFA=
Date:   Fri, 14 Jun 2019 15:26:50 +0000
Message-ID: <VI1PR0402MB2800BBC003EA7C572FBEF09DE0EE0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <20190614094228.mg5khguayhwdu5rh@shell.armlinux.org.uk>
In-Reply-To: <20190614094228.mg5khguayhwdu5rh@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e220bde8-ae8d-4b99-a27e-08d6f0dcb8d1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3519;
x-ms-traffictypediagnostic: VI1PR0402MB3519:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB35194BA566E2EAFA34C84092E0EE0@VI1PR0402MB3519.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(346002)(366004)(39860400002)(376002)(199004)(189003)(186003)(66476007)(73956011)(64756008)(76116006)(66556008)(66446008)(446003)(66946007)(6246003)(71190400001)(71200400001)(33656002)(4326008)(476003)(486006)(86362001)(256004)(81166006)(11346002)(8936002)(44832011)(81156014)(8676002)(25786009)(52536014)(7736002)(305945005)(14444005)(66066001)(5660300002)(26005)(2906002)(6506007)(6116002)(3846002)(229853002)(102836004)(478600001)(53936002)(9686003)(99286004)(54906003)(68736007)(74316002)(6306002)(14454004)(6436002)(316002)(7696005)(6916009)(76176011)(561944003)(55016002)(966005)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3519;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ux1rAIuWRdFEE1YizEymyI5sT6AXW70tm9Xiw/9pQIqN+xfHLD+iA3JUWkY4O5WruA/l/h9NIIAURtpcumTMFxKpa97xaHpYWvaI5aZNFy/JCgQ7O//ixXqQeOAOD4PH2M5V+K+D73e/3omwepNQlENO8KsbWrR061gt8RpJbLjMEufO0ZFPbF2CYX5CQWuJP2sHPJAKStA774s30KUFYBiAfzpKUHeFGRL2OwalD5yFfkQ2EKoaMaMv44SIPHl1chv1brXSSRKOra7IIOrTzImfX2crH6cdkOcT/E9qXlTZtld688H7hdVRdgEuf9Z8H8hKSPwSJwaFMjO3l10/chIZNEUVpV28HfJR8/9iRZ/oLJQMDFcmDNpnMPzP7skN3/ZWpM/e0kLQw69zMquL4G+S2eNpt7iTOB1KRWvoCwY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e220bde8-ae8d-4b99-a27e-08d6f0dcb8d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 15:26:50.2800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3519
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH RFC 0/6] DPAA2 MAC Driver
>=20
> On Fri, Jun 14, 2019 at 02:55:47AM +0300, Ioana Ciornei wrote:
> > After today's discussion with Russell King about what phylink exposes
> > in
> > .mac_config(): https://marc.info/?l=3Dlinux-netdev&m=3D156043794316709&=
w=3D2
> > I am submitting for initial review the dpaa2-mac driver model.
> >
> > At the moment, pause frame support is missing so inherently all the
> > USXGMII modes that rely on backpressure applied by the PHY in rate
> > adaptation between network side and system side don't work properly.
> >
> > As next steps, the driver will have to be integrated with the SFP bus
> > so commands such as 'ethtool --dump-module-eeprom' will have to work
> > through the current callpath through firmware.
>=20
> From what I understand having read the doc patch, would it be fair to say
> that every operation that is related to the link state has to be passed f=
rom
> the ETH driver to the firmware, and then from the firmware back to the
> kernel to the MAC driver?

That is correct.

>=20
> Does this mean that "ethtool --dump-module-eeprom" goes through this
> process as well - eth driver into firmware, which then gets forwarded out=
 of
> the formware on the MAC side, via phylink to the SFP cage?
>=20
> If that is true, what is the proposal - to forward a copy of the EEPROM o=
n
> module insertion into the firmware, so that it is stored there when anyon=
e
> requests it?  What about the diagnostic monitoring that is real-time?
>=20

At the moment, we do not have a proposal that could solve all these issues.
We thought about a solution where the eth driver issues a command to the fi=
rmware that then issues an IRQ to the mac driver which could retrieve and t=
hen pass back the information.
This doesn't seem too feasible since the ethernet driver should be waiting =
for the data to arrive back from the firmware while in an ethtool callback.


> Or is the SFP cage entirely handled by firmware?

No, the SFP cage is not handled by firmware.

>=20
> > This poses somewhat of a problem, as
> > dpaa2-eth lacks any handle to the phy so it will probably need further
> > modification to the API that the firmware exposes (same applies to
> > 'ethtool --phy-statistics').
>=20
> This again sounds like the eth driver forwards the request to firmware wh=
ich
> then forwards it to the mac driver for it to process.
>=20
> Is that correct?

Correct.

>=20
> >
> > The documentation patch provides a more complete view of the software
> > architecture and the current implementation.
> >
> > Ioana Ciornei (4):
> >   net: phy: update the autoneg state in phylink_phy_change
> >   dpaa2-mac: add MC API for the DPMAC object
> >   dpaa2-mac: add initial driver
> >   net: documentation: add MAC/PHY proxy driver documentation
> >
> > Ioana Radulescu (2):
> >   dpaa2-eth: add support for new link state APIs
> >   dpaa2-eth: add autoneg support
> >
> >  .../freescale/dpaa2/dpmac-driver.rst               | 159 ++++++
> >  .../device_drivers/freescale/dpaa2/index.rst       |   1 +
> >  MAINTAINERS                                        |   8 +
> >  drivers/net/ethernet/freescale/dpaa2/Kconfig       |  13 +
> >  drivers/net/ethernet/freescale/dpaa2/Makefile      |   2 +
> >  .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |  83 +++-
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   | 541
> +++++++++++++++++++++
> >  drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h   | 107 ++++
> >  drivers/net/ethernet/freescale/dpaa2/dpmac.c       | 369
> ++++++++++++++
> >  drivers/net/ethernet/freescale/dpaa2/dpmac.h       | 210 ++++++++
> >  drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h    |  35 ++
> >  drivers/net/ethernet/freescale/dpaa2/dpni.c        |  70 +++
> >  drivers/net/ethernet/freescale/dpaa2/dpni.h        |  27 +
> >  drivers/net/phy/phylink.c                          |   1 +
> >  14 files changed, 1612 insertions(+), 14 deletions(-)  create mode
> > 100644
> > Documentation/networking/device_drivers/freescale/dpaa2/dpmac-
> driver.r
> > st  create mode 100644
> > drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> >  create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
> >  create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.c
> >  create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.h
> >
> > --
> > 1.9.1
> >

