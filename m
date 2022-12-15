Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D878764DBFC
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 14:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiLONKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 08:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLONKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 08:10:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1892BB2D
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 05:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 774A5B81BA9
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 13:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10996C433F2;
        Thu, 15 Dec 2022 13:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671109817;
        bh=ZX9vkL5qKOiJKCBuB10CRXHUblrj1ri5jUDkoUac8bU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uUAUWWEEV/p7VH8sjQ9kTb/K0REc/qzYHeDQCDdRT9h1uOGf8MdZISenB/sXdaTk3
         pR5mLfX5idQk5Xd0MApKsdRkjEP77qnXFqmAoY7a6jS3vst1pDLX9VVlrSJVzqjnb7
         3YafS/fHEkKtHs+/J1xszDTqaxUWGf4iWZjaVvCZfVz1KJzAzNsfaSyXmVDLYmeV7Q
         AqZSL7VkWrYR+fc1WCMVLdHnKdu3hMr+hmsr5REUyUGI6zm0L74xRnCRmvRe+XO9Ij
         hcFd0yr3GYfAbADyFzt45QRJrnuNf582MFxY5GbyR1w21L/9Mw0Tm4+jutlq1f40Ha
         4LGhfdMK67IbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB0AEC197B4;
        Thu, 15 Dec 2022 13:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net,v2] net: stmmac: fix errno when
 create_singlethread_workqueue() fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167110981695.21157.9894715143404186757.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Dec 2022 13:10:16 +0000
References: <20221214080117.3514615-1-cuigaosheng1@huawei.com>
In-Reply-To: <20221214080117.3514615-1-cuigaosheng1@huawei.com>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, boon.leong.ong@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
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

On Wed, 14 Dec 2022 16:01:17 +0800 you wrote:
> We should set the return value to -ENOMEM explicitly when
> create_singlethread_workqueue() fails in stmmac_dvr_probe(),
> otherwise we'll lose the error value.
> 
> Fixes: a137f3f27f92 ("net: stmmac: fix possible memory leak in stmmac_dvr_probe()")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: stmmac: fix errno when create_singlethread_workqueue() fails
    https://git.kernel.org/netdev/net/c/2cb815cfc78b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


