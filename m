Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA32313973
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 17:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbhBHQa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 11:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbhBHQ3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 11:29:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED05BC061786;
        Mon,  8 Feb 2021 08:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wd3NQ7jvBJekE/Q3L0BhBL56hsU4rrZSvP5lEzeZjdQ=; b=gyYwk9jV5WbkAYSYTsOv5WiVB
        viFcAotojHEvc8naHZ5pZw4qc22smB/hwFUhAbPxpS9JNfRhtZgXf1VYgbUFHkO7hBAmHX/aqqW9N
        eFR34uk7+QT2j4nzDyE8NgqNSROLGyMinjmalsjwTlRKTK0YGH8tfnvYEnn2rB2p4x1Wj/r6sABJI
        ZtJGYCsixRYaR8ZRFim+7K2ownflUlp0FjpxcyQ0LytPRUlXsW890TncOIysi9ltzQyOdo70ydkAL
        LWNUVyN+xiZ2y/PknqLK6r5y5Pfp3SKLyIqMLaFzOYjZuJgfjAEWD/B/cfqvSfhG+wIwitiobo2LL
        yxbaSx/xg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40832)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l99Oq-0002GK-F2; Mon, 08 Feb 2021 16:28:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l99Op-0003Bv-EX; Mon, 08 Feb 2021 16:28:31 +0000
Date:   Mon, 8 Feb 2021 16:28:31 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v5 15/15] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
Message-ID: <20210208162831.GM1463@shell.armlinux.org.uk>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
 <20210208151244.16338-16-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208151244.16338-16-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 08:42:44PM +0530, Calvin Johnson wrote:
> Modify dpaa2_mac_connect() to support ACPI along with DT.
> Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
> DT or ACPI.
> 
> Replace of_get_phy_mode with fwnode_get_phy_mode to get
> phy-mode for a dpmac_node.
> 
> Use helper function phylink_fwnode_phy_connect() to find phy_dev and
> connect to mac->phylink.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

I don't think this does the full job.

>  static int dpaa2_pcs_create(struct dpaa2_mac *mac,
> -			    struct device_node *dpmac_node, int id)
> +			    struct fwnode_handle *dpmac_node,
> +			    int id)
>  {
>  	struct mdio_device *mdiodev;
> -	struct device_node *node;
> +	struct fwnode_handle *node;
>  
> -	node = of_parse_phandle(dpmac_node, "pcs-handle", 0);
> -	if (!node) {
> +	node = fwnode_find_reference(dpmac_node, "pcs-handle", 0);
> +	if (IS_ERR(node)) {
>  		/* do not error out on old DTS files */
>  		netdev_warn(mac->net_dev, "pcs-handle node not found\n");
>  		return 0;
>  	}
>  
> -	if (!of_device_is_available(node)) {
> +	if (!of_device_is_available(to_of_node(node))) {

If "node" is an ACPI node, then to_of_node() returns NULL, and
of_device_is_available(NULL) is false. So, if we're using ACPI
and we enter this path, we will always hit the error below:

>  		netdev_err(mac->net_dev, "pcs-handle node not available\n");
> -		of_node_put(node);
> +		of_node_put(to_of_node(node));
>  		return -ENODEV;
>  	}

> @@ -306,7 +321,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  	 * error out if the interface mode requests them and there is no PHY
>  	 * to act upon them
>  	 */
> -	if (of_phy_is_fixed_link(dpmac_node) &&
> +	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&

If "dpmac_node" is an ACPI node, to_of_node() will return NULL, and
of_phy_is_fixed_link() will oops.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
