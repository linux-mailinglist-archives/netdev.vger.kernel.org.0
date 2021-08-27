Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A7F3F96A8
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhH0JLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232048AbhH0JK7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 05:10:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E3EA860FE7;
        Fri, 27 Aug 2021 09:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630055411;
        bh=KtaLjADZLZAaXQ5u8fALR16uxTbk0idokKca9+uFx1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZG4rlozxE7DxRyO93Qk18qWeRv1HyxLmxoMnkn1Dp5GyAfnokrwCiPS6WYI8ZhjiH
         mcO63dEPBxGlmG4jnllWyfbJmJRfeWW9IiBG1ZWqFJEIuFYk+jR4Ykpu9W7oWUdAfM
         Vuqxo2JnP0u+J/qNLZLKA/tYLbi6gaF7RRoEK3nQq96FSZ/WCVXj4JuU3RhUgi3jza
         l8Oy3fIU512D4vXJD3gfOGrOTNm+IL4FvSdOI/FcAUNudpGnoXhM7tDuiDcKia53m2
         dE6lhpSk+68tcX87BYPvCDPj7m8iCttAPwee613+zHZy91d/LSKko/wVDvklC9pNfI
         tGbwny1d/JBXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D7D4560A27;
        Fri, 27 Aug 2021 09:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/6] net/mlx5: Lag, fix multipath lag activation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163005541087.19735.3077952130395559575.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Aug 2021 09:10:10 +0000
References: <20210826221810.215968-2-saeed@kernel.org>
In-Reply-To: <20210826221810.215968-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dchumak@nvidia.com, roid@nvidia.com, mbloch@nvidia.com,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 26 Aug 2021 15:18:05 -0700 you wrote:
> From: Dima Chumak <dchumak@nvidia.com>
> 
> When handling FIB_EVENT_ENTRY_REPLACE event for a new multipath route,
> lag activation can be missed if a stale (struct lag_mp)->mfi pointer
> exists, which was associated with an older multipath route that had been
> removed.
> 
> [...]

Here is the summary with links:
  - [net,1/6] net/mlx5: Lag, fix multipath lag activation
    https://git.kernel.org/netdev/net/c/2f8b6161cca5
  - [net,2/6] net/mlx5: Remove all auxiliary devices at the unregister event
    https://git.kernel.org/netdev/net/c/8e7e2e8ed0e2
  - [net,3/6] net/mlx5e: Fix possible use-after-free deleting fdb rule
    https://git.kernel.org/netdev/net/c/9a5f9cc794e1
  - [net,4/6] net/mlx5: E-Switch, Set vhca id valid flag when creating indir fwd group
    https://git.kernel.org/netdev/net/c/ca6891f9b27d
  - [net,5/6] net/mlx5e: Use correct eswitch for stack devices with lag
    https://git.kernel.org/netdev/net/c/f9d196bd632b
  - [net,6/6] net/mlx5: DR, fix a potential use-after-free bug
    https://git.kernel.org/netdev/net/c/6cc64770fb38

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


