Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153832F6A53
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbhANTAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbhANTAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 14:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3723823B5D;
        Thu, 14 Jan 2021 19:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610650811;
        bh=y69RDY4qFL4lNhjCfuLqeCPaQq7e0ZLoe0puEl47Rr4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WS77BE7qLCVCkCEzifgsfok87GoUgQY23lk4os1ZiLXdtHRC9HwuMRPvoQkVIY0kd
         9hxX3SFvrA5+DRw49evUBYitYpH4wLDJu6Hw2D1o15bLhdgyiy8znotuDwzFX3biAQ
         xOI/nhoxPRossA2+Ym3ifxeuq+YmUImYVzWk7WpKvG172XIN0jGbqgPhHB8x/8g0BP
         swm1BTjOa4pqCDeaMMD+kIqA5jf6e/GhqvBfM2trNsUEXkeGfaygylCVjcEgUd/f4C
         nkYK6Cl+xSVDtuoLlxV8mQMCzZXlhjbmfnE4RYKYUEH2rM2t7jnBWyLNKoM7ba+B5p
         /zCFBs0Tmwn3A==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 29A0C60649;
        Thu, 14 Jan 2021 19:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/2] net: stmmac: fix taprio schedule configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161065081116.20848.13616158602957995234.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 19:00:11 +0000
References: <20210113131557.24651-1-yannick.vignon@oss.nxp.com>
In-Reply-To: <20210113131557.24651-1-yannick.vignon@oss.nxp.com>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, yannick.vignon@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 13 Jan 2021 14:15:56 +0100 you wrote:
> From: Yannick Vignon <yannick.vignon@nxp.com>
> 
> When configuring a 802.1Qbv schedule through the tc taprio qdisc on an NXP
> i.MX8MPlus device, the effective cycle time differed from the requested one
> by N*96ns, with N number of entries in the Qbv Gate Control List. This is
> because the driver was adding a 96ns margin to each interval of the GCL,
> apparently to account for the IPG. The problem was observed on NXP
> i.MX8MPlus devices but likely affected all devices relying on the same
> configuration callback (dwmac 4.00, 4.10, 5.10 variants).
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: stmmac: fix taprio schedule configuration
    https://git.kernel.org/netdev/net/c/b76889ff51bf
  - [net,v2,2/2] net: stmmac: fix taprio configuration when base_time is in the past
    https://git.kernel.org/netdev/net/c/fe28c53ed71d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


