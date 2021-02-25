Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69D33248B5
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 03:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235941AbhBYCAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 21:00:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56920 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235863AbhBYCAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 21:00:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lF5wV-008Klg-HP; Thu, 25 Feb 2021 02:59:51 +0100
Date:   Thu, 25 Feb 2021 02:59:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Melki <christian.melki@t2data.com>
Cc:     kuba@kernel.org, hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net] net: phy: micrel: set soft_reset callback to
 genphy_soft_reset for KSZ8081
Message-ID: <YDcEl2vPZ5XABMsR@lunn.ch>
References: <20210224205536.9349-1-christian.melki@t2data.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224205536.9349-1-christian.melki@t2data.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 09:55:36PM +0100, Christian Melki wrote:
> Following a similar reinstate for the KSZ9031.
> 
> Older kernels would use the genphy_soft_reset if the PHY did not implement
> a .soft_reset.
> 
> Bluntly removing that default may expose a lot of situations where various
> PHYs/board implementations won't recover on various changes.
> Like with this implementation during a 4.9.x to 5.4.x LTS transition.
> I think it's a good thing to remove unwanted soft resets but wonder if it
> did open a can of worms?
> 
> Atleast this fixes one iMX6 FEC/RMII/8081 combo.
> 
> Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
> Signed-off-by: Christian Melki <christian.melki@t2data.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
