Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46765450545
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhKONXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:23:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231913AbhKONXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 08:23:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9A53F63210;
        Mon, 15 Nov 2021 13:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636982410;
        bh=2+6Q+ASYuJ/HE6E6L+Q/56BvaTJg2xvxyMzwjMoFnyA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XtaPSAGy3pYgG0lEpM5TQpiMXniUlA8IplRHkxyMJE6VMk+eX4Bn2B/buRcfFoAAc
         AbPMAMShnTmOJCEbTalDaqStUmKo1IrT1/BLQhc0trmEp4d60sHiM1793ELpKNUJFH
         z3gV5oVeEN9ldzgduV4cuNuXmKDPwp25vRGIeDH4LL9LRaSXLSJ7FaP7VOhe5zzchs
         MTs2MhtVeke115tOmokbmx9YjD6rp1TDshznOsu4RhORbAFO2V96/lzAq4ZC8UdAWV
         EOkGv/5RSW7ys9o/LcQD58c4NbaGcvULy7YY/xTY65gPLk1FOxlv6Bf/COGEX45jOd
         5du4W15VKpM3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 92AD960A88;
        Mon, 15 Nov 2021 13:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: stmmac: enhance XDP ZC driver level
 switching performance
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698241059.21342.15722076817804554278.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 13:20:10 +0000
References: <20211111143949.2806049-1-boon.leong.ong@intel.com>
In-Reply-To: <20211111143949.2806049-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kurt.kanzenbach@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 Nov 2021 22:39:49 +0800 you wrote:
> The previous stmmac_xdp_set_prog() implementation uses stmmac_release()
> and stmmac_open() which tear down the PHY device and causes undesirable
> autonegotiation which causes a delay whenever AFXDP ZC is setup.
> 
> This patch introduces two new functions that just sufficiently tear
> down DMA descriptors, buffer, NAPI process, and IRQs and reestablish
> them accordingly in both stmmac_xdp_release() and stammac_xdp_open().
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: stmmac: enhance XDP ZC driver level switching performance
    https://git.kernel.org/netdev/net-next/c/ac746c8520d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


