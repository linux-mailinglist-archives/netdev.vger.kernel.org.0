Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85146E573C
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 04:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjDRCAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 22:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjDRCAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 22:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057D7D2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 19:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8375A62C13
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 02:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1F5CC4339B;
        Tue, 18 Apr 2023 02:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681783220;
        bh=dIPk5pwMu4HrHFDtOmk3fvRt/q6YYXMdj8PLUZG0BHY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CmXlVWJI7AO0MC3wFMelcEX2/B6wG6jhH8rlaazI060AD4kI/p0zdnCKJqFN/tK6Q
         q7syXkmaIYZP5EsRVu5t/+Z8t08NhBqezwyrp/g612YBEbz+0PvzNi19Ak1FIOM5Te
         siSxp9LxdrRJO6CPxv1q5M93cmlHmUUnmvTJemywA/vgRj4CkdOylK/3iLbeciU6gp
         efX8rupA6zR/gDjDMbscV5OpHaEfj9/aomuW+4E+mGVYqnSaS1Mrt6ye0VFjqgBpSg
         90x1zmLPW5CDf8aDfOirmUjOz1JzBHqMU4hJe1jUhxJxHSj4Lez9oJ7Qty9mSpOp9z
         I7B36kU8AxbTQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CCB9DC395C8;
        Tue, 18 Apr 2023 02:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 00/10] Support tunnel mode in mlx5 IPsec packet
 offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168178322083.31657.5452417493368986210.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Apr 2023 02:00:20 +0000
References: <cover.1681388425.git.leonro@nvidia.com>
In-Reply-To: <cover.1681388425.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, leonro@nvidia.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        saeedm@nvidia.com, raeds@nvidia.com, ehakim@nvidia.com,
        simon.horman@corigine.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 13 Apr 2023 15:29:18 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v1:
>  * Added Simon's ROB tags
>  * Changed some hard coded values to be defines
>  * Dropped custom MAC header struct in favor of struct ethhdr
>  * Fixed missing returned error
>  * Changed "void *" casting to "struct ethhdr *" casting
> v0: https://lore.kernel.org/all/cover.1681106636.git.leonro@nvidia.com
> 
> [...]

Here is the summary with links:
  - [net-next,v1,01/10] net/mlx5e: Add IPsec packet offload tunnel bits
    https://git.kernel.org/netdev/net-next/c/1210af3b9956
  - [net-next,v1,02/10] net/mlx5e: Check IPsec packet offload tunnel capabilities
    https://git.kernel.org/netdev/net-next/c/1c80e949292f
  - [net-next,v1,03/10] net/mlx5e: Configure IPsec SA tables to support tunnel mode
    https://git.kernel.org/netdev/net-next/c/006adbc6de9f
  - [net-next,v1,04/10] net/mlx5e: Prepare IPsec packet reformat code for tunnel mode
    https://git.kernel.org/netdev/net-next/c/6480a3b6c90a
  - [net-next,v1,05/10] net/mlx5e: Support IPsec RX packet offload in tunnel mode
    https://git.kernel.org/netdev/net-next/c/37a417ca911a
  - [net-next,v1,06/10] net/mlx5e: Support IPsec TX packet offload in tunnel mode
    https://git.kernel.org/netdev/net-next/c/efbd31c4d844
  - [net-next,v1,07/10] net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel mode
    https://git.kernel.org/netdev/net-next/c/4c24272b4e2b
  - [net-next,v1,08/10] net/mlx5: Allow blocking encap changes in eswitch
    https://git.kernel.org/netdev/net-next/c/acc109291a02
  - [net-next,v1,09/10] net/mlx5e: Create IPsec table with tunnel support only when encap is disabled
    https://git.kernel.org/netdev/net-next/c/146c196b60e4
  - [net-next,v1,10/10] net/mlx5e: Accept tunnel mode for IPsec packet offload
    https://git.kernel.org/netdev/net-next/c/c941da23aaf0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


