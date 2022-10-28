Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA685610933
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 06:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiJ1EKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 00:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJ1EK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 00:10:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427021C937;
        Thu, 27 Oct 2022 21:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7008EB82868;
        Fri, 28 Oct 2022 04:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 049E3C43470;
        Fri, 28 Oct 2022 04:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666930220;
        bh=ABnJRCnsmqjUk+OIZss6e713oQPwQLlsbLHJskM+WOs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ghFWmyThLByvmCpP+/g/1Iq4Kc+AOyqngXEQLtRifQ5atQvC+mFY2ttVO6BN1kUU+
         krDXYMSjGAk+qIgKQ+hiL33CHQ/Ni81CCtgSwBfJyJh4hEYPaVKkNs/15BI/QsVt63
         gOjBL1yWBt6hL6+clERvpuwKYgaJqT89nRcTV3yU1ZcKJNxAmNr77C/xI3evoJRG/S
         0viQnArSWJngzAcTRTl/wEX+SDb6GCG5S9t6KQqi9f+FYWCZgukil0imA6SlM6jFTY
         P4U/bd+KSxedAideT9Bfp7ZH/4M57EAD+G6fR9lvYlNp9aFAT9V5RhuXCmEkUXMl5u
         dFle3mXkSlpgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBF20E270DB;
        Fri, 28 Oct 2022 04:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dpaa2-eth: Simplify bool conversion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166693021989.17555.16663776649073557990.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Oct 2022 04:10:19 +0000
References: <20221026051824.38730-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20221026051824.38730-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 26 Oct 2022 13:18:24 +0800 you wrote:
> ./drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c:453:42-47: WARNING: conversion to bool not needed here
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2577
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: dpaa2-eth: Simplify bool conversion
    https://git.kernel.org/netdev/net-next/c/148b811c7797

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


