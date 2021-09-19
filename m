Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86479410BB5
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 15:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhISNLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 09:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhISNLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 09:11:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D9EED61244;
        Sun, 19 Sep 2021 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632057006;
        bh=1MV9xxeDPgp+UZI+hxChIeld6nQrbJmqiiX5yEKAeFQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sQ654/BuAF+gZFOWPK8Zu6zHHyCo3Fdkovy+cb+lrs0McUikFUDOGEBitwqPnO7ir
         QBGG/pGCgZJI8lnjbQDBCp+2iN9gep2loVl8MFpSdXnhmXSNU8o4j7UmDZ5S1n8gci
         lv2Ly3Mti/wVFLvIO9oE8W/RIkh6VtoqTsz12i+7Cl06aCHkIs7XZHHa0+CTNQekMJ
         RKszZjG8W5tPQznO8kRcqFFEZnK757KowTCLFSkODCdcohpVa40uAwIr16HER+0yGC
         3NvJOdzUoPX+adVUiJFH2hEuYl6yDtf3/cPgWJVB7rGYk1ZjFc11zRy5oJIIR8YI6e
         fXwhmnPHIsfdw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CB2E460A37;
        Sun, 19 Sep 2021 13:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: move and reuse mq_change_real_num_tx()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205700682.29079.206134808466736012.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 13:10:06 +0000
References: <20210917135506.1408151-1-kuba@kernel.org>
In-Reply-To: <20210917135506.1408151-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        cong.wang@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 17 Sep 2021 06:55:06 -0700 you wrote:
> The code for handling active queue changes is identical
> between mq and mqprio, reuse it.
> 
> Suggested-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/net/sch_generic.h |  2 ++
>  net/sched/sch_generic.c   | 24 ++++++++++++++++++++++++
>  net/sched/sch_mq.c        | 23 -----------------------
>  net/sched/sch_mqprio.c    | 24 +-----------------------
>  4 files changed, 27 insertions(+), 46 deletions(-)

Here is the summary with links:
  - [net-next] net: sched: move and reuse mq_change_real_num_tx()
    https://git.kernel.org/netdev/net-next/c/f7116fb46085

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


