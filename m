Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DA8455ACA
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344242AbhKRLoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:44:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344264AbhKRLnN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 06:43:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DD2AA61B93;
        Thu, 18 Nov 2021 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637235611;
        bh=4ey0TOsPQdahXbbsw2XZXLYSlXV6R7ZuWgzz7Ow0fLs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q78lukv6qXrpEwLU1Q5XK/ASmenD8Gu77GBuGEVJnYXxZPtwErO4gQXYgxpNij+DU
         Xd5NfYQc/bKDYvEtqZORJqEnSx/8+IY8+LUso0YxqRECGrLrq72W1lfRzZHzwQYwU8
         VXcmq7dK5SEoSTK6l+ovzS40Fzp1xMk3E0blgxwpjOdEt0z0GzeS87gPoqTU7u2S6t
         pJVzrDp0WAhUdlVgS9WxWpFJMxBjtYqTpeSCd5bSRkmGLeWDpAP+azDEzGJC+Yzmqn
         01kodCtFcvdXG/9K5HAWeK5hiLzBVl9U+rj956Pwkeuhw21CQds3ebjJzy2rhh/neN
         IUiz8KXEpQplA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D5AEC60A4E;
        Thu, 18 Nov 2021 11:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: ag71xx: phylink validate implementation
 updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723561187.11739.18113033668356200683.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 11:40:11 +0000
References: <YZUxxU30M4IgNNPi@shell.armlinux.org.uk>
In-Reply-To: <YZUxxU30M4IgNNPi@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     chris.snook@gmail.com, linux@rempel-privat.de, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Nov 2021 16:45:57 +0000 you wrote:
> Hi,
> 
> This series converts ag71xx to fill in the supported_interfaces member
> of phylink_config, cleans up the validate() implementation, and then
> converts to phylink_generic_validate().
> 
> The question over the port linkmode restriction has been answered by
> Oleksij - there is no reason for this restriction, so we can go the
> whole hog with this conversion. Thanks!
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: ag71xx: populate supported_interfaces member
    https://git.kernel.org/netdev/net-next/c/680e9d2cd4bf
  - [net-next,2/3] net: ag71xx: remove interface checks in ag71xx_mac_validate()
    https://git.kernel.org/netdev/net-next/c/5e20a8aa48a0
  - [net-next,3/3] net: ag71xx: use phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/c8fa4bac30e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


