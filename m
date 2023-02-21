Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994C969D7D4
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 02:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbjBUBA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 20:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbjBUBA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 20:00:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EF022DFF
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 17:00:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 662B9B80E67
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D50D8C4339B;
        Tue, 21 Feb 2023 01:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676941222;
        bh=iRBj7Ys6QYKYOpArUWC//7cRBT5SCNHonBgbkqz+kgM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EmB7su3NH2AvyeZLMPLAZnKbl1rJk60PgnX0iOl1uNZ12D2Askc+VhwB/aXg2qm8P
         /XK3N6C4OkrPb14QulArI+FukRRy3VimAWlY5tLtBxSsEc/8VkMKxvSEgd2TlqD2Zo
         BFTF0cqP6ud1yRW6xjduWyyuBJmJr6oGFWJlFeXBy+pPRgjpuPv8tkYUrERwW2CnGP
         euHw4nU8+aD77zlC3lHWpbTlxjDfgnomIZkMCMdClSIOCmke8uFAWEtacOJbU16gtO
         hgkPczKVg19Aj5DiwpR+FVi+RwCO1LCw9KEjBDBFgPVz1APw5/wvoZ2IzT+qvgrQwb
         NkT98urJ+XI/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6727E68D20;
        Tue, 21 Feb 2023 01:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v13 0/8] net/sched: cls_api: Support hardware miss to
 tc action
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167694122274.14671.17012256659035609111.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 01:00:22 +0000
References: <20230217223620.28508-1-paulb@nvidia.com>
In-Reply-To: <20230217223620.28508-1-paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, saeedm@nvidia.com, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net,
        marcelo.leitner@gmail.com, ozsh@nvidia.com, jiri@nvidia.com,
        roid@nvidia.com, vladbu@nvidia.com, idosch@nvidia.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 18 Feb 2023 00:36:12 +0200 you wrote:
> Hi,
> 
> This series adds support for hardware miss to instruct tc to continue execution
> in a specific tc action instance on a filter's action list. The mlx5 driver patch
> (besides the refactors) shows its usage instead of using just chain restore.
> 
> Currently a filter's action list must be executed all together or
> not at all as driver are only able to tell tc to continue executing from a
> specific tc chain, and not a specific filter/action.
> 
> [...]

Here is the summary with links:
  - [net-next,v13,1/8] net/sched: Rename user cookie and act cookie
    https://git.kernel.org/netdev/net-next/c/db4b49025c0c
  - [net-next,v13,2/8] net/sched: cls_api: Support hardware miss to tc action
    https://git.kernel.org/netdev/net-next/c/80cd22c35c90
  - [net-next,v13,3/8] net/sched: flower: Move filter handle initialization earlier
    https://git.kernel.org/netdev/net-next/c/08a0063df3ae
  - [net-next,v13,4/8] net/sched: flower: Support hardware miss to tc action
    https://git.kernel.org/netdev/net-next/c/606c7c43d08c
  - [net-next,v13,5/8] net/mlx5: Kconfig: Make tc offload depend on tc skb extension
    https://git.kernel.org/netdev/net-next/c/03a283cdc8c8
  - [net-next,v13,6/8] net/mlx5: Refactor tc miss handling to a single function
    https://git.kernel.org/netdev/net-next/c/93a1ab2c545b
  - [net-next,v13,7/8] net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
    https://git.kernel.org/netdev/net-next/c/235ff07da7ec
  - [net-next,v13,8/8] net/mlx5e: TC, Set CT miss to the specific ct action instance
    https://git.kernel.org/netdev/net-next/c/6702782845a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


