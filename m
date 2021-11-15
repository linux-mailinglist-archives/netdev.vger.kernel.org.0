Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D324506FD
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbhKOOeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:34:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232572AbhKOOdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:33:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C1D7B63225;
        Mon, 15 Nov 2021 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636986609;
        bh=vOLjlC7kLsvfUnaTGWlugnrD0CgOJl28Dql8PSJPsdQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EfBZvD1TGZo7PakdI9vLa9Y7ZZVqVlwPRpBynAQvCQi5anvw7ITHmol6oZ6lqRpg4
         0mZJdizW/v4Jv2q+4C6PksS8qYsQVVoslvOocRVuyeddjirUcO2YdIWBWsz8E8k6Ut
         BsMBm3WlKZ90XcQRDb8IfM9dWPPjMxUNNCKRUJq0tIWECNQ4QfUBFl9MJLEG9gOZE5
         aBEBLr/vAWkY7AyKro2oEJld6XKB1NbSou3oq2fLcMxCWM/RkgtTAV9r3yvRX6SKJK
         mI8QwB6P7DKNXNre5nbnQA0c0MJMOYN/qANpUjN53Wd8G3RHZ2B6wj/CahzQ2C7G0O
         /9ua4cPfZszgw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B10EC60AA1;
        Mon, 15 Nov 2021 14:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: stmmac: socfpga: add runtime suspend/resume callback
 for stratix10 platform
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698660972.25242.8236818279167028149.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:30:09 +0000
References: <20211115070423.6845-1-Meng.Li@windriver.com>
In-Reply-To: <20211115070423.6845-1-Meng.Li@windriver.com>
To:     Meng Li <Meng.Li@windriver.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        meng.li@windriver.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Nov 2021 15:04:23 +0800 you wrote:
> From: Meng Li <meng.li@windriver.com>
> 
> According to upstream commit 5ec55823438e("net: stmmac:
> add clocks management for gmac driver"), it improve clocks
> management for stmmac driver. So, it is necessary to implement
> the runtime callback in dwmac-socfpga driver because it doesn't
> use the common stmmac_pltfr_pm_ops instance. Otherwise, clocks
> are not disabled when system enters suspend status.
> 
> [...]

Here is the summary with links:
  - [v3] net: stmmac: socfpga: add runtime suspend/resume callback for stratix10 platform
    https://git.kernel.org/netdev/net/c/911957003948

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


