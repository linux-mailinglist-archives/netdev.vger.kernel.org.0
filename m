Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC9B357749
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhDGWAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234337AbhDGWAU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:00:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 58C28611EE;
        Wed,  7 Apr 2021 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617832810;
        bh=rWObaaR8yHycL/sGZT2kwmqBwrZybXZaPAdWE6IzaOg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NtcopKWkSeoXrwMwqtuN6+PbWIrbEpRPfvNn/THtxlpo5qv0Gwy+1JKSVYx2fLaBV
         jbsbeTytTDu76EoX3bW9JT2t+9lRt+f8TXTy0Y5AHCe59BPzMgfCXN6bWw7gRHINRX
         C2rXFVaYAzDT5TmVDSV8nBjZW6kSqrMaGqHSw0OkfP4Q6UinUYwi/vXqPSbUXjc5jB
         i/xPnFbd6NNqZgRn2EfTqjTMo/0TOVWYNfpYVkfaNyQOgXwzpZ36fwVupDmal3H5Nn
         0kPw7HuDaMFTMDP1PJomzlTka+uYXmw4+XiMuJF8mx+ylJVGhA0EyaIkkI3lqNHNun
         rKKxX/LDEtAog==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4C3F360BE6;
        Wed,  7 Apr 2021 22:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: tipc: Fix spelling errors in net/tipc module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783281030.1764.11775858542583523130.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:00:10 +0000
References: <20210407015945.420908-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210407015945.420908-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 7 Apr 2021 09:59:45 +0800 you wrote:
> These patches fix a series of spelling errors in net/tipc module.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/tipc/bearer.h | 6 +++---
>  net/tipc/net.c    | 2 +-
>  net/tipc/node.c   | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [v2] net: tipc: Fix spelling errors in net/tipc module
    https://git.kernel.org/netdev/net/c/a79ace4b3129

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


