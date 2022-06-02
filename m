Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67AAC53B11F
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbiFBBUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbiFBBUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A059013C0BD
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 18:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B307615F3
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 01:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 823E5C34119;
        Thu,  2 Jun 2022 01:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654132813;
        bh=e2OcopGpqyp58cFs9F88X418a3OUeKjmt5PA/NdJijw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C3fB6Fe26/5p3oul/5MRHJLWHgdDm3eS0ha1dh8Yfl4aT0hazH6sWCRXHl17b/hzV
         otwxcgnENt7o39YaZ8dOvXWGri8lCT21CE1A1vxJdVRDSrTPj2qV1AYhuwD7sEP6+Y
         4EiHfuTS24dTMXcYYICLEer0H//a+Ddjv+fYPldMQDk3wzgjVXy5cYrSH9ovwSmJFj
         7jHLgkTam1qrzXtSxX6EOER4G8pqpAmWJVMyVz6XbYw5IRvGHNC4xSTlj+sMd4rs/9
         JnC39KXxbKp4XtI5DwQp8bVwbD0V4BpGGOnPqmmAICxfMetDltPHPwwtt1P+gDBaKc
         P0OCfbAMxObbw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66F38F0394F;
        Thu,  2 Jun 2022 01:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/7] net/mlx5: Don't use already freed action pointer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165413281341.8511.9931929673309954074.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 01:20:13 +0000
References: <20220531205447.99236-2-saeed@kernel.org>
In-Reply-To: <20220531205447.99236-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, leonro@nvidia.com,
        dan.carpenter@oracle.com, saeedm@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 31 May 2022 13:54:41 -0700 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The call to mlx5dr_action_destroy() releases "action" memory. That
> pointer is set to miss_action later and generates the following smatch
> error:
> 
>  drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c:53 set_miss_action()
>  warn: 'action' was already freed.
> 
> [...]

Here is the summary with links:
  - [net,1/7] net/mlx5: Don't use already freed action pointer
    https://git.kernel.org/netdev/net/c/80b2bd737d0e
  - [net,2/7] net/mlx5e: TC NIC mode, fix tc chains miss table
    https://git.kernel.org/netdev/net/c/66cb64e292d2
  - [net,3/7] net/mlx5: CT: Fix header-rewrite re-use for tupels
    https://git.kernel.org/netdev/net/c/1f2856cde64b
  - [net,4/7] net/mlx5e: Disable softirq in mlx5e_activate_rq to avoid race condition
    https://git.kernel.org/netdev/net/c/2e642afb61b2
  - [net,5/7] net/mlx5: correct ECE offset in query qp output
    https://git.kernel.org/netdev/net/c/3fc2a9e89b35
  - [net,6/7] net/mlx5e: Update netdev features after changing XDP state
    https://git.kernel.org/netdev/net/c/f6279f113ad5
  - [net,7/7] net/mlx5: Fix mlx5_get_next_dev() peer device matching
    https://git.kernel.org/netdev/net/c/1c5de097bea3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


