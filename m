Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539D7609D88
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiJXJK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbiJXJK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:10:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B0029C99
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D4A861127
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 09:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D667BC433D7;
        Mon, 24 Oct 2022 09:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666602616;
        bh=oZHeITMKk/qfhiIniS+hT5SX5c0MXj8HVpqZDsHbC9k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NNpnEwTvNoSJ/GoNRHo7lO2MJ3ru8sqfhO6sL3ZY6/B1dnt/axv1DGn7k1lWBCJCe
         u2jObFL33pUwJN2S4TSzHW15yov/vnpzchdL+98S0DpdaNQgnq2EH+f4sr3Ax9Pat2
         BWrOxwL29+GWm8T9hH+q+CiK9kE1rDO0ZElKSlogsu4p2AI9nhrAtgn2H2IYiWdtKp
         o2kNYuqoWTP8kQk+rTLW0kA9LRqKOYhh+CofPAyobnm3+/1qCaWp+uq9RwFesVty/A
         DiH4P8ET1DkMIApr+JhiY5JcAW3FpJEQStfm8INuSQ9CvATwZqtMgUmcLRj0qJ7xqH
         vsgTcEtsCkvhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BCAB0C4166D;
        Mon, 24 Oct 2022 09:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/5] inet6: Remove inet6_destroy_sock() calls.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166660261676.3485.16310457743644962563.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 09:10:16 +0000
References: <20221019223603.22991-1-kuniyu@amazon.com>
In-Reply-To: <20221019223603.22991-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        kuni1840@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 19 Oct 2022 15:35:58 -0700 you wrote:
> This is a follow-up series for commit d38afeec26ed ("tcp/udp: Call
> inet6_destroy_sock() in IPv6 sk->sk_destruct().").
> 
> This series cleans up unnecessary inet6_destory_sock() calls in
> sk->sk_prot->destroy() and call it from sk->sk_destruct() to make
> sure we do not leak memory related to IPv6 specific-resources.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/5] inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().
    https://git.kernel.org/netdev/net-next/c/b5fc29233d28
  - [v2,net-next,2/5] dccp: Call inet6_destroy_sock() via sk->sk_destruct().
    https://git.kernel.org/netdev/net-next/c/1651951ebea5
  - [v2,net-next,3/5] sctp: Call inet6_destroy_sock() via sk->sk_destruct().
    https://git.kernel.org/netdev/net-next/c/6431b0f6ff16
  - [v2,net-next,4/5] inet6: Remove inet6_destroy_sock().
    https://git.kernel.org/netdev/net-next/c/1f8c4eeb9455
  - [v2,net-next,5/5] inet6: Clean up failure path in do_ipv6_setsockopt().
    https://git.kernel.org/netdev/net-next/c/b45a337f061e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


