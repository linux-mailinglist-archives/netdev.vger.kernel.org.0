Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569154AE940
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiBIF1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:27:42 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbiBIFU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:20:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E437FC0612BF;
        Tue,  8 Feb 2022 21:20:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41A14CE13BA;
        Wed,  9 Feb 2022 05:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8859CC340F6;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644384028;
        bh=l7UnrMd1qWPYoE6yezCxaKmMzhHLhzW30Wngdzs2KoI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L81/cIVv4Wmc7hR0YxCSx/8nSPC/v3ElD+6SxW6rn7fdZxj5wTJ8ep/3ty65l4VC8
         HqtA8eN8AVJ1e5FrqKoj5FFrh76ajoEYTXQG80chykcXGrFSaAIPC159qbmHWPi5zd
         O+ah3SiSUXpjNuub7hltvRuKNVWnbARsimVDnYhyqpnB4j/A7Yv2I/NlCm4pM1Qs6v
         x4/WOZrZl7EeJmuqFz+swUjWIDZkQGj2f443sBQgFtbq8oLwz1+zgBOjIak/XW/gMb
         pSdkJ/Xw0XdfuWoXkFMoEyUVY0tOG/Ie1FpVq4CixOp9wRcIIsupE9tGTWrw+BdpYT
         WBnl3+MXLfYFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75EDEE6D447;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ethernet: litex: Add the dependency on HAS_IOMEM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164438402847.12376.5907633854409051279.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 05:20:28 +0000
References: <20220208013308.6563-1-cai.huoqing@linux.dev>
In-Reply-To: <20220208013308.6563-1-cai.huoqing@linux.dev>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, kgugala@antmicro.com,
        mholenko@antmicro.com, gsomlo@gmail.com, joel@jms.id.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  8 Feb 2022 09:33:08 +0800 you wrote:
> The LiteX driver uses devm io funtion API which
> needs HAS_IOMEM enabled, so add the dependency on HAS_IOMEM.
> 
> Fixes: ee7da21ac4c3 ("net: Add driver for LiteX's LiteETH network interface")
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
> ---
>  drivers/net/ethernet/litex/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [v2] net: ethernet: litex: Add the dependency on HAS_IOMEM
    https://git.kernel.org/netdev/net/c/2427f03fb42f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


