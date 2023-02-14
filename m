Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B152696099
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjBNKU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjBNKUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:20:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD13061B4
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 072F6CE201E
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 10:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23813C4339B;
        Tue, 14 Feb 2023 10:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676370019;
        bh=3ABx1L0khoiIVuwHqzVDMncl+G2mONEBKJifoy+G/Xc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Uey2NREHgdMGTH83A73jHse8LpHmLDNkjeGMXvw6BL85ysglhvscri2uvpddTDKC2
         WTkCyMRUx+r/tWqzsVJUhMbx7PEnONLoLAj88HjCCyn+d9uTVtRQG1/4PWLF3IbnVG
         wh5g3VI1DXSulxx8m3/6rLSeUOwnVPjK7bA/Y8UKXt3BFdGrC7xEsEtviUJERIGaEd
         6yNa9MRU62sT3tkGm7XgqCpK8PbSwujgJDY12TDy7mwx6RCzp3nepINLcj9gz/LpMv
         hv/VLE/UDBITFhH/5h22KeCgfq6qrKW0/5ff2FAT2YPEuc7JWnZKpeeKdNxfi2zvGs
         5oBKdYo/LnSow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02F70E68D35;
        Tue, 14 Feb 2023 10:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH  net-next v4 0/9] add support for per action hw stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167637001900.27531.17888495360173690530.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 10:20:19 +0000
References: <20230212132520.12571-1-ozsh@nvidia.com>
In-Reply-To: <20230212132520.12571-1-ozsh@nvidia.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, saeedm@nvidia.com, roid@nvidia.com,
        jiri@nvidia.com, mleitner@redhat.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, jhs@mojatatu.com,
        ecree.xilinx@gmail.com, kuba@kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 12 Feb 2023 15:25:11 +0200 you wrote:
> There are currently two mechanisms for populating hardware stats:
> 1. Using flow_offload api to query the flow's statistics.
>    The api assumes that the same stats values apply to all
>    the flow's actions.
>    This assumption breaks when action drops or jumps over following
>    actions.
> 2. Using hw_action api to query specific action stats via a driver
>    callback method. This api assures the correct action stats for
>    the offloaded action, however, it does not apply to the rest of the
>    actions in the flow's actions array, as elaborated below.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/9] net/sched: optimize action stats api calls
    https://git.kernel.org/netdev/net-next/c/8f2ca70c07f4
  - [net-next,v4,2/9] net/sched: act_pedit, setup offload action for action stats query
    https://git.kernel.org/netdev/net-next/c/3320f36fd8ad
  - [net-next,v4,3/9] net/sched: pass flow_stats instead of multiple stats args
    https://git.kernel.org/netdev/net-next/c/ac7d27907d54
  - [net-next,v4,4/9] net/sched: introduce flow_offload action cookie
    https://git.kernel.org/netdev/net-next/c/d307b2c6f962
  - [net-next,v4,5/9] net/sched: support per action hw stats
    https://git.kernel.org/netdev/net-next/c/5246c896b805
  - [net-next,v4,6/9] net/mlx5e: TC, add hw counter to branching actions
    https://git.kernel.org/netdev/net-next/c/e9d1061d8727
  - [net-next,v4,7/9] net/mlx5e: TC, store tc action cookies per attr
    https://git.kernel.org/netdev/net-next/c/cca7eac13856
  - [net-next,v4,8/9] net/mlx5e: TC, map tc action cookie to a hw counter
    https://git.kernel.org/netdev/net-next/c/d13674b1d14c
  - [net-next,v4,9/9] net/mlx5e: TC, support per action stats
    https://git.kernel.org/netdev/net-next/c/2b68d659a704

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


