Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B06145D270
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243960AbhKYBfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:35:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345567AbhKYBdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 20:33:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C0857610F9;
        Thu, 25 Nov 2021 01:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637803808;
        bh=OXajVRbnsvrCd8OKqNfQzuCkZeiFzfItGXfy7ktKpHE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n7xktyjfoaZrS8YGQlgZ4KtNvqsW3sGEuklURsnGlPhZZCeQHjMJHl3oQe9Z6CQ/E
         ylLHudEl+cdnkBuOvcfrt9/Tx4j8KA63KS/zKlsKkiruMcFrsAToNCeg0wzZyBpf6P
         QYdFOd3fiR6Uu1UIewJxXY5Glk+H8RRGWQp0uu4SaPzcLdp2X416D3qTPzhBB3dQpv
         qsMxmEX2YkA5TyD7UEr+FoZuptdDB6hGMy6WoDc/oWmlGvhTR5/kY3/10NcJPMhVXY
         YjndopTqtarSAZpsx3SJXVcjAqD8YrYD22pmn51EUQ+QxPVD9pY0RbWVi+WY2C2y1N
         QKccTAM3h7/+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B46DE60A21;
        Thu, 25 Nov 2021 01:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] MAINTAINERS: Update B53 section to cover SF2 switch
 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780380873.5226.8842192897227704621.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 01:30:08 +0000
References: <20211123222422.3745485-1-f.fainelli@gmail.com>
In-Reply-To: <20211123222422.3745485-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, linux@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Nov 2021 14:24:22 -0800 you wrote:
> Update the B53 Ethernet switch section to contain
> drivers/net/dsa/bcm_sf2*.
> 
> Reported-by: Russell King (Oracle) <linux@armlinux.org.uk>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] MAINTAINERS: Update B53 section to cover SF2 switch driver
    https://git.kernel.org/netdev/net/c/550b8e1d182c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


