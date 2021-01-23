Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78727301246
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 03:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbhAWCaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 21:30:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:36950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbhAWCau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 21:30:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id ED7D923B55;
        Sat, 23 Jan 2021 02:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611369010;
        bh=LOIOXfspCXmNEKWExfVa6HeC2JfufFMepdIvAt/GA7Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vk0DzkrU+HRg+syBoG9CYeaR61h8Pqf95mQ9wp2Q9RCQPZzTdF59fzvqxNkXMV3MB
         zZ45tiX9js+juPiOPnmyF25ztzVc55SG8rXX7O+T+MHbOeD8NQF5dnb7pkMoFP7rmz
         i/qzA/cMhuP9TrBLyQ16JQPf8il4L5kL3cwqycdeAlacVpaJSMPhzR2Lib/il9HagK
         cTjfdpiH6mAkX5eRsge8av7Q17vPPxuzvTOmxA/YyfjQUxNPclzqiQu342OThKmOtS
         FKNCmoOdzpBpfqZxzzW1hKEnygdTFJHXHspkYnGYS6XjzsAId+AW0HBJF9yj7FGTcV
         WiU46N/qfCV4g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E047F652DC;
        Sat, 23 Jan 2021 02:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwmac-intel-plat: remove config data on error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161136900991.8400.5085131401439003900.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 02:30:09 +0000
References: <20210120110745.36412-1-bianpan2016@163.com>
In-Reply-To: <20210120110745.36412-1-bianpan2016@163.com>
To:     Pan Bian <bianpan2016@163.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, vineetha.g.jaya.kumaran@intel.com,
        rusaimi.amira.rusaimi@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 20 Jan 2021 03:07:44 -0800 you wrote:
> Remove the config data when rate setting fails.
> 
> Fixes: 9efc9b2b04c7 ("net: stmmac: Add dwmac-intel-plat for GBE driver")
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: stmmac: dwmac-intel-plat: remove config data on error
    https://git.kernel.org/netdev/net/c/3765d86ffcd3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


