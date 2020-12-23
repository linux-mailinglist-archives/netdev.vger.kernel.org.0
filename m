Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75692E15A6
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731217AbgLWCuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731203AbgLWCur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F959225AB;
        Wed, 23 Dec 2020 02:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608691807;
        bh=8qn6oO4m18MYx8BZVHIur5nTRJHrKGVkSGxnlj5DQUY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=elD3VaoiwBpVozYCRaItCmshf+dgCOFoU114tkYu/7NBcju+CbBc11kLw3jIU31W2
         ue6xSHqImxW7L5npMacpPKvCyK4jKzhyIoFqiKQJWfc9vDX1QjPBbOwtNTuORnoT8D
         Q3GtJmRm+eHpIJnzYFhn0AxIxclEg9bjm80dGYQbh8PkmwbNpAWhVe4Vn3Jy5qAIl5
         pkmTlW5jz6OCtJy7/lDB3xBAt8ta/qCyJjIX+8v08YDmfVjDhp6iWt4SaM9PPi19nt
         AtbkVSrp5QJltF2p9l3Bvta6TYTJbW36Kgm3jCYPPDnh40OLo3q322aK1h8hQah/SV
         eougoqBzMXSGw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 31FBC604E9;
        Wed, 23 Dec 2020 02:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwmac-meson8b: ignore the second clock input
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160869180719.29227.9509776224388013090.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Dec 2020 02:50:07 +0000
References: <20201219135036.3216017-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20201219135036.3216017-1-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        davem@davemloft.net, kuba@kernel.org, khilman@baylibre.com,
        jbrunet@baylibre.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, thomas.graichen@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 19 Dec 2020 14:50:36 +0100 you wrote:
> The dwmac glue registers on Amlogic Meson8b and newer SoCs has two clock
> inputs:
> - Meson8b and Meson8m2: MPLL2 and MPLL2 (the same parent is wired to
>   both inputs)
> - GXBB, GXL, GXM, AXG, G12A, G12B, SM1: FCLK_DIV2 and MPLL2
> 
> All known vendor kernels and u-boots are using the first input only. We
> let the common clock framework automatically choose the "right" parent.
> For some boards this causes a problem though, specificially with G12A and
> newer SoCs. The clock input is used for generating the 125MHz RGMII TX
> clock. For the two input clocks this means on G12A:
> - FCLK_DIV2: 999999985Hz / 8 = 124999998.125Hz
> - MPLL2: 499999993Hz / 4 = 124999998.25Hz
> 
> [...]

Here is the summary with links:
  - net: stmmac: dwmac-meson8b: ignore the second clock input
    https://git.kernel.org/netdev/net/c/f87777a3c30c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


