Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7606BE02F
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 05:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCQEak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 00:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjCQEa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 00:30:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967675A924
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 21:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33DADB8242B
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 04:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF687C4339B;
        Fri, 17 Mar 2023 04:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679027422;
        bh=ANWkpW7NmXyH7Cm+bQk0pdnFSJfPd1KDb2G+1Gv4WS8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GRKb7YRUvLA1RO9OtRyG1GfPxgH9Bi2GUyrj8DGMPzvRJF7zUXbbTd0bBnmdkHyvO
         iGFT3MtCI/z6KWHKO+zYoJB9VId9G7n61VZQq3rFEEDIlk7Xarhmn5dOnJXiBzfe+u
         BQMozrhr5ze8j85M0I9k87ILjE6TgTsmfA5EbVA25yUJNJ6f4myUZuyKQuRSM+f2V7
         tRhwUKVQtb7EyddJr2MYee+fPaMnwOLCSoT2My+a97czZtlyQ/9d2pTSIuZpTXl6yV
         qALDC9qEh2nghE1lVemTqMR9zubFujIohoIo/bCFhHUbXB/ZeI1TZU3N6/ikW3/RJE
         9yPGPrxklclDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D56BAE21EE8;
        Fri, 17 Mar 2023 04:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net V2 01/14] net/mlx5e: Fix macsec ASO context alignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167902742186.2591.14038970181271591884.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 04:30:21 +0000
References: <20230315225847.360083-2-saeed@kernel.org>
In-Reply-To: <20230315225847.360083-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, ehakim@nvidia.com, leonro@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Wed, 15 Mar 2023 15:58:34 -0700 you wrote:
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> Currently mlx5e_macsec_umr struct does not satisfy hardware memory
> alignment requirement. Hence the result of querying advanced steering
> operation (ASO) is not copied to the memory region as expected.
> 
> Fix by satisfying hardware memory alignment requirement and move
> context to be first field in struct for better readability.
> 
> [...]

Here is the summary with links:
  - [net,V2,01/14] net/mlx5e: Fix macsec ASO context alignment
    https://git.kernel.org/netdev/net/c/37beabe9a891
  - [net,V2,02/14] net/mlx5e: Don't cache tunnel offloads capability
    https://git.kernel.org/netdev/net/c/9a92fe1db9e5
  - [net,V2,03/14] net/mlx5: Fix setting ec_function bit in MANAGE_PAGES
    https://git.kernel.org/netdev/net/c/ba5d8f72b82c
  - [net,V2,04/14] net/mlx5: Disable eswitch before waiting for VF pages
    https://git.kernel.org/netdev/net/c/7ba930fc25de
  - [net,V2,05/14] net/mlx5: E-switch, Fix wrong usage of source port rewrite in split rules
    https://git.kernel.org/netdev/net/c/1313d78ac0c1
  - [net,V2,06/14] net/mlx5: E-switch, Fix missing set of split_count when forward to ovs internal port
    https://git.kernel.org/netdev/net/c/28d3815a629c
  - [net,V2,07/14] net/mlx5e: Fix cleanup null-ptr deref on encap lock
    https://git.kernel.org/netdev/net/c/c9668f0b1d28
  - [net,V2,08/14] net/mlx5e: kTLS, Fix missing error unwind on unsupported cipher type
    https://git.kernel.org/netdev/net/c/dd64572490c3
  - [net,V2,09/14] net/mlx5: Set BREAK_FW_WAIT flag first when removing driver
    https://git.kernel.org/netdev/net/c/031a163f2c47
  - [net,V2,10/14] net/mlx5e: Lower maximum allowed MTU in XSK to match XDP prerequisites
    https://git.kernel.org/netdev/net/c/78dee7befd56
  - [net,V2,11/14] net/sched: TC, fix raw counter initialization
    https://git.kernel.org/netdev/net/c/d1a0075ad6b6
  - [net,V2,12/14] net/mlx5e: TC, fix missing error code
    https://git.kernel.org/netdev/net/c/1166add424da
  - [net,V2,13/14] net/mlx5e: TC, fix cloned flow attribute
    https://git.kernel.org/netdev/net/c/b23bf10cca59
  - [net,V2,14/14] net/mlx5e: TC, Remove error message log print
    https://git.kernel.org/netdev/net/c/c7b7c64ab582

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


