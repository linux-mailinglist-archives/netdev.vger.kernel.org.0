Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E710040F8DB
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239858AbhIQNLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235265AbhIQNL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:11:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 98F39611C4;
        Fri, 17 Sep 2021 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631884207;
        bh=nO1/aVBlG82KIoJKcsFqGqOzauFVzjv1LobclgXvjTQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KvIywNfGDvZqpVzng3hIxCh79JaiLLt0Elx1W6BoHzYFgYpZiCVZvctc7ZuPTWMCr
         invnPoVund2Vf5ocbaN+z8ludE2PkIGxzpyIUz7WXocI9SN8bg+L/dtrptBeI+BAaB
         a/SbuBTQ1FcVXVzmxZu8XwRzHmUgP0EHSOUovHhCe3PZ5HssoVhqmFoTXYW8iaDRai
         2U89M1E9tQ6GzbkrN9owhEeNjoMFytLQJsbd09io4IuezYpI/kFfgQwH3X9q76QTf7
         CyPtw8uP4lt4GEckwNFoJ3ytTlTYohg2N8FN0vhAaoC+o3wejhf3iru8Wk3pE8XG6f
         x0XDwsHdtuuDg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 876E1609B4;
        Fri, 17 Sep 2021 13:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwmac-visconti: Make use of the helper function
 dev_err_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163188420754.25822.8146846295180412777.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Sep 2021 13:10:07 +0000
References: <20210916073737.9216-1-caihuoqing@baidu.com>
In-Reply-To: <20210916073737.9216-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, nobuhiro1.iwamatsu@toshiba.co.jp,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 16 Sep 2021 15:37:36 +0800 you wrote:
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.
> And using dev_err_probe() can reduce code size, and the error value
> gets printed.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> 
> [...]

Here is the summary with links:
  - net: stmmac: dwmac-visconti: Make use of the helper function dev_err_probe()
    https://git.kernel.org/netdev/net-next/c/b20b54fb00a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


