Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84FB49FCB2
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245531AbiA1PUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:20:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50764 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243841AbiA1PUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:20:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 843CC60DE8;
        Fri, 28 Jan 2022 15:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6F92C340E6;
        Fri, 28 Jan 2022 15:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643383210;
        bh=ceVVnou4kfql6ZPDjslsQVwx9NKAS8aICoGNXGiUpKM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oiAKyW4pJmQnyfiJJk4AiypkW3W0Ty5Lv1AWoDKZ5ORs4ta4er27AKysOiNCRu6wG
         0e9UUdzI/RSnKNUcNyh2ZngcJjFi0jEOVcTcXuuAta9ablLmwsIT53k8QvwfVWmqc/
         Z7RECqEoPrA6yZfldofzRxv5v4I833ftoKLpnJ8lZ2/KPlPhEPp0gSm5NmdkEvfKQA
         3aDvaxr8i4SysxK7QTTDSsrNHizhO+9nQTYQwvacs8JaENbFFK7Cm7ha7/Dfcvith2
         Bx7eRZ64At5gIGC3vFw2FraCFkk6GOG9pD4JW6EJueg3vCjPoYSrqxMb0Z+wDf/Yi6
         jTffkOtF2R2bQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B55A2E5D087;
        Fri, 28 Jan 2022 15:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: properly handle with runtime pm in
 stmmac_dvr_remove()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338321073.8810.2377370074085228481.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 15:20:10 +0000
References: <20220128141550.2350-1-jszhang@kernel.org>
In-Reply-To: <20220128141550.2350-1-jszhang@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, qiangqing.zhang@nxp.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 22:15:50 +0800 you wrote:
> There are two issues with runtime pm handling in stmmac_dvr_remove():
> 
> 1. the mac is runtime suspended before stopping dma and rx/tx. We
> need to ensure the device is properly resumed back.
> 
> 2. the stmmaceth clk enable/disable isn't balanced in both exit and
> error handling code path. Take the exit code path for example, when we
> unbind the driver or rmmod the driver module, the mac is runtime
> suspended as said above, so the stmmaceth clk is disabled, but
> 	stmmac_dvr_remove()
> 	  stmmac_remove_config_dt()
> 	    clk_disable_unprepare()
> CCF will complain this time. The error handling code path suffers
> from the similar situtaion.
> 
> [...]

Here is the summary with links:
  - net: stmmac: properly handle with runtime pm in stmmac_dvr_remove()
    https://git.kernel.org/netdev/net/c/6449520391df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


