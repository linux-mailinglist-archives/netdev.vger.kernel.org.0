Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C304D3CBB66
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 19:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhGPRxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 13:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhGPRxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 13:53:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 32AE361374;
        Fri, 16 Jul 2021 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626457810;
        bh=9GfvL7f9VeykaH7rPuAR9tMobFPRfLb54JmCj8+4DdM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Uy5Rwbm4cCi7JMSlzOKKD2UjqKIMMY9tWOHE6GfxEfNCrhlz/XoM7IuuK4tayHYn/
         XVWpkNZPSkrQjM1yTWQ+O2q4J337tphmHOvmkejuD3zeimqhb5dEY9RFBdp8966CUX
         GsicsQGt+YhRFEzgOnAhC7ZUShyoqTLJjU4dlLyMv4qxmIq9jufDK0Kcn7tvAW3rNg
         WnkNiFsy6stbsb9zgHt170XADDFs+8m7DNKMgLpcIePoe5BQBmc5s2n3R2bKLSntSF
         TAzziD47mBFBR1GmQA/mAcC3fC7OKyte2rGZ8PcehWajSA8/sn+trm0dVshQMKSN2h
         O3+LSwDUPuqaw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2644660A54;
        Fri, 16 Jul 2021 17:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] net: Deal with if statement in rtnetlink_send()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162645781015.974.695697420418247600.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Jul 2021 17:50:10 +0000
References: <20210715121258.18385-1-yajun.deng@linux.dev>
In-Reply-To: <20210715121258.18385-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        johannes.berg@intel.com, avagin@gmail.com, ryazanov.s.a@gmail.com,
        vladimir.oltean@nxp.com, roopa@cumulusnetworks.com,
        zhudi21@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 15 Jul 2021 20:12:56 +0800 you wrote:
> Patch1: use nlmsg_notify() in rtnetlink_send(), so that the caller
> wouldn't deal with if statement.
> Patch2: Remove unnecessary if statement.
> 
> 
> Yajun Deng (2):
>   rtnetlink: use nlmsg_notify() in rtnetlink_send()
>   net/sched: Remove unnecessary if statement
> 
> [...]

Here is the summary with links:
  - [v2,1/2] rtnetlink: use nlmsg_notify() in rtnetlink_send()
    https://git.kernel.org/netdev/net-next/c/cfdf0d9ae75b
  - [v2,2/2] net/sched: Remove unnecessary if statement
    https://git.kernel.org/netdev/net-next/c/f79a3bcb1a50

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


