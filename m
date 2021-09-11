Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E62C4075CC
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 11:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbhIKJb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 05:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235407AbhIKJbY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 05:31:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 196DF61216;
        Sat, 11 Sep 2021 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631352606;
        bh=qdaWEUd1KSrLpISbbqbmAzB80NVLQS21cH6iG8/ZBZw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qOSkB35zTtfCVAWtwAb3pw6H2aNP5lAUirDjwRVqDTrazC9HEv4Ju62gbnExW1BC/
         YjRCV8lsADelggta77QGJoX7YEyUyxF+rulizSM5UDtD/7nGNc2Oq+zVDGILg55CVg
         AbyM64GBagjFr4WDwLcbrk9QSfnjyXq7o2Bb28IxAjKhbdQKg+10Qa8CYMesFey5Rl
         hV4ahWodfytLxb+KCYaw9n+jRUZfqFfQf0AZT2gfwsaG04lMHzPDiqSct41wEUVPMR
         BXmL9045/w/JPgMcSKMqzmyFYk9IUX7mOeC7Vy6C0ThWHg+Lvk+exrQDd3bXbeq1sQ
         ArfZTUHZQgt9A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0DA7C609ED;
        Sat, 11 Sep 2021 09:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: allow CSR clock of 300MHz
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163135260605.6855.16868234164937660969.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Sep 2021 09:30:06 +0000
References: <20210910195535.12533-1-jesper.nilsson@axis.com>
In-Reply-To: <20210910195535.12533-1-jesper.nilsson@axis.com>
To:     Jesper Nilsson <jesper.nilsson@axis.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, kernel@axis.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 10 Sep 2021 21:55:34 +0200 you wrote:
> The Synopsys Ethernet IP uses the CSR clock as a base clock for MDC.
> The divisor used is set in the MAC_MDIO_Address register field CR
> (Clock Rate)
> 
> The divisor is there to change the CSR clock into a clock that falls
> below the IEEE 802.3 specified max frequency of 2.5MHz.
> 
> [...]

Here is the summary with links:
  - net: stmmac: allow CSR clock of 300MHz
    https://git.kernel.org/netdev/net/c/08dad2f4d541

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


