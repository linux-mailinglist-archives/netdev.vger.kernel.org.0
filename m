Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FEF634F2F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbiKWEwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235267AbiKWEwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:52:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CF8D5A3D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:52:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7D8261A5A
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 258A0C433B5;
        Wed, 23 Nov 2022 04:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179129;
        bh=Mx2XkilFPGg6RwbfTTw3xiJsjmQ1YcK56tZPDShT6Ps=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q4LL8CweUzsWp0hIx/pxykaueooMkfz3jH0LvpnU895lYcuqFPeVIC09XfO6C6iE2
         5DsyOvrxAflG9YdSBvPqn0B0sOBiKf7ocSGtiYjAB5oeVEKYUqGuW5rba8726dZ/cP
         /iGty0/pdCZJbv2GvR0U0TsVYpqK0NwMTgGc67BJ1IKUh47cIpU0EmbBz5dgCLK1qL
         7VBytGXL7dKz8FFJmI/NYNLi3wtmgQuyJKXmfaTpvVVQPxyUeTQFoy5cvmV8QUXSGd
         TwZj4pGkyYedif5JOQNlvPC0xvedVKNy6Om/tnB1LobEVvtsVHm2mJqsMUrnCuXdFP
         zGiDglFCHQvsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 005D3C395F0;
        Wed, 23 Nov 2022 04:52:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2] tcp: Fix build break when CONFIG_IPV6=n
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166917912899.11566.5697559493651446354.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 04:52:08 +0000
References: <20221122184158.170798-1-saeed@kernel.org>
In-Reply-To: <20221122184158.170798-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, geert+renesas@glider.be,
        matthieu.baerts@tessares.net, jamie.bainbridge@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 22 Nov 2022 10:41:58 -0800 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> The cited commit caused the following build break when CONFIG_IPV6 was
> disabled
> 
> net/ipv4/tcp_input.c: In function ‘tcp_syn_flood_action’:
> include/net/sock.h:387:37: error: ‘const struct sock_common’ has no member named ‘skc_v6_rcv_saddr’; did you mean ‘skc_rcv_saddr’?
> 
> [...]

Here is the summary with links:
  - [net-next,V2] tcp: Fix build break when CONFIG_IPV6=n
    https://git.kernel.org/netdev/net-next/c/c90b6b1005ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


