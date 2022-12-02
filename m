Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551E263FF88
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 05:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiLBEkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 23:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiLBEkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 23:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BFDC9365
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 20:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0D3CB820A9
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 04:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61447C433C1;
        Fri,  2 Dec 2022 04:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669956017;
        bh=7SjnQtbczCHpyENCu2nGx0oR3hUoq/elqt7biapwHlY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UYkoHYsdrarICnPPs+Rn66Hz6JPnYH91O6IsVxgguoFJUFheNHYqAAigTZFaziPY2
         gxYz+irzkXtEVS2AsMVuT46qqLocdkfbtbqTT/CYhYcHf5ZO3CYl/bs6ao0eBXeN5Q
         bqGm/NaMwh0ENTZ10JXfUbejrXsblLzOzKjZl5c7Z1C/b8Z0yux/pXyWCy2+UFYfI8
         V6NDxQIWdn6+qdjc7yr9GPhIQhi2+SVSq4M5Ja5XwylancXtSuZ+Wpz2zfYOgazPKg
         iAcOWB8fc6uockZ6lsjjCAPnoAV5Sgbj4jGpX6pjmeiteCQM/HV+87d9ye71TCB6x3
         X7rqUQUlxWQ7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3FF7EE270C8;
        Fri,  2 Dec 2022 04:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 0/8]
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166995601725.2394.13228944085745632127.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 04:40:17 +0000
References: <20221129164815.128922-1-bigeasy@linutronix.de>
In-Reply-To: <20221129164815.128922-1-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, tglx@linutronix.de,
        kurt@linutronix.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 29 Nov 2022 17:48:07 +0100 you wrote:
> I started playing with HSR and run into a problem. Tested latest
> upstream -rc and noticed more problems. Now it appears to work.
> For testing I have a small three node setup with iperf and ping. While
> iperf doesn't complain ping reports missing packets and duplicates.
> 
> v4…v5:
> - Added __rcu annotation ub patch #7
> - Spelling fixes in #2 and #6.
> 
> [...]

Here is the summary with links:
  - [v5,net-next,1/8] Revert "net: hsr: use hlist_head instead of list_head for mac addresses"
    (no matching commit)
  - [v5,net-next,2/8] hsr: Add a rcu-read lock to hsr_forward_skb().
    https://git.kernel.org/netdev/net-next/c/5aa2820177af
  - [v5,net-next,3/8] hsr: Avoid double remove of a node.
    https://git.kernel.org/netdev/net-next/c/0c74d9f79ec4
  - [v5,net-next,4/8] hsr: Disable netpoll.
    https://git.kernel.org/netdev/net-next/c/d5c7652eb16f
  - [v5,net-next,5/8] hsr: Synchronize sending frames to have always incremented outgoing seq nr.
    https://git.kernel.org/netdev/net-next/c/06afd2c31d33
  - [v5,net-next,6/8] hsr: Synchronize sequence number updates.
    https://git.kernel.org/netdev/net-next/c/5c7aa13210c3
  - [v5,net-next,7/8] hsr: Use a single struct for self_node.
    https://git.kernel.org/netdev/net-next/c/20d3c1e9b861
  - [v5,net-next,8/8] selftests: Add a basic HSR test.
    https://git.kernel.org/netdev/net-next/c/7d0455e97072

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


