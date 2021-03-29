Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E9634C0E3
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhC2BKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhC2BKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 21:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C60C161948;
        Mon, 29 Mar 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616980209;
        bh=dzftri+gmkIIaOnXUn9800SYI6DxI9JW/J4WywxVokg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DHUsyBTlWir9x7InqbCTBzl7BUj/WDxqKvs/hxFxgq7gINiREmjSde9ugU5tfOIXa
         PZG/OfNlLq8AmiFYW/qDz8rUGYSexvpHrhs6rgMuKO2haOg6XoX2OZWK2WdPlPrWkg
         aSEVulIB3bpiB1bGv87bE/pHX6bG8+2JFn3kgxcGX+dCbTPmmV/VOjZkqsFOshJgaa
         qOX80lKsi/4PQbMkVcWLfrEx+tjoQ5tFdFIiV1mL0eyCJAKdIoJTzSSvQKyoBIgGiW
         RinxTIE6U4b+zHcu6/7EZBjFm5FybXCrHuMayU3dR0/P2DpAmLadD46uYFJ9Il49IJ
         689aEVnb0909A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BCE77609E8;
        Mon, 29 Mar 2021 01:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: stmmac: fix missing unlock on error in
 stmmac_suspend()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161698020976.2631.14820438547306102972.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 01:10:09 +0000
References: <20210327093322.1649580-1-yangyingliang@huawei.com>
In-Reply-To: <20210327093322.1649580-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        qiangqing.zhang@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 17:33:22 +0800 you wrote:
> Add the missing unlock before return from stmmac_suspend()
> in the error handling case.
> 
> Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] net: stmmac: fix missing unlock on error in stmmac_suspend()
    https://git.kernel.org/netdev/net-next/c/30f347ae7cc1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


