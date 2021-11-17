Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B92D453F34
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhKQEDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:03:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231569AbhKQEDG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:03:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DA84361B5F;
        Wed, 17 Nov 2021 04:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637121608;
        bh=gbGrpmsHWTusyXaYjCJbo07A5KUgxrYpgwZ+BbDRNJ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=enEpiSCsvn1N8fa2LgbZs27IJSH2DOITwwaeqWsokjz7MRhGpiHEKLFpi2ShWqqq7
         CDBP3X3iuGNs2pJAzFYMWy5WhkkijEFju+SdHgKaBWywW0f+IocQ0n9lLnDql2L0sO
         75lhp+D25PAmCIlpRHxbKfjSHh5kXZV+2cR8dSjDIIwtwmXiJC/lB/iI8WIyJ3YSSk
         hv5ij34q6F3mQvkIrY9yBgcqODQeuR2aS9KobfJf3C8TtLQwgNsvcFMWHm83ZzvRON
         vCCAOlSunH9uhR/ApdLKxqbP3egUje7Nck4kVIiT4cULnkhKwiwf9jxV9omGBTOtLG
         NENHwnOVDLkTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C8B4360A4E;
        Wed, 17 Nov 2021 04:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: Fix signed/unsigned wreckage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163712160881.18981.2457911611612517229.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 04:00:08 +0000
References: <87mtm578cs.ffs@tglx>
In-Reply-To: <87mtm578cs.ffs@tglx>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        weifeng.voon@intel.com, vee.khee.wong@intel.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, b.spranger@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Nov 2021 16:21:23 +0100 you wrote:
> The recent addition of timestamp correction to compensate the CDC error
> introduced a subtle signed/unsigned bug in stmmac_get_tx_hwtstamp() while
> it managed for some obscure reason to avoid that in stmmac_get_rx_hwtstamp().
> 
> The issue is:
> 
>     s64 adjust = 0;
>     u64 ns;
> 
> [...]

Here is the summary with links:
  - net: stmmac: Fix signed/unsigned wreckage
    https://git.kernel.org/netdev/net/c/3751c3d34cd5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


