Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DEE515CA9
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 14:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbiD3MNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 08:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbiD3MNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 08:13:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C577659;
        Sat, 30 Apr 2022 05:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97B90CE02C7;
        Sat, 30 Apr 2022 12:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E2A6C385AE;
        Sat, 30 Apr 2022 12:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651320612;
        bh=lh6YsWWNzTF+K97GRW8ZIrWk45vWopwIEJRFY+ww1RE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ll8X7x8Km5uESLL4dQBsbreGwaDFmcPQGz/eqWe6gStjgYt1jwA5HI8ssi6/h4SUx
         1AsdOhgj6UHlqFDhyAnpMUb23Xu56rMqoACG6fD2zKKPZGMwCN0RjbvEa5kFwwzqWh
         a/nASF7luILFeaY6cbbPE8O/CnXs/NvExPa3skHiViyX8Mv1HpiT0qq74jV8az8xP4
         01+O7Jv3XH2jHLaBB6Rf5OMpWkQJJ3OcfFm/rV7RV46ZVkR2D7dbNE3yQ8ANrcEHmX
         kenFGoPgk+zwjV+W+hNjl+naixZjWe1+v2jM+iNx17BXP4ssoU/Lx+6TbXSpBBvPzy
         st+AIxiUkjX9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7E9DBF03841;
        Sat, 30 Apr 2022 12:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] generic net and ipv6 minor optimisations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165132061250.13332.11733885633402337969.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 12:10:12 +0000
References: <cover.1651141755.git.asml.silence@gmail.com>
In-Reply-To: <cover.1651141755.git.asml.silence@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, edumazet@google.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 28 Apr 2022 11:58:43 +0100 you wrote:
> 1-3 inline simple functions that only reshuffle arguments possibly adding
> extra zero args, and call another function. It was benchmarked before with
> a bunch of extra patches, see for details
> 
> https://lore.kernel.org/netdev/cover.1648981570.git.asml.silence@gmail.com/
> 
> It may increase the binary size, but it's the right thing to do and at least
> without modules it actually sheds some bytes for some standard-ish config.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: inline sock_alloc_send_skb
    https://git.kernel.org/netdev/net-next/c/de32bc6aad09
  - [net-next,2/5] net: inline skb_zerocopy_iter_dgram
    https://git.kernel.org/netdev/net-next/c/657dd5f97b2e
  - [net-next,3/5] net: inline dev_queue_xmit()
    https://git.kernel.org/netdev/net-next/c/c526fd8f9f4f
  - [net-next,4/5] ipv6: help __ip6_finish_output() inlining
    https://git.kernel.org/netdev/net-next/c/4b143ed7dde5
  - [net-next,5/5] ipv6: refactor ip6_finish_output2()
    https://git.kernel.org/netdev/net-next/c/58f71be58b87

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


