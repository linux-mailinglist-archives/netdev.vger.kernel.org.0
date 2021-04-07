Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB834357763
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhDGWKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhDGWKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EA72C61284;
        Wed,  7 Apr 2021 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617833412;
        bh=t4gSIK9ujp1Ac6Uyjdco62IgsAi0xDy9OANGt9ytiOU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pqZSyGQGACB4yIygUmoc/ymn2PupXpqFrFwPeekFwXv5RIDjMvY48HnYmiYbujztX
         NmbbOTzynNca7aKKzRPuqYoybH6L3680vV9BGo6aLfmu+EyDdpF0/aYIIVvHJYzo3d
         MTOxfwCosA4po+37Wowavlcwb9e4Lc+o97M6eF7n8OCgPp/NpLn/W2GE8V+B3/YMBy
         WrxIZPRMNCKo9gIJs2Fip0oWE92vgNyHPPdzVvja02jBLIxAPeaQlAtJAeW+T8bGB4
         rThcQw+ycD45yP+KgxLRA2KoAOnLcmFIJeTZ3A9x6TfsVeEaEhOdVNYRqWlaGq1RJx
         T9FErxV+2tnug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E04C5609B6;
        Wed,  7 Apr 2021 22:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: remove the new_ifindex argument from
 dev_change_net_namespace
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783341191.5631.11514663646639989858.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:10:11 +0000
References: <20210407064051.248174-1-avagin@gmail.com>
In-Reply-To: <20210407064051.248174-1-avagin@gmail.com>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  6 Apr 2021 23:40:51 -0700 you wrote:
> Here is only one place where we want to specify new_ifindex. In all
> other cases, callers pass 0 as new_ifindex. It looks reasonable to add a
> low-level function with new_ifindex and to convert
> dev_change_net_namespace to a static inline wrapper.
> 
> Fixes: eeb85a14ee34 ("net: Allow to specify ifindex when device is moved to another namespace")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Andrei Vagin <avagin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: remove the new_ifindex argument from dev_change_net_namespace
    https://git.kernel.org/netdev/net-next/c/0854fa82c96c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


