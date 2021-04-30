Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCA2370380
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 00:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbhD3WbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 18:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231439AbhD3WbA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 18:31:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2A00F6147F;
        Fri, 30 Apr 2021 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619821811;
        bh=XVCO9O9G7bisl1YNGCySOUbejBlFNAz4x2iboi+HPMM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P9ap/x9ZZ85fjGARq/R5Mx/7yINZ5m2vDn0crZ0pRnL67E9R3C8D1iy1Gz0Y+0L8a
         qrjt/ByO8Es0bUMCdCVDrOfxD0GNXFNx0gVkj4JtGt2Hfv1D7RON4QgUd0nRhGyGQ1
         VBR8n1K7TXqFHx0Avk6V3wz/rER4D/zkhXG2u5I5FL7j6ZG9oCtA6MAbvAGvCZj0gD
         pdE5JD+n+P2IsoPe4Z2BeEX20jpxW5RQtiQ1x9HWGlDp6nmBEFZgKAJ50l0WhcO++V
         pvC1W0678QKrRs+6jDm85TsI/nsYyAyjv07iSpwkbaroO9+FgHbKcck0eWyI1Wa8Zn
         ibXsMIlvrPnrA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1D1D160CD1;
        Fri, 30 Apr 2021 22:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: Remove duplicate declaration of stmmac_priv
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161982181111.1234.7541800919565959093.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Apr 2021 22:30:11 +0000
References: <20210430031047.34888-1-wanjiabing@vivo.com>
In-Reply-To: <20210430031047.34888-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kael_w@yeah.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 30 Apr 2021 11:10:47 +0800 you wrote:
> In commit f4da56529da60 ("net: stmmac: Add support for external
> trigger timestamping"), struct stmmac_priv was declared at line 507
> which caused duplicate struct declarations.
> Remove later duplicate declaration here.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> 
> [...]

Here is the summary with links:
  - net: stmmac: Remove duplicate declaration of stmmac_priv
    https://git.kernel.org/netdev/net/c/f18c51b6513c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


