Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECFC5BABE2
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 13:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiIPLAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 07:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiIPK7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 06:59:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77BD9F744;
        Fri, 16 Sep 2022 03:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66A1062874;
        Fri, 16 Sep 2022 10:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0534C433B5;
        Fri, 16 Sep 2022 10:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663325414;
        bh=Ryu5zV7w1g4mi3MxMOO/XbTv/+hPCzyDG2kWgDLY9q0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MHbh1VFg1QKOB7+F23My4ppwa/j9PtbyZEj4D6NLcPmErRsm0pg3LXRHAkbVK3OK5
         LUVX74FshzDpWJKzWvzUcRwSw9Oa1KoKEwtL7wp2Y6N5SuE5mURJhp+PSdfSxSrkRC
         miX5dIy5Fk19Qbpr95mfEUStABLPpkskFgKSzfokvp3bt/DHCFwy1UZuO7die7beV6
         D3e8qiCMFsVKak7A6YGHXeEnIrb4aLWQSLz0G4UoQUvXI94RLpyk+U9/KwBAJSbMnF
         +czAZfZZ+ytZWNYMSXQetDflEDWJZ1XYSimHU1jpMlxQOtxZAEG/gAoIVdLbcaxHOn
         dh6Gu+O1QBjMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8C5E2C74000;
        Fri, 16 Sep 2022 10:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mellanox/mlxsw: fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166332541457.30138.16956052562774634433.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 10:50:14 +0000
References: <20220908124350.22861-1-wangjianli@cdjrlc.com>
In-Reply-To: <20220908124350.22861-1-wangjianli@cdjrlc.com>
To:     wangjianli <wangjianli@cdjrlc.com>
Cc:     idosch@nvidia.com, petrm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Thu,  8 Sep 2022 20:43:50 +0800 you wrote:
> Delete the redundant word 'in'.
> 
> Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - mellanox/mlxsw: fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/a292c25607ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


