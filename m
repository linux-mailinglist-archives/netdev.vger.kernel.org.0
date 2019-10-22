Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD51E00EC
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731333AbfJVJmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:42:03 -0400
Received: from mail-eopbgr30040.outbound.protection.outlook.com ([40.107.3.40]:52566
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730312AbfJVJmC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:42:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHy2t9DVbXr860FJgzZ3X5mZM/uP+ilbofjwAjzk4PZKl23i38BkBAHWb04qbN0zTgcNrNwiHC5Xq+wyAy4byR4UiT05POJCTuCK5y6e08WFi4fce1hvmrTFzAao3Dc/JArunFVeQ/GE9dKj4P1fmb8b3CEVVqbGfN6mO9xhJ17BOAbulk1Iw0+JuqnO1Mstfe9mRPncM5igi2tVIl5QmrppqEYUCkg2tfgEY8hgIaR45fq4Nt7TyRbPcrN/TDpfnS6hLANk04jfSveoXnKIZlg0Yy640doL8tM9kMYy+sk4PXrl/KDDVH721TYMs8s+toV/Ej/v/oH7EeGOA5Ht5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Er68+fYeGugE2/z7H6e9hB4k1w9YBjqHxu2Iw7lIGp8=;
 b=BcZPsVj7fV/IOOJGkRsJRao131bPx4Jj3wbgWFhkohdiWVCPqC4gBvjLcBYDo+8lCK6CGPM4FHG5W/+hwi2fSGeOa9Iw4Gwc2Tgxs9ol4dFt4dkpuCeOmt+9zo2ciK86ZmR6E1yQkoYtBZe5qB19ewdjS2EgNgQtmYnwkCQuR6xlGcEcMNTAXUP5SCZ6Z/SoeZcqZos1s4LUXlRmn/2keD+l3kMfxhV0fzLpj0D0hOz5z9l9sc3bqNyGT685eABgkQWGUArbuwiFosVz/SKKHolRWN3yF6qPcs+6BE7RwLwq/zVM3/IiI75DKf0bvlrphSBJTaNOkC9RJ2uLOye9vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Er68+fYeGugE2/z7H6e9hB4k1w9YBjqHxu2Iw7lIGp8=;
 b=HJd/CQJq6CkzOzMauY9s/fWpfKL8OPHdiOtqE4Iomedd32zItAW9tXWMps4FHHI5RPxwc571qalqwN3vocpM5vkU/+84dnAL1vZNKDItx1SdZhwegzQRSam8ukiZ+BFBAdE2vKWzko5iWvWMuedqT7iFhkzV6aWtLy59zTZQ2QU=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3565.eurprd04.prod.outlook.com (52.134.9.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Tue, 22 Oct 2019 09:41:45 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2367.022; Tue, 22 Oct
 2019 09:41:45 +0000
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
Thread-Index: AQHViGH4+n2mXc5g4kiXAW6oJiL5B6dmUJEAgAAWAYA=
Date:   Tue, 22 Oct 2019 09:41:45 +0000
Message-ID: <VI1PR0402MB2800BC4220CD181E13B033A6E0680@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1571698228-30985-1-git-send-email-ioana.ciornei@nxp.com>
 <1571698228-30985-5-git-send-email-ioana.ciornei@nxp.com>
 <20191022081404.GN25745@shell.armlinux.org.uk>
In-Reply-To: <20191022081404.GN25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b243b228-5824-48c3-648d-08d756d40d60
x-ms-traffictypediagnostic: VI1PR0402MB3565:|VI1PR0402MB3565:
x-ms-exchange-purlcount: 3
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3565E2AD4E0556F1461F6F40E0680@VI1PR0402MB3565.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(199004)(189003)(6246003)(476003)(66446008)(66556008)(76116006)(6116002)(55016002)(64756008)(66476007)(81166006)(102836004)(81156014)(6436002)(2906002)(3846002)(86362001)(66946007)(6306002)(11346002)(26005)(8936002)(229853002)(5660300002)(486006)(44832011)(4326008)(9686003)(8676002)(30864003)(6506007)(446003)(76176011)(478600001)(7696005)(54906003)(316002)(99286004)(25786009)(52536014)(74316002)(256004)(6916009)(186003)(66066001)(45080400002)(71200400001)(33656002)(966005)(7736002)(71190400001)(305945005)(14454004)(14444005)(5024004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3565;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lHMMGB2joVw0WM1sGxadgUtZHe8aJeB9c9OSlb//X4laDA8RvFPDr52+1rGg2TOkuJTfa/rt5Bty3EU0kX8nefPKac4gOy9/2fZGMepfcZKjzQc+sPKhzSiho0dTt2ys1HbVhPR1ZzjxT/YKf8RRshdtq7mXcZ60f46aCAnnYej8XAMwv/a6SBvmwtWTTDAbf9B5x5mqo6FqJQ0I8i/lDYO19U9Xq0m29bsI0ELY9gM8ITjORdgA9hplO1ERpIkNVeFSgbfg2EA8ZjrALB/vpdG/HnJPDJUc6mHN+PuRtGXjRu2isxKGirRHg1sJsL7Mm37r2ob8A2+0HIeknrM5XFdI+KPzoj6tvgCvgW66QRTCGayU+Whlzq3+RGbGmflPcZbhLwWl8RlukIYtW78IudgzKnLA6i6dpfPgpg+uLTXthdcfuJtugV+L0+aEc4/HgSV4gmNfcNKw/YolVE5pNQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b243b228-5824-48c3-648d-08d756d40d60
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:41:45.2751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7M6XhVpwL7aegYhdsIZI49eFZyp08ggq9c5Mka33wYJVwBRMiqNxsH6a3eby3Bfn/VUzE7fibpto3pgMEnC0yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3565
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next 4/4] net: documentation: add docs for MAC/PH=
Y
> support in DPAA2
>=20
> This mentions phylink, but I never got the other patches of the series wh=
ich
> presumably implement this idea.

Hi Russell,

I copied you to the entire series. Anyhow, here is a link to the entire pat=
ch set - https://www.spinics.net/lists/netdev/msg606466.html.

>=20
> Please also note that I gave up waiting for another set, and as I now hav=
e
> LX2160A hardware, I ended up writing my own version, which can be found i=
n
> my cex7 branch at:

I looked through the branch and it seems that the approach you are going fo=
r is similar (if not exactly the same) as the one from my previous patch se=
t that was shut down.
Also, sorry for the delay on sending another set but it takes a bit of time=
 to consider all the implications of changing the entire architecture of th=
e solution to better fit the upstream model.

Ioana

>=20
>  git://git.armlinux.org.uk/~rmk/linux-arm.git cex7
>=20
>=20
> http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=3Dcex7
>=20
> On Tue, Oct 22, 2019 at 01:50:28AM +0300, Ioana Ciornei wrote:
> > Add documentation file for the MAC/PHY support in the DPAA2
> > architecture. This describes the architecture and implementation of
> > the interface between phylink and a DPAA2 network driver.
> >
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> >  .../device_drivers/freescale/dpaa2/index.rst       |   1 +
> >  .../freescale/dpaa2/mac-phy-support.rst            | 191
> +++++++++++++++++++++
> >  MAINTAINERS                                        |   2 +
> >  3 files changed, 194 insertions(+)
> >  create mode 100644
> > Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-suppor
> > t.rst
> >
> > diff --git
> > a/Documentation/networking/device_drivers/freescale/dpaa2/index.rst
> > b/Documentation/networking/device_drivers/freescale/dpaa2/index.rst
> > index 67bd87fe6c53..ee40fcc5ddff 100644
> > ---
> > a/Documentation/networking/device_drivers/freescale/dpaa2/index.rst
> > +++ b/Documentation/networking/device_drivers/freescale/dpaa2/index.rs
> > +++ t
> > @@ -8,3 +8,4 @@ DPAA2 Documentation
> >     overview
> >     dpio-driver
> >     ethernet-driver
> > +   mac-phy-support
> > diff --git
> > a/Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-supp
> > ort.rst
> > b/Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-supp
> > ort.rst
> > new file mode 100644
> > index 000000000000..51e6624fb774
> > --- /dev/null
> > +++ b/Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-
> > +++ support.rst
> > @@ -0,0 +1,191 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +.. include:: <isonum.txt>
> > +
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +DPAA2 MAC / PHY support
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +:Copyright: |copy| 2019 NXP
> > +
> > +Overview
> > +--------
> > +
> > +The DPAA2 MAC / PHY support consists of a set of APIs that help DPAA2
> > +network drivers (dpaa2-eth, dpaa2-ethsw) interract with the PHY librar=
y.
> > +
> > +DPAA2 Software Architecture
> > +---------------------------
> > +
> > +Among other DPAA2 objects, the fsl-mc bus exports DPNI objects
> > +(abstracting a network interface) and DPMAC objects (abstracting a
> > +MAC). The dpaa2-eth driver probes on the DPNI object and connects to
> > +and configures a DPMAC object with the help of phylink.
> > +
> > +Data connections may be established between a DPNI and a DPMAC, or
> > +between two DPNIs. Depending on the connection type, the
> > +netif_carrier_[on/off] is handled directly by the dpaa2-eth driver or =
by
> phylink.
> > +
> > +.. code-block:: none
> > +
> > +  Sources of abstracted link state information presented by the MC
> > + firmware
> > +
> > +                                               +----------------------=
----------------+
> > +  +------------+                  +---------+  |                      =
     xgmac_mdio |
> > +  | net_device |                  | phylink |--|  +-----+  +-----+  +-=
----+  +-----+  |
> > +  +------------+                  +---------+  |  | PHY |  | PHY |  | =
PHY |  | PHY |  |
> > +        |                             |        |  +-----+  +-----+  +-=
----+  +-----+  |
> > +      +------------------------------------+   |                    Ex=
ternal MDIO bus |
> > +      |            dpaa2-eth               |   +----------------------=
----------------+
> > +      +------------------------------------+
> > +        |                             |                               =
            Linux
> > +
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ~~~~~~~~~~~~~~~~~~~~
> > +        |                             |                               =
      MC firmware
> > +        |              /|             V
> > +  +----------+        / |       +----------+
> > +  |          |       /  |       |          |
> > +  |          |       |  |       |          |
> > +  |   DPNI   |<------|  |<------|   DPMAC  |
> > +  |          |       |  |       |          |
> > +  |          |       \  |<---+  |          |
> > +  +----------+        \ |    |  +----------+
> > +                       \|    |
> > +                             |
> > +           +--------------------------------------+
> > +           | MC firmware polling MAC PCS for link |
> > +           |  +-----+  +-----+  +-----+  +-----+  |
> > +           |  | PCS |  | PCS |  | PCS |  | PCS |  |
> > +           |  +-----+  +-----+  +-----+  +-----+  |
> > +           |                    Internal MDIO bus |
> > +           +--------------------------------------+
> > +
> > +
> > +Depending on an MC firmware configuration setting, each MAC may be in
> one of two modes:
> > +
> > +- DPMAC_LINK_TYPE_FIXED: the link state management is handled
> > +exclusively by
> > +  the MC firmware by polling the MAC PCS. Without the need to
> > +register a
> > +  phylink instance, the dpaa2-eth driver will not bind to the
> > +connected dpmac
> > +  object at all.
> > +
> > +- DPMAC_LINK_TYPE_PHY: The MC firmware is left waiting for link state
> > +update
> > +  events, but those are in fact passed strictly between the dpaa2-mac
> > +(based on
> > +  phylink) and its attached net_device driver (dpaa2-eth,
> > +dpaa2-ethsw),
> > +  effectively bypassing the firmware.
> > +
> > +Implementation
> > +--------------
> > +
> > +At probe time or when a DPNI's endpoint is dynamically changed, the
> > +dpaa2-eth is responsible to find out if the peer object is a DPMAC
> > +and if this is the case, to integrate it with PHYLINK using the
> > +dpaa2_mac_connect() API, which will do the following:
> > +
> > + - look up the device tree for PHYLINK-compatible of binding
> > + (phy-handle)
> > + - will create a PHYLINK instance associated with the received
> > + net_device
> > + - connect to the PHY using phylink_of_phy_connect()
> > +
> > +The following phylink_mac_ops callback are implemented:
> > +
> > + - .validate() will populate the supported linkmodes with the MAC capa=
bilities
> > +   only when the phy_interface_t is RGMII_* (at the moment, this is th=
e only
> > +   link type supported by the driver).
> > +
> > + - .mac_config() will configure the MAC in the new configuration using=
 the
> > +   dpmac_set_link_state() MC firmware API.
> > +
> > + - .mac_link_up() / .mac_link_down() will update the MAC link using th=
e same
> > +   API described above.
> > +
> > +At driver unbind() or when the DPNI object is disconnected from the
> > +DPMAC, the dpaa2-eth driver calls dpaa2_mac_disconnect() which will,
> > +in turn, disconnect from the PHY and destroy the PHYLINK instance.
> > +
> > +In case of a DPNI-DPMAC connection, an 'ip link set dev eth0 up'
> > +would start the following sequence of operations:
> > +
> > +(1) phylink_start() called from .dev_open().
> > +(2) The .mac_config() and .mac_link_up() callbacks are called by PHYLI=
NK.
> > +(3) In order to configure the HW MAC, the MC Firmware API
> > +    dpmac_set_link_state() is called.
> > +(4) The firmware will eventually setup the HW MAC in the new configura=
tion.
> > +(5) A netif_carrier_on() call is made directly from PHYLINK on the ass=
ociated
> > +    net_device.
> > +(6) The dpaa2-eth driver handles the LINK_STATE_CHANGE irq in order to
> > +    enable/disable Rx taildrop based on the pause frame settings.
> > +
> > +.. code-block:: none
> > +
> > +  +---------+               +---------+
> > +  | PHYLINK |-------------->|  eth0   |
> > +  +---------+           (5) +---------+
> > +  (1) ^  |
> > +      |  |
> > +      |  v (2)
> > +  +-----------------------------------+
> > +  |             dpaa2-eth             |
> > +  +-----------------------------------+
> > +         |                    ^ (6)
> > +         |                    |
> > +         v (3)                |
> > +  +---------+---------------+---------+
> > +  |  DPMAC  |               |  DPNI   |
> > +  +---------+               +---------+
> > +  |            MC Firmware            |
> > +  +-----------------------------------+
> > +         |
> > +         |
> > +         v (4)
> > +  +-----------------------------------+
> > +  |             HW MAC                |
> > +  +-----------------------------------+
> > +
> > +In case of a DPNI-DPNI connection, a usual sequence of operations
> > +looks like the following:
> > +
> > +(1) ip link set dev eth0 up
> > +(2) The dpni_enable() MC API called on the associated fsl_mc_device.
> > +(3) ip link set dev eth1 up
> > +(4) The dpni_enable() MC API called on the associated fsl_mc_device.
> > +(5) The LINK_STATE_CHANGED irq is received by both instances of the dp=
aa2-
> eth
> > +    driver because now the operational link state is up.
> > +(6) The netif_carrier_on() is called on the exported net_device from
> > +    link_state_update().
> > +
> > +.. code-block:: none
> > +
> > +  +---------+               +---------+
> > +  |  eth0   |               |  eth1   |
> > +  +---------+               +---------+
> > +      |  ^                     ^  |
> > +      |  |                     |  |
> > +  (1) v  | (6)             (6) |  v (3)
> > +  +---------+               +---------+
> > +  |dpaa2-eth|               |dpaa2-eth|
> > +  +---------+               +---------+
> > +      |  ^                     ^  |
> > +      |  |                     |  |
> > +  (2) v  | (5)             (5) |  v (4)
> > +  +---------+---------------+---------+
> > +  |  DPNI   |               |  DPNI   |
> > +  +---------+               +---------+
> > +  |            MC Firmware            |
> > +  +-----------------------------------+
> > +
> > +
> > +Exported API
> > +------------
> > +
> > +Any DPAA2 driver that drivers endpoints of DPMAC objects should
> > +service its _EVENT_ENDPOINT_CHANGED irq and connect/disconnect from
> > +the associated DPMAC when necessary using the below listed API::
> > +
> > + - int dpaa2_mac_connect(struct dpaa2_mac *mac);
> > + - void dpaa2_mac_disconnect(struct dpaa2_mac *mac);
> > +
> > +A phylink integration is necessary only when the partner DPMAC is not =
of
> TYPE_FIXED.
> > +One can check for this condition using the below API::
> > +
> > + - bool dpaa2_mac_is_type_fixed(struct fsl_mc_device
> > + *dpmac_dev,struct fsl_mc_io *mc_io);
> > +
> > +Before connection to a MAC, the caller must allocate and populate the
> > +dpaa2_mac structure with the associated net_device, a pointer to the
> > +MC portal to be used and the actual fsl_mc_device structure of the DPM=
AC.
> > diff --git a/MAINTAINERS b/MAINTAINERS index
> > d0e562d3ce5b..fdc3c89a4a6d 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5052,6 +5052,8 @@ F:	drivers/net/ethernet/freescale/dpaa2/dpmac*
> >  F:	drivers/net/ethernet/freescale/dpaa2/dpkg.h
> >  F:	drivers/net/ethernet/freescale/dpaa2/Makefile
> >  F:	drivers/net/ethernet/freescale/dpaa2/Kconfig
> > +F:	Documentation/networking/device_drivers/freescale/dpaa2/ethernet-
> driver.rst
> > +F:	Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-
> support.rst
> >
> >  DPAA2 ETHERNET SWITCH DRIVER
> >  M:	Ioana Radulescu <ruxandra.radulescu@nxp.com>
> > --
> > 1.9.1
> >
> >
> >
> >
>=20
> --
> RMK's Patch system:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.a=
r
> mlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=3D02%7C01%7Cioana.cior
> nei%40nxp.com%7C3d68212cba5c486cd92208d756c7d35d%7C686ea1d3bc2b4c
> 6fa92cd99c5c301635%7C0%7C0%7C637073288560452478&amp;sdata=3DJOi4zc4
> WROKWPD085JMZw4mo8a6pyVZa4JXo6wiaD%2BI%3D&amp;reserved=3D0
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbp=
s up
> According to speedtest.net: 11.9Mbps down 500kbps up
