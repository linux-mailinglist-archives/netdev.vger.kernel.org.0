Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C886B3DBFD2
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 22:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhG3UaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 16:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhG3UaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 16:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ABF7360F48;
        Fri, 30 Jul 2021 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627677005;
        bh=BxFASqzSnYPlDWdTMu1GjoSjF4sTklDOEVzC0i1cYmM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d9CKrnIqfCqcflDOt7Hz6EPPflStrjkcV8vYcwTmG5h+cQgLQt/8CH6Lvp/YDhMoU
         RtUp7+NCo6QJOSXueMZJK+vo7phkEZ7K1y0Q8gGrXOpwZ8uQY1mIBJKoMB4sFbksFL
         7JiGx7wmUZgc4DR+a8AHNQIUPAWVew7gEJJ3Z+G9VYofnabvHdPqsnjZSWkpdBPAu9
         Tb8dPYb4aaT5+9g0TUwt+ui2rhnXdfN5o6Wa3JQacQTzIduxD6PphfQnNEenr6KFRB
         ZHfEcgkllqBTgHAj/vIaejKGUI52UudAPu0Pt7K8uUueP3WEd2cCVkGhcKYzH3Jlwg
         FY9ZTMk/2eepA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 977A060A85;
        Fri, 30 Jul 2021 20:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] Clean devlink net namespace operations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162767700561.11153.17362580046562666251.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Jul 2021 20:30:05 +0000
References: <cover.1627578998.git.leonro@nvidia.com>
In-Reply-To: <cover.1627578998.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        leonro@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, parav@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 29 Jul 2021 20:19:23 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v2:
>  * Patch 1: Dropped cmd argument
> v1: https://lore.kernel.org/lkml/cover.1627564383.git.leonro@nvidia.com
>  * Patch 1:
>    * Renamed function name
>    * Added bool parameter to the notifier function
>  * Patch 2:
>    * added Jiri's ROB and dropped word "RAW" from the comment"
> v0: https://lore.kernel.org/lkml/cover.1627545799.git.leonro@nvidia.com
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] devlink: Break parameter notification sequence to be before/after unload/load driver
    https://git.kernel.org/netdev/net-next/c/05a7f4a8dff1
  - [net-next,v2,2/2] devlink: Allocate devlink directly in requested net namespace
    https://git.kernel.org/netdev/net-next/c/26713455048e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


