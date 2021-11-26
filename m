Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A7445E693
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357785AbhKZDfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 22:35:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358092AbhKZDdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 22:33:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 546EC6112F;
        Fri, 26 Nov 2021 03:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637897409;
        bh=GTT1ehgWI25ZSOWRHixiqqVgfEY61Uge6R/e5yv1jcU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kvw6GgQPfrWL9pA7OHQXSzVQ9iAULXaxTUs3p9Hx8kiQkd4i3tzuqiKfTu/KsAxja
         IO2DzYNLPEA0btM/LFo2Op8JCBQxE/uN/w0XcjIbp4TyP2TYE/YLIdcX803gaNR9rh
         nhgwISY/msBGDzwec6QUXJevS520Khrp6xNqNKkqL5UfNRinEfGyX0KJsGxA2QeiOz
         +G+mB7JEaL/79hP2ccOcN3b1VOjLvc2tyHh9Pe6qXBJkxf4AKt/DMs9fXabrFrH7B1
         p/ndcWQUTM70p5tgeVu3CHZkI9IzKUTMJhv8tKoOQqdLRKhjWyarwGaVP2U7BXl8zI
         LCtiz8F15mvkA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 43CA160BCF;
        Fri, 26 Nov 2021 03:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: stmmac: perserve TX and RX coalesce value
 during XDP setup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163789740927.8117.11153473080203312776.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 03:30:09 +0000
References: <20211124114019.3949125-1-boon.leong.ong@intel.com>
In-Reply-To: <20211124114019.3949125-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        kuba@kernel.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, kurt@linutronix.de,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 19:40:19 +0800 you wrote:
> When XDP program is loaded, it is desirable that the previous TX and RX
> coalesce values are not re-inited to its default value. This prevents
> unnecessary re-configurig the coalesce values that were working fine
> before.
> 
> Fixes: ac746c8520d9 ("net: stmmac: enhance XDP ZC driver level switching performance")
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: stmmac: perserve TX and RX coalesce value during XDP setup
    https://git.kernel.org/netdev/net-next/c/61da6ac71570

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


