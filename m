Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AD91BA6DD
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgD0Os3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 10:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726953AbgD0Os3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 10:48:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C7CC0610D5;
        Mon, 27 Apr 2020 07:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YMCdyK8i4NHqmV0CuBigav+at+kNv4arzXM266XsjFA=; b=QhEo1yZ4eckdHv6Ca6QfmGgjk
        j7W2lb6MAghgTs6Kpp00+HFRYb9nEI9mpZhp8dUlBLZWo+JDClktcag0JllPl7cx1PVkISqGH7dlP
        SGWZ6fsZMz/StwDqxR/V2PerM4v1PeDOT9X6h/ECvuY5XFNRlJgtXmPKcPSSWnLRdWY4C1bBcYkLv
        QuOrw9yRpJdfMO3/zKPKI2YVxj4VGQZXxmEqELmNO1//wQf+TWM1URlt+HYddcSQrOknG0XzCnA3R
        VOtD8qSQ5cLzvsvcthEaECVeCk/uEvp0jdRpb9yshQZ0DaSiG6milrTcX/qY3D86v+6mLd1OFGv9V
        axBseXLQw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:44654)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jT53K-0003RG-N2; Mon, 27 Apr 2020 15:48:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jT53H-0006kG-32; Mon, 27 Apr 2020 15:48:07 +0100
Date:   Mon, 27 Apr 2020 15:48:07 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>, linux-kernel@vger.kernel.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v2 0/3] Introduce new APIs to support phylink
 and phy layers
Message-ID: <20200427144806.GI25745@shell.armlinux.org.uk>
References: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
 <20200427135820.GH25745@shell.armlinux.org.uk>
 <20200427143238.GA26436@lsv03152.swis.in-blr01.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427143238.GA26436@lsv03152.swis.in-blr01.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 08:02:38PM +0530, Calvin Johnson wrote:
> On Mon, Apr 27, 2020 at 02:58:20PM +0100, Russell King - ARM Linux admin wrote:
> > On Mon, Apr 27, 2020 at 06:54:06PM +0530, Calvin Johnson wrote:
> > > Following functions are defined:
> > >   phylink_fwnode_phy_connect()
> > >   phylink_device_phy_connect()
> > >   fwnode_phy_find_device()
> > >   device_phy_find_device()
> > >   fwnode_get_phy_node()
> > > 
> > > First two help in connecting phy to phylink instance.
> > > Next two help in finding a phy on a mdiobus.
> > > Last one helps in getting phy_node from a fwnode.
> > > 
> > > Changes in v2:
> > >   move phy code from base/property.c to net/phy/phy_device.c
> > >   replace acpi & of code to get phy-handle with fwnode_find_reference
> > >   replace of_ and acpi_ code with generic fwnode to get phy-handle.
> > > 
> > > Calvin Johnson (3):
> > >   device property: Introduce phy related fwnode functions
> > >   net: phy: alphabetically sort header includes
> > >   phylink: Introduce phylink_fwnode_phy_connect()
> > 
> > Thanks for this, but there's more work that needs to be done here.  I
> > also think that we must have an ack from ACPI people before this can be
> > accepted - you are in effect proposing a new way for representing PHYs
> > in ACPI.
> 
> Thanks for your review.
> 
> Agree that we need an ack from ACPI people.
> However, I don't think it is a completely new way as similar acpi approach to
> get phy-handle is already in place.
> Please see this:
> https://elixir.bootlin.com/linux/v5.7-rc3/source/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c#L832

That was added by:

commit 8089a96f601bdfe3e1b41d14bb703aafaf1b8f34
Author: Iyappan Subramanian <isubramanian@apm.com>
Date:   Mon Jul 25 17:12:41 2016 -0700

    drivers: net: xgene: Add backward compatibility

    This patch adds xgene_enet_check_phy_hanlde() function that checks whether
    MDIO driver is probed successfully and sets pdata->mdio_driver to true.
    If MDIO driver is not probed, ethernet driver falls back to backward
    compatibility mode.

    Since enum xgene_enet_cmd is used by MDIO driver, removing this from
    ethernet driver.

    Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
    Tested-by: Fushen Chen <fchen@apm.com>
    Tested-by: Toan Le <toanle@apm.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

The commit message says nothing about adding ACPI stuff, and searching
the 'net for the posting of this patch seems to suggest that it wasn't
obviously copied to any ACPI people:

    https://lists.openwall.net/netdev/2016/07/26/11

Annoyingly, searching for:

    "drivers: net: xgene: Add backward compatibility" site:lore.kernel.org

doesn't find it on lore, so can't get the full headers and therefore
addresses.

So, yes, there's another driver using it, but the ACPI folk probably
never got a look-in on that instance.  Even if they had been copied,
the patch description is probably sufficiently poor that they wouldn't
have read the patch.

I'd say there's questions over whether ACPI people will find this an
acceptable approach.

Given that your patch moves this from one driver to a subsystem thing,
it needs to be ratified by ACPI people, because it's effectively
becoming a standardised way to represent a PHY in ACPI.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
