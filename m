Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6768B3247D3
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbhBYAUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234547AbhBYAUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 19:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5EA8D64F11;
        Thu, 25 Feb 2021 00:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614212407;
        bh=wnAIPBprFZceo32iwm9Vth3MHQM2ktK6F0R+YU0JY6k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pSs4eDtlDBdy8xXCn8PFnvKOUX10VKBzqXAx1lY389efFLVInUU7qesO+guHYAZDS
         VgLHBnQ0XlDk35p4YFT2edPuVpyrbTxRy0k2rA9TjHKlbmXpWpSA34+dQvulFAJ/oz
         WNZFeWe48s9FFWWhK4LswkRmz1cJJtY2ZtHL8ORHzRbE5ork5Fhj4ETlzPyRYpULGH
         +0NuF3ptYEHeIifdRGM8jiWBZ07KDR3x/beYsupvlip9aseW8nxi5iqXu+8ieIiFnB
         KKmR3yoDmZxQgzyjcNwhYgB4cdVnZwb9Ytd7awde4UwPZ5KDIZczhDPXNmjt0otBr9
         fEglBTs2fY8bg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 502CF609F2;
        Thu, 25 Feb 2021 00:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: Fix missing spin_lock_init in
 visconti_eth_dwmac_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161421240732.21407.2002592111735114066.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Feb 2021 00:20:07 +0000
References: <20210223104803.4047281-1-weiyongjun1@huawei.com>
In-Reply-To: <20210223104803.4047281-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     hulkci@huawei.com, peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 23 Feb 2021 10:48:03 +0000 you wrote:
> The driver allocates the spinlock but not initialize it.
> Use spin_lock_init() on it to initialize it correctly.
> 
> Fixes: b38dd98ff8d0 ("net: stmmac: Add Toshiba Visconti SoCs glue driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - net: stmmac: Fix missing spin_lock_init in visconti_eth_dwmac_probe()
    https://git.kernel.org/netdev/net/c/17d7fd47aa90

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


