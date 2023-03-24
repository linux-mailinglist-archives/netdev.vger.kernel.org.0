Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42596C82D2
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbjCXREr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjCXREp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:04:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97A51815C;
        Fri, 24 Mar 2023 10:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YZTvo4re7ukycagR5LNjBgnmgr5GpRxpdGMsq3Xv67c=; b=kh34JUjDbQxLs/xBxq75Puf/ts
        f8PxI4lo6IOWLC9CMbESFCU5XCfy6v3vEV/lZlmJtdqZTSjXilgLgrhhB+Mhw10yS1xIS5lVclD4O
        oUokrCd+URgeTHQq5ClBKQbwB0Xjom7NbHfTwIQOrnwnk0hwPvCH71blIk5ySCyDwuDQlmZEzTgyZ
        Nnk5hpAs5TAvyDkIRJ8qQ22D02ayeRn/LJhGE19um9f0pVCNog6VwpXDKLJg8vDD9RDEAsAoAh8IP
        yyhfj2KKqPLW8VntEKEaGVFIIJm4RcecYbaZW9UGbN1ZtJzY980bvMss1Tss4/8ZGT9M8ScBSRyzD
        rJAEy9bw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39534)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfkq5-0007Ra-5C; Fri, 24 Mar 2023 17:04:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfkq1-0002av-Ns; Fri, 24 Mar 2023 17:04:25 +0000
Date:   Fri, 24 Mar 2023 17:04:25 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 6/7] net: dsa: mv88e6xxx: provide software
 node for default settings
Message-ID: <ZB3YGWTWLYyecgw7@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
 <ZB24fDEqwx53Rthm@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZB24fDEqwx53Rthm@kuha.fi.intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 04:49:32PM +0200, Heikki Krogerus wrote:
> Hi Russell,
> 
> On Wed, Mar 22, 2023 at 12:00:21PM +0000, Russell King (Oracle) wrote:
> > +static struct fwnode_handle *mv88e6xxx_create_fixed_swnode(struct fwnode_handle *parent,
> > +							   int speed,
> > +							   int duplex)
> > +{
> > +	struct property_entry fixed_link_props[3] = { };
> > +
> > +	fixed_link_props[0] = PROPERTY_ENTRY_U32("speed", speed);
> > +	if (duplex == DUPLEX_FULL)
> > +		fixed_link_props[1] = PROPERTY_ENTRY_BOOL("full-duplex");
> > +
> > +	return fwnode_create_named_software_node(fixed_link_props, parent,
> > +						 "fixed-link");
> > +}
> > +
> > +static struct fwnode_handle *mv88e6xxx_create_port_swnode(phy_interface_t mode,
> > +							  int speed,
> > +							  int duplex)
> > +{
> > +	struct property_entry port_props[2] = {};
> > +	struct fwnode_handle *fixed_link_fwnode;
> > +	struct fwnode_handle *new_port_fwnode;
> > +
> > +	port_props[0] = PROPERTY_ENTRY_STRING("phy-mode", phy_modes(mode));
> > +	new_port_fwnode = fwnode_create_software_node(port_props, NULL);
> > +	if (IS_ERR(new_port_fwnode))
> > +		return new_port_fwnode;
> > +
> > +	fixed_link_fwnode = mv88e6xxx_create_fixed_swnode(new_port_fwnode,
> > +							  speed, duplex);
> > +	if (IS_ERR(fixed_link_fwnode)) {
> > +		fwnode_remove_software_node(new_port_fwnode);
> > +		return fixed_link_fwnode;
> > +	}
> > +
> > +	return new_port_fwnode;
> > +}
> 
> That new fwnode_create_named_software_node() function looks like a
> conflict waiting to happen - if a driver adds a node to the root level
> (does not have to be root level), all the tests will pass because
> there is only a single device, but when a user later tries the driver
> with two devices, it fails, because the node already exist. But you
> don't need that function at all.

I think you're totally failing to explain how this can fail.

Let me reiterate what thestructure of the swnodes here is:

	root
	`- node%d (%d allocated by root IDA)
	   +- phy-mode property
	   `- fixed-link
	      +- speed property
	      `- optional full-duplex property

If we have two different devices creating these nodes, then at the
root level, they will end up having different root names. The
"fixed-link" is a child of this node.

swnode already allows multiple identical names at the sub-node
level - each node ends up with its own IDA to allocate the generic
"node%d" names from. So as soon as we have multiple nodes, they
end up as this:

	root
	+- node0
	|  `- node 0
	+- node1
	|  `- node 0
	+- node2
	|  `- node 0
	etc

So, if we end up with two devices creating these at the same time,
we end up with:

	root
	+- nodeA (A allocated by root IDA)
	|  +- phy-mode property
	|  `- fixed-link
	|     +- speed property
	|     `- optional full-duplex property
	`- nodeB (B allocated by root IDA, different from above)
	   +- phy-mode property
	   `- fixed-link
	      +- speed property
	      `- optional full-duplex property

Since the kobject is parented to the parent's kobject, what we
end up with in sysfs is:

	.../nodeA/fixed-link/speed
	.../nodeB/fixed-link/speed

Thus, the "fixed-link" ndoes can _not_ conflict.

Please explain in detail where you think the conflict is, because
so far no one has been able to counter my assertions that this is
_safe_ with a proper full technical description of the problem.
All I get is hand-wavey "this conflicts".

Honestly, I'm getting sick of poor quality reviews... the next
poor review that claims there's a conflict here without properly
explain it will be told where to go.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
