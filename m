Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23311376D30
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 01:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhEGXLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 19:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229887AbhEGXLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 19:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 89D8061474;
        Fri,  7 May 2021 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620429011;
        bh=0SEb8qXdbULhZl1Rbi9ZyzqneA1LLsfAQjCA3iIoAS4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bdr8lQj0Y2KVZxX/8FhzdAg1RX/mc3Xx7iHJjn5wNtNFCMHtSq4s9BporZ1tYf/Qn
         0wkp7L37/FmChaLA44v3yREtW6abAuN8p+OlNdLpfqLnWmoojOlSaQvgJJtpHQO2sL
         VXTPfLGfaIfHL+pCbecup4M+E6XEM3Bi4r71i0MA2KDN+V+w/PFNVUOig5cIA9glAB
         OlKYhy8m+rH7cGjdAKqx49Wv21uqDIrGGqT0W7/9DouCAcTLogDhfiGSP1+QfetekA
         yL/eGTLUQse13UDTJIZu/M6b6gyns1XlFNZRvSn38R3AY5rU/vO9dC6uMxNeQBIm/Z
         v2AzbhFJmoicA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 78A6860A4F;
        Fri,  7 May 2021 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] net: stmmac: Do not enable RX FIFO overflow interrupts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162042901148.19618.711614255596815942.git-patchwork-notify@kernel.org>
Date:   Fri, 07 May 2021 23:10:11 +0000
References: <20210506143312.20784-1-yannick.vignon@oss.nxp.com>
In-Reply-To: <20210506143312.20784-1-yannick.vignon@oss.nxp.com>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, mcoquelin.stm32@gmail.com,
        qiangqing.zhang@nxp.com, sebastien.laveze@oss.nxp.com,
        yannick.vignon@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  6 May 2021 16:33:12 +0200 you wrote:
> From: Yannick Vignon <yannick.vignon@nxp.com>
> 
> The RX FIFO overflows when the system is not able to process all received
> packets and they start accumulating (first in the DMA queue in memory,
> then in the FIFO). An interrupt is then raised for each overflowing packet
> and handled in stmmac_interrupt(). This is counter-productive, since it
> brings the system (or more likely, one CPU core) to its knees to process
> the FIFO overflow interrupts.
> 
> [...]

Here is the summary with links:
  - [net,v1] net: stmmac: Do not enable RX FIFO overflow interrupts
    https://git.kernel.org/netdev/net/c/8a7cb245cf28

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


