Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B507A1BA58C
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgD0N6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbgD0N6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 09:58:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77888C0610D5;
        Mon, 27 Apr 2020 06:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HI+hXdef3teFcq3aFHJ+lNQ36+H/xnayzEP1cLz139A=; b=m8KykkkylWdoseBY1n/gsoqEh
        KVFTqlhC0kFSp30GS16jUkbUZq7hRIIFETkZzuGl9kBqK2RTa4RTpC3CXJ9+Rj7Y2/iLhSK6XgT3N
        ScefK7wtt9WxTxKjVKBC1wqYSRrECSrlLe9tbgSH1oytOZq2pylhi5zsVzFC+5p4NpsqR+RUNxT9D
        XtUWUAj78s5iuppoliNlc9owGzJlBFNQSFZrqSOPfgOik+W8NN+vB08RqRaYtuQPZwCNiRbA7SqBY
        h1PR2wiMjIpCXZqlGIY/VXWn7lBiRbKH5zdlKb0HDEBtgr2ibt+ebxHGba7DtaX29ZXB3ypvrWRYi
        E6rLzrZ9Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:44642)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jT4H7-0003EQ-Ql; Mon, 27 Apr 2020 14:58:22 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jT4H6-0006iG-Q0; Mon, 27 Apr 2020 14:58:20 +0100
Date:   Mon, 27 Apr 2020 14:58:20 +0100
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
Message-ID: <20200427135820.GH25745@shell.armlinux.org.uk>
References: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 06:54:06PM +0530, Calvin Johnson wrote:
> Following functions are defined:
>   phylink_fwnode_phy_connect()
>   phylink_device_phy_connect()
>   fwnode_phy_find_device()
>   device_phy_find_device()
>   fwnode_get_phy_node()
> 
> First two help in connecting phy to phylink instance.
> Next two help in finding a phy on a mdiobus.
> Last one helps in getting phy_node from a fwnode.
> 
> Changes in v2:
>   move phy code from base/property.c to net/phy/phy_device.c
>   replace acpi & of code to get phy-handle with fwnode_find_reference
>   replace of_ and acpi_ code with generic fwnode to get phy-handle.
> 
> Calvin Johnson (3):
>   device property: Introduce phy related fwnode functions
>   net: phy: alphabetically sort header includes
>   phylink: Introduce phylink_fwnode_phy_connect()

Thanks for this, but there's more work that needs to be done here.  I
also think that we must have an ack from ACPI people before this can be
accepted - you are in effect proposing a new way for representing PHYs
in ACPI.

> 
>  drivers/net/phy/phy_device.c | 83 ++++++++++++++++++++++++++++++------
>  drivers/net/phy/phylink.c    | 68 +++++++++++++++++++++++++++++
>  include/linux/phy.h          |  3 ++
>  include/linux/phylink.h      |  6 +++
>  4 files changed, 146 insertions(+), 14 deletions(-)
> 
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
