Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C786C626740
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 07:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbiKLGAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 01:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiKLGAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 01:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D8AA47A
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 22:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD2A560B07
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 334CFC433B5;
        Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668232818;
        bh=NZfXw7EWOxj8Aemr0sepLKjMkXHLCgOeauf1hWQFWaU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WeRKIOVvC98h1rAgn0mFP/Zv1vPO590ozHW11r9hwhez8eAjo/1N3vKUxVfhSSo6Z
         nmyVSuY5C2ll3vgJujT55UFjL2+4uq3ky8sc5n/d002QCK5p17xcawPoS19pr/AIrT
         L6vkMlAwy2QcAsQRF7Zm+g7PdhifHq7LnDvzUYV37TEP373MIWd+OfuZau8G33xgdc
         Gzv/GTerbc0gZJ+mV+dvzfBfRLvgqH7cKyzuBzYnCazeI9jH0CJqbyt5fW5GKOhRz1
         rNQTh9GoFgVKPCr9/m9NOIxptdAIy9ZQvhuVMWhWs8yerXqgnJ8kNbV2+wWu3AVjex
         ey7HrUTWlPaIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1A262E50D93;
        Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: tcp_wfree() refactoring
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166823281810.10181.3763824429429154745.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 06:00:18 +0000
References: <20221110190239.3531280-1-edumazet@google.com>
In-Reply-To: <20221110190239.3531280-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Nov 2022 19:02:39 +0000 you wrote:
> Use try_cmpxchg() (instead of cmpxchg()) in a more readable way.
> 
> oval = smp_load_acquire(&sk->sk_tsq_flags);
> do {
> 	...
> } while (!try_cmpxchg(&sk->sk_tsq_flags, &oval, nval));
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: tcp_wfree() refactoring
    https://git.kernel.org/netdev/net-next/c/b548b17a93fd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


