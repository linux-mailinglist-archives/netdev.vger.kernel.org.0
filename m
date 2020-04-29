Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBCA1BD989
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgD2K00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:26:26 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46400 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgD2K00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 06:26:26 -0400
Received: by mail-ot1-f68.google.com with SMTP id z25so1199844otq.13;
        Wed, 29 Apr 2020 03:26:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mvIHWhU04g3v6LjKSsky5pEk63GBz533E/sobmoo7Wc=;
        b=f3Nkvak66UjmGA9qsFMGjnOQsHTxX7S/iX5P4MRLEb2ZD7LUsHMkfaeeMZBN2dhf5I
         yMav5dxFky3KGtmstKdvClOyOAOj6QNjEp8ZKv2p4X0bbhyTpCSV4eDYfUvJDqkCyV8l
         aKuTF4yjCgvOA1bygw0cuYpKL6XMNQHXYxtpES/YN/FR1dJ1+WX1AF6BhXFpeEjrKJLd
         OUDlBrAlNb0922P9R1vV8XDmXXh6gqsuK5NDcryBtJIoIOA7PWNqQdunBBdfV5EBvlU5
         oo469ys7e1i2Kti0+5wOIWJmxOyDVHAIkcMfTIwVQBdmiqeNE5pGTgOgm15tNYrULjUV
         nqjg==
X-Gm-Message-State: AGi0PuYkJcfbc9hr6VSyJAX6wxFbnMcIkwRUosuZ0530+uVcj0T0WXtA
        ldPT6x+wE9P5+nCagBOODKdetDwviEu3xPZJcvw=
X-Google-Smtp-Source: APiQypJnyzo4VqldDo304UGZQtLY+7AXB7jFtaFmqclX/7CuNEy43JujxFtdEqaZN6afWwi2LXcTKDkxwr3nMu1panQ=
X-Received: by 2002:a9d:6ac8:: with SMTP id m8mr26003040otq.262.1588155984780;
 Wed, 29 Apr 2020 03:26:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
 <20200427135820.GH25745@shell.armlinux.org.uk> <20200427143238.GA26436@lsv03152.swis.in-blr01.nxp.com>
 <20200427144806.GI25745@shell.armlinux.org.uk> <20200429053753.GA12533@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20200429053753.GA12533@lsv03152.swis.in-blr01.nxp.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 29 Apr 2020 12:26:12 +0200
Message-ID: <CAJZ5v0g4oaDGGk1Jg5rihaG1kj1BYHpZpwTFrXX4Jo4tettbgg@mail.gmail.com>
Subject: Re: [net-next PATCH v2 0/3] Introduce new APIs to support phylink and
 phy layers
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, linux.cj@gmail.com,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 7:38 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> On Mon, Apr 27, 2020 at 03:48:07PM +0100, Russell King - ARM Linux admin wrote:
> > On Mon, Apr 27, 2020 at 08:02:38PM +0530, Calvin Johnson wrote:
> > > On Mon, Apr 27, 2020 at 02:58:20PM +0100, Russell King - ARM Linux admin wrote:
> > > > On Mon, Apr 27, 2020 at 06:54:06PM +0530, Calvin Johnson wrote:
> > > > > Following functions are defined:
> > > > >   phylink_fwnode_phy_connect()
> > > > >   phylink_device_phy_connect()
> > > > >   fwnode_phy_find_device()
> > > > >   device_phy_find_device()
> > > > >   fwnode_get_phy_node()
> > > > >
> > > > > First two help in connecting phy to phylink instance.
> > > > > Next two help in finding a phy on a mdiobus.
> > > > > Last one helps in getting phy_node from a fwnode.
> > > > >
> > > > > Changes in v2:
> > > > >   move phy code from base/property.c to net/phy/phy_device.c
> > > > >   replace acpi & of code to get phy-handle with fwnode_find_reference
> > > > >   replace of_ and acpi_ code with generic fwnode to get phy-handle.
> > > > >
> > > > > Calvin Johnson (3):
> > > > >   device property: Introduce phy related fwnode functions
> > > > >   net: phy: alphabetically sort header includes
> > > > >   phylink: Introduce phylink_fwnode_phy_connect()
> > > >
> > > > Thanks for this, but there's more work that needs to be done here.  I
> > > > also think that we must have an ack from ACPI people before this can be
> > > > accepted - you are in effect proposing a new way for representing PHYs
> > > > in ACPI.
> > >
> > > Thanks for your review.
> > >
> > > Agree that we need an ack from ACPI people.
> > > However, I don't think it is a completely new way as similar acpi approach to
> > > get phy-handle is already in place.
> > > Please see this:
> > > https://elixir.bootlin.com/linux/v5.7-rc3/source/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c#L832
> >
> > That was added by:
> >
> > commit 8089a96f601bdfe3e1b41d14bb703aafaf1b8f34
> > Author: Iyappan Subramanian <isubramanian@apm.com>
> > Date:   Mon Jul 25 17:12:41 2016 -0700
> >
> >     drivers: net: xgene: Add backward compatibility
> >
> >     This patch adds xgene_enet_check_phy_hanlde() function that checks whether
> >     MDIO driver is probed successfully and sets pdata->mdio_driver to true.
> >     If MDIO driver is not probed, ethernet driver falls back to backward
> >     compatibility mode.
> >
> >     Since enum xgene_enet_cmd is used by MDIO driver, removing this from
> >     ethernet driver.
> >
> >     Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
> >     Tested-by: Fushen Chen <fchen@apm.com>
> >     Tested-by: Toan Le <toanle@apm.com>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> > The commit message says nothing about adding ACPI stuff, and searching
> > the 'net for the posting of this patch seems to suggest that it wasn't
> > obviously copied to any ACPI people:
> >
> >     https://lists.openwall.net/netdev/2016/07/26/11
> >
> > Annoyingly, searching for:
> >
> >     "drivers: net: xgene: Add backward compatibility" site:lore.kernel.org
> >
> > doesn't find it on lore, so can't get the full headers and therefore
> > addresses.
> >
> > So, yes, there's another driver using it, but the ACPI folk probably
> > never got a look-in on that instance.  Even if they had been copied,
> > the patch description is probably sufficiently poor that they wouldn't
> > have read the patch.
> >
> > I'd say there's questions over whether ACPI people will find this an
> > acceptable approach.
> >
> > Given that your patch moves this from one driver to a subsystem thing,
> > it needs to be ratified by ACPI people, because it's effectively
> > becoming a standardised way to represent a PHY in ACPI.
>
> How can we get attention/response from ACPI people?

This is in my queue, but the processing of this has been slow for a
while, sorry about that.

If you have a new version of the series, please submit it, otherwise
ping me in a couple of days if I don't respond to the patches in the
meantime.

Thanks!
