Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A83B279C52
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 22:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgIZUWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 16:22:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57176 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbgIZUWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 16:22:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMGiB-00GJNw-Nq; Sat, 26 Sep 2020 22:22:27 +0200
Date:   Sat, 26 Sep 2020 22:22:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v3 net-next 02/15] net: dsa: allow drivers to request
 promiscuous mode on master
Message-ID: <20200926202227.GA3887691@lunn.ch>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
 <20200926193215.1405730-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926193215.1405730-3-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 10:32:02PM +0300, Vladimir Oltean wrote:
> Currently DSA assumes that taggers don't mess with the destination MAC
> address of the frames on RX. That is not always the case. Some DSA
> headers are placed before the Ethernet header (ocelot), and others
> simply mangle random bytes from the destination MAC address (sja1105
> with its incl_srcpt option).
> 
> Currently the DSA master goes to promiscuous mode automatically when the
> slave devices go too (such as when enslaved to a bridge), but in
> standalone mode this is a problem that needs to be dealt with.
> 
> So give drivers the possibility to signal that their tagging protocol
> will get randomly dropped otherwise, and let DSA deal with fixing that.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
