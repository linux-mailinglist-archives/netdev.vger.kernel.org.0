Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB52E017B
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 12:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbfJVKD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 06:03:28 -0400
Received: from mail-eopbgr150054.outbound.protection.outlook.com ([40.107.15.54]:14209
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729388AbfJVKD1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 06:03:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mi6WpVCAk+hV9QDgtj//DkK94HCn5TclAU2cFFa9XY0wF8kM4d2+Z1Hy4WH3S+dlZZV2N/HxkbBruvMelfae7VtaMnC+3OKX91i3f0K2ftS9EakH6q+G6b8cXp+339yJkvfWjQ01RiX6hiQnMjLET+Y0p347AkcLDDjEP2rxX8t9nS25G5G292t5LgCj6/UTCqKVfhn1boVPvqKxNwzel5UNehdqrs9vR8zDltD39pbJqXnDTneg6hROuSjUZj/8FmHcW9PkMi8sZmShgcfK9OaRfxDlvc03VA1cBjR2arXXdLpxyP4h5E04IqT+unygk1EpBDjbrrlPzy/LJX5hMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bX84pvDjch2WJYnEBo548iUiyapg7EOWY5pxkTwEPBw=;
 b=nW/A3htTpeceF1dKw6A1B3++x9lmpKVLOUkE5EmbrsWx3KXuhdX3VGHNBMh1wzqQTCmlg1kARA/85H/fTYuHw6jkb9BatAq45DpZm8lGE2QaCG8fPsXIpbINGrgxku8HTo9bROrcI9pI8mXAOOR/UXSw73qlpBKHyWakT4cVkckyLae2Xw2JJ46g7hVMnVMFcREMfljrQjTv93X3tO8dQCyOHj7/vIJtlK1hzGGOQ3PGEYUgI/fQxhJgTl/QOWfMKhWSjfrrT5+vQcjaLFw6knW4ltphYe76YoQ1EOGyE5lWv/f+pBJaniFTHQZLh3OpTrYhIUvUV/lf2YVysgORNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bX84pvDjch2WJYnEBo548iUiyapg7EOWY5pxkTwEPBw=;
 b=BZ8QGYB5WqFqLEENwKaJd+Z5AFNs5xKxNjtFso5l4M9kSXZ2eu70a88cm2g3oEHc+zA8NAOFDS9ZPxZ3q7Lbt8NPJRMOnbXG/Ng4Ix2YBszhqN4L+9kTKh03YgEnhJOD1flWr6Kt1iKEfx5nCyG514kb/vmwoUZ0ea98vGIV0f8=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2909.eurprd04.prod.outlook.com (10.175.20.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Tue, 22 Oct 2019 10:03:07 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2367.022; Tue, 22 Oct
 2019 10:03:06 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: RE: [PATCH net-next 4/4] net: documentation: add docs for MAC/PHY
 support in DPAA2
Thread-Topic: [PATCH net-next 4/4] net: documentation: add docs for MAC/PHY
 support in DPAA2
Thread-Index: AQHViGH4+n2mXc5g4kiXAW6oJiL5B6dmUJEAgAAWAYCAAAS8AIAAAmJQ
Date:   Tue, 22 Oct 2019 10:03:06 +0000
Message-ID: <VI1PR0402MB2800D7A6DCBA67E50F735FA5E0680@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1571698228-30985-1-git-send-email-ioana.ciornei@nxp.com>
 <1571698228-30985-5-git-send-email-ioana.ciornei@nxp.com>
 <20191022081404.GN25745@shell.armlinux.org.uk>
 <VI1PR0402MB2800BC4220CD181E13B033A6E0680@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <20191022094946.GR25745@shell.armlinux.org.uk>
In-Reply-To: <20191022094946.GR25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8599faf8-fe53-4969-29c3-08d756d7092e
x-ms-traffictypediagnostic: VI1PR0402MB2909:|VI1PR0402MB2909:
x-ms-exchange-purlcount: 4
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2909B4CE818238939C6ECBD1E0680@VI1PR0402MB2909.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(199004)(189003)(102836004)(33656002)(186003)(6506007)(476003)(52536014)(446003)(76176011)(7696005)(30864003)(478600001)(45080400002)(99286004)(25786009)(486006)(81166006)(8676002)(11346002)(14454004)(966005)(81156014)(86362001)(8936002)(26005)(44832011)(5660300002)(66476007)(66556008)(64756008)(66446008)(66066001)(14444005)(3846002)(6916009)(2906002)(71200400001)(76116006)(6436002)(305945005)(71190400001)(6116002)(7736002)(74316002)(6246003)(229853002)(55016002)(6306002)(9686003)(54906003)(316002)(66946007)(5024004)(256004)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2909;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dJzuJBSe0X+G0V4DSLylL8lsCoGWuc87VcaMXnQpXHw6CeQGSZoNj0mWUA8zwy6smjO1q3qJ7q9t05cSq7G12yRLhKkjAHigLFwEvVLVQSQHn4e/tr8jLo9vwMEcvD3D6FirjsuIhUPSUMqdUP/2J/+xXLC2SZM7U3lWw9D2it4u+xD6/c4fwjg0CIf2V8kCdkfv6cVhLIMwSOD6pWm8Ou2alRIOT6IyIRcw586txXub3V4tghYhrQDUjlQrXcLpTTUU3ccOK7E8Z1I7XxMdIpmYGOmhEkdzzsZDsl5BS4FLp9B/VCguQ2XWYtyMrMTgaQnpDrfRTdvV1knfCklPWmYiEV7WA2f08I0SxWTfykyGJ+8F4BFxcIIEZb/nH50KU2Refr6XL3JCakve4ozAZvCOakmI9UG24JvSjoFDINdroSYiGLYS0HTeSnVnT8jyhGnZjEAu+9ODS5qSggyNZrCXnpT5orenUFxfBgCHat0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8599faf8-fe53-4969-29c3-08d756d7092e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 10:03:06.6992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PnFwJfZC46dX4Y60GJaRhriwcCNHZHxwGHa39GXHkeFkCbE0fZ7raj9vW6gUsbdviZpIzfOe5DzaMTLDB2kXjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2909
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > This mentions phylink, but I never got the other patches of the
> > > series which presumably implement this idea.
> >
> > Hi Russell,
> >
> > I copied you to the entire series. Anyhow, here is a link to the entire=
 patch
> set -
> https://www.spinics.net/lists/netdev/msg606466.html.
>=20
> Please avoid using rmk@armlinux.org.uk for patches.  dspam doesn't know
> about Linux stuff there, and so files emails that contain patches into sp=
am.
> Please use linux@armlinux.org.uk for all kernel related work, as per my
> addresses in the MAINTAINERS file.
>=20
> I now need to manually transfer all those emails...
>=20

I'll keep that in mind for the future. Sorry for the trouble.

> > > Please also note that I gave up waiting for another set, and as I
> > > now have LX2160A hardware, I ended up writing my own version, which
> > > can be found in my cex7 branch at:
> >
> > I looked through the branch and it seems that the approach you are goin=
g
> for is similar (if not exactly the same) as the one from my previous patc=
h set
> that was shut down.
> > Also, sorry for the delay on sending another set but it takes a bit of =
time to
> consider all the implications of changing the entire architecture of the
> solution to better fit the upstream model.
> >
> > Ioana
> >
> > >
> > >  git://git.armlinux.org.uk/~rmk/linux-arm.git cex7
> > >
> > >
> > > http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=3Dcex7
> > >
> > > On Tue, Oct 22, 2019 at 01:50:28AM +0300, Ioana Ciornei wrote:
> > > > Add documentation file for the MAC/PHY support in the DPAA2
> > > > architecture. This describes the architecture and implementation
> > > > of the interface between phylink and a DPAA2 network driver.
> > > >
> > > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > ---
> > > >  .../device_drivers/freescale/dpaa2/index.rst       |   1 +
> > > >  .../freescale/dpaa2/mac-phy-support.rst            | 191
> > > +++++++++++++++++++++
> > > >  MAINTAINERS                                        |   2 +
> > > >  3 files changed, 194 insertions(+)  create mode 100644
> > > > Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-
> su
> > > > ppor
> > > > t.rst
> > > >
> > > > diff --git
> > > >
> a/Documentation/networking/device_drivers/freescale/dpaa2/index.rs
> > > > t
> > > >
> b/Documentation/networking/device_drivers/freescale/dpaa2/index.rs
> > > > t index 67bd87fe6c53..ee40fcc5ddff 100644
> > > > ---
> > > >
> a/Documentation/networking/device_drivers/freescale/dpaa2/index.rs
> > > > t
> > > > +++
> b/Documentation/networking/device_drivers/freescale/dpaa2/inde
> > > > +++ x.rs
> > > > +++ t
> > > > @@ -8,3 +8,4 @@ DPAA2 Documentation
> > > >     overview
> > > >     dpio-driver
> > > >     ethernet-driver
> > > > +   mac-phy-support
> > > > diff --git
> > > > a/Documentation/networking/device_drivers/freescale/dpaa2/mac-
> phy-
> > > > supp
> > > > ort.rst
> > > > b/Documentation/networking/device_drivers/freescale/dpaa2/mac-
> phy-
> > > > supp
> > > > ort.rst
> > > > new file mode 100644
> > > > index 000000000000..51e6624fb774
> > > > --- /dev/null
> > > > +++
> b/Documentation/networking/device_drivers/freescale/dpaa2/mac-
> > > > +++ phy-
> > > > +++ support.rst
> > > > @@ -0,0 +1,191 @@
> > > > +.. SPDX-License-Identifier: GPL-2.0 .. include:: <isonum.txt>
> > > > +
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > > > +DPAA2 MAC / PHY support
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > > > +
> > > > +:Copyright: |copy| 2019 NXP
> > > > +
> > > > +Overview
> > > > +--------
> > > > +
> > > > +The DPAA2 MAC / PHY support consists of a set of APIs that help
> > > > +DPAA2 network drivers (dpaa2-eth, dpaa2-ethsw) interract with the
> PHY library.
> > > > +
> > > > +DPAA2 Software Architecture
> > > > +---------------------------
> > > > +
> > > > +Among other DPAA2 objects, the fsl-mc bus exports DPNI objects
> > > > +(abstracting a network interface) and DPMAC objects (abstracting
> > > > +a MAC). The dpaa2-eth driver probes on the DPNI object and
> > > > +connects to and configures a DPMAC object with the help of phylink=
.
> > > > +
> > > > +Data connections may be established between a DPNI and a DPMAC,
> > > > +or between two DPNIs. Depending on the connection type, the
> > > > +netif_carrier_[on/off] is handled directly by the dpaa2-eth
> > > > +driver or by
> > > phylink.
> > > > +
> > > > +.. code-block:: none
> > > > +
> > > > +  Sources of abstracted link state information presented by the
> > > > + MC firmware
> > > > +
> > > > +                                               +------------------=
--------------------+
> > > > +  +------------+                  +---------+  |                  =
         xgmac_mdio |
> > > > +  | net_device |                  | phylink |--|  +-----+  +-----+=
  +-----+  +-----+
> |
> > > > +  +------------+                  +---------+  |  | PHY |  | PHY |=
  | PHY |  | PHY |  |
> > > > +        |                             |        |  +-----+  +-----+=
  +-----+  +-----+  |
> > > > +      +------------------------------------+   |                  =
  External MDIO bus |
> > > > +      |            dpaa2-eth               |   +------------------=
--------------------+
> > > > +      +------------------------------------+
> > > > +        |                             |                           =
                Linux
> > > > +
> > >
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ~~~~~~~
> > > ~~~~~~~~~~~~~~~~~~~~
> > > > +        |                             |                           =
          MC firmware
> > > > +        |              /|             V
> > > > +  +----------+        / |       +----------+
> > > > +  |          |       /  |       |          |
> > > > +  |          |       |  |       |          |
> > > > +  |   DPNI   |<------|  |<------|   DPMAC  |
> > > > +  |          |       |  |       |          |
> > > > +  |          |       \  |<---+  |          |
> > > > +  +----------+        \ |    |  +----------+
> > > > +                       \|    |
> > > > +                             |
> > > > +           +--------------------------------------+
> > > > +           | MC firmware polling MAC PCS for link |
> > > > +           |  +-----+  +-----+  +-----+  +-----+  |
> > > > +           |  | PCS |  | PCS |  | PCS |  | PCS |  |
> > > > +           |  +-----+  +-----+  +-----+  +-----+  |
> > > > +           |                    Internal MDIO bus |
> > > > +           +--------------------------------------+
> > > > +
> > > > +
> > > > +Depending on an MC firmware configuration setting, each MAC may
> > > > +be in
> > > one of two modes:
> > > > +
> > > > +- DPMAC_LINK_TYPE_FIXED: the link state management is handled
> > > > +exclusively by
> > > > +  the MC firmware by polling the MAC PCS. Without the need to
> > > > +register a
> > > > +  phylink instance, the dpaa2-eth driver will not bind to the
> > > > +connected dpmac
> > > > +  object at all.
> > > > +
> > > > +- DPMAC_LINK_TYPE_PHY: The MC firmware is left waiting for link
> > > > +state update
> > > > +  events, but those are in fact passed strictly between the
> > > > +dpaa2-mac (based on
> > > > +  phylink) and its attached net_device driver (dpaa2-eth,
> > > > +dpaa2-ethsw),
> > > > +  effectively bypassing the firmware.
> > > > +
> > > > +Implementation
> > > > +--------------
> > > > +
> > > > +At probe time or when a DPNI's endpoint is dynamically changed,
> > > > +the dpaa2-eth is responsible to find out if the peer object is a
> > > > +DPMAC and if this is the case, to integrate it with PHYLINK using
> > > > +the
> > > > +dpaa2_mac_connect() API, which will do the following:
> > > > +
> > > > + - look up the device tree for PHYLINK-compatible of binding
> > > > + (phy-handle)
> > > > + - will create a PHYLINK instance associated with the received
> > > > + net_device
> > > > + - connect to the PHY using phylink_of_phy_connect()
> > > > +
> > > > +The following phylink_mac_ops callback are implemented:
> > > > +
> > > > + - .validate() will populate the supported linkmodes with the MAC
> capabilities
> > > > +   only when the phy_interface_t is RGMII_* (at the moment, this i=
s
> the only
> > > > +   link type supported by the driver).
> > > > +
> > > > + - .mac_config() will configure the MAC in the new configuration u=
sing
> the
> > > > +   dpmac_set_link_state() MC firmware API.
> > > > +
> > > > + - .mac_link_up() / .mac_link_down() will update the MAC link usin=
g
> the same
> > > > +   API described above.
> > > > +
> > > > +At driver unbind() or when the DPNI object is disconnected from
> > > > +the DPMAC, the dpaa2-eth driver calls dpaa2_mac_disconnect()
> > > > +which will, in turn, disconnect from the PHY and destroy the PHYLI=
NK
> instance.
> > > > +
> > > > +In case of a DPNI-DPMAC connection, an 'ip link set dev eth0 up'
> > > > +would start the following sequence of operations:
> > > > +
> > > > +(1) phylink_start() called from .dev_open().
> > > > +(2) The .mac_config() and .mac_link_up() callbacks are called by
> PHYLINK.
> > > > +(3) In order to configure the HW MAC, the MC Firmware API
> > > > +    dpmac_set_link_state() is called.
> > > > +(4) The firmware will eventually setup the HW MAC in the new
> configuration.
> > > > +(5) A netif_carrier_on() call is made directly from PHYLINK on the
> associated
> > > > +    net_device.
> > > > +(6) The dpaa2-eth driver handles the LINK_STATE_CHANGE irq in
> order to
> > > > +    enable/disable Rx taildrop based on the pause frame settings.
> > > > +
> > > > +.. code-block:: none
> > > > +
> > > > +  +---------+               +---------+
> > > > +  | PHYLINK |-------------->|  eth0   |
> > > > +  +---------+           (5) +---------+
> > > > +  (1) ^  |
> > > > +      |  |
> > > > +      |  v (2)
> > > > +  +-----------------------------------+
> > > > +  |             dpaa2-eth             |
> > > > +  +-----------------------------------+
> > > > +         |                    ^ (6)
> > > > +         |                    |
> > > > +         v (3)                |
> > > > +  +---------+---------------+---------+
> > > > +  |  DPMAC  |               |  DPNI   |
> > > > +  +---------+               +---------+
> > > > +  |            MC Firmware            |
> > > > +  +-----------------------------------+
> > > > +         |
> > > > +         |
> > > > +         v (4)
> > > > +  +-----------------------------------+
> > > > +  |             HW MAC                |
> > > > +  +-----------------------------------+
> > > > +
> > > > +In case of a DPNI-DPNI connection, a usual sequence of operations
> > > > +looks like the following:
> > > > +
> > > > +(1) ip link set dev eth0 up
> > > > +(2) The dpni_enable() MC API called on the associated fsl_mc_devic=
e.
> > > > +(3) ip link set dev eth1 up
> > > > +(4) The dpni_enable() MC API called on the associated fsl_mc_devic=
e.
> > > > +(5) The LINK_STATE_CHANGED irq is received by both instances of
> > > > +the dpaa2-
> > > eth
> > > > +    driver because now the operational link state is up.
> > > > +(6) The netif_carrier_on() is called on the exported net_device fr=
om
> > > > +    link_state_update().
> > > > +
> > > > +.. code-block:: none
> > > > +
> > > > +  +---------+               +---------+
> > > > +  |  eth0   |               |  eth1   |
> > > > +  +---------+               +---------+
> > > > +      |  ^                     ^  |
> > > > +      |  |                     |  |
> > > > +  (1) v  | (6)             (6) |  v (3)
> > > > +  +---------+               +---------+
> > > > +  |dpaa2-eth|               |dpaa2-eth|
> > > > +  +---------+               +---------+
> > > > +      |  ^                     ^  |
> > > > +      |  |                     |  |
> > > > +  (2) v  | (5)             (5) |  v (4)
> > > > +  +---------+---------------+---------+
> > > > +  |  DPNI   |               |  DPNI   |
> > > > +  +---------+               +---------+
> > > > +  |            MC Firmware            |
> > > > +  +-----------------------------------+
> > > > +
> > > > +
> > > > +Exported API
> > > > +------------
> > > > +
> > > > +Any DPAA2 driver that drivers endpoints of DPMAC objects should
> > > > +service its _EVENT_ENDPOINT_CHANGED irq and connect/disconnect
> > > > +from the associated DPMAC when necessary using the below listed
> API::
> > > > +
> > > > + - int dpaa2_mac_connect(struct dpaa2_mac *mac);
> > > > + - void dpaa2_mac_disconnect(struct dpaa2_mac *mac);
> > > > +
> > > > +A phylink integration is necessary only when the partner DPMAC is
> > > > +not of
> > > TYPE_FIXED.
> > > > +One can check for this condition using the below API::
> > > > +
> > > > + - bool dpaa2_mac_is_type_fixed(struct fsl_mc_device
> > > > + *dpmac_dev,struct fsl_mc_io *mc_io);
> > > > +
> > > > +Before connection to a MAC, the caller must allocate and populate
> > > > +the dpaa2_mac structure with the associated net_device, a pointer
> > > > +to the MC portal to be used and the actual fsl_mc_device structure=
 of
> the DPMAC.
> > > > diff --git a/MAINTAINERS b/MAINTAINERS index
> > > > d0e562d3ce5b..fdc3c89a4a6d 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -5052,6 +5052,8 @@ F:
> 	drivers/net/ethernet/freescale/dpaa2/dpmac*
> > > >  F:	drivers/net/ethernet/freescale/dpaa2/dpkg.h
> > > >  F:	drivers/net/ethernet/freescale/dpaa2/Makefile
> > > >  F:	drivers/net/ethernet/freescale/dpaa2/Kconfig
> > > > +F:
> 	Documentation/networking/device_drivers/freescale/dpaa2/ethern
> et-
> > > driver.rst
> > > > +F:
> 	Documentation/networking/device_drivers/freescale/dpaa2/mac-
> phy-
> > > support.rst
> > > >
> > > >  DPAA2 ETHERNET SWITCH DRIVER
> > > >  M:	Ioana Radulescu <ruxandra.radulescu@nxp.com>
> > > > --
> > > > 1.9.1
> > > >
> > > >
> > > >
> > > >
> > >
> > > --
> > > RMK's Patch system:
> > >
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fww
> > > w.ar
> > >
> mlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=3D02%7C01%7Cioana.c
> ior
> > >
> nei%40nxp.com%7C3d68212cba5c486cd92208d756c7d35d%7C686ea1d3bc2b4
> c
> > >
> 6fa92cd99c5c301635%7C0%7C0%7C637073288560452478&amp;sdata=3DJOi4zc4
> > > WROKWPD085JMZw4mo8a6pyVZa4JXo6wiaD%2BI%3D&amp;reserved=3D0
> > > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down
> > > 622kbps up According to speedtest.net: 11.9Mbps down 500kbps up
> >
>=20
> --
> RMK's Patch system:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww
> .armlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=3D02%7C01%7Cioan
> a.ciornei%40nxp.com%7Cde221afe23be4819e4a008d756d53174%7C686ea1d3
> bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637073345987966962&amp;sdata=3D
> TlljIAmAnmc9nIfnAwXZmIO03XbO94PL9x9P0oI94Zg%3D&amp;reserved=3D0
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbp=
s
> up According to speedtest.net: 11.9Mbps down 500kbps up
