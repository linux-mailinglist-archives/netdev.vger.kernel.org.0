Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8AFE011A
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731469AbfJVJt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:49:56 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40942 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbfJVJtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 05:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=w/mYC2UN1A+kizzohIvsq6DqZ3a/YmmiJru/bkKkB1o=; b=OKsb1k7ZtWC3HtQo+X9AzExti
        l60p2dX+zHwLWutHLbYLpExEfbg81mDgxCPBSlYROu52igEM6BwRHKYV3gngkJ9XBCzUmDn366IvW
        o9g9eO2jBn5Bncob4zgIgGHKfGDMUYxJ83S7xB+KXiF71VAw+srfoJF2C0T8O9qgH2QDSZ+pbYbaj
        jaO5Dngwi24exM2DDU/w2ynUosE1mRF8tr5Jg3bWuAbW4xTR/eQ0668sVwm+g6/ifs/rdfCTX5lzh
        SA8ze068zhGOTBPvwAMEESiUtfQACL+lfLTYaTLyhiY6oXKk/QcCoTQ58UDpIUm4GVVu3zjpL9acw
        VUzWqT56g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57564)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iMqnW-0006N0-4v; Tue, 22 Oct 2019 10:49:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iMqnS-0004Se-Ax; Tue, 22 Oct 2019 10:49:46 +0100
Date:   Tue, 22 Oct 2019 10:49:46 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 4/4] net: documentation: add docs for MAC/PHY
 support in DPAA2
Message-ID: <20191022094946.GR25745@shell.armlinux.org.uk>
References: <1571698228-30985-1-git-send-email-ioana.ciornei@nxp.com>
 <1571698228-30985-5-git-send-email-ioana.ciornei@nxp.com>
 <20191022081404.GN25745@shell.armlinux.org.uk>
 <VI1PR0402MB2800BC4220CD181E13B033A6E0680@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB2800BC4220CD181E13B033A6E0680@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 09:41:45AM +0000, Ioana Ciornei wrote:
> > Subject: Re: [PATCH net-next 4/4] net: documentation: add docs for MAC/PHY
> > support in DPAA2
> > 
> > This mentions phylink, but I never got the other patches of the series which
> > presumably implement this idea.
> 
> Hi Russell,
> 
> I copied you to the entire series. Anyhow, here is a link to the entire patch set - https://www.spinics.net/lists/netdev/msg606466.html.

Please avoid using rmk@armlinux.org.uk for patches.  dspam doesn't
know about Linux stuff there, and so files emails that contain
patches into spam.  Please use linux@armlinux.org.uk for all kernel
related work, as per my addresses in the MAINTAINERS file.

I now need to manually transfer all those emails...

