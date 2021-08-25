Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24403F72B6
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239743AbhHYKKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238783AbhHYKKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:10:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5BE0761176;
        Wed, 25 Aug 2021 10:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629886206;
        bh=OSv0PWWhZVtTGTqPHk5I4aEOsasp+kDfKfr1GgHP/Jg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hVsPT+kAgICx6tBRqyIhV1hRk3fq1W7DSNR3HAPr5WuXl5eeKpe6pOHyp3VqvwQ+N
         V2NcJFe7BRrX4E2rZW9V7IpHi87l3AwuzTSlIwr0GtiWQuR0C+NW1NStmGbAC8WtGk
         17WSzEYastYu2FK5g/4nxI7RphiZGXc1o5vvfqJK+Bn2S3bJUueux+HYt5Q7JjN2ny
         RAYPQYojThwaAWg6UuqqDpeDrHkkQ6uEc9jfxKUOtPC8rigejMj6CLuNajaMPQQI3p
         h43ADJxrIs7x0vOkLUl4N6z7/Rf3WdnHcaDH0/VbhNEALssh4Ly4nIJw1td90EyvnF
         ZmbQ7VbqWHZIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4C1EF6097B;
        Wed, 25 Aug 2021 10:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/1] net: stmmac: fix kernel panic due to NULL pointer
 dereference of buf->xdp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988620630.3256.11386363919352017742.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:10:06 +0000
References: <20210825005742.980267-1-yoong.siang.song@intel.com>
In-Reply-To: <20210825005742.980267-1-yoong.siang.song@intel.com>
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        boon.leong.ong@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 25 Aug 2021 08:57:42 +0800 you wrote:
> Ensure a valid XSK buffer before proceed to free the xdp buffer.
> 
> The following kernel panic is observed without this patch:
> 
> RIP: 0010:xp_free+0x5/0x40
> Call Trace:
> stmmac_napi_poll_rxtx+0x332/0xb30 [stmmac]
> ? stmmac_tx_timer+0x3c/0xb0 [stmmac]
> net_rx_action+0x13d/0x3d0
> __do_softirq+0xfc/0x2fb
> ? smpboot_register_percpu_thread+0xe0/0xe0
> run_ksoftirqd+0x32/0x70
> smpboot_thread_fn+0x1d8/0x2c0
> kthread+0x169/0x1a0
> ? kthread_park+0x90/0x90
> ret_from_fork+0x1f/0x30
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] net: stmmac: fix kernel panic due to NULL pointer dereference of buf->xdp
    https://git.kernel.org/netdev/net/c/2b9fff64f032

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


