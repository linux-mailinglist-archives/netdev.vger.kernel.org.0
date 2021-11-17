Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D00C453EF8
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhKQDdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:33:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232890AbhKQDdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 22:33:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E9B9617E4;
        Wed, 17 Nov 2021 03:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637119809;
        bh=aUJxR7/AxG2LydPzILMvjaTrdWYcN3YlfwlE6JlB0Zo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XuM9AhiAReZzyguxjq3YsoaBc6ZrAtOuT1/n3PUDFrAOQS0ipDNXZs5cTo92PDaP1
         BScpWLnWCYz43TAsHWWzYdHpcY1qTDCJakejE+E3RNquJH+4tGaiJuz/xwfUjP3Grp
         594ySgGNEQp5m1rW3lzrdmLVHwMGAVttOkCl3aXE5RFGYNaoHAv4UBIY0/zD8ZjY4k
         gpD/wItMhbekGAZaMaEdqY2mh7SECIc6nHNA1g3WP7EEvNzq1Pg+788F2M7WrGeG8B
         J+sVS+0gQZiQxWvDsxEvhwSHgiTSmn6eftFQwemduo/OTlr/xN0/w1qU4TtSEXhv0M
         o6NalprLRsW5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6929360A4E;
        Wed, 17 Nov 2021 03:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: document SMII and correct phylink's new
 validation mechanism
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163711980942.5825.15434052999657595052.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 03:30:09 +0000
References: <E1mmfVl-0075nP-14@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mmfVl-0075nP-14@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Nov 2021 17:11:17 +0000 you wrote:
> SMII has not been documented in the kernel, but information on this PHY
> interface mode has been recently found. Document it, and correct the
> recently introduced phylink handling for this interface mode.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  Documentation/networking/phy.rst | 5 +++++
>  drivers/net/phy/phylink.c        | 2 +-
>  include/linux/phy.h              | 2 +-
>  3 files changed, 7 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: document SMII and correct phylink's new validation mechanism
    https://git.kernel.org/netdev/net-next/c/b9241f54138c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


