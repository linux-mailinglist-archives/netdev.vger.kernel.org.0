Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADCD342727
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 21:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhCSUui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 16:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhCSUuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 16:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8078D6197D;
        Fri, 19 Mar 2021 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616187008;
        bh=HaHU326JkpnmnGbW4GI7gh2gmyPkzMzgQxkUizJNxzQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e95suqjNeEuUCTPYagSpCmG2ejbrSEJh1A5GPIrd8pI+hI979k9tLAYUSCPF27xAe
         gmFIYwlYMr8GywoMUtocbtbGxraduk7kOrG/YEnaOCV4sFDZO+1LeAUUGXR2AkHedt
         FWP99g9kbtHAaYNhaNCnxc8wq7oq43+Iral9av2HMINHJEwcq+BsDZSkM0KZjTllqW
         jqNpylMzJpRuSG29nZFiUSpxKj4DkDovPiH2+q8pQ7AYY1wXi/moHrcRs6IZK+ibIf
         9PAKQ/QQRjUreR2EF1+8eewcfrhUNgAGntQipF77aLFwi0AmfRgzq7HRO7ArDRFt61
         QDNXlungNHF1w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6FC8C609DB;
        Fri, 19 Mar 2021 20:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwmac-sun8i: Provide TX and RX fifo sizes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618700844.7421.17310950197436009326.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 20:50:08 +0000
References: <20210319134422.9351-1-clabbe@baylibre.com>
In-Reply-To: <20210319134422.9351-1-clabbe@baylibre.com>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     alexandre.torgue@st.com, davem@davemloft.net,
        jernej.skrabec@siol.net, joabreu@synopsys.com,
        marek.belisko@gmail.com, mripard@kernel.org,
        peppe.cavallaro@st.com, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 19 Mar 2021 13:44:22 +0000 you wrote:
> MTU cannot be changed on dwmac-sun8i. (ip link set eth0 mtu xxx returning EINVAL)
> This is due to tx_fifo_size being 0, since this value is used to compute valid
> MTU range.
> Like dwmac-sunxi (with commit 806fd188ce2a ("net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes"))
> dwmac-sun8i need to have tx and rx fifo sizes set.
> I have used values from datasheets.
> After this patch, setting a non-default MTU (like 1000) value works and network is still useable.
> 
> [...]

Here is the summary with links:
  - net: stmmac: dwmac-sun8i: Provide TX and RX fifo sizes
    https://git.kernel.org/netdev/net/c/014dfa26ce1c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


