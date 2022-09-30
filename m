Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1745F0B5E
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 14:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiI3MKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 08:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiI3MKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 08:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA378E4D7;
        Fri, 30 Sep 2022 05:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BAC662314;
        Fri, 30 Sep 2022 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDC20C433D6;
        Fri, 30 Sep 2022 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664539817;
        bh=t4MV0cXsgxNGKQwmObRrW7em92ARScSQC2qWmTjzovQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KeV6Gh4OSEr2mXoiXetMBdO5j0Hz8yukyPXjPfV8XJg9AE5LKiLalPvL7xd9XenRI
         qryxYNibohsCt3qgfOiAj2sWB6E/ivBaVByPqauGxi9nf4OVVwSPJgtPV/GIzOnRvP
         WLcTtuUy3unm1OZ6n+4qCSRtR5jA6jp1xatVrFMzdisTzxAxEeFsl9HWibblSPajip
         B/6gZd0JyVhWKWDaFJ71tIFJDJCjhOqLXK8HOKhZ17sc+9Rkfivjp+Rli16vKt255v
         kXqBlIkV9p8KR3eia8oxJl5hK2w127wfYDcmMO/BynApvdLimR2MkprapG2UpgEnv1
         Rk21Q4I68zczw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AB2E5E49FA5;
        Fri, 30 Sep 2022 12:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mlx5: Fix spelling mistake "syndrom" -> "syndrome"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166453981769.22292.1617251533762607587.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 12:10:17 +0000
References: <20220928220755.67137-1-colin.i.king@gmail.com>
In-Reply-To: <20220928220755.67137-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 28 Sep 2022 23:07:55 +0100 you wrote:
> There is a spelling mistake in a devlink_health_report message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net/mlx5: Fix spelling mistake "syndrom" -> "syndrome"
    https://git.kernel.org/netdev/net-next/c/fd01b9b5b02b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


