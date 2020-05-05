Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FB41C6498
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 01:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbgEEXkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 19:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727895AbgEEXkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 19:40:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426FEC061A0F;
        Tue,  5 May 2020 16:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=i7LzIqelxTirgC24kz7WiSVTVMleXcRWmalGKIurdBs=; b=NWIDf8yHMHJLmpK5AJ7C6BGBW
        KEplB4MxY0qLv8jphSm5OygZjvB3GdaGb0ILO1+Iuog6hNiuZk/fzt8OKgPoSOY8rx/wOFyGr0LvN
        p6ILzTHq5VEXfDmaI7Lne6pbEHQWn18kfXMD0JrVNYcM9oo7jqT66EHvuQRVY13tu3Fpa5BM5JNUv
        80DIn4PNi5bvPxZfIvrXWXsHCIhVE3kOztJA3d3fIrt6X7tLSG4JmYjwrULrjjeKPjoHJBVGba3VH
        fIjarqLFLVRQe5xD23tnJEVkjIvataodA5AOnAA+1PVFLlAfXesdTj8b1RtFCdUUaKPb4iczk7aW4
        E+UmKE29A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56670)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jW7AM-0005GA-9P; Wed, 06 May 2020 00:39:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jW7AE-0007aX-E1; Wed, 06 May 2020 00:39:50 +0100
Date:   Wed, 6 May 2020 00:39:50 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>, linux.cj@gmail.com,
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
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v3 1/5] net: phy: Introduce phy related fwnode
 functions
Message-ID: <20200505233950.GM1551@shell.armlinux.org.uk>
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
 <20200505132905.10276-2-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505132905.10276-2-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 06:59:01PM +0530, Calvin Johnson wrote:
> +static inline struct phy_device *device_phy_find_device(struct device *dev)
> +{
> +	return NULL;
> +}
> +
> +struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
> +{
> +	return NULL;
> +}

This wants to be "static inline" to avoid the issue the 0-day robot
found.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
