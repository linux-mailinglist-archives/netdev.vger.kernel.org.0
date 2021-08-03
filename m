Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF7A3DF6E2
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhHCVaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232094AbhHCVaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 17:30:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3B7C260F58;
        Tue,  3 Aug 2021 21:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628026206;
        bh=9vy1kkOmYeqKyawuRUDZRNqyyJ2HBSbui9+kgIEvYLE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HLuhjf3Cpk21n/f5Yjels4BEA9x6G2nM/44oqu8L8AXY1r4rRX2Xp/x8V8DfpSbKM
         wC3wYSsiYQIVLPSv5VGN/UuvGDBh0TjKXB80pM0ywYzKi/6LV36nU3yJzkVSmNL0c0
         UKfU0CqM4riqkJhtTRCj9g8DcylbbGcpiY4xsH43aML5wadfl4J3dEDzMaWCMhMnXV
         3wiP++hoLHBH/LFaoqiPK4GZikfQ9/Vj7r2V3VriaG2p9AP0dYmC1EcDSRcvXRYrlb
         mQDt1sfE/4sSrRoeqm8nkBuNNmQZZjPSMpxcV2ciBG8WsIEG1pCvznnXHi8K8XWN/R
         c0B3+s/gPG0CQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2B49460A44;
        Tue,  3 Aug 2021 21:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: decnet: Fix refcount warning for new
 dn_fib_info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162802620617.14199.1617442108464944975.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 21:30:06 +0000
References: <20210803073739.22339-1-yajun.deng@linux.dev>
In-Reply-To: <20210803073739.22339-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  3 Aug 2021 15:37:39 +0800 you wrote:
> fib_treeref needs to be set after kzalloc. The old code had a ++ which
> led to the confusion when the int was replaced by a refcount_t.
> 
> Fixes: 79976892f7ea ("net: convert fib_treeref from int to refcount_t")
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/decnet/dn_fib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: decnet: Fix refcount warning for new dn_fib_info
    https://git.kernel.org/netdev/net-next/c/bebc3bbf5131

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


