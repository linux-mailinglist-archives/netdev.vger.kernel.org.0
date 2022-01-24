Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1CF497E8D
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238331AbiAXMKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238278AbiAXMKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:10:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C113C06173B;
        Mon, 24 Jan 2022 04:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38D72B80F91;
        Mon, 24 Jan 2022 12:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0ACAC340EB;
        Mon, 24 Jan 2022 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643026210;
        bh=IfvTnE0SElEHHi2ltg3BcoNG0+vnUbVnatoPsazTfrA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZLj8jiXKiBJXx4rz5XwFYC7F2XjUZnGHfOJboWp8mjLqhmW+yZQD2itVrdnb1VIft
         GLVgY46o0Dbbn16NiSQTZDOtYXLvfTl4mRvhnEYve2lkrO5A6wUomuuA24A2RoeKd1
         knerznu2BY2pSImVwzTmYwOgRrz+vPrC6/wNAZs7wttp3q7XJmUK6lNRkgqiSAJkYN
         SN2ldaD2kxs8bUffx/pGX/6MHRAca7Nc2jjiTKmEWfBjeu50AdkX4FboYaQ0CQsL/O
         aguooll5IwUjpo613xGDw/Qjzaq8PSzh8tP1s6p5GkgS4K9p4KnEU4MbCPQSrszpWo
         lxEejI2Tu2KMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3CDFC395DF;
        Mon, 24 Jan 2022 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/smc: Transitional solution for clcsock race issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164302621079.19022.3641686752810483922.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Jan 2022 12:10:10 +0000
References: <1642844589-23022-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1642844589-23022-1-git-send-email-guwen@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 22 Jan 2022 17:43:09 +0800 you wrote:
> We encountered a crash in smc_setsockopt() and it is caused by
> accessing smc->clcsock after clcsock was released.
> 
>  BUG: kernel NULL pointer dereference, address: 0000000000000020
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 0 P4D 0
>  Oops: 0000 [#1] PREEMPT SMP PTI
>  CPU: 1 PID: 50309 Comm: nginx Kdump: loaded Tainted: G E     5.16.0-rc4+ #53
>  RIP: 0010:smc_setsockopt+0x59/0x280 [smc]
>  Call Trace:
>   <TASK>
>   __sys_setsockopt+0xfc/0x190
>   __x64_sys_setsockopt+0x20/0x30
>   do_syscall_64+0x34/0x90
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>  RIP: 0033:0x7f16ba83918e
>   </TASK>
> 
> [...]

Here is the summary with links:
  - [net,v2] net/smc: Transitional solution for clcsock race issue
    https://git.kernel.org/netdev/net/c/c0bf3d8a943b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


