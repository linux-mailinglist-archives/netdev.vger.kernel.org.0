Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1503813B4
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbhENWVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233899AbhENWV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:21:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D5516145E;
        Fri, 14 May 2021 22:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621030814;
        bh=et/+s01ZLmVUPLGTxR/l1iI6VdyfGm9pv83vQp8CHgQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZyJlsxL4sDXiIj3RpBALT0xM5AZWgtQjlMF41JenVx08//A1+FWlTZP3Hs8Strcqu
         A/MlA0ZIYSPYzat1E7wRuyvTHWDREfGSqw65nYBwB9ubym+KCf4DAyGliOPLKQHikj
         3kQGePe6xVYY3kmZvEdMQ1nzr3HbUeZ/g6KeSChlqBx5J+vVQQeBmPW2kWBDsqFNg9
         zsm7O/V8qTvuyLRJ2BnXFbmvrpSVZSRTpqpyWk3XJa15kNYdSAAYLBEhYjzacwAT0E
         KMxIAY1vY3ONAJ1l7sbXdMtLwkE43fKKMYw2o5grl8QXvf9Ahf4moSGq0NR9DX/7Jc
         AyPrcDyzm1iJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 01A6F60A02;
        Fri, 14 May 2021 22:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] Add support for RK3308 gmac
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103081400.6483.16712842906186927250.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 22:20:14 +0000
References: <20210514113813.2093534-1-t.schramm@manjaro.org>
In-Reply-To: <20210514113813.2093534-1-t.schramm@manjaro.org>
To:     Tobias Schramm <t.schramm@manjaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, heiko@sntech.de,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, david.wu@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 14 May 2021 13:38:10 +0200 you wrote:
> The Rockchip RK3308 SoC features an internal gmac. Only the signals
> required for RMII are exposed so it is limited to 10/100 Mbit/s operation.
> This patchset adds support for it.
> I've tested the patchset on a Rock Pi S, works fine.
> 
> Cheers,
> Tobias
> 
> [...]

Here is the summary with links:
  - [1/3] dt-bindings: net: rockchip-dwmac: add rk3308 gmac compatible
    https://git.kernel.org/netdev/net-next/c/2cc8c910f515
  - [2/3] net: stmmac: dwmac-rk: add support for rk3308 gmac
    https://git.kernel.org/netdev/net-next/c/b4ac94565c14
  - [3/3] arm64: dts: rockchip: add gmac to rk3308 dts
    https://git.kernel.org/netdev/net-next/c/8d1a81f21a9e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


