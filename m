Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCF26918EB
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 08:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjBJHAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 02:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjBJHAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 02:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8311BED
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 23:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C2ACB823F2
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42F38C433EF;
        Fri, 10 Feb 2023 07:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676012418;
        bh=yEe2IJdExozzl9fOOjHLadfaw9LJWVnWEVFv3gRFM+I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cdC04mK6vqTv4FasNiiqkILNV/AIdPp8YgtTK/06DrIM6mMg8bNNfYI9k6X/b8iLx
         q3cZO5KNWrQmOuK/HHUT9MLP5NQgCC3J8o8NFeiJEuI1qAmHi/454ZDzxycziayJxh
         ZENV3lTF8Je4LmF2/LWzRpG25+MeGfViqC3iNsDluIn04xpw57GCMcNv2b8ZFZEzN/
         b6bQN45Mt2uYkKNBgLvPT+sl2RGyHtajv4+JdOGxFHgRVwF3lUJtdW0arLoLLtLKzl
         pb+HqRO4FO5cWEFmi81zE7ECE57azwZ1yvxivYEemZM79NICOPxV1vjbQ7k4a5s0Px
         PgSQvzlAxZivg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1988EE55EFD;
        Fri, 10 Feb 2023 07:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] ipv6: Fix socket connection with DSCP fib-rules.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167601241810.12809.3450172143227883606.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 07:00:18 +0000
References: <cover.1675875519.git.gnault@redhat.com>
In-Reply-To: <cover.1675875519.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 8 Feb 2023 18:13:56 +0100 you wrote:
> The "flowlabel" field of struct flowi6 is used to store both the actual
> flow label and the DS Field (or Traffic Class). However the .connect
> handlers of datagram and TCP sockets don't set the DS Field part when
> doing their route lookup. This breaks fib-rules that match on DSCP.
> 
> Guillaume Nault (3):
>   ipv6: Fix datagram socket connect with DSCP.
>   ipv6: Fix tcp socket connect with DSCP.
>   selftests: fib_rule_tests: Test UDP and TCP connections with DSCP
>     rules.
> 
> [...]

Here is the summary with links:
  - [net,1/3] ipv6: Fix datagram socket connection with DSCP.
    https://git.kernel.org/netdev/net/c/e010ae08c71f
  - [net,2/3] ipv6: Fix tcp socket connection with DSCP.
    https://git.kernel.org/netdev/net/c/8230680f36fd
  - [net,3/3] selftests: fib_rule_tests: Test UDP and TCP connections with DSCP rules.
    https://git.kernel.org/netdev/net/c/c21a20d9d102

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


