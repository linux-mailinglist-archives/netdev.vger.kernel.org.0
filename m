Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2678C3E321A
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 01:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243922AbhHFXaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 19:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhHFXaV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 19:30:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7664B61104;
        Fri,  6 Aug 2021 23:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628292605;
        bh=DYy+ZIaxswpVjqjePpN6rabkMlJ9RAKKiv/OClreniw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lsUKtkBhihz2HQW6zhyViztoJJCpVlr8W4V6CNJzSX6LPRQk1oaqbBRJZdfDSYepR
         HRQxbTKiPmFX198r5SpWV+VUhY+Y+Tg6LfKU1nuiVvsPtkftyzwpHXZZ4OKaxozqhN
         Jdod+702tD9TjWdevbxOa77iNjTftyZ9dNI9YSky9mQ8ARcg1tgAh+Pl2SzZBpE0wa
         HfxsjtYlIIvVg41Ra3+FHVjjaAiiHK71VRwAJAU+4dT/oj3WLOIDTE86ZF8MISC6iJ
         QsIjySZOa+y1f5EEvzvzA+TDQCz80gBnd6mFv0BMs4+yZSKo4S7wCOtWSwtLI0+6X2
         1NTiEbKX222TQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 657DD60A7C;
        Fri,  6 Aug 2021 23:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: davinci_cpdma: revert "drop frame
 padding"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162829260541.19160.13562237803383676607.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Aug 2021 23:30:05 +0000
References: <20210806142809.15069-1-grygorii.strashko@ti.com>
In-Reply-To: <20210806142809.15069-1-grygorii.strashko@ti.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, ben.hutchings@essensium.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org, lokeshvutla@ti.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 6 Aug 2021 17:28:09 +0300 you wrote:
> This reverts commit 9ffc513f95ee ("net: ethernet: ti: davinci_cpdma: drop
> frame padding") which has depndency from not yet merged patch [1] and so
> breaks cpsw_new driver.
> 
> [1] https://patchwork.kernel.org/project/netdevbpf/patch/20210805145511.12016-1-grygorii.strashko@ti.com/
> Fixes: 9ffc513f95ee ("net: ethernet: ti: davinci_cpdma: drop frame padding")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: ti: davinci_cpdma: revert "drop frame padding"
    https://git.kernel.org/netdev/net-next/c/35ba6abb73e4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


