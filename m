Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC21133E107
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhCPWAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230026AbhCPWAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8273C64DFB;
        Tue, 16 Mar 2021 22:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615932008;
        bh=j1xrHW25OjlLtqOHq6iNIBMOYHzxKmGu/gVm3Mscqoo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T6oUqm6/OSSFJ36odaxuwA2k5TVOQihqpeUVWnsji4PE/I5ixrztXXmjoka8dducc
         +fS+FLokUptsE8gREpZBI7KIxq7ZqMIFQ34uDkToISXWlLfdRavTjir9t9FfUZl+Nh
         sltl5NdcgaOoEopo2X/bF42djgRNe5vX1SUTeB+ScYsOcg2UL2SJF++qqL/4msPyCz
         FcRcYc54W+8xcWezXOMEsfuDcG+Ttn8dUWgFGy48HfHCh388yi32v52tVCh+99SPMl
         ymwouNySQPibeeg+5epXNYUqYweZCqurug9m9H5LGaJFurjVERlDKiD8vjQfqHOYwL
         TBjG69l7In8CQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 71A2860A3D;
        Tue, 16 Mar 2021 22:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipv4: route.c: simplify procfs code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593200846.27352.1361618268443189646.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 22:00:08 +0000
References: <20210316025736.37254-1-yejune.deng@gmail.com>
In-Reply-To: <20210316025736.37254-1-yejune.deng@gmail.com>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Mar 2021 10:57:36 +0800 you wrote:
> proc_creat_seq() that directly take a struct seq_operations,
> and deal with network namespaces in ->open.
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  net/ipv4/route.c | 34 ++++------------------------------
>  1 file changed, 4 insertions(+), 30 deletions(-)

Here is the summary with links:
  - net: ipv4: route.c: simplify procfs code
    https://git.kernel.org/netdev/net-next/c/f105f26e4560

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


