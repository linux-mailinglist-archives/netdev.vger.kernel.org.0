Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FB26DA7A7
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 04:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240511AbjDGCU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 22:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240502AbjDGCUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 22:20:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F732A9
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 19:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CE1B64749
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 02:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6404CC4339B;
        Fri,  7 Apr 2023 02:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680834020;
        bh=/6HOWbj+NuOyOJOp+/0NHXBuwnN5IUqqchiDA5L7gTE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PLHRprqafasJLw/r+AyXr4VyoL6arWgjm9d6Z6s8urYUTX6vRS+ZKY5Nmu+U9COzR
         i4k2r25ZVlMdV5ca5YJLFBiIid+G3eszvFmetXKospRbrzalO8kHEXB820j6c231F2
         OFBPV7qB4SIc9HrFLyHQLVXk2R31DRehkLPAd+fn1dJa3uBJQ3i1HcwRom+xCDUr2b
         YvM7YjL6vUfj27vCb/mcu/SyZOhA+2llQnwfo60sOzjwEOfXo0M2xvIPSdeM0ahnYO
         /sAouYzxtRj0s26s+Xxn0I2iR9THKk+sIA+KxkPmAvagaHBsHW/LEqeHALrh0VYz2C
         mWgBizQDaVljA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 492A6C41671;
        Fri,  7 Apr 2023 02:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5e: Set default can_offload action
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168083402029.18528.11718147215850947886.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Apr 2023 02:20:20 +0000
References: <20230406020232.83844-2-saeed@kernel.org>
In-Reply-To: <20230406020232.83844-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, paulb@nvidia.com, roid@nvidia.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Wed,  5 Apr 2023 19:02:18 -0700 you wrote:
> From: Paul Blakey <paulb@nvidia.com>
> 
> Many parsers of tc actions just return true on their can_offload()
> implementation, without checking the input flow/action.
> Set the default can_offload action to true (allow), and avoid
> having many can_offload implementations that do just that.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: Set default can_offload action
    https://git.kernel.org/netdev/net-next/c/0840c9f7d80b
  - [net-next,02/15] net/mlx5e: TC, Remove unused vf_tun variable
    https://git.kernel.org/netdev/net-next/c/7195d9a0c8df
  - [net-next,03/15] net/mlx5e: TC, Move main flow attribute cleanup to helper func
    https://git.kernel.org/netdev/net-next/c/a830ec485e83
  - [net-next,04/15] net/mlx5e: CT: Use per action stats
    https://git.kernel.org/netdev/net-next/c/13aca17b450e
  - [net-next,05/15] net/mlx5e: TC, Remove CT action reordering
    https://git.kernel.org/netdev/net-next/c/67efaf45930d
  - [net-next,06/15] net/mlx5e: TC, Remove special handling of CT action
    https://git.kernel.org/netdev/net-next/c/08fe94ec5f77
  - [net-next,07/15] net/mlx5e: TC, Remove multiple ct actions limitation
    https://git.kernel.org/netdev/net-next/c/d0cc0853640d
  - [net-next,08/15] net/mlx5e: TC, Remove tuple rewrite and ct limitation
    https://git.kernel.org/netdev/net-next/c/5d7cb06eb91a
  - [net-next,09/15] net/mlx5e: TC, Remove mirror and ct limitation
    https://git.kernel.org/netdev/net-next/c/dc614025e228
  - [net-next,10/15] net/mlx5e: TC, Remove sample and ct limitation
    https://git.kernel.org/netdev/net-next/c/35c8de16d846
  - [net-next,11/15] net/mlx5e: Remove redundant macsec code
    https://git.kernel.org/netdev/net-next/c/1a62ffcaaabf
  - [net-next,12/15] net/mlx5: Update cyclecounter shift value to improve ptp free running mode precision
    https://git.kernel.org/netdev/net-next/c/6a4010927562
  - [net-next,13/15] net/mlx5e: Rename misleading skb_pc/cc references in ptp code
    https://git.kernel.org/netdev/net-next/c/cf1cccae7983
  - [net-next,14/15] net/mlx5e: Fix RQ SW state layout in RQ devlink health diagnostics
    https://git.kernel.org/netdev/net-next/c/6bd0f349ae70
  - [net-next,15/15] net/mlx5e: Fix SQ SW state layout in SQ devlink health diagnostics
    https://git.kernel.org/netdev/net-next/c/b0d87ed27be7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


