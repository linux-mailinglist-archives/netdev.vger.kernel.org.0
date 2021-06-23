Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96913B2159
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 21:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhFWTm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 15:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhFWTmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 15:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2A40E611AD;
        Wed, 23 Jun 2021 19:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624477205;
        bh=BRD/Oc2lBavYBa9jE89msNcpt+ySXV3WESTS9Sqy/h4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H58zbeBWoZyw+SU6JLq4nah+V2flFg8B3F6QysjRl7wV8yY/7AOBgdl9S4bAk2B6w
         zkYodY3ABe8zUBUaQAa/anrCbCXLum+trdoMM2tchW3hTK2qSPYCBM6v8n1QdOC9FY
         GMYI172an2DUMG1HPIv/+LhOg6fYEwam5l6+BpybgNowbTMgmfBBLC/tKlpdJlasOz
         bFViWrsWC/sdZERhss4kN1LeuQLzTW47/qiEPfRKmdPBnc9bR/NWJ3nrYks22oxOZE
         xMXhf9CWfdY7D2LYm421oYLkZ/S2Jdr47103r3EV7qDf1xCmJ3ygaelYs2CRdUzDaZ
         3FtPhH2nFgDMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 15F0560A71;
        Wed, 23 Jun 2021 19:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] Some optimization for lockless qdisc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162447720508.16324.9587614099468280280.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 19:40:05 +0000
References: <1624344597-11806-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1624344597-11806-1-git-send-email-linyunsheng@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, olteanv@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        edumazet@google.com, weiwan@google.com, cong.wang@bytedance.com,
        ap420073@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        mkl@pengutronix.de, linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        a.fatoum@pengutronix.de, atenart@kernel.org,
        alexander.duyck@gmail.com, hdanton@sina.com, jgross@suse.com,
        JKosina@suse.com, mkubecek@suse.cz, bjorn@kernel.org,
        alobakin@pm.me
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 22 Jun 2021 14:49:54 +0800 you wrote:
> Patch 1: remove unnecessary seqcount operation.
> Patch 2: implement TCQ_F_CAN_BYPASS.
> Patch 3: remove qdisc->empty.
> 
> Performance data for pktgen in queue_xmit mode + dummy netdev
> with pfifo_fast:
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] net: sched: avoid unnecessary seqcount operation for lockless qdisc
    https://git.kernel.org/netdev/net-next/c/dd25296afaf6
  - [net-next,v3,2/3] net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc
    https://git.kernel.org/netdev/net-next/c/c4fef01ba479
  - [net-next,v3,3/3] net: sched: remove qdisc->empty for lockless qdisc
    https://git.kernel.org/netdev/net-next/c/d3e0f57501bd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