> > Please also note that I gave up waiting for another set, and as I now have
> > LX2160A hardware, I ended up writing my own version, which can be found in
> > my cex7 branch at:
> 
> I looked through the branch and it seems that the approach you are going for is similar (if not exactly the same) as the one from my previous patch set that was shut down.
> Also, sorry for the delay on sending another set but it takes a bit of time to consider all the implications of changing the entire architecture of the solution to better fit the upstream model.
> 
> Ioana
> 
> > 
> >  git://git.armlinux.org.uk/~rmk/linux-arm.git cex7
> > 
> > 
> > http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=cex7
> > 
> > On Tue, Oct 22, 2019 at 01:50:28AM +0300, Ioana Ciornei wrote:
> > > Add documentation file for the MAC/PHY support in the DPAA2
> > > architecture. This describes the architecture and implementation of
> > > the interface between phylink and a DPAA2 network driver.
> > >
> > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > ---
> > >  .../device_drivers/freescale/dpaa2/index.rst       |   1 +
> > >  .../freescale/dpaa2/mac-phy-support.rst            | 191
> > +++++++++++++++++++++
> > >  MAINTAINERS                                        |   2 +
> > >  3 files changed, 194 insertions(+)
> > >  create mode 100644
> > > Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-suppor
> > > t.rst
> > >
> > > diff --git
> > > a/Documentation/networking/device_drivers/freescale/dpaa2/index.rst
> > > b/Documentation/networking/device_drivers/freescale/dpaa2/index.rst
> > > index 67bd87fe6c53..ee40fcc5ddff 100644
> > > ---
> > > a/Documentation/networking/device_drivers/freescale/dpaa2/index.rst
> > > +++ b/Documentation/networking/device_drivers/freescale/dpaa2/index.rs
> > > +++ t
> > > @@ -8,3 +8,4 @@ DPAA2 Documentation
> > >     overview
> > >     dpio-driver
> > >     ethernet-driver
> > > +   mac-phy-support
> > > diff --git
> > > a/Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-supp
> > > ort.rst
> > > b/Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-supp
> > > ort.rst
> > > new file mode 100644
> > > index 000000000000..51e6624fb774
> > > --- /dev/null
> > > +++ b/Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-
> > > +++ support.rst
> > > @@ -0,0 +1,191 @@
> > > +.. SPDX-License-Identifier: GPL-2.0
> > > +.. include:: <isonum.txt>
> > > +
> > > +=======================
> > > +DPAA2 MAC / PHY support
> > > +=======================
> > > +
> > > +:Copyright: |copy| 2019 NXP
> > > +
> > > +Overview
> > > +--------
> > > +
> > > +The DPAA2 MAC / PHY support consists of a set of APIs that help DPAA2
> > > +network drivers (dpaa2-eth, dpaa2-ethsw) interract with the PHY library.
> > > +
> > > +DPAA2 Software Architecture
> > > +---------------------------
> > > +
> > > +Among other DPAA2 objects, the fsl-mc bus exports DPNI objects
> > > +(abstracting a network interface) and DPMAC objects (abstracting a
> > > +MAC). The dpaa2-eth driver probes on the DPNI object and connects to
> > > +and configures a DPMAC object with the help of phylink.
> > > +
> > > +Data connections may be established between a DPNI and a DPMAC, or
> > > +between two DPNIs. Depending on the connection type, the
> > > +netif_carrier_[on/off] is handled directly by the dpaa2-eth driver or by
> > phylink.
> > > +
> > > +.. code-block:: none
> > > +
> > > +  Sources of abstracted link state information presented by the MC
> > > + firmware
> > > +
> > > +                                               +--------------------------------------+
> > > +  +------------+                  +---------+  |                           xgmac_mdio |
> > > +  | net_device |                  | phylink |--|  +-----+  +-----+  +-----+  +-----+  |
> > > +  +------------+                  +---------+  |  | PHY |  | PHY |  | PHY |  | PHY |  |
> > > +        |                             |        |  +-----+  +-----+  +-----+  +-----+  |
> > > +      +------------------------------------+   |                    External MDIO bus |
> > > +      |            dpaa2-eth               |   +--------------------------------------+
> > > +      +------------------------------------+
> > > +        |                             |                                           Linux
> > > +
> > ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > ~~~~~~~~~~~~~~~~~~~~
> > > +        |                             |                                     MC firmware
> > > +        |              /|             V
> > > +  +----------+        / |       +----------+
> > > +  |          |       /  |       |          |
> > > +  |          |       |  |       |          |
> > > +  |   DPNI   |<------|  |<------|   DPMAC  |
> > > +  |          |       |  |       |          |
> > > +  |          |       \  |<---+  |          |
> > > +  +----------+        \ |    |  +----------+
> > > +                       \|    |
> > > +                             |
> > > +           +--------------------------------------+
> > > +           | MC firmware polling MAC PCS for link |
> > > +           |  +-----+  +-----+  +-----+  +-----+  |
> > > +           |  | PCS |  | PCS |  | PCS |  | PCS |  |
> > > +           |  +-----+  +-----+  +-----+  +-----+  |
> > > +           |                    Internal MDIO bus |
> > > +           +--------------------------------------+
> > > +
> > > +
> > > +Depending on an MC firmware configuration setting, each MAC may be in
> > one of two modes:
> > > +
> > > +- DPMAC_LINK_TYPE_FIXED: the link state management is handled
> > > +exclusively by
> > > +  the MC firmware by polling the MAC PCS. Without the need to
> > > +register a
> > > +  phylink instance, the dpaa2-eth driver will not bind to the
> > > +connected dpmac
> > > +  object at all.
> > > +
> > > +- DPMAC_LINK_TYPE_PHY: The MC firmware is left waiting for link state
> > > +update
> > > +  events, but those are in fact passed strictly between the dpaa2-mac
> > > +(based on
> > > +  phylink) and its attached net_device driver (dpaa2-eth,
> > > +dpaa2-ethsw),
> > > +  effectively bypassing the firmware.
> > > +
> > > +Implementation
> > > +--------------
> > > +
> > > +At probe time or when a DPNI's endpoint is dynamically changed, the
> > > +dpaa2-eth is responsible to find out if the peer object is a DPMAC
> > > +and if this is the case, to integrate it with PHYLINK using the
> > > +dpaa2_mac_connect() API, which will do the following:
> > > +
> > > + - look up the device tree for PHYLINK-compatible of binding
> > > + (phy-handle)
> > > + - will create a PHYLINK instance associated with the received
> > > + net_device
> > > + - connect to the PHY using phylink_of_phy_connect()
> > > +
> > > +The following phylink_mac_ops callback are implemented:
> > > +
> > > + - .validate() will populate the supported linkmodes with the MAC capabilities
> > > +   only when the phy_interface_t is RGMII_* (at the moment, this is the only
> > > +   link type supported by the driver).
> > > +
> > > + - .mac_config() will configure the MAC in the new configuration using the
> > > +   dpmac_set_link_state() MC firmware API.
> > > +
> > > + - .mac_link_up() / .mac_link_down() will update the MAC link using the same
> > > +   API described above.
> > > +
> > > +At driver unbind() or when the DPNI object is disconnected from the
> > > +DPMAC, the dpaa2-eth driver calls dpaa2_mac_disconnect() which will,
> > > +in turn, disconnect from the PHY and destroy the PHYLINK instance.
> > > +
> > > +In case of a DPNI-DPMAC connection, an 'ip link set dev eth0 up'
> > > +would start the following sequence of operations:
> > > +
> > > +(1) phylink_start() called from .dev_open().
> > > +(2) The .mac_config() and .mac_link_up() callbacks are called by PHYLINK.
> > > +(3) In order to configure the HW MAC, the MC Firmware API
> > > +    dpmac_set_link_state() is called.
> > > +(4) The firmware will eventually setup the HW MAC in the new configuration.
> > > +(5) A netif_carrier_on() call is made directly from PHYLINK on the associated
> > > +    net_device.
> > > +(6) The dpaa2-eth driver handles the LINK_STATE_CHANGE irq in order to
> > > +    enable/disable Rx taildrop based on the pause frame settings.
> > > +
> > > +.. code-block:: none
> > > +
> > > +  +---------+               +---------+
> > > +  | PHYLINK |-------------->|  eth0   |
> > > +  +---------+           (5) +---------+
> > > +  (1) ^  |
> > > +      |  |
> > > +      |  v (2)
> > > +  +-----------------------------------+
> > > +  |             dpaa2-eth             |
> > > +  +-----------------------------------+
> > > +         |                    ^ (6)
> > > +         |                    |
> > > +         v (3)                |
> > > +  +---------+---------------+---------+
> > > +  |  DPMAC  |               |  DPNI   |
> > > +  +---------+               +---------+
> > > +  |            MC Firmware            |
> > > +  +-----------------------------------+
> > > +         |
> > > +         |
> > > +         v (4)
> > > +  +-----------------------------------+
> > > +  |             HW MAC                |
> > > +  +-----------------------------------+
> > > +
> > > +In case of a DPNI-DPNI connection, a usual sequence of operations
> > > +looks like the following:
> > > +
> > > +(1) ip link set dev eth0 up
> > > +(2) The dpni_enable() MC API called on the associated fsl_mc_device.
> > > +(3) ip link set dev eth1 up
> > > +(4) The dpni_enable() MC API called on the associated fsl_mc_device.
> > > +(5) The LINK_STATE_CHANGED irq is received by both instances of the dpaa2-
> > eth
> > > +    driver because now the operational link state is up.
> > > +(6) The netif_carrier_on() is called on the exported net_device from
> > > +    link_state_update().
> > > +
> > > +.. code-block:: none
> > > +
> > > +  +---------+               +---------+
> > > +  |  eth0   |               |  eth1   |
> > > +  +---------+               +---------+
> > > +      |  ^                     ^  |
> > > +      |  |                     |  |
> > > +  (1) v  | (6)             (6) |  v (3)
> > > +  +---------+               +---------+
> > > +  |dpaa2-eth|               |dpaa2-eth|
> > > +  +---------+               +---------+
> > > +      |  ^                     ^  |
> > > +      |  |                     |  |
> > > +  (2) v  | (5)             (5) |  v (4)
> > > +  +---------+---------------+---------+
> > > +  |  DPNI   |               |  DPNI   |
> > > +  +---------+               +---------+
> > > +  |            MC Firmware            |
> > > +  +-----------------------------------+
> > > +
> > > +
> > > +Exported API
> > > +------------
> > > +
> > > +Any DPAA2 driver that drivers endpoints of DPMAC objects should
> > > +service its _EVENT_ENDPOINT_CHANGED irq and connect/disconnect from
> > > +the associated DPMAC when necessary using the below listed API::
> > > +
> > > + - int dpaa2_mac_connect(struct dpaa2_mac *mac);
> > > + - void dpaa2_mac_disconnect(struct dpaa2_mac *mac);
> > > +
> > > +A phylink integration is necessary only when the partner DPMAC is not of
> > TYPE_FIXED.
> > > +One can check for this condition using the below API::
> > > +
> > > + - bool dpaa2_mac_is_type_fixed(struct fsl_mc_device
> > > + *dpmac_dev,struct fsl_mc_io *mc_io);
> > > +
> > > +Before connection to a MAC, the caller must allocate and populate the
> > > +dpaa2_mac structure with the associated net_device, a pointer to the
> > > +MC portal to be used and the actual fsl_mc_device structure of the DPMAC.
> > > diff --git a/MAINTAINERS b/MAINTAINERS index
> > > d0e562d3ce5b..fdc3c89a4a6d 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -5052,6 +5052,8 @@ F:	drivers/net/ethernet/freescale/dpaa2/dpmac*
> > >  F:	drivers/net/ethernet/freescale/dpaa2/dpkg.h
> > >  F:	drivers/net/ethernet/freescale/dpaa2/Makefile
> > >  F:	drivers/net/ethernet/freescale/dpaa2/Kconfig
> > > +F:	Documentation/networking/device_drivers/freescale/dpaa2/ethernet-
> > driver.rst
> > > +F:	Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-
> > support.rst
> > >
> > >  DPAA2 ETHERNET SWITCH DRIVER
> > >  M:	Ioana Radulescu <ruxandra.radulescu@nxp.com>
> > > --
> > > 1.9.1
> > >
> > >
> > >
> > >
> > 
> > --
> > RMK's Patch system:
> > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.ar
> > mlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=02%7C01%7Cioana.cior
> > nei%40nxp.com%7C3d68212cba5c486cd92208d756c7d35d%7C686ea1d3bc2b4c
> > 6fa92cd99c5c301635%7C0%7C0%7C637073288560452478&amp;sdata=JOi4zc4
> > WROKWPD085JMZw4mo8a6pyVZa4JXo6wiaD%2BI%3D&amp;reserved=0
> > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> > According to speedtest.net: 11.9Mbps down 500kbps up
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
