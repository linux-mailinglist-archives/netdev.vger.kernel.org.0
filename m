Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8A33BF10F
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 22:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbhGGUxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 16:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230474AbhGGUxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 16:53:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D795261CCE;
        Wed,  7 Jul 2021 20:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625691064;
        bh=KcLczx3VGsBt1P9w3VNT+56SSY+1/GyZMpqQTJ1Rgo8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QxxpIV5SkT28mPeG3EXRKSYjCHdIHfvBC+X/UjtdzzQJcwxKAOjeiLJZlRM8dXy+j
         VxjxDQ2avOUB+jOlwhPQ17SOBDY3rHrznsyD86LltL6xT5NQWkYt3EHpUOqCd2jLW7
         yN5ot77yvs5FdCrQZgQU0FcID3mubQJtKHLVwoZZOPA+v91bORNg561+dR8wCnula7
         V9dnfsPtw+1hYeaBRI/sjf/V7baEjgieGZ2AHg0twmGIOSNJXTwJG0JK9bD6EEmqVi
         0CDQyItyBzbIzlTyN8/ercPYhyd+yVD5dPL8y1afEL7t5dJf6/K2SOU18jJ3HamGwS
         Z3GIAuqvikvVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C4A2A60A3A;
        Wed,  7 Jul 2021 20:51:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] stmmac: platform: Fix signedness bug in
 stmmac_probe_config_dt()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162569106480.4918.10877247731048790736.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Jul 2021 20:51:04 +0000
References: <20210707075335.26488-1-yuehaibing@huawei.com>
In-Reply-To: <20210707075335.26488-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, ajayg@nvidia.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 7 Jul 2021 15:53:35 +0800 you wrote:
> The "plat->phy_interface" variable is an enum and in this context GCC
> will treat it as an unsigned int so the error handling is never
> triggered.
> 
> Fixes: b9f0b2f634c0 ("net: stmmac: platform: fix probe for ACPI devices")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] stmmac: platform: Fix signedness bug in stmmac_probe_config_dt()
    https://git.kernel.org/netdev/net/c/eca81f09145d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


