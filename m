Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EC03F724D
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239784AbhHYJuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239513AbhHYJuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 05:50:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E37A6610FD;
        Wed, 25 Aug 2021 09:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629885005;
        bh=G9W19wcM7scN5TQI5aCEGctxyPWqb76aI4QghIn1k44=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T2Rd6S2Y6qeStlduHD6EE0+u4FNeu23Pg6ejMu5pFTLW9GWCCHnAP63t1j9/7zO2f
         i79zpmRX57TPJWgjo+iLJmDsDGqPciyWNXnYh5wgw9gzqDkw9GRcnFcynfO934GMcU
         B69aFjXC7ORzbHcOrwl0p7JjISS/ROb6zZBBBrchirvRdILedFW9Q53UF7r0ajbxXA
         3XWPKCPKRz8p/0bMN0hJyXjLGGyU6mCAFKNcQFabqLy3VrWm2F1d6gii4FDSTbwZhE
         jl6XlQY0ovXdWomHJXYDke2e+fBUu0/IbQjkOH3jGK27PNIWVGXpmWueQ0P/XVWCgb
         lWB9Rr5HzNuUg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D0A6760A12;
        Wed, 25 Aug 2021 09:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable
 warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988500584.26256.659865970373423632.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 09:50:05 +0000
References: <20210823143754.14294-1-michael.riesch@wolfvision.net>
In-Reply-To: <20210823143754.14294-1-michael.riesch@wolfvision.net>
To:     Michael Riesch <michael.riesch@wolfvision.net>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 23 Aug 2021 16:37:54 +0200 you wrote:
> This reverts commit 2c896fb02e7f65299646f295a007bda043e0f382
> "net: stmmac: dwmac-rk: add pd_gmac support for rk3399" and fixes
> unbalanced pm_runtime_enable warnings.
> 
> In the commit to be reverted, support for power management was
> introduced to the Rockchip glue code. Later, power management support
> was introduced to the stmmac core code, resulting in multiple
> invocations of pm_runtime_{enable,disable,get_sync,put_sync}.
> 
> [...]

Here is the summary with links:
  - net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings
    https://git.kernel.org/netdev/net/c/2d26f6e39afb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


