Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD6C41AECD
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240676AbhI1MVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240470AbhI1MVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E23D261213;
        Tue, 28 Sep 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632831607;
        bh=Bni9Ut7PKmnC7xbJOn3opuIqfdnOiscAJRVuKBTDJsU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p2Oa5nhiFht7dwzyKwQBOMfm/zREyy4pPZTkOmMAkWZ7xuDIP57U78SEpu4nfkqnF
         U5qzhfrAGb6fG00ae2hCHdRS8DLYValgxosId256bWD1mrUSO26l1iKjWB7sEhIBP9
         YFlbr4KVPrym+HPPedAwFjcK5KyFv0uVu3saDN2zeDMOJm8dpU3dWsLVO0LKBk+dGM
         j34hw/6iEvQp2EWX5gKSHCJ5tXWvlvrb/ZwzIaePVteDb+XhDfO2SjzkXO2eYBX3hb
         j1GIGEWptgR7IUhbLjVBtOKDCxyEU8Mnx/NRjJCGS39sFGRms1SArUPexPRvs2noE1
         cAQCkTzfZsl6A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DB04260A69;
        Tue, 28 Sep 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: fix off-by-one error in sanity check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283160789.2416.15889045565100483092.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:20:07 +0000
References: <20210927135849.1595484-1-arnd@kernel.org>
In-Reply-To: <20210927135849.1595484-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de, linux@armlinux.org.uk, mcoquelin.stm32@gmail.com,
        boon.leong.ong@intel.com, qiangqing.zhang@nxp.com,
        weifeng.voon@intel.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 27 Sep 2021 15:58:29 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> My previous patch had an off-by-one error in the added sanity
> check, the arrays are MTL_MAX_{RX,TX}_QUEUES long, so if that
> index is that number, it has overflown.
> 
> The patch silenced the warning anyway because the strings could
> no longer overlap with the input, but they could still overlap
> with other fields.
> 
> [...]

Here is the summary with links:
  - net: stmmac: fix off-by-one error in sanity check
    https://git.kernel.org/netdev/net-next/c/d68c2e1d19c5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


