Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A843AA3FB
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhFPTML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232296AbhFPTMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5AFCC611CE;
        Wed, 16 Jun 2021 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623870603;
        bh=yzlIDihKnNvjknOPU2lHi5fsnt7+4ZwDFrQLheoFmTM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BK7Xv0RRI5lUngVut4W+X4ZaK14b3J/PL77EM6Of+bwp8+3ItpIsv/1/GG5bXteDY
         c74CH+H6OXy1rFXc9UQkQs9Fu/qYRh1gBEDP050wgDUyufzNo8ZGEHDIgzO3pXaOrK
         fk4MyVp1xgRETvHE/6FUbqc2/0EbvVEOEQPZlP6a3yh1UfBgSzJAa9LVzrxQ10ScJO
         rIvfAN2aRyKiqPLX+fwODBZCzIlC7fNily+7UmE6N950kMukvZSc8Me9jJkg3BBRbz
         d9C5BYnxj+InjpZKto0du/AiHCMITx6kLBFnkdvB+ZoagK9JfnpQAYXax6pjGf5nI/
         xNpilpvP/MoXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4718060A54;
        Wed, 16 Jun 2021 19:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: Fix error return code in
 ingenic_mac_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387060328.23352.18155798235650955751.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 19:10:03 +0000
References: <20210615172155.2839938-1-weiyongjun1@huawei.com>
In-Reply-To: <20210615172155.2839938-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     zhouyanjie@wanyeetech.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 17:21:55 +0000 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 2bb4b98b60d7 ("net: stmmac: Add Ingenic SoCs MAC support.")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: Fix error return code in ingenic_mac_probe()
    https://git.kernel.org/netdev/net-next/c/61273f9d8314

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


