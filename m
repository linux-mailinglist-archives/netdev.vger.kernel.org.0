Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F9F34B268
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhCZXAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230139AbhCZXAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 19:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BED2D61A48;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616799612;
        bh=ot+7owfL+GI3GOc/wfSCv75+AhS2i6dAC6xmX2c3JAQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BCJNlmnHUkQp1ORnCWFGVSkIetH3kibCJHaIEeuXNqD6X/wuZuLeyJSNg/F3FtiF+
         oPU59hVsjCACVEEqKgRjFoBCL2LARfxHFy3cT6dkVJdpzvnL2v4ekeRtzZhhHctrFJ
         BFH85oXG6OF48zk6I/OOjtv22qcghVyr7kpZpxaAG7x2tBmVvpLYwgEnBwtX2tOJgh
         PLbefh8B6Z5uCG2nrQO/sWLPIX+dcVEYEopv7Gt5B8Fm/F3OwxLsoM0QI+6GrI1Xvv
         AMCjoCSS+/x6qlG22QLWtIJgUAXizJpBPKkVzfJqvNUk6LjesRnOemMVzcOjauDHqJ
         C5+5uZ2PumlwA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A5D066096E;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: Fix kernel panic due to NULL pointer
 dereference of fpe_cfg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679961267.14639.4413249532749146951.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 23:00:12 +0000
References: <20210326091046.26391-1-mohammad.athari.ismail@intel.com>
In-Reply-To: <20210326091046.26391-1-mohammad.athari.ismail@intel.com>
To:     Ismail@ci.codeaurora.org,
        Mohammad Athari <mohammad.athari.ismail@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        m.szyprowski@samsung.com, boon.leong.ong@intel.com,
        weifeng.voon@intel.com, vee.khee.wong@intel.com,
        tee.min.tan@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 26 Mar 2021 17:10:46 +0800 you wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> In this patch, "net: stmmac: support FPE link partner hand-shaking
> procedure", priv->plat->fpe_cfg wouldn`t be "devm_kzalloc"ed if
> dma_cap->frpsel is 0 (Flexible Rx Parser is not supported in SoC) in
> tc_init(). So, fpe_cfg will be remain as NULL and accessing it will cause
> kernel panic.
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: Fix kernel panic due to NULL pointer dereference of fpe_cfg
    https://git.kernel.org/netdev/net-next/c/63c173ff7aa3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


