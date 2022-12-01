Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E5B63EFDD
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 12:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiLALuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 06:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiLALuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 06:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0EC9AE04
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 03:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F039561FAF
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 11:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 579DAC433D7;
        Thu,  1 Dec 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669895415;
        bh=Xq16YW9rL6VL7nkkus5LWdRJFyEc2eNVWOYmdUS9534=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nhQjVGGT6BVYcbsdWE2dvVZR20rT4isxjbEbwd/3QEjlSZyLMnjF58My94PgDgcKq
         1xoxWQHqfdiCXvkMpKeEpJlAK0xPN2imKFhOBd+fzaDdA72znFrICMwJZsqtNnsn04
         GtBlO3culsgbvFJz3zKm4A3pVbZDq0tfwxztbudXFJ83wDsYBhRlMiQTc78kmyCRND
         XpjC6jdgg3QXEbIrgjgVszX7NMs5uqWaY3JkustnYMRVq2bqVxTTcYgzgzfBDLvw8u
         Gb/7aL1IhmCq/J5NJagX6X89+BhG9qsTL+UPOEm2Gug8k+fMM27bzrNN9a2En6W1qY
         S6ny/vqCw8GGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E6D8E52537;
        Thu,  1 Dec 2022 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] inet: ping: use hlist_nulls rcu iterator during lookup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166989541525.32624.1543840469881112502.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 11:50:15 +0000
References: <20221129140644.28525-1-fw@strlen.de>
In-Reply-To: <20221129140644.28525-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 29 Nov 2022 15:06:44 +0100 you wrote:
> ping_lookup() does not acquire the table spinlock, so iteration should
> use hlist_nulls_for_each_entry_rcu().
> 
> Spotted during code review.
> 
> Fixes: dbca1596bbb0 ("ping: convert to RCU lookups, get rid of rwlock")
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net] inet: ping: use hlist_nulls rcu iterator during lookup
    https://git.kernel.org/netdev/net/c/c25b7a7a565e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


