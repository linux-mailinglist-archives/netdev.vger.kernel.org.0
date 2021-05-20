Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8EF38B9E6
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 01:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhETXBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 19:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231919AbhETXBc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 19:01:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 600EB613AE;
        Thu, 20 May 2021 23:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621551610;
        bh=d3OAH1SWRvHEo0ZPbCi0Z6vsFyuPVS9WwpZ0HO2l2T8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KjzhLn0pulgUajUesBp7AGBpChrD+gXv7ir7cJ7lCThbc3RhstNY9+tmyxTp40Lv5
         5sVjFxN6CwEfke5AjFZx78T0feXLJ4YfPId9Noy8VhGTiISqsvJTIE0+1iuPQYd3X5
         Huao7b1YonR1DGYFzkc2mBWpXhm8Mnv43odEmiz0yJzMM9tWeLnOhY78Tz/Fi68Urv
         wXxLkpqwhQfDwIEfHdnYeL0doKK5JRZTjoY17OT0Ro7OfYvLiQYN6lCRl+WGZeDJ7L
         lBbm2mvz4Nmsf222fsGNcq7lY+AyNZPOf0yLUT7Lq1KXLUKW/kpjsBr2zKeK2QoVdj
         SfElfdUVsKwHQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 532F1609F6;
        Thu, 20 May 2021 23:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: fixes for stmmac
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162155161033.31527.4405992814200131855.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 23:00:10 +0000
References: <20210520125117.1015-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210520125117.1015-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 20 May 2021 20:51:15 +0800 you wrote:
> Two clock fixes for stmmac driver.
> 
> Joakim Zhang (2):
>   net: stmmac: correct clocks enabled in stmmac_vlan_rx_kill_vid()
>   net: stmmac: fix system hang if change mac address after interface
>     ifdown
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: stmmac: correct clocks enabled in stmmac_vlan_rx_kill_vid()
    https://git.kernel.org/netdev/net/c/b3dcb3127786
  - [net,2/2] net: stmmac: fix system hang if change mac address after interface ifdown
    https://git.kernel.org/netdev/net/c/4691ffb18ac9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


