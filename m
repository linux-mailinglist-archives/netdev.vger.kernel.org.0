Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6931A5809A3
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 04:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237338AbiGZCuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 22:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236897AbiGZCuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 22:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A66C5FA5;
        Mon, 25 Jul 2022 19:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95658614E1;
        Tue, 26 Jul 2022 02:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03B01C341C8;
        Tue, 26 Jul 2022 02:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658803815;
        bh=Vy54MVlfrb3/EozZgqR+L9CfuXU2/kOebhXV8UQNnlc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g7skRmagOWuLGAKzonuZNrHXq+El+IMdGkDuekdSva3904YejfZa2Ud+3nZIxHsaU
         NpzpBoYxr3HcnIWLBpYd55WTyWbiesbe/2HSZXG4y2L9FKrf0x2iqVRYwviyIAC57h
         eFdNu5MlvGudRvRh3UuU1pad8/RTdReTdJiHxjGqHHZxFPYdKhh3pgRtODfxpr2/Od
         r1dBXH9Nm23GoXOnB7UP7ncJ2Qcufzq7czg6t683B0lSN1DDUdREjwWqXi+NumMMTB
         8X5RwI4+UhLWw0JwL76dWpjeeuAhXHUG/6ZhoCnYnjrFHV1YHTbolgY34Q/xB+nyP7
         Hq2iS51G4e1tw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E3C6AE450B7;
        Tue, 26 Jul 2022 02:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v5 0/5] *Add MTU change with stmmac interface running
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165880381492.11874.3864813905774312951.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jul 2022 02:50:14 +0000
References: <20220723142933.16030-1-ansuelsmth@gmail.com>
In-Reply-To: <20220723142933.16030-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 23 Jul 2022 16:29:28 +0200 you wrote:
> This series is to permit MTU change while the interface is running.
> Major rework are needed to permit to allocate a new dma conf based on
> the new MTU before applying it. This is to make sure there is enough
> space to allocate all the DMA queue before releasing the stmmac driver.
> 
> This was tested with a simple way to stress the network while the
> interface is running.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/5] net: ethernet: stmicro: stmmac: move queue reset to dedicated functions
    https://git.kernel.org/netdev/net-next/c/f9ec5723c3db
  - [net-next,v5,2/5] net: ethernet: stmicro: stmmac: first disable all queues and disconnect in release
    https://git.kernel.org/netdev/net-next/c/7028471edb64
  - [net-next,v5,3/5] net: ethernet: stmicro: stmmac: move dma conf to dedicated struct
    https://git.kernel.org/netdev/net-next/c/8531c80800c1
  - [net-next,v5,4/5] net: ethernet: stmicro: stmmac: generate stmmac dma conf before open
    https://git.kernel.org/netdev/net-next/c/ba39b344e924
  - [net-next,v5,5/5] net: ethernet: stmicro: stmmac: permit MTU change with interface up
    https://git.kernel.org/netdev/net-next/c/347007968744

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


