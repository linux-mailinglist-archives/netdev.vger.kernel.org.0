Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4843D589F
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 13:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbhGZK7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 06:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233351AbhGZK7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 06:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 29A3760EB2;
        Mon, 26 Jul 2021 11:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627299605;
        bh=kMAs2b3tuO2e+8hgSQdeVypEf1a13iD9tSUV8798Utg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FnyKnd9AGDsgQaV+kul09GPPEMl8LTTcFDQ/LQaIDbTvYHGFnUZnWfPDjANa1lBcz
         l+EtQTwzDiDGmcrCz7szvCSEGOLY1UE6vuks/OvFFHkoGBFQryuqKXgiMxiTP7jf9y
         QUQJ7QVOIq2fpdXq8ORLYMfVnL0BaQBXND+Thkc8DLyy5y0IMOi8VI3Gd0xCgtg/xl
         pPJN8OuxVyNz7VsjiEjTbqCtyAgCJ7upcda/7Gc3QNTyzo5WWxI6g763dPAK4F7AaE
         WLW4Gtg5j/MBbRtAOoRHc1n8ezbC+UvByia2Ov9EqqKe2caMl9s6Piui6IGHMHhlAI
         3i3bDB25pyhVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1E8F160A5B;
        Mon, 26 Jul 2021 11:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: add est_irq_status callback function for
 GMAC 4.10 and 5.10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162729960512.898.7324413513898376609.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 11:40:05 +0000
References: <20210726022020.5907-1-mohammad.athari.ismail@intel.com>
In-Reply-To: <20210726022020.5907-1-mohammad.athari.ismail@intel.com>
To:     Ismail@ci.codeaurora.org,
        Mohammad Athari <mohammad.athari.ismail@intel.com>
Cc:     alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        kuba@kernel.org, peppe.cavallaro@st.com, mcoquelin.stm32@gmail.com,
        boon.leong.ong@intel.com, weifeng.voon@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 26 Jul 2021 10:20:20 +0800 you wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> Assign dwmac5_est_irq_status to est_irq_status callback function for
> GMAC 4.10 and 5.10. With this, EST related interrupts could be handled
> properly.
> 
> Fixes: e49aa315cb01 ("net: stmmac: EST interrupts handling and error reporting")
> Cc: <stable@vger.kernel.org> # 5.13.x
> Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: add est_irq_status callback function for GMAC 4.10 and 5.10
    https://git.kernel.org/netdev/net/c/94cbe7db7d75

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


