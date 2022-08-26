Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A173F5A26C3
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242917AbiHZLUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiHZLUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00543E760;
        Fri, 26 Aug 2022 04:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70A4861B41;
        Fri, 26 Aug 2022 11:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB051C433D7;
        Fri, 26 Aug 2022 11:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661512814;
        bh=al1BYldTpOTootqG41dhJTt73kWohLiYx4+8rM8Sluw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DHsR16XIMWROQpSzqdKbQ7HYoTEqGBspbW5ux+KhTKcSKWNjnuCRCCEVA4J5C5WIR
         nSxswGhfL9fYRRscDB31ckcFZkLL8//ucg5qLc27/HqSbicvCV4FQ+yYZw1g+hW2A4
         byCwPx6Ysa44VKeCGQyyCi+kQhFJ5DDGEmAjP7GUvrDayz0jKWW1rhFdnDmFbiubqs
         5Ty3PeJq4mngnx/2AQOzmjYO6RiKZQWEps9EaEeo+JsTQULC+8S25jjB1m/tEsrGEW
         OQ2A3lngu1P9mJRUl0nwNowSOMdMhtfGM76Q3/F1RtTEEq5scJtSVdMbcO1/jUacbB
         rfWtHVxklecHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1D70E2A040;
        Fri, 26 Aug 2022 11:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: remove unnecessary init of qidsc skb
 head
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166151281472.24189.7543834802818916872.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Aug 2022 11:20:14 +0000
References: <20220824091003.15935-1-shaozhengchao@huawei.com>
In-Reply-To: <20220824091003.15935-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 24 Aug 2022 17:10:03 +0800 you wrote:
> The memory allocated by using kzallloc_node and kcalloc has been cleared.
> Therefore, the structure members of the new qdisc are 0. So there's no
> need to explicitly assign a value of 0.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  include/net/sch_generic.h | 7 -------
>  net/sched/sch_generic.c   | 1 -
>  net/sched/sch_htb.c       | 2 --
>  3 files changed, 10 deletions(-)

Here is the summary with links:
  - [net-next] net: sched: remove unnecessary init of qidsc skb head
    https://git.kernel.org/netdev/net-next/c/44387d1736c4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


