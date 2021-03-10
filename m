Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694ED334959
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbhCJVA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:00:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:32808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231994AbhCJVAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 16:00:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 39F0665007;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615410013;
        bh=Z7oTbKHk11YGf40BZ70xL625Hbhbx0+7qkDHJEa/jmo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FOQtaUxNkIyld2QxmZ/c0l29ZcpDDOIV2nO3Pm1h7lXr9uqf9YCM5fNqld7/+Myk+
         SuMMuxVztiJQM5KL6K0Yopm4Nzc+eNmIsfDcJYFEsgJZ3VXbL68RMRvh0VuEqI2KcU
         TqavLVATyqW1ODsIMbXK8Ky+Sq8DwrXpaBGVKbucZNosXAmIMigdvfQKqn4PBGAbJA
         WgBJMBrDek+6CgNuWrIe/uMwp03jDdwWxP+9qwAFy5vfWkCECDK1DA183iQMk57F5T
         Tlt3eUjs32/jpci2NPU/3M/EM1yuHqrLtgCStlHyAe3A/IU51jD/41+IFr/zpaQD+H
         acQ8Axbm9NUNg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2F99B609D1;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: chelsiofix: spelling typo of 'rewriteing'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541001319.4631.11478864114484708120.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 21:00:13 +0000
References: <1615345606-1799-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1615345606-1799-1-git-send-email-wangqing@vivo.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 11:06:46 +0800 you wrote:
> rewriteing -> rewriting
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: ethernet: chelsiofix: spelling typo of 'rewriteing'
    https://git.kernel.org/netdev/net-next/c/4b18d5d1b2ba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


