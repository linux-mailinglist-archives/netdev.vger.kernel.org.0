Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D5D410B58
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 13:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhISLvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 07:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231443AbhISLvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 07:51:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4F7F56104F;
        Sun, 19 Sep 2021 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632052207;
        bh=vLzfbeHjAdDhUeBu0uAsqJFXcY0sO4+U5w6QeIhOVHg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kSiO1HQ4CoX/xIOFEjWeqxhnH/giK+XJkIpwn4XEBEgMJBIrbDLZjyuxDTO7EBDcX
         SVOEdi9CTWlIYCRn2fle1z9SLdaWEDcQFebj47DLIsg6wzTiqaC+A2d82hvNDoaXP5
         Q/fWh/yZqL3dxid90MYSO1aCs2M7dkfP8QmfwGnmv9N7X0F2KtZ2AdHKMoXTQDCLT5
         UxnTrelSDRHWyw/cknpMrd+iLlLFKon+sIEYVpdXYOCOqU1pKcUKaC3FM1hnlDWZTc
         DZMiBYCzwLxeDv2A+I5ITLaEzBvtJDjqdEzvTnwCTvrRuQPGDRiWhxggBuQ2tPqbIL
         WtJb/c3A3vTLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3CE6860A37;
        Sun, 19 Sep 2021 11:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: net_namespace: Fix undefined member in
 key_remove_domain()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205220724.27306.14476410213655918687.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 11:50:07 +0000
References: <20210918090410.29772-1-yajun.deng@linux.dev>
In-Reply-To: <20210918090410.29772-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 18 Sep 2021 17:04:10 +0800 you wrote:
> The key_domain member in struct net only exists if we define CONFIG_KEYS.
> So we should add the define when we used key_domain.
> 
> Fixes: 9b242610514f ("keys: Network namespace domain tag")
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/core/net_namespace.c | 4 ++++
>  1 file changed, 4 insertions(+)

Here is the summary with links:
  - [net-next] net: net_namespace: Fix undefined member in key_remove_domain()
    https://git.kernel.org/netdev/net-next/c/aed0826b0cf2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


