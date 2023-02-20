Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBC869C727
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 10:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjBTJAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 04:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjBTJAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 04:00:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7D3EF8B
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 01:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 816F3B80B45
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 09:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B59EC4339C;
        Mon, 20 Feb 2023 09:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676883618;
        bh=9cxUpviyM7axaxYKii3tixgT/aI4r5duIMPKJMYrVW4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PPmx0H3/pidAXgHx9Wb8khFv/XdcKixTFjaLmQOIIV79DmgwjL9VzlXawPE3GBcoY
         PLk8vBeZ8oakKoqMghgtkxeCmZs9ykkY5HU9bDhPirWl+VyR6LTL7xZYOZkb2txwvw
         KRpBlxDEdWjIruxjZ+ouM28lkcRoU28sYnu98GXLE2o7VXCO5M0nMouCC8BfnLI8I0
         deYRgOsTmK+Swmx0+KGHsR/0ax6Q3hsqoI0Tq3HkM6eNFz2idwf0QVWqtoyGb86HX6
         rmApcd8StuAqq0h71+GXgvIAay2jr2TQoy2yL4Y4fpvdHoFOaOD+Nc7F3h1s8UWxTQ
         A7mpJliv70Ilw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21E6DE68D20;
        Mon, 20 Feb 2023 09:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] ipv6: icmp6: better drop reason support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167688361813.6320.4018001345264762025.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 09:00:18 +0000
References: <20230216162842.1633734-1-edumazet@google.com>
In-Reply-To: <20230216162842.1633734-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Feb 2023 16:28:34 +0000 you wrote:
> This series aims to have more precise drop reason reports for icmp6.
> 
> This should reduce false positives on most usual cases.
> 
> This can be extended as needed later.
> 
> Eric Dumazet (8):
>   ipv6: icmp6: add drop reason support to ndisc_recv_ns()
>   ipv6: icmp6: add drop reason support to ndisc_recv_na()
>   ipv6: icmp6: add drop reason support to ndisc_recv_rs()
>   ipv6: icmp6: add drop reason support to ndisc_router_discovery()
>   ipv6: icmp6: add drop reason support to ndisc_redirect_rcv()
>   ipv6: icmp6: add SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS
>   ipv6: icmp6: add SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST
>   ipv6: icmp6: add drop reason support to icmpv6_echo_reply()
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] ipv6: icmp6: add drop reason support to ndisc_recv_ns()
    https://git.kernel.org/netdev/net-next/c/7c9c8913f452
  - [net-next,2/8] ipv6: icmp6: add drop reason support to ndisc_recv_na()
    https://git.kernel.org/netdev/net-next/c/3009f9ae21ec
  - [net-next,3/8] ipv6: icmp6: add drop reason support to ndisc_recv_rs()
    https://git.kernel.org/netdev/net-next/c/243e37c642ac
  - [net-next,4/8] ipv6: icmp6: add drop reason support to ndisc_router_discovery()
    https://git.kernel.org/netdev/net-next/c/2f326d9d9ff4
  - [net-next,5/8] ipv6: icmp6: add drop reason support to ndisc_redirect_rcv()
    https://git.kernel.org/netdev/net-next/c/ec993edf05ca
  - [net-next,6/8] ipv6: icmp6: add SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS
    https://git.kernel.org/netdev/net-next/c/784d4477f07b
  - [net-next,7/8] ipv6: icmp6: add SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST
    https://git.kernel.org/netdev/net-next/c/c34b8bb11ebc
  - [net-next,8/8] ipv6: icmp6: add drop reason support to icmpv6_echo_reply()
    https://git.kernel.org/netdev/net-next/c/ac03694bc009

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


