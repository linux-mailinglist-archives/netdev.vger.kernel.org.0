Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BB132D43C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 14:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240657AbhCDNdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 08:33:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39840 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233758AbhCDNdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 08:33:22 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lHo5g-009I8K-7F; Thu, 04 Mar 2021 14:32:32 +0100
Date:   Thu, 4 Mar 2021 14:32:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net 1/2] net: dsa: sja1105: fix SGMII PCS being forced to
 SPEED_UNKNOWN instead of SPEED_10
Message-ID: <YEDhcK4Hxq3E9k8b@lunn.ch>
References: <20210304105654.873554-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304105654.873554-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 04, 2021 at 12:56:53PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When using MLO_AN_PHY or MLO_AN_FIXED, the MII_BMCR of the SGMII PCS is
> read before resetting the switch so it can be reprogrammed afterwards.
> This works for the speeds of 1Gbps and 100Mbps, but not for 10Mbps,
> because SPEED_10 is actually 0, so AND-ing anything with 0 is false,
> therefore that last branch is dead code.
> 
> Do what others do (genphy_read_status_fixed, phy_mii_ioctl) and just
> remove the check for SPEED_10, let it fall into the default case.
> 
> Fixes: ffe10e679cec ("net: dsa: sja1105: Add support for the SGMII port")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
