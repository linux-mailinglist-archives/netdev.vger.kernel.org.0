Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0BA4614EE
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346598AbhK2MZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 07:25:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60800 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244399AbhK2MX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 07:23:27 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF94B6131D;
        Mon, 29 Nov 2021 12:20:09 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F36A6056B;
        Mon, 29 Nov 2021 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638188409;
        bh=cL6EgVVC1DsCIYVnx1E2JDuO7ZUOxCNXbc27Nc9cyR8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OdoUKmFF/gpmMdkh7IzP8OmIrZjUB9HGHQFDJ1AFTP0V/xMawrEUZU81BFRcZutc3
         ma632BllgFwqU8yN31x7WhPxwIhO/LTxbUrFx5IypNifyJb9Bkl3lwwrTeJrWXIaVX
         JRcEqollL/uEKeB0wHq8CPIyQtXsjdk32R6vmiruycosecH3fplT+Xp7mYjTgue9hE
         UEknfYueFyqVhgCPR7EXs5SY6+/JVy+Pfa+7u4CZYlc6vbYKRaTv5xEZnWvmEcw55U
         lt3w9BZ821q4v2V5x5onetWlYDux3sye2Ix4qqpd3AK0+jdfrH1kbNZza2y279qg7z
         /B4oXJ7GSE+pA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2F04C609D5;
        Mon, 29 Nov 2021 12:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: Avoid DMA_CHAN_CONTROL write if no Split
 Header support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163818840918.20614.10733400123125984165.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 12:20:09 +0000
References: <20211126155115.12394-1-vincent.whitchurch@axis.com>
In-Reply-To: <20211126155115.12394-1-vincent.whitchurch@axis.com>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, kernel@axis.com,
        Jose.Abreu@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 26 Nov 2021 16:51:15 +0100 you wrote:
> The driver assumes that split headers can be enabled/disabled without
> stopping/starting the device, so it writes DMA_CHAN_CONTROL from
> stmmac_set_features().  However, on my system (IP v5.10a without Split
> Header support), simply writing DMA_CHAN_CONTROL when DMA is running
> (for example, with the commands below) leads to a TX watchdog timeout.
> 
>  host$ socat TCP-LISTEN:1024,fork,reuseaddr - &
>  device$ ethtool -K eth0 tso off
>  device$ ethtool -K eth0 tso on
>  device$ dd if=/dev/zero bs=1M count=10 | socat - TCP4:host:1024
>  <tx watchdog timeout>
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: Avoid DMA_CHAN_CONTROL write if no Split Header support
    https://git.kernel.org/netdev/net/c/f8e7dfd6fdab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


