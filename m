Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B44944C328
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhKJOnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:43:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232268AbhKJOm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:42:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 80CB261251;
        Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636555208;
        bh=ClH1raJ1gNeWlCLe84QT8iMe+pEQxMf3C+dYT1zgwd0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LXZy18LKTX0FBQjKi8mqqTAuHMZq3fkFvrsGDLhLtSCZ9FPIwxq572jCFKb1e+dJw
         oFEm29u1Rox7273GuxsS4ls7O3/LS/pLz25aXlS+yWRMLGxju2m5staZUrgFYZgdO4
         3Lc01tMlbiCGH4P2b4ohmm4gjxp+FNfZZ5ogLN+5Fz0mo0Jb2EjRPwXbzIGNBY6XWS
         jYEf10cTUuRTsMooIQrJhs0rgf3Q5TGjXZUzOCRMRi2fWxRR+ja1vEpLQSNgu3385c
         8yUMMz5sC58Ui5zqyO8ujiSGeQbqxXwV/mO1ymfMytYaAYAMzyJRJLTVtgBhqH+dNK
         i3r6Txl4FR+vQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 73E9860A6B;
        Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: cpsw_ale: Fix access to un-initialized
 memory
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163655520846.19242.6691586585047743470.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 14:40:08 +0000
References: <c709f0325a7244ff133e405d017d9efba3b200f6.1636406827.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <c709f0325a7244ff133e405d017d9efba3b200f6.1636406827.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, kuba@kernel.org,
        shenyang39@huawei.com, vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  8 Nov 2021 22:28:55 +0100 you wrote:
> It is spurious to allocate a bitmap without initializing it.
> So, better safe than sorry, initialize it to 0 at least to have some known
> values.
> 
> While at it, switch to the devm_bitmap_ API which is less verbose.
> 
> Fixes: 4b41d3436796 ("net: ethernet: ti: cpsw: allow untagged traffic on host port")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: cpsw_ale: Fix access to un-initialized memory
    https://git.kernel.org/netdev/net/c/7a166854b4e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


