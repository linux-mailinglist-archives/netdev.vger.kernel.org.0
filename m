Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5BA6957BA
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 05:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjBNEK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 23:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjBNEKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 23:10:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504C017CE5
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 20:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAA6FB81B22
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 04:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2A6CC4339C;
        Tue, 14 Feb 2023 04:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676347818;
        bh=q+Wi+m22u9QqzPsbRSNPt5MdhQIN64iXlyo4THlYwyo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mW3VOfQ2syz1C8eXEkOHgrY4WtoHty5YGk7DTQgdSTvkeHtS57ZeDau2i/OkM33/j
         OG+q/w5f/UkQ5Wn2SRcyp/dL8MmeAPZaOAI4mNljw/n1Tx/3iA3Y/NfjMSuduiBAiB
         eJj7Z9tcrWU/BZq7XGKN/UXGutXaRCZxy7AFQ95Zk90JB5pVxwYhmKS0MJQRB2Q+2z
         JxE24UyUNgFmZG2S+Ta11JrUQCYAh9HiEhjllliVHwO/+U9TEh1QXq5WMM1Gk6vHWC
         S78f93YOjNjjVERquS+dOxsL6VgmIVDr9Bhl7Iera6QdnNKzCJMpaB7l6TLkd+ofiy
         +VnAxkLvX0iow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8DC3FE270C2;
        Tue, 14 Feb 2023 04:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] ipv6: more drop reason
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167634781857.18399.3340594477350756997.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 04:10:18 +0000
References: <20230210184708.2172562-1-edumazet@google.com>
In-Reply-To: <20230210184708.2172562-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, netdev@vger.kernel.org, eric.dumazet@gmail.com
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

On Fri, 10 Feb 2023 18:47:04 +0000 you wrote:
> Add more drop reasons to IPv6:
> 
>  - IPV6_BAD_EXTHDR
>  - IPV6_NDISC_FRAG
>  - IPV6_NDISC_HOP_LIMIT
>  - IPV6_NDISC_BAD_CODE
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: dropreason: add SKB_DROP_REASON_IPV6_BAD_EXTHDR
    https://git.kernel.org/netdev/net-next/c/dc68eaf2c29f
  - [net-next,2/4] net: add pskb_may_pull_reason() helper
    https://git.kernel.org/netdev/net-next/c/1fb2d41501f3
  - [net-next,3/4] ipv6: icmp6: add drop reason support to icmpv6_notify()
    https://git.kernel.org/netdev/net-next/c/30c89bad3ea2
  - [net-next,4/4] ipv6: icmp6: add drop reason support to ndisc_rcv()
    https://git.kernel.org/netdev/net-next/c/545dbcd124b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


