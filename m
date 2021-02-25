Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D0B3254E0
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 18:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhBYRxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 12:53:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229993AbhBYRw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 12:52:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C740664F3B;
        Thu, 25 Feb 2021 17:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614275538;
        bh=FPTGhUGq7szHwsLCII12l77rlUJPQOEqsA5NMu+FjEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OVDCKUh4OdtGyq0AjyuOlND+f9YqhtfHn/hXW584fVntpwnm3Mw86G6p1etJQxzPs
         p15uoSpN29x+zS3Je9/5YdrAEBuvInwDXQ8suDl+8iWB6Ri6XiReh4RGeBu3pHhKA5
         A7ib3vJcCXhS0Atty07CwQxqBf398P7pSHwztMpeguPvykVMgFjR2uF+JRj9LYJ13D
         d2oDZ4HeCawb58hRyB428pTqt6/pZx6mWTiCDU1YZGVJpeSqcKKjttPJxHgvslhdIa
         iyjI4j62aO4ufxgUAHhHwlHrw9FkZDw1UlUcA+yqJC0I9VhjqHJ+aZQXddpuJY2tCD
         ja3sOlr6xrMzQ==
Date:   Thu, 25 Feb 2021 09:52:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Christian Melki <christian.melki@t2data.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net] net: phy: micrel: set soft_reset callback to
 genphy_soft_reset for KSZ8081
Message-ID: <20210225095216.73a7d799@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YDcEl2vPZ5XABMsR@lunn.ch>
References: <20210224205536.9349-1-christian.melki@t2data.com>
        <YDcEl2vPZ5XABMsR@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 02:59:51 +0100 Andrew Lunn wrote:
> On Wed, Feb 24, 2021 at 09:55:36PM +0100, Christian Melki wrote:
> > Following a similar reinstate for the KSZ9031.
> > 
> > Older kernels would use the genphy_soft_reset if the PHY did not implement
> > a .soft_reset.
> > 
> > Bluntly removing that default may expose a lot of situations where various
> > PHYs/board implementations won't recover on various changes.
> > Like with this implementation during a 4.9.x to 5.4.x LTS transition.
> > I think it's a good thing to remove unwanted soft resets but wonder if it
> > did open a can of worms?
> > 
> > Atleast this fixes one iMX6 FEC/RMII/8081 combo.
> > 
> > Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
> > Signed-off-by: Christian Melki <christian.melki@t2data.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
