Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA786595EB
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 08:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbiL3HuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 02:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiL3HuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 02:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF5110040
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 23:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC295B81B0B
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 07:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 805D6C433F1;
        Fri, 30 Dec 2022 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672386616;
        bh=rFYKp8WJBk5vy68Fk9DuPLvHk0uMhHWGZRHUqciP73A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HzAo3gnvcJqdyGkVbbdGY34oIRKEze/kgOYTuQr7fkrKnwlUes4kbwG3HBv5JWMX1
         RiZMST3/l9HPpeBgKXpWOpQqLET25prPoo0QMp8HtQ5uh3iOVYvHPF5TteI/8VLSOO
         1g6tFRXeDyPiAQdyqpv0WMG71Q1pyypL6QVR5Zzfkno23AFKXDRcqcDKLwu+kaRlO0
         +UfVKQ1LqLjee+ZLB4YET/JDFP3ZzyiDhVAxSIyhV/fdjvNHSnOL3SK9dAx9uTjtOj
         QUb9Cqn9nHkN0HRb3fWrpatC9QoIAuH7f7a0af+2F926aMQ0gJ5BCXtCCOaZESj+8A
         YzX9HjGMBo8+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64527E50D71;
        Fri, 30 Dec 2022 07:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V1 net 0/7] ENA driver bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167238661640.5828.10518622638673173209.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Dec 2022 07:50:16 +0000
References: <20221229073011.19687-1-darinzon@amazon.com>
In-Reply-To: <20221229073011.19687-1-darinzon@amazon.com>
To:     <darinzon@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        nafea@amazon.com, alisaidi@amazon.com, akiyano@amazon.com,
        ndagan@amazon.com, shayagr@amazon.com, itzko@amazon.com,
        osamaabb@amazon.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 29 Dec 2022 07:30:04 +0000 you wrote:
> From: David Arinzon <darinzon@amazon.com>
> 
> ENA driver bug fixes
> 
> David Arinzon (7):
>   net: ena: Fix toeplitz initial hash value
>   net: ena: Don't register memory info on XDP exchange
>   net: ena: Account for the number of processed bytes in XDP
>   net: ena: Use bitmask to indicate packet redirection
>   net: ena: Fix rx_copybreak value update
>   net: ena: Set default value for RX interrupt moderation
>   net: ena: Update NUMA TPH hint register upon NUMA node update
> 
> [...]

Here is the summary with links:
  - [V1,net,1/7] net: ena: Fix toeplitz initial hash value
    https://git.kernel.org/netdev/net/c/332b49ff637d
  - [V1,net,2/7] net: ena: Don't register memory info on XDP exchange
    https://git.kernel.org/netdev/net/c/9c9e539956fa
  - [V1,net,3/7] net: ena: Account for the number of processed bytes in XDP
    https://git.kernel.org/netdev/net/c/c7f5e34d9063
  - [V1,net,4/7] net: ena: Use bitmask to indicate packet redirection
    https://git.kernel.org/netdev/net/c/59811faa2c54
  - [V1,net,5/7] net: ena: Fix rx_copybreak value update
    https://git.kernel.org/netdev/net/c/c7062aaee099
  - [V1,net,6/7] net: ena: Set default value for RX interrupt moderation
    https://git.kernel.org/netdev/net/c/e712f3e4920b
  - [V1,net,7/7] net: ena: Update NUMA TPH hint register upon NUMA node update
    https://git.kernel.org/netdev/net/c/a8ee104f986e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


