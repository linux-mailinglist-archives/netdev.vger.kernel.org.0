Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF5E2CD8CC
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436515AbgLCORK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:17:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36452 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgLCORC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 09:17:02 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkpP8-00A2wB-MX; Thu, 03 Dec 2020 15:16:18 +0100
Date:   Thu, 3 Dec 2020 15:16:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, catherine.redmond@analog.com,
        brian.murray@analog.com, danail.baylov@analog.com,
        maurice.obrien@analog.com
Subject: Re: [PATCH] net: phy: adin: add signal mean square error registers
 to phy-stats
Message-ID: <20201203141618.GD2333853@lunn.ch>
References: <20201203080719.30040-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203080719.30040-1-alexandru.ardelean@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 10:07:19AM +0200, Alexandru Ardelean wrote:
> When the link is up on the ADIN1300/ADIN1200, the signal quality on each
> pair is indicated in the mean square error register for each pair (MSE_A,
> MSE_B, MSE_C, and MSE_D registers, Address 0x8402 to Address 0x8405,
> Bits[7:0]).
> 
> These values can be useful for some industrial applications.
> 
> This change implements support for these registers using the PHY
> statistics mechanism.

There was a discussion about values like these before. If i remember
correctly, it was for a BroadReach PHY. I thought we decided to add
them to the link state information?

Ah, found it.

commit 68ff5e14759e7ac1aac7bc75ac5b935e390fa2b3
Author: Oleksij Rempel <linux@rempel-privat.de>
Date:   Wed May 20 08:29:15 2020 +0200

    net: phy: tja11xx: add SQI support

and

ommit 8066021915924f58ed338bf38208215f5a7355f6
Author: Oleksij Rempel <linux@rempel-privat.de>
Date:   Wed May 20 08:29:14 2020 +0200

    ethtool: provide UAPI for PHY Signal Quality Index (SQI)

Can you convert your MSE into SQI?

    Andrew
