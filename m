Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EAA1C59BD
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgEEOg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729123AbgEEOg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:36:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1B9C061A0F;
        Tue,  5 May 2020 07:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JHqeW2n9o8eTf4Hj7Xby8dss3L4FHej0u+cvFpm1AoA=; b=GDDaMxFr/i1udh9LrXu6dWreK
        r28SRTfpehqGgO/3BlnNRVwB7mdrW7xBnVPGeiIGVOAiDzF0/5vmc8zgNIAfZQvFfXyZATf+kRN+3
        iRS+dtALs24P+0ElYCsS78KRX48bXcODPVQFpR878hQogOs4f7kOvk3XkpCGUd/wKpQ+GKJfNPbRF
        rIDFJgJdyViOV9mRsMuoGh3ylNSsPtvnj5y2YDGOSxZj3GIOnP0q8WHr+39iLDLynHDCNF0ILLypd
        HixG9HokCuyUkZhIe9aAENG+VoIYS13gGtzTZnjundmF+bmjSQJlnUSDMFlVclzcDlgHfo1hRslzS
        EpnQu/4QA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56510)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jVyfz-0002xZ-I8; Tue, 05 May 2020 15:36:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jVyfv-0007Dz-PQ; Tue, 05 May 2020 15:35:59 +0100
Date:   Tue, 5 May 2020 15:35:59 +0100
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
Subject: Re: [net-next PATCH v3 3/5] phylink: Introduce
 phylink_fwnode_phy_connect()
Message-ID: <20200505143559.GJ1551@shell.armlinux.org.uk>
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
 <20200505132905.10276-4-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505132905.10276-4-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 06:59:03PM +0530, Calvin Johnson wrote:
> Define phylink_fwnode_phy_connect() to connect phy specified by
> a fwnode to a phylink instance.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
> Changes in v3:
>   remove NULL return check as it is invalid
>   remove unused phylink_device_phy_connect()
> 
> Changes in v2:
>   replace of_ and acpi_ code with generic fwnode to get phy-handle.
> 
>  drivers/net/phy/phylink.c | 48 +++++++++++++++++++++++++++++++++++++++
>  include/linux/phylink.h   |  3 +++
>  2 files changed, 51 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 0f23bec431c1..560d1069426c 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -961,6 +961,54 @@ int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
>  }
>  EXPORT_SYMBOL_GPL(phylink_connect_phy);
>  
> +/**
> + * phylink_fwnode_phy_connect() - connect the PHY specified in the fwnode.
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + * @fwnode: a pointer to a &struct fwnode_handle.
> + * @flags: PHY-specific flags to communicate to the PHY device driver
> + *
> + * Connect the phy specified @fwnode to the phylink instance specified
> + * by @pl. Actions specified in phylink_connect_phy() will be
> + * performed.
> + *
> + * Returns 0 on success or a negative errno.
> + */
> +int phylink_fwnode_phy_connect(struct phylink *pl,
> +			       struct fwnode_handle *fwnode,
> +			       u32 flags)
> +{
> +	struct fwnode_handle *phy_fwnode;
> +	struct phy_device *phy_dev;
> +	int ret = 0;
> +
> +	/* Fixed links and 802.3z are handled without needing a PHY */
> +	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
> +	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
> +	     phy_interface_mode_is_8023z(pl->link_interface)))
> +		return 0;
> +
> +	phy_fwnode = fwnode_get_phy_node(fwnode);
> +	if ((IS_ERR(phy_fwnode)) && pl->cfg_link_an_mode == MLO_AN_PHY)
> +		return -ENODEV;

This doesn't reflect the behaviour of phylink_of_phy_connect() - it is
*not* a cleanup of what is there, which is:

                if (!phy_node) {
                        if (pl->cfg_link_an_mode == MLO_AN_PHY)
                                return -ENODEV;
                        return 0;
                }

which does:

- if there is a PHY node, find the PHY and connect it.
- if there is no PHY node, then:
   + if we are expecting a PHY to be present, return an error.
   + otherwise, it is not a problem, continue.

That is very important behaviour - it allows drivers to call
phylink_*_phy_connect() without knowing whether there should or should
not be a PHY - and keeps that knowledge within phylink.  It means
network drivers don't have to parse the firmware to find out if there's
a fixed link or SFP cage attached, and decide whether to call these
functions.

> +
> +	phy_dev = fwnode_phy_find_device(phy_fwnode);
> +	fwnode_handle_put(phy_fwnode);
> +	if (!phy_dev)
> +		return -ENODEV;
> +
> +	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
> +				pl->link_interface);
> +	if (ret)
> +		return ret;
> +
> +	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
> +	if (ret)
> +		phy_detach(phy_dev);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phylink_fwnode_phy_connect);
> +

I think we need to go further with this, and we need to have
phylink_fwnode_phy_connect() functionally identical to
phylink_of_phy_connect() for DT-based fwnodes.  Doing so will avoid
introducing errors such as the one you've added above.

The only difference between these two is that DT has a number of
legacy properties - these can be omitted if the fwnode is not a DT
node.

Remember that fwnode is compatible with DT, so fwnode_phy_find_device()
can internally decide whether to look for the ACPI property or one of
the three DT properties.

It also means that phylink_of_phy_connect() can become:

int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
                           u32 flags)
{
        return phylink_fwnode_phy_connect(pl, of_fwnode_handle(dn), flags);
}

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
