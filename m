Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206B82DC329
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 16:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgLPPdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 10:33:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57492 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgLPPdf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 10:33:35 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kpYnI-00CJAy-GG; Wed, 16 Dec 2020 16:32:48 +0100
Date:   Wed, 16 Dec 2020 16:32:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 2/7] net: dsa: be louder when a non-legacy
 FDB operation fails
Message-ID: <20201216153248.GB2901580@lunn.ch>
References: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
 <20201213140710.1198050-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201213140710.1198050-3-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 04:07:05PM +0200, Vladimir Oltean wrote:
> The dev_close() call was added in commit c9eb3e0f8701 ("net: dsa: Add
> support for learning FDB through notification") "to indicate inconsistent
> situation" when we could not delete an FDB entry from the port.
> 
> bridge fdb del d8:58:d7:00:ca:6d dev swp0 self master
> 
> It is a bit drastic and at the same time not helpful if the above fails
> to only print with netdev_dbg log level, but on the other hand to bring
> the interface down.
> 
> So increase the verbosity of the error message, and drop dev_close().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
