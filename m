Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B424549E3FB
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241654AbiA0OAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:00:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51550 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241011AbiA0OAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BB0BB82287;
        Thu, 27 Jan 2022 14:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ECE5FC36AE3;
        Thu, 27 Jan 2022 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643292011;
        bh=CYunBMddd9vXfgSmHRNWWiWCi6UBp8t/F0L+BGJTblw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GDqCgLj/oQJw5bzxosAu+/6SPgVHY/PzrLOsoqJEaQ27fLnjjm/Zt5r8HDw0NAve5
         blCbLhqGyU46Kk2AtJnw1oJcH7jzz+bSrawwRvDBxtFcuHoYdsEJpbBE9wnvc+50N+
         Ku3j7xMWpbWoPXnK470dKEqOECp4/8XrVeMojq120wWUTHp1y/GidaI/1gzsRhdA8R
         1A7wTcYW5jnu0AuWO7jijjfePhauzP2ogYJ4gKEe0CUv0MnmAw/dbf7hU/eQHvdHu3
         xPWePYCr7iU2M1PKz3/MDtuStZr34Lpj9kIV9gyC0XXWt/HwryHfy1qX4BAYiKT+Lh
         Moax/0wzh0R/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2AB1E5D084;
        Thu, 27 Jan 2022 14:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwmac-sun8i: use return val of
 readl_poll_timeout()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329201085.13469.12025143259464894463.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 14:00:10 +0000
References: <20220126165215.1921-1-jszhang@kernel.org>
In-Reply-To: <20220126165215.1921-1-jszhang@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, mripard@kernel.org, wens@csie.org,
        jernej.skrabec@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Jan 2022 00:52:15 +0800 you wrote:
> When readl_poll_timeout() timeout, we'd better directly use its return
> value.
> 
> Before this patch:
> [    2.145528] dwmac-sun8i: probe of 4500000.ethernet failed with error -14
> 
> After this patch:
> [    2.138520] dwmac-sun8i: probe of 4500000.ethernet failed with error -110
> 
> [...]

Here is the summary with links:
  - net: stmmac: dwmac-sun8i: use return val of readl_poll_timeout()
    https://git.kernel.org/netdev/net/c/9e0db41e7a0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


