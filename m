Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7154A581DF1
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240083AbiG0DKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiG0DKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1CA6248
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E183961798
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 03:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44128C43145;
        Wed, 27 Jul 2022 03:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658891414;
        bh=vXl8addqiwzMHY8/w0mcFzuPcxCU5mEhx9KmdOyJhKI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K9BcuTrbXlXKo1cVy1T5HeNHDVIESr70FAxppIsLIvoZED8XllDLy6jSHcuaVT5JC
         IkjzKwAvCEA/Ru4EQ8XqsvEUzFYgto9wLxEnagxpn5XhnhfWknNLMu2xlORWfzRZmA
         HmZ0YN+yJu4VjdKFaKdWOihUxVvUpcBuhK/fyhQtbdJ5+ep2Co78whgt7Q1qRUB5W+
         BieXnTWiKxUPK+MLZPn+z91QNOK23sQLT44FkmwsuFiyVxLmb9SxN/aH5ks/eWRsec
         EPUOXlPG0ooqFTFZbN4dTgRjfZc3i52sFcqvRakRFCeB4O0XEhWEgc2UyS3CS+ONYo
         LNRSMUTIyPXAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D14AC43142;
        Wed, 27 Jul 2022 03:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ip6mr: remove stray rcu_read_unlock() from
 ip6_mr_forward()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165889141418.5272.939658706209911204.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jul 2022 03:10:14 +0000
References: <20220725200554.2563581-1-eric.dumazet@gmail.com>
In-Reply-To: <20220725200554.2563581-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, olteanv@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 25 Jul 2022 13:05:54 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> One rcu_read_unlock() should have been removed in blamed commit.
> 
> Fixes: 9b1c21d898fd ("ip6mr: do not acquire mrt_lock while calling ip6_mr_forward()")
> Reported-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] ip6mr: remove stray rcu_read_unlock() from ip6_mr_forward()
    https://git.kernel.org/netdev/net-next/c/a7e555d4a184

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


