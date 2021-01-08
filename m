Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD302EEACB
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 02:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbhAHBMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 20:12:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56202 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729561AbhAHBMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 20:12:25 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxgJX-00GnQl-AZ; Fri, 08 Jan 2021 02:11:39 +0100
Date:   Fri, 8 Jan 2021 02:11:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Danielle Ratson <danieller@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@nvidia.com, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: Re: [PATCH net-next repost v2 2/7] ethtool: Get link mode in use
 instead of speed and duplex parameters
Message-ID: <X/exS1VmkmxCI8TK@lunn.ch>
References: <20210106130622.2110387-1-danieller@mellanox.com>
 <20210106130622.2110387-3-danieller@mellanox.com>
 <20210107164240.17fcda6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107164240.17fcda6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> > index 05073482db05..c21e71e0c0e8 100644
> > --- a/Documentation/networking/ethtool-netlink.rst
> > +++ b/Documentation/networking/ethtool-netlink.rst
> > @@ -406,6 +406,7 @@ Kernel response contents:
> >    ``ETHTOOL_A_LINKMODES_PEER``                bitset  partner link modes
> >    ``ETHTOOL_A_LINKMODES_SPEED``               u32     link speed (Mb/s)
> >    ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
> > +  ``ETHTOOL_A_LINKMODES_LINK_MODE``           u8      link mode
> 
> Are there other places in the uapi we already limit ourselves to 
> u8 / max 255? Otherwise u32 is better, the nlattr will be padded,
> anyway.

Only allowing 255 values might be too limiting. We already have 91 of
them. It was initially thought that 32 would be enough, and fixing
that limitation was a lot of work.

     Andrew
