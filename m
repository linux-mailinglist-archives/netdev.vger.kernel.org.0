Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF353510D92
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 03:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356554AbiD0BDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 21:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356541AbiD0BDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 21:03:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0E4AE45
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 18:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F4EDB82450
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 01:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32E59C385AC;
        Wed, 27 Apr 2022 01:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651021211;
        bh=gSr2L7859tkbSI6aEhnL6PNxUepzisuGu5POd5nnOXM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ucAa7Okv5H0cN5IeYO/3QrBhyQUvPNleP6Ff3GkvD3YySnws+aYdi/iHUbq2aB0Ke
         L4X++w5T0twtuDBszBvF7qq6rWmF2GQUaWRjnEFN+31R8Ho7+Ot9Ox/PExtyxRUEn8
         +ffDRpRrBs7McJmrV+syu5QZJr8AWuT4VmJmIrULoQIHoiNRne4EuT8twygMmh3VaJ
         CiHfRYPVl62bewnDeDBEsJmVFmFRgd94a/Hckfacox1/+tbIdI/39Al6XWzZfrIYzy
         dVBqyN1U0tnvCmKixflkPzR+Z5FxMdBoNN5/UurYm/JTLFAKGR9hf7dG0mS/TnJQDo
         btd+aV+W+Jv2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 140F4EAC09C;
        Wed, 27 Apr 2022 01:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: Use this_cpu_inc() to increment net->core_stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165102121107.22539.16627755071494426729.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 01:00:11 +0000
References: <YmbO0pxgtKpCw4SY@linutronix.de>
In-Reply-To: <YmbO0pxgtKpCw4SY@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        davem@davemloft.net, pabeni@redhat.com, tglx@linutronix.de,
        peterz@infradead.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 25 Apr 2022 18:39:46 +0200 you wrote:
> The macro dev_core_stats_##FIELD##_inc() disables preemption and invokes
> netdev_core_stats_alloc() to return a per-CPU pointer.
> netdev_core_stats_alloc() will allocate memory on its first invocation
> which breaks on PREEMPT_RT because it requires non-atomic context for
> memory allocation.
> 
> This can be avoided by enabling preemption in netdev_core_stats_alloc()
> assuming the caller always disables preemption.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: Use this_cpu_inc() to increment net->core_stats
    https://git.kernel.org/netdev/net/c/6510ea973d8d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


