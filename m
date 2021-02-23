Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2493323168
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 20:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhBWTZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 14:25:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231827AbhBWTYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 14:24:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A567264DF3;
        Tue, 23 Feb 2021 19:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614108245;
        bh=l4t8uWb8DAsf7kJCaLUF0TLZ7FQgm2OzB/Hxw9fmfLQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JCw2wmIimQr7ruU1D3wdesSy6Feri72V3pXPNI/ZbZxvUYA2CO6y33qnNeaFkQ6Mw
         sHoBaLAnxP50xQRHRQVtEGDi/veTG2m6IxSmgEKAJ8XBGcwfTMe7fSAi/BzNsFxg7E
         s1jY1H00v6ZKBJfy6VdrsIXJHRBCdILwYd5E+tlb3z8jqwSq8gT14EX+Cq+qGpvwlh
         VgWbE/Azmr3lKnadq/0u1Ib6ylldhVMgRgwoyttPjdEUygw9NYwXE69SIL45o6gO7M
         dSGgMzzUWufNEBG3F7RYAAC7Jdwgib0tJf19L5A9NNllqXy+yc80OY2YDnSzqfPuGF
         gSxAmx2NLOhrQ==
Date:   Tue, 23 Feb 2021 11:24:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Melki <christian.melki@t2data.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH v2 net] net: phy: micrel: set soft_reset callback to
 genphy_soft_reset for KSZ8081
Message-ID: <20210223112402.7ed1fe93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c1adb83f-57dc-9a97-f10a-c0853cdd8f09@t2data.com>
References: <c1adb83f-57dc-9a97-f10a-c0853cdd8f09@t2data.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 09:30:30 +0100 Christian Melki wrote:
> Following a similar reinstate for the KSZ9031.
> 
> Older kernels would use the genphy_soft_reset if the PHY did not 
> implement a .soft_reset.
> 
> Bluntly removing that default may expose a lot of situations where 
> various PHYs/board implementations won't recover on various changes.
> Like with tgus implementation during a 4.9.x to 5.4.x LTS transition.
> I think it's a good thing to remove unwanted soft resets but wonder if 
> it did open a can of worms?
> 
> Atleast this fixes one iMX6 FEC/RMII/8081 combo.
> 
> Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
> Signed-off-by: Christian Melki <christian.melki@t2data.com>

Still does not apply to net/master:

Applying: net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8081
error: patch failed: drivers/net/phy/micrel.c:1303
error: drivers/net/phy/micrel.c: patch does not apply
Patch failed at 0001 net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8081
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
