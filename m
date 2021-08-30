Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD3B3FBF8A
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhH3XvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhH3Xu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 19:50:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ABC5B60FC0;
        Mon, 30 Aug 2021 23:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630367405;
        bh=XC5/RxeMwsfqRMIcmqKRKMnXALGgU8NxsDuThv6XuNU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dG0+l5Wa8fPuuSaoJl9PPnVXcVgzFpgzQ3yKR+Sl9BsMYOv8Ixo1eu+wPTpiZdhCo
         cE+4mqUD0m0vJUP0Hzv45yll/TOaAC/tmRzkn2js2bV4cIejhkTikWaNesEmIfaral
         yfO6R+vSdhXTQzhKsiLEOUCwwRCvYyzTAKAGv3EGpvTBuESToTkmXOEnsSX1pseV3s
         cs+kPsS13b0+wh49TSZAv8CtbnjQ0RN+ca74EP5g2TUD4O63Gnym3XFz1pBxkR4Br3
         BdsfS6pqV53SegsntHSGmg6WOfYXx3HDwdL4FlDXmSZxifmG0Q9JYtM+tMakK+nQLl
         LHVDdgmwBcm7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A19FF60A6C;
        Mon, 30 Aug 2021 23:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sch_htb: Fix inconsistency when leaf qdisc creation fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163036740565.26456.2620307252821609438.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Aug 2021 23:50:05 +0000
References: <20210826115425.1744053-1-maximmi@nvidia.com>
In-Reply-To: <20210826115425.1744053-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     kuba@kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, saeedm@nvidia.com,
        tariqt@nvidia.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 26 Aug 2021 14:54:25 +0300 you wrote:
> In HTB offload mode, qdiscs of leaf classes are grafted to netdev
> queues. sch_htb expects the dev_queue field of these qdiscs to point to
> the corresponding queues. However, qdisc creation may fail, and in that
> case noop_qdisc is used instead. Its dev_queue doesn't point to the
> right queue, so sch_htb can lose track of used netdev queues, which will
> cause internal inconsistencies.
> 
> [...]

Here is the summary with links:
  - [net] sch_htb: Fix inconsistency when leaf qdisc creation fails
    https://git.kernel.org/netdev/net-next/c/ca49bfd90a9d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


