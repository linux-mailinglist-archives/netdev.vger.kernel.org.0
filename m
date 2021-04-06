Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E2B355FBA
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344788AbhDFXuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344770AbhDFXuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8DF41613C0;
        Tue,  6 Apr 2021 23:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617753009;
        bh=zU5PgoVX2+C0VrAQex2YCIxLZ67eZY8t2e0MftEbYLQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mJRJ+0F598Bd7NO2mfX+bICpAhOOEDMNyWUIt0KaebLJkSb8CZIHZiYbuS8z9DhKS
         P9qQUxkdrkqd0vG1i7Ig/tb98l/BlGPGffGsbBq17elGiFbNg0nAr0l9lKcujmnPXU
         P68109bzf+0usMg1eMgho769QG0iif8qT4OMWSrDVf3HQwsN6W4PY9kn/tCzLnoDkS
         v7ixYFkVO61pyq18Tt/cQpdGJQ9v0FqOqq0VkDY2s9Havzn1+Jt6DHndZI0q5jKqWi
         tpjvQQ01JqRU712epjS4XJBFEP12y84kj580o/hNA7G0aa04zYeYOHrlcl73pA82Zw
         5YubED4voGCPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D1E960A2A;
        Tue,  6 Apr 2021 23:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1 1/1] ethtool: fix incorrect datatype in set_eee ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775300950.25054.9937992682848380005.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Apr 2021 23:50:09 +0000
References: <20210406131730.25404-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210406131730.25404-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  6 Apr 2021 21:17:30 +0800 you wrote:
> The member 'tx_lpi_timer' is defined with __u32 datatype in the ethtool
> header file. Hence, we should use ethnl_update_u32() in set_eee ops.
> 
> Fixes: fd77be7bd43c ("ethtool: set EEE settings with EEE_SET request")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Cc: Michal Kubecek <mkubecek@suse.cz>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net,v1,1/1] ethtool: fix incorrect datatype in set_eee ops
    https://git.kernel.org/netdev/net/c/63cf32389925

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


