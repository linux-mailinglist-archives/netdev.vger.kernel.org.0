Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8A859678A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 04:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238398AbiHQCuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 22:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbiHQCuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 22:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE50B8E9B6;
        Tue, 16 Aug 2022 19:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A0D3B81B95;
        Wed, 17 Aug 2022 02:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E38E5C43470;
        Wed, 17 Aug 2022 02:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660704614;
        bh=l3kNu7vvpbzejigtZdoCU+j4K+IMMM9cGDihf/v/r8E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FZVV5U5KU80OvpMpaB7vRJ+7o02C8plAIrUXfuA5Fvu1LeeeqBIXvzaeNSwImpYQr
         FYQgjxyM+oTJrh4p4D/ov1HI+HPenW98vIAI4nqT7zowLdrs9xnV+5str6gabcgUmq
         A3d5DpALciOpLfPv5txytgDSu5MrgHFHI5JIkcWFRnreSZqRi3av7pPcJkM27IY07w
         UEBkt/CucaLRlnQGY5ukUvYeZzMUN1QWBqaLGb69etkp08YsNeim21QMpA4vp1ygoP
         0Q/+Ku+aTHxxB/dEcS55qHM9FH7D3sADpj/982JwHJcoQvvMHfbrYzNMaMOljqk4LE
         3ZR7zLDTDuJig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5890E2A04D;
        Wed, 17 Aug 2022 02:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: fix misuse of qcpu->backlog in
 gnet_stats_add_queue_cpu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166070461480.20872.1972078197561544010.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 02:50:14 +0000
References: <20220815030848.276746-1-shaozhengchao@huawei.com>
In-Reply-To: <20220815030848.276746-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bigeasy@linutronix.de, a.darwish@linutronix.de,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Aug 2022 11:08:48 +0800 you wrote:
> In the gnet_stats_add_queue_cpu function, the qstats->qlen statistics
> are incorrectly set to qcpu->backlog.
> 
> Fixes: 448e163f8b9b("gen_stats: Add gnet_stats_add_queue()")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/core/gen_stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: sched: fix misuse of qcpu->backlog in gnet_stats_add_queue_cpu
    https://git.kernel.org/netdev/net/c/de64b6b6fb6f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


