Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B19B6E7270
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 06:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjDSEu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 00:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjDSEuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 00:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F04A61A1;
        Tue, 18 Apr 2023 21:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D94EC63B06;
        Wed, 19 Apr 2023 04:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3295EC4339E;
        Wed, 19 Apr 2023 04:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681879818;
        bh=69Tud3bSSGNHl0lC6ZBQofnTfR5CiybZ4tvETIL9Nz0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gQxfCyBAGlwYOBB1+JBZD/k+7HcjZpACEwUTdlEfpU7Ncv+8U+f0G/bWBbsoCeGsm
         wsl8IepB0W+cyAJDrf+m00vVKKyPRXykgpLw7+2LQAhnR9nGIDAHNFcHFvsv/pqbjP
         spaanqSwVGRkLFoFg6Vf0h1agKMXqlE2WLgyAusfhh6zBKsTVKIvIsh++oIgI/t3s/
         o8QIhKmMyzxWCYE4HxiVHRTCu8mgkcA7tAX4LE+2nAWPEjv1CtgvagL9bVf88WKo4e
         HJCYPUVp95UCqohZmahFGuGyaeW94HOaVEWkuaKFTAFYc7e4R1uGHjXeGyx60r7RVb
         FIKt6MdXufpZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 106CDE50D63;
        Wed, 19 Apr 2023 04:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: stmmac: dwmac-sti: remove
 stih415/stih416/stid127
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168187981806.31004.15139314026801382632.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 04:50:18 +0000
References: <20230416195523.61075-1-avolmat@me.com>
In-Reply-To: <20230416195523.61075-1-avolmat@me.com>
To:     Alain Volmat <avolmat@me.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        patrice.chotard@foss.st.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 16 Apr 2023 21:55:23 +0200 you wrote:
> Remove no more supported platforms (stih415/stih416 and stid127)
> 
> Signed-off-by: Alain Volmat <avolmat@me.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Patch sent previously as part of serie: https://lore.kernel.org/all/20230209091659.1409-8-avolmat@me.com/
> 
> [...]

Here is the summary with links:
  - net: ethernet: stmmac: dwmac-sti: remove stih415/stih416/stid127
    https://git.kernel.org/netdev/net-next/c/14cac662235e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


