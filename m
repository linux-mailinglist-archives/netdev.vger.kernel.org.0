Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9CB4C6B49
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbiB1LvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbiB1Lux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:50:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED01371C8C
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 03:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82491B81100
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 11:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28352C340F6;
        Mon, 28 Feb 2022 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646049011;
        bh=oJNAvvMfzkCAwVdRcfnYBJCg/iJ0UsACXRgRTPWb3rU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CQvsgbTqxGi0Q9aTBS6HWZKR6r2K9ZfJlB3WGGXX7CpR0nJx+eORj3CfXA52dE7Ar
         whve4qxtiM+AYMacQYqDvUpthXMqAmfguYI5PMeN2TSDaF5g/RwBPpZ7fGB8lf1Bra
         /6c8KK5iQ1f9rlANhtvlV3Llob4WOzfFKP3OjhNDP7/2AOkbgoNaWpKKuUQEf8eBsk
         QiCgVRWQNWfRSCpAubIUuUFOIzpgM8lt394pIkk9MEtdfl+jIEIr2oxEVDFPZCSy+5
         NnXY8omCtPloBTk3mg3b/YxbcEQ1AQ7lJDDNzJnTwUSImPGfG/1JIgoe4mSMnwCary
         KjwRf4X9QCX9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12A13E6D4BB;
        Mon, 28 Feb 2022 11:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sysctl: avoid two synchronize_rcu() calls
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164604901107.16787.8792897669050452059.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 11:50:11 +0000
References: <20220225161855.489923-1-eric.dumazet@gmail.com>
In-Reply-To: <20220225161855.489923-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 25 Feb 2022 08:18:55 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Both rps_sock_flow_sysctl() and flow_limit_cpu_sysctl()
> are using synchronize_rcu() right before freeing memory
> either by vfree() or kfree()
> 
> They can switch to kvfree_rcu(ptr) and kfree_rcu(ptr) to benefit
> from asynchronous mode, instead of blocking the current thread.
> 
> [...]

Here is the summary with links:
  - [net-next] net/sysctl: avoid two synchronize_rcu() calls
    https://git.kernel.org/netdev/net-next/c/b3483bc7a1f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


