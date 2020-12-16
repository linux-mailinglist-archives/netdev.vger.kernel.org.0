Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3B02DC35B
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 16:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgLPPnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 10:43:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57586 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgLPPnn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 10:43:43 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kpYxA-00CJG5-V9; Wed, 16 Dec 2020 16:43:00 +0100
Date:   Wed, 16 Dec 2020 16:43:00 +0100
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
Subject: Re: [PATCH v3 net-next 7/7] net: dsa: ocelot: request DSA to fix up
 lack of address learning on CPU port
Message-ID: <20201216154300.GF2901580@lunn.ch>
References: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
 <20201213140710.1198050-8-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201213140710.1198050-8-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 04:07:10PM +0200, Vladimir Oltean wrote:
> Given the following setup:
> 
> ip link add br0 type bridge
> ip link set eno0 master br0
> ip link set swp0 master br0
> ip link set swp1 master br0
> ip link set swp2 master br0
> ip link set swp3 master br0
> 
> Currently, packets received on a DSA slave interface (such as swp0)
> which should be routed by the software bridge towards a non-switch port
> (such as eno0) are also flooded towards the other switch ports (swp1,
> swp2, swp3) because the destination is unknown to the hardware switch.
> 
> This patch addresses the issue by monitoring the addresses learnt by the
> software bridge on eno0, and adding/deleting them as static FDB entries
> on the CPU port accordingly.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
