Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9090947E750
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 19:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349567AbhLWSAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 13:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbhLWSAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 13:00:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D12EC061401;
        Thu, 23 Dec 2021 10:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6DEB61F20;
        Thu, 23 Dec 2021 18:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19D99C36AE9;
        Thu, 23 Dec 2021 18:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640282410;
        bh=bBYbMtiu2+DyDN6q1VrK6nglRwnumCktCsEIcgFSG1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kQ1oFKuKiEcqaazndT86z7GauYxKkRFcJVDFkaa3pAdp40RX/3I2bXibDxcNaVkGY
         mnBAxH1FQ7y61taDfliZfWbwxZMd2/aGaB1knwuyk5IAwOZQBA7KH+ncLEqaZMdjQb
         j2R6aDqI2GRdyO+SX9Y6EpPvLWzsmYmmP2+TtMYsnjwyJN2K9T02buFxJ6b9ydN473
         L46b9lt8wBpc4zs9Pv60u3v2zQ/e0yGa+IUO2my7u/54K4NmKqAgaWYrhBGtxz3C9Q
         CadvSsqONAVmLrn9HryCED7/pdBVOBCBgNekdfRVJa+2SVgw0Nc3T11X5Dg1XTvaxq
         3MTwjcknoOq4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EFF12EAC065;
        Thu, 23 Dec 2021 18:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: ptp: fix potentially overflowing expression
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164028240997.22568.623578349650497483.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 18:00:09 +0000
References: <20211223073928.37371-1-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20211223073928.37371-1-xiaoliang.yang_1@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, Jose.Abreu@synopsys.com, mst@redhat.com,
        Joao.Pinto@synopsys.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Dec 2021 15:39:28 +0800 you wrote:
> Convert the u32 variable to type u64 in a context where expression of
> type u64 is required to avoid potential overflow.
> 
> Fixes: e9e3720002f6 ("net: stmmac: ptp: update tas basetime after ptp adjust")
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: stmmac: ptp: fix potentially overflowing expression
    https://git.kernel.org/netdev/net/c/eccffcf4657a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


