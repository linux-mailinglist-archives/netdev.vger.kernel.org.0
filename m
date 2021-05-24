Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98F538DE5A
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 02:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhEXAVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 20:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhEXAVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 20:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CFAD961152;
        Mon, 24 May 2021 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621815609;
        bh=EXvPN6rhp8a5d2Mo3KrB37LpUXR6zCY+LP3AnTXJ64Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J5jkUziZntCn0m5Lhpt3BWoDhlkTlxo+K13ty1nbTeosR292+UYKQxGCr/eZx9oyh
         ZJtkYXtDvyLXa+BvGneMzaLNAs6NUywvIFCTbvBLme/fGVeI7ROkEd/COilGw5t6er
         6tn6dKroLVCvWYISBbKTZA0Q7QGizNNJFugrvrPCNHJIgnwi9acn6q1m6gNaGXfup8
         5sOxDasbJDDWfUG4rYffcqBYoeEFcXadhHXkC29gajWTVagmK9rnXPLvMlTA14Ih1p
         STi9+Qi1N+rTxgHx4sgCGXRHTsntcFdDrs3bI6jn9Y945VhgwbetbTHVJuahrcbVs/
         RJB+3vaCZxMNA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C22BF60C29;
        Mon, 24 May 2021 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] two fixes for the fq_pie scheduler
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162181560979.26786.13116118895081737886.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 00:20:09 +0000
References: <cover.1621687869.git.dcaratti@redhat.com>
In-Reply-To: <cover.1621687869.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sat, 22 May 2021 15:14:33 +0200 you wrote:
> - patch 1/2 restores the possibility to use 65536 flows with fq_pie,
>   preserving the fix for an endless loop in the control plane
> - patch 2/2 fixes an OOB access that can be observed in the traffic
>   path of fq_pie scheduler, when the classification selects a flow
>   beyond the allocated space.
> 
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/sched: fq_pie: re-factor fix for fq_pie endless loop
    https://git.kernel.org/netdev/net/c/3a62fed2fd7b
  - [net,2/2] net/sched: fq_pie: fix OOB access in the traffic path
    https://git.kernel.org/netdev/net/c/e70f7a11876a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


