Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47170633CDF
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiKVMuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiKVMuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:50:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706CB606AC;
        Tue, 22 Nov 2022 04:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B0DF616E8;
        Tue, 22 Nov 2022 12:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CFEDC433C1;
        Tue, 22 Nov 2022 12:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669121415;
        bh=P0BJNBt3oLjVxgkRlwdr3Yf+9ZQwWQ3RBCz2667DvJk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sA/GBa2kV6T7EackXVMibrEY3nCGDThl790RJPXqD0zRCVngJb0HUk1GkO4vJ1bq4
         Hes9E8myqFT5zOXpatb2am7hP6XmcEL8oP4WU1nmeTeuKCKyKZPiWVECEYpalf52ZX
         2L1pqxNMXkUds4OLuZuxlykPOWD1Zh9pYaxDLZL/bf9y73V+OiaYyuricQGmDRavjx
         bfu6Iic10LQGGmn/6rVAL5dHJTkRd6+aXM3/BzsFPP7CbK9uYZRuRBOp2hQDswsLMO
         gd1UqdLGy/C9d3g9+1y17aa6zuYSmwGsheO5C5E4PBNeN837Jd03aOVfjz8eG+zn0a
         mHmb+wqJg8JQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43167E270E3;
        Tue, 22 Nov 2022 12:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-pf: Remove duplicate MACSEC setting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166912141527.31853.8038166730589981221.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 12:50:15 +0000
References: <20221119133616.3583538-1-zhengbin13@huawei.com>
In-Reply-To: <20221119133616.3583538-1-zhengbin13@huawei.com>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhangqilong3@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 19 Nov 2022 21:36:16 +0800 you wrote:
> Commit 4581dd480c9e ("net: octeontx2-pf: mcs: consider MACSEC setting")
> has already added "depends on MACSEC || !MACSEC", so remove it.
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> [...]

Here is the summary with links:
  - octeontx2-pf: Remove duplicate MACSEC setting
    https://git.kernel.org/netdev/net/c/bb3cfbaf7c64

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


