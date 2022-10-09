Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B857F5F8DA5
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 21:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiJITKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 15:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiJITKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 15:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24CB13F59
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 12:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1081D60C71
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 19:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61619C433D7;
        Sun,  9 Oct 2022 19:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665342615;
        bh=m2W0oIvqYUrhvMLiOttW3xzh2yP5cc6sLLAm+NitzfU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ptY60xawPKkqnO4IfMMWT+uHDQM/zW+fujGTh8fT4qd79WD8qKhQcQP0Z6r3jXqWj
         Srw2/meuHNHkxOjUiAlMVHYLr3IpwIcqPxKoH6y7lVJsNodgh48/xn/1ClOjcGEc38
         O2hGLcRZyYr9U2fyN5nbv8kTtrWANqAsSIXL1A4AMxIMQcH8h+xkt2Jd4LG7QfSWjK
         l+IahCbG1IdZl+AajF6YhA0+jGOQRcQXC+37X9sZPaQgMuDn6uWhv/YAZuh8SuRIFg
         jrgNDw6L7zp92zdRQ078WHJsbwoVKqELCvJMUpbWxFjQUqyspx78KfdfYNFlpqSOqS
         FJ0zjBsGNeiKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3FE34E2A05F;
        Sun,  9 Oct 2022 19:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2-pf: mcs: fix missing unlock in some error paths
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166534261525.10565.8365371181009883666.git-patchwork-notify@kernel.org>
Date:   Sun, 09 Oct 2022 19:10:15 +0000
References: <20221008082650.3074606-1-yangyingliang@huawei.com>
In-Reply-To: <20221008082650.3074606-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, sbhatta@marvell.com, sgoutham@marvell.com,
        davem@davemloft.net
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

On Sat, 8 Oct 2022 16:26:50 +0800 you wrote:
> Add the missing unlock in some error paths.
> 
> Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net] octeontx2-pf: mcs: fix missing unlock in some error paths
    https://git.kernel.org/netdev/net/c/897fab7a726a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


