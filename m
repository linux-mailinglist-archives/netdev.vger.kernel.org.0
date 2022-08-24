Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B9359FA03
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbiHXMab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237446AbiHXMaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:30:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480A15853D
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5FB1B824A9
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 12:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E081C4314D;
        Wed, 24 Aug 2022 12:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661344220;
        bh=NY6xKDT1mgJUgCLndmndGBYqetL1FRgiznzbaPKipjA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NZcIYtlVch96BsUPtbszSXko7QOYuiFcsZzXLuXDowdNSOkDNexSFKfvKlk4OcJKn
         Wz3k4gakRSIaI9uR0M0PrdG/MIAflyQs2VUZiPhcRA74b9attvcmJEOzY7fv6QhEJf
         LVbM6Oprcs2VOcMcFqf31obOUh7w2qyoEzWp5dzj0yEgJaIunba9xlKrl6GBuJ0LXJ
         UiWZtFROUTL4eViLeD4ma8rN9XQjqDxCmHNejgyGp4Zg+QCPjPi22/6hs4yBaW9ILT
         lQJlwqw1T7Fzn9+p1sw/EaeVgxaTgCequANKlPjY9/HHgesAcIDTiB//61ESeqDtW1
         EwumSvxTTJ2Pg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E537E2A03B;
        Wed, 24 Aug 2022 12:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5e: Introduce flow steering API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166134422031.21889.11069861970906196921.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 12:30:20 +0000
References: <20220823055533.334471-2-saeed@kernel.org>
In-Reply-To: <20220823055533.334471-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, lkayal@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Mon, 22 Aug 2022 22:55:19 -0700 you wrote:
> From: Lama Kayal <lkayal@nvidia.com>
> 
> Move mlx5e_flow_steering struct to fs_en.c to make it private.
> Introduce flow_steering API and let other files go through it.
> 
> Signed-off-by: Lama Kayal <lkayal@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: Introduce flow steering API
    https://git.kernel.org/netdev/net-next/c/f52f2faee581
  - [net-next,02/15] net/mlx5e: Decouple fs_tt_redirect from en.h
    https://git.kernel.org/netdev/net-next/c/4e0ecc17a74e
  - [net-next,03/15] net/mlx5e: Decouple fs_tcp from en.h
    https://git.kernel.org/netdev/net-next/c/1be44b42b25c
  - [net-next,04/15] net/mlx5e: Drop priv argument of ptp function in en_fs
    https://git.kernel.org/netdev/net-next/c/81a0b241affe
  - [net-next,05/15] net/mlx5e: Convert ethtool_steering member of flow_steering struct to pointer
    https://git.kernel.org/netdev/net-next/c/c7eafc5ed068
  - [net-next,06/15] net/mlx5e: Directly get flow_steering struct as input when init/cleanup ethtool steering
    https://git.kernel.org/netdev/net-next/c/e8b5c4bcb554
  - [net-next,07/15] net/mlx5e: Separate ethtool_steering from fs.h and make private
    https://git.kernel.org/netdev/net-next/c/9c2c1c5e7fde
  - [net-next,08/15] net/mlx5e: Introduce flow steering debug macros
    https://git.kernel.org/netdev/net-next/c/93a07599ee0a
  - [net-next,09/15] net/mlx5e: Make flow steering arfs independent of priv
    https://git.kernel.org/netdev/net-next/c/45b83c6c6831
  - [net-next,10/15] net/mlx5e: Make all ttc functions of en_fs get fs struct as argument
    https://git.kernel.org/netdev/net-next/c/ca959d97d6bb
  - [net-next,11/15] net/mlx5e: Completely eliminate priv from fs.h
    https://git.kernel.org/netdev/net-next/c/d494dd2bb70c
  - [net-next,12/15] net/mlx5: E-Switch, Add default drop rule for unmatched packets
    https://git.kernel.org/netdev/net-next/c/8ea7bcf63218
  - [net-next,13/15] net/mlx5: E-Switch, Split creating fdb tables into smaller chunks
    https://git.kernel.org/netdev/net-next/c/4a561817064f
  - [net-next,14/15] net/mlx5: E-Switch, Move send to vport meta rule creation
    https://git.kernel.org/netdev/net-next/c/430e2d5e2a98
  - [net-next,15/15] net/mlx5: TC, Add support for SF tunnel offload
    https://git.kernel.org/netdev/net-next/c/72e0bcd15636

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


