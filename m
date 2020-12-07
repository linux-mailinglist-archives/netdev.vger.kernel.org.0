Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62E62D17B3
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 18:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgLGRky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 12:40:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLGRky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 12:40:54 -0500
Date:   Mon, 7 Dec 2020 09:40:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607362813;
        bh=MUSXIOvIYzhGLYVrX7I8CQU70761ufoUa5AB7qW/OEw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=mC8gM5z+TxfnbMltfcC8XCR7RfXtoGkjK1b8gh/M6vjpUFBXYgU32+cOLFvnro5I5
         y5eN7hxwJCCMvnLf9duRbUylRvHObLYW29I9mD0XjCR65fuz+D3X7vZUPQMlUGkUTA
         XaDa5cma3vOIXBRj4YeWeO/AxXgeAGrQnOmRI7WISTAajaWfPG/o4Ee+49Xs6LPTu9
         1T5E5VBeeqR3vmu8akz65jkSsAYB3cv33Wxol16bodojJH0pbtZCfxr8vwNnxgL/VU
         vcOffL6aQGPOnEUI5hPKbkVP279T/WCj5oOArsBnEsg3eua8n/c7FLvEq4u7LwpYYy
         7YNSzw0DJZjSA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v4] devlink: Add devlink port documentation
Message-ID: <20201207094012.5853ff07@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <BY5PR12MB43227128D9DEDC9E41744017DCCE0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201130164119.571362-1-parav@nvidia.com>
        <20201203180255.5253-1-parav@nvidia.com>
        <20201205122717.76d193a2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <BY5PR12MB43227128D9DEDC9E41744017DCCE0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020 04:46:14 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Sunday, December 6, 2020 1:57 AM
> > 
> > On Thu, 3 Dec 2020 20:02:55 +0200 Parav Pandit wrote:  
> > > Added documentation for devlink port and port function related commands.
> > >
> > > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > > Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>  
> >   
> > > +============
> > > +Devlink Port
> > > +============
> > > +
> > > +``devlink-port`` is a port that exists on the device.  
> > 
> > Can we add something like:
> > 
> > Each port is a logically separate ingress/egress point of the device.
> > 
> > ?  
> This may not be true when both physical ports are under bond.

Bonding changes forwarding logic, not what points of egress ASIC has.

> > > Such PCI function consists
> > > +of one or more networking ports.  
> > 
> > PCI function consists of networking ports? What do you mean by a networking
> > port? All devlink ports are networking ports.
> >  
> I am not sure this document should be a starting point to define such restriction.

Well it's the reality today. Adding "networking" everywhere in this
document is pointless.

> > > A networking port of such PCI function is
> > > +represented by the eswitch devlink port.  
> > 
> > What's eswitch devlink port? It was never defined.  
> Eswitch devlink port is the port which sets eswitch attributes (id and length).

You mean phys_port_id?

> > > before
> > > +enumerating the function.  
> > 
> > What does this mean? What does enumerate mean in this context?
> >   
> Enumerate means before creating the device of the function.
> However today due to SR-IOV limitation, it is before probing the function device.

Can you rephrase to make the point clearer?

> > > For example user may set the hardware address of
> > > +the function represented by the devlink port function.  
> > 
> > What's a hardware address? You mean MAC address?  
> Yes, MAC address.
> Port function attribute is named as hardware address to be generic enough similar to other iproute2 tools.

Right, but in iproute2 the context makes it clear. Here we could be
talking about many things.
