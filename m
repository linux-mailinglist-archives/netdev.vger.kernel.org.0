Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B097D6244AE
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbiKJOuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiKJOuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F60AFAD7
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01B24B82219
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E608C433B5;
        Thu, 10 Nov 2022 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668091816;
        bh=MOxXPrHZJTHTZkmqnaHZEYkU9pILaMftR/4L6KG+vB8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gWlx1p7ZcGAsIJu7dnmchPKwBp+ADhWJXRQcbqCtCIL+t2dYbh2sPmGhROJtKm46Y
         /aIptaggrEDh8d8J0bEe9P8wnQIA12jEH5+qsxjI4VmHJka1ZniCDAlEVhgOLmrdgo
         Fx9L/cH3N4r+P+T5onh/LR/HGxoDrxK34hDBmWiVlWVSbHGm0JSZbrBM8X6YuOVDre
         rQVAK9TV2SBCG8kDMhMN1aDWUAs+pJRB+Cvdxh34RyQC/KSAeBWlbUidp7VEuto2eg
         88Z2yqPCewkQPAm2c7lkcqHwxkrtqhW9+La452ujYkRTYt3GFGKFd3sf2MHxaoBL/f
         PuIgqOArl5R5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CC81E270C5;
        Thu, 10 Nov 2022 14:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethernet: tundra: free irq when alloc ring failed in
 tsi108_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166809181644.19446.17796054379922297887.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 14:50:16 +0000
References: <20221109044016.126866-1-shaozhengchao@huawei.com>
In-Reply-To: <20221109044016.126866-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, u.kleine-koenig@pengutronix.de,
        mkl@pengutronix.de, tie-fei.zang@freescale.com, akpm@osdl.org,
        Alexandre.Bounine@tundra.com, jeff@garzik.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Wed, 9 Nov 2022 12:40:16 +0800 you wrote:
> When alloc tx/rx ring failed in tsi108_open(), it doesn't free irq. Fix
> it.
> 
> Fixes: 5e123b844a1c ("[PATCH] Add tsi108/9 On Chip Ethernet device driver support")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v2: move free_irq to error handling path and modify fixes tag
> 
> [...]

Here is the summary with links:
  - [net] ethernet: tundra: free irq when alloc ring failed in tsi108_open()
    https://git.kernel.org/netdev/net/c/acce40037041

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


