Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD9742CB30
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhJMUmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229496AbhJMUmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0E7AF6113E;
        Wed, 13 Oct 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157607;
        bh=oxqndR1jJfWTAcXBRvlidoUmdA3Xkf0uYdHiQpdXlFQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eTARX+UHrN1AuCPL2TzorePG8YL0zzQ2rNSpAMvq635bdST+lNjjEPn0gVAnZYgBZ
         mVpMs2XdSX8sSBQbYQuFth4YkGaLN4EvVbPkqsZiw90JRAreFgEZCIVDvI47+VP3T1
         z8Xa630wGx5UWl688r8Sr/OPCJqfGxI7w1tkPHkAiklZb7TwYeJJeyzl7V5KRPg1Z6
         vOYRjIRsFpSkweBvOJ2vPIITMcbaovzlNavRe1BP5uT25vfEjhGFItTB/2bdeOGjwd
         FBZWemDTt0W1EtwYAVHdLXVxyqvZNXqX3ogK0GHo7ZhYM+SMC/UNGhkhlGnmNj//+r
         wUmUEIKYARZfw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 08A8E609EF;
        Wed, 13 Oct 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: unregister cross-chip notifier after
 ds->ops->teardown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163415760703.2895.9979622967812805701.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 20:40:07 +0000
References: <20211012123735.2545742-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211012123735.2545742-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 15:37:35 +0300 you wrote:
> To be symmetric with the error unwind path of dsa_switch_setup(), call
> dsa_switch_unregister_notifier() after ds->ops->teardown.
> 
> The implication is that ds->ops->teardown cannot emit cross-chip
> notifiers. For example, currently the dsa_tag_8021q_unregister() call
> from sja1105_teardown() does not propagate to the entire tree due to
> this reason. However I cannot find an actual issue caused by this,
> observed using code inspection.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: unregister cross-chip notifier after ds->ops->teardown
    https://git.kernel.org/netdev/net-next/c/39e222bfd7f3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


