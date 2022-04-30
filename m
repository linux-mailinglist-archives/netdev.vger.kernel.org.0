Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834A3515E28
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 16:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbiD3OZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 10:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382836AbiD3OXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 10:23:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C736FBE37;
        Sat, 30 Apr 2022 07:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCD25B83086;
        Sat, 30 Apr 2022 14:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9667CC385B6;
        Sat, 30 Apr 2022 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651328411;
        bh=0xoe/LxFqApX7ISnui86MdoEsq8Xn9EH9My+RuZq8mU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ri5g3Y7WRhFxZNML504fDjptIJ13BeoEJRWSiy4PzofTm8mJR7Za5OONZAqgagQ8b
         juoiV1qTuesG9+SDqto90ao1z+svN7rqi+q7/+v7sIsjOKBtXg/RTZ4cWNEth1od0F
         5RRvTdv3rAQmgpq4g0HRzjmaSlrlxkXBfk8oUR3W1g/m1Z1zDK4tAwbtvk12wrEL9r
         qlLXh/1HKNbhF7tYiUKdH/Fw7EWJ5co/cy9EVlezeFZaaqkHiyBb4/s9bp0UQPhJsS
         0oIT76XGV4iiQRe6MbnTa9F+8J1+Wzk8BZ9QTZ4DbsPMYJOmHjeFCnRQY9UfJ8Fia+
         3A34U3v+iGF0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C661E8DD85;
        Sat, 30 Apr 2022 14:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv4: remove unnecessary type castings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165132841150.7113.9262041805649538846.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 14:20:11 +0000
References: <20220429021404.1648570-1-yuzhe@nfschina.com>
In-Reply-To: <20220429021404.1648570-1-yuzhe@nfschina.com>
To:     Yu Zhe <yuzhe@nfschina.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, hukun@nfschina.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Apr 2022 19:14:04 -0700 you wrote:
> remove unnecessary void* type castings.
> 
> Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
> ---
>  net/ipv4/fib_frontend.c  | 4 ++--
>  net/ipv4/fib_rules.c     | 2 +-
>  net/ipv4/fib_trie.c      | 2 +-
>  net/ipv4/icmp.c          | 2 +-
>  net/ipv4/igmp.c          | 4 ++--
>  net/ipv4/inet_fragment.c | 2 +-
>  net/ipv4/ipmr.c          | 2 +-
>  net/ipv4/ping.c          | 2 +-
>  8 files changed, 10 insertions(+), 10 deletions(-)

Here is the summary with links:
  - ipv4: remove unnecessary type castings
    https://git.kernel.org/netdev/net-next/c/2e47eece158a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


