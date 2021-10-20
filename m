Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68977434CA4
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhJTNwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230123AbhJTNw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:52:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 12CF461391;
        Wed, 20 Oct 2021 13:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634737815;
        bh=mMLNzvi+ja5VPcITeQlmfCGzJuEkK2uuELoDkxTQttc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O1fPyeAm9kXd07AWEgrHNeoPTLYoWLYLD7qetVspc2k3t/cRCDLp3FvXR6rLk0SA2
         NnjquSrT+Wi19xqAmR0NIOdv7+0GcbDjZTpMPDYEb39RVK3DoJjP+iZjT08hNM16T/
         BtRFRbGmI19/NLfiWOEYQZbbZjKN9zR9kjJFpIHLHEtKKOIA6tvSo40ZOdWwD+iMpF
         /YzUegWKh0IKpBRb27GfgC5xxk4ghcxpxtzJOMI5yP6Wg/3AF+XLBCAwvpMun61oxb
         pZ1cJUUcasq2PjkG5dtXAzWqjCnVXeK8GK3zNKoJclMCdiSzdBZNr/Z+8kn5U0+rr5
         rumx1VOJFeWag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 08B9C609F7;
        Wed, 20 Oct 2021 13:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: Fix E2E delay mechanism
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163473781503.13902.15458300131400475237.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 13:50:15 +0000
References: <20211020070433.71398-1-kurt@linutronix.de>
In-Reply-To: <20211020070433.71398-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, fugang.duan@nxp.com,
        bigeasy@linutronix.de, boon.leong.ong@intel.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 20 Oct 2021 09:04:33 +0200 you wrote:
> When utilizing End to End delay mechanism, the following error messages show up:
> 
> |root@ehl1:~# ptp4l --tx_timestamp_timeout=50 -H -i eno2 -E -m
> |ptp4l[950.573]: selected /dev/ptp3 as PTP clock
> |ptp4l[950.586]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
> |ptp4l[950.586]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
> |ptp4l[952.879]: port 1: new foreign master 001395.fffe.4897b4-1
> |ptp4l[956.879]: selected best master clock 001395.fffe.4897b4
> |ptp4l[956.879]: port 1: assuming the grand master role
> |ptp4l[956.879]: port 1: LISTENING to GRAND_MASTER on RS_GRAND_MASTER
> |ptp4l[962.017]: port 1: received DELAY_REQ without timestamp
> |ptp4l[962.273]: port 1: received DELAY_REQ without timestamp
> |ptp4l[963.090]: port 1: received DELAY_REQ without timestamp
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: Fix E2E delay mechanism
    https://git.kernel.org/netdev/net/c/3cb958027cb8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


