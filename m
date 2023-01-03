Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBDD65BD03
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbjACJUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237112AbjACJUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:20:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D524CE0A1;
        Tue,  3 Jan 2023 01:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF58561229;
        Tue,  3 Jan 2023 09:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4072EC433F2;
        Tue,  3 Jan 2023 09:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672737617;
        bh=SerKHQrowj7eNz7nlu2mjO2Ycwmdq3DdXH04+EeFqn8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F+S+/7r9Lui00FUzNiprQbxDAze4fuJizOy25fw7IzgBBFKTo3bdhxBBUg8AilWlv
         055Y3NQxA/Z/+bhUTV56fs+Qiw1oCGDZD+T3UXMSBRoxAAvoRSzh3tfHX5zGbuYg20
         mS+4V0afCO2w9W+NCdFFjcZgEx6R/R9HleI/xIytYJKX2vxrTPwrHB9y8JN+TNX5HO
         HJif+gt75smrdWtH2k7EG0NBKrsvjOm+LA9AYw0gQrHISoFrR9W3wygT15uSx7X1Vw
         XbvyxS1DVqla9Z7JPjRmoBfryysQFX1k6u2KsU9f5GDx/ftItml9jrBnQ5W0DZQUik
         nJRRoRYPfBZbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C9E8C395DF;
        Tue,  3 Jan 2023 09:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [v2 PATCH net] octeontx2-pf: Fix lmtst ID used in aura free
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167273761711.18098.13255060434872425902.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Jan 2023 09:20:17 +0000
References: <20230103035012.15924-1-gakula@marvell.com>
In-Reply-To: <20230103035012.15924-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, sbhatta@marvell.com, hkelam@marvell.com,
        sgoutham@marvell.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 3 Jan 2023 09:20:12 +0530 you wrote:
> Current code uses per_cpu pointer to get the lmtst_id mapped to
> the core on which aura_free() is executed. Using per_cpu pointer
> without preemption disable causing mismatch between lmtst_id and
> core on which pointer gets freed. This patch fixes the issue by
> disabling preemption around aura_free.
> 
> Fixes: ef6c8da71eaf ("octeontx2-pf: cn10K: Reserve LMTST lines per core")
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> 
> [...]

Here is the summary with links:
  - [v2,net] octeontx2-pf: Fix lmtst ID used in aura free
    https://git.kernel.org/netdev/net/c/4af1b64f80fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


