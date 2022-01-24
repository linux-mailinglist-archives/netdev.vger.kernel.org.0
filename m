Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A34498147
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 14:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243176AbiAXNkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 08:40:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48068 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiAXNkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 08:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ED3AB80FD4;
        Mon, 24 Jan 2022 13:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5D84C340E7;
        Mon, 24 Jan 2022 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643031610;
        bh=dee1fRxc4gg7X1d98rKG3dz7x+qLTHmpqKgRlioZx3g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h2mEx8o+BEPlMCVUTHG+pnmkatkvu5I+4wjyqIwzzLMIdHYasEa4uyufNVWptzNDD
         iBt0VYcXbAPNNBo7s/1Yj1E08FcJGPm5t/yJR7npXIK8wgp0oMhtcuWWGCEMqh379E
         KQj3P6bQSXqWhL1FVX+zfcWt3BRtKD9IndAM3OJpiQHsHjZ0tRmzh+OLbWealk6Un1
         8nrECR1AZz9WmfKUUxneB1SK0L/vkIBO1GKdz2py63QFWZ4pf0qgekhbTwivs00Q5i
         alBKEpWSbraqdtm7TXiP34EwbEFMJLJKFfO+zgFYF8ZsImT+mKlcPX/sla5AvOfkNI
         Cpyhxc724sl3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ACF72F60790;
        Mon, 24 Jan 2022 13:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: remove unused members in struct stmmac_priv
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164303161069.21877.8559780902897550675.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Jan 2022 13:40:10 +0000
References: <20220123122758.2876-1-jszhang@kernel.org>
In-Reply-To: <20220123122758.2876-1-jszhang@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 23 Jan 2022 20:27:58 +0800 you wrote:
> The tx_coalesce and mii_irq are not used at all now, so remove them.
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - net: stmmac: remove unused members in struct stmmac_priv
    https://git.kernel.org/netdev/net/c/de8a820df2ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


