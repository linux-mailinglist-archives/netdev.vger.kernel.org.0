Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA0668B877
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjBFJUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjBFJUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:20:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB605B8C
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 01:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EC6EB80D89
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD6B3C4339B;
        Mon,  6 Feb 2023 09:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675675218;
        bh=WnEl6QbdPKA/y4Q/DbwC10S25TCthLW5qwUZzT18wzw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hGxQvHzUPAF6OgePSl00qRbScFV40R/i5LLbHuJ6cafBicB2l00GJMuGn7bfowjVx
         85wF9QD+3JDn0EzswgoWf1Tnq09Q12laT/HmqOhg5aWiwYe3S9er9aeBPtumMj6APS
         NLBe5eifS4S92dlJQTicLjKf0U4nMoyKtEfVYrEIAmeMEHp4PWnMx/wAG9QizOdCuL
         D0i6fFI5KPG8qeMd9SZkYPkOwBGy307nOJUcxFRBclttC46/ZhhdUs+Clh65Kfk8tw
         r/BCyGIgfPfj/ZtbrOZQ1TxWwJDcN3vKvphzQo2JpRpk8AdS55sE0KPUAReXtSmndI
         1ZZJ7S6fNLaMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8DACDE55EFB;
        Mon,  6 Feb 2023 09:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: Lag,
 Update multiport eswitch check to log an error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567521857.4325.8280002381321615996.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 09:20:18 +0000
References: <20230204100854.388126-2-saeed@kernel.org>
In-Reply-To: <20230204100854.388126-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, roid@nvidia.com, maord@nvidia.com
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
by Saeed Mahameed <saeedm@nvidia.com>:

On Sat,  4 Feb 2023 02:08:40 -0800 you wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> Update the function to log an error to the user if failing to offload
> the rule and while there add correct prefix for the function name.
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: Lag, Update multiport eswitch check to log an error
    https://git.kernel.org/netdev/net-next/c/2afcfae77a07
  - [net-next,02/15] net/mlx5: Lag, Use mlx5_lag_dev() instead of derefering pointers
    https://git.kernel.org/netdev/net-next/c/9a49a64ea7ed
  - [net-next,03/15] net/mlx5: Lag, Remove redundant bool allocation on the stack
    https://git.kernel.org/netdev/net-next/c/b399b066e27e
  - [net-next,04/15] net/mlx5: Lag, Use flag to check for shared FDB mode
    https://git.kernel.org/netdev/net-next/c/6a80313d24ac
  - [net-next,05/15] net/mlx5: Lag, Move mpesw related definitions to mpesw.h
    https://git.kernel.org/netdev/net-next/c/199abf33f414
  - [net-next,06/15] net/mlx5: Separate mlx5 driver documentation into multiple pages
    https://git.kernel.org/netdev/net-next/c/f2d51e579359
  - [net-next,07/15] net/mlx5: Update Kconfig parameter documentation
    https://git.kernel.org/netdev/net-next/c/a12ba19269d7
  - [net-next,08/15] net/mlx5: Document previously implemented mlx5 tracepoints
    https://git.kernel.org/netdev/net-next/c/e12ebbf0cc55
  - [net-next,09/15] net/mlx5: Add counter information to mlx5 driver documentation
    https://git.kernel.org/netdev/net-next/c/8ce3b586faa4
  - [net-next,10/15] net/mlx5: Document support for RoCE HCA disablement capability
    https://git.kernel.org/netdev/net-next/c/04937a0f6891
  - [net-next,11/15] net/mlx5: Add firmware support for MTUTC scaled_ppm frequency adjustments
    https://git.kernel.org/netdev/net-next/c/b63636b6c170
  - [net-next,12/15] net/mlx5: Enhance debug print in page allocation failure
    https://git.kernel.org/netdev/net-next/c/7eef93003e5d
  - [net-next,13/15] net/mlx5e: IPoIB, Add support for XDR speed
    https://git.kernel.org/netdev/net-next/c/ce231772da8c
  - [net-next,14/15] net/mlx5e: IPsec, support upper protocol selector field offload
    https://git.kernel.org/netdev/net-next/c/a7385187a386
  - [net-next,15/15] net/mlx5e: Trigger NAPI after activating an SQ
    https://git.kernel.org/netdev/net-next/c/79efecb41f58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


