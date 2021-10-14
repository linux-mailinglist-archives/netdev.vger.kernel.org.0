Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D04E42E480
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 01:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbhJNXCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 19:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230512AbhJNXCO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 19:02:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C844861090;
        Thu, 14 Oct 2021 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634252408;
        bh=AA0WZn+DU/kRFEWzKKA9jV8f4+zGPBeXV2ztIbRNPMg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gazF9vBuoi77an2Rv23QRPzB1DZddRP4rXm9pHs3pNdG2aWdOlT84Hc/ZyKtD7lV3
         4zN5lF9CkJLsrxBoYBBeulaEWgh4gBrBjU0ACkeORf0oGRifdBf6q7TTm59Tyjom4C
         5vu+fJMGvIbJN8ke5uqb7Q8j69CyKqWSFgPmtRyVjTtpfOmlT+A8BB5V7w3KsDdy2Z
         fgLQBXWLnGNlI02eKAAaXi77qKnPCxKT27FYiMNdOkb9g+4S98teMzbpsyrYa/3RYO
         kj1SqUsnXtnU3ucvt5P7rih9Wnp7S+U42I73FUm6arg0VSOAU2fgORPz5bqOCYVunJ
         0smF+Tr8dMnmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BC939609ED;
        Thu, 14 Oct 2021 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: of: fix stub of_net helpers for CONFIG_NET=n
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163425240876.7869.13697654167587568953.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 23:00:08 +0000
References: <20211014090055.2058949-1-arnd@kernel.org>
In-Reply-To: <20211014090055.2058949-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, arnd@arndb.de,
        robh+dt@kernel.org, frowand.list@gmail.com, andrew@lunn.ch,
        michael@walle.cc, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 14 Oct 2021 11:00:37 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Moving the of_net code from drivers/of/ to net/core means we
> no longer stub out the helpers when networking is disabled,
> which leads to a randconfig build failure with at least one
> ARM platform that calls this from non-networking code:
> 
> [...]

Here is the summary with links:
  - [net-next] net: of: fix stub of_net helpers for CONFIG_NET=n
    https://git.kernel.org/netdev/net-next/c/8b017fbe0bbb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


