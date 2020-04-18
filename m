Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6B21AEC17
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 13:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgDRLin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 07:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725826AbgDRLim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 07:38:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EF2C061A0C;
        Sat, 18 Apr 2020 04:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YzCIraB2l/Lt/pX1w7eqa5nEw+BnjwIsYHWmi6W/bHw=; b=ZLljGH2yND0Zm9AGUF8VeySby
        jiqWKIXoPkD7CDT4CNyOdkqpVeCwE9oiL1X4ziYLUoCiVpTuFbUCLekM/yWmKxAAzJnZ5sWv7Z5+e
        2qJaraB3ZJkWmykVYMD86iUd2bLTvpi/7+mFzak8fExuAqN/40cahMs+mX1OVyWoZ66I2ZnL7iqi7
        SS0IbZX/KvwdXUSlKDDw/r7TGFl6hzp0Xs+4fo1si4rs7Yd9j/Rrw+wuuOZZI0K2K1pv9zihQoUgs
        O32hsruWXFqGq+cJS1eUTx3PTYv6cMxhi/4pxLiIEEfTgdtDwDaCyR7nS4vO3I+BI8d7Ya/IC/6ES
        27sUCYMnQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51702)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jPlnf-0007pI-IV; Sat, 18 Apr 2020 12:38:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jPlnZ-0003pI-QH; Sat, 18 Apr 2020 12:38:13 +0100
Date:   Sat, 18 Apr 2020 12:38:13 +0100
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
        netdev@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, Varun Sethi <V.Sethi@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [RFC net-next PATCH v2 2/2] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
Message-ID: <20200418113813.GT25745@shell.armlinux.org.uk>
References: <20200418105432.11233-1-calvin.johnson@oss.nxp.com>
 <20200418105432.11233-3-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418105432.11233-3-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 04:24:32PM +0530, Calvin Johnson wrote:
> Modify dpaa2_mac_connect() to support ACPI along with DT.
> Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
> DT or ACPI.
> Replace of_get_phy_mode with fwnode_get_phy_mode to get
> phy-mode for a dpmac_node.
> Define and use helper functions fwnode_phy_match() and
> fwnode_phy_find_device() to find phy_dev that is later
> connected to mac->phylink.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
> Changes in v2:
> - Major change following other network drivers supporting ACPI
> - dropped v1 patches 1, 2, 4, 5 and 6 as they are no longer valid
> - incorporated other v1 review comments
> 
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 122 ++++++++++++++----
>  1 file changed, 94 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index 3ee236c5fc37..5a03da54a67f 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -3,6 +3,9 @@
>  
>  #include "dpaa2-eth.h"
>  #include "dpaa2-mac.h"
> +#include <linux/acpi.h>
> +#include <linux/phy.h>
> +#include <linux/phylink.h>

Why do you need linux/phy.h and linux/phylink.h here?  Please try
building the driver without; you'll find they are already included
via dpaa2-mac.h.

> +static int fwnode_phy_match(struct device *dev, const void *phy_fwnode)
> +{
> +	return dev->fwnode == phy_fwnode;
> +}
> +
> +static struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
> +{
> +	struct device *d;
> +	struct mdio_device *mdiodev;
> +
> +	if (!phy_fwnode)
> +		return NULL;
> +
> +	d = bus_find_device(&mdio_bus_type, NULL, phy_fwnode, fwnode_phy_match);
> +	if (d) {
> +		mdiodev = to_mdio_device(d);
> +		if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
> +			return to_phy_device(d);
> +		put_device(d);
> +	}
> +
> +	return NULL;
> +}

This is groping around in the mdio bus implementation details; drivers
must not do this layering violation.  Please propose an interface in
the mdio code to do what you need.

> +
>  int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  {
>  	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
>  	struct net_device *net_dev = mac->net_dev;
> -	struct device_node *dpmac_node;
> +	struct fwnode_handle *dpmac_node = NULL;
> +	struct fwnode_reference_args args;
> +	struct phy_device *phy_dev;
>  	struct phylink *phylink;
>  	struct dpmac_attr attr;
> +	int status;
>  	int err;
>  
>  	err = dpmac_open(mac->mc_io, 0, dpmac_dev->obj_desc.id,
> @@ -251,7 +299,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  
>  	mac->if_link_type = attr.link_type;
>  
> -	dpmac_node = dpaa2_mac_get_node(attr.id);
> +	dpmac_node = dpaa2_mac_get_node(&mac->mc_dev->dev, attr.id);
>  	if (!dpmac_node) {
>  		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
>  		err = -ENODEV;
> @@ -269,7 +317,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  	 * error out if the interface mode requests them and there is no PHY
>  	 * to act upon them
>  	 */
> -	if (of_phy_is_fixed_link(dpmac_node) &&
> +	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
>  	    (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
>  	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
>  	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
> @@ -282,7 +330,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  	mac->phylink_config.type = PHYLINK_NETDEV;
>  
>  	phylink = phylink_create(&mac->phylink_config,
> -				 of_fwnode_handle(dpmac_node), mac->if_mode,
> +				 dpmac_node, mac->if_mode,
>  				 &dpaa2_mac_phylink_ops);
>  	if (IS_ERR(phylink)) {
>  		err = PTR_ERR(phylink);
> @@ -290,20 +338,38 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  	}
>  	mac->phylink = phylink;
>  
> -	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
> +	if (is_of_node(dpmac_node))
> +		err = phylink_of_phy_connect(mac->phylink,
> +					     to_of_node(dpmac_node), 0);
> +	else if (is_acpi_node(dpmac_node)) {
> +		status = acpi_node_get_property_reference(dpmac_node,
> +							  "phy-handle",
> +							  0, &args);
> +		if (ACPI_FAILURE(status))
> +			goto err_phylink_destroy;
> +		phy_dev = fwnode_phy_find_device(args.fwnode);
> +		if (!phy_dev)
> +			goto err_phylink_destroy;
> +
> +		err = phylink_connect_phy(mac->phylink, phy_dev);
> +		if (err)
> +			phy_detach(phy_dev);

phy_detach() reverses the effect of phy_attach_direct().  This is not
the correct cleanup function in this case, because the PHY hasn't been
attached (and phylink_connect_phy() will clean up any effects it has
on error.)  You only need to reverse the effect of your
fwnode_phy_find_device(), which phy_detach() is inappropriate for.

In any case, if this method of getting a PHY is accepted by ACPI folk,
it could be moved into a helper in phylink_fwnode_phy_connect() - and
that really needs to happen before a patch adding this functionality is
acceptable.

> +	}
>  	if (err) {
> -		netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
> +		netdev_err(net_dev, "phylink_fwnode_phy_connect() = %d\n", err);

That's a very misleading change - there is no function named as per your
new name.

>  		goto err_phylink_destroy;
>  	}
>  
> -	of_node_put(dpmac_node);
> +	if (is_of_node(dpmac_node))
> +		of_node_put(to_of_node(dpmac_node));
>  
>  	return 0;
>  
>  err_phylink_destroy:
>  	phylink_destroy(mac->phylink);
>  err_put_node:
> -	of_node_put(dpmac_node);
> +	if (is_of_node(dpmac_node))
> +		of_node_put(to_of_node(dpmac_node));
>  err_close_dpmac:
>  	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
>  	return err;
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
