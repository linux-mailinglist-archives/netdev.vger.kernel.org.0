Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F3147986C
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 04:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhLRDaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 22:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbhLRDaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 22:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A55C061574;
        Fri, 17 Dec 2021 19:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2A76B82B82;
        Sat, 18 Dec 2021 03:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AA17C36AEB;
        Sat, 18 Dec 2021 03:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639798216;
        bh=LlWR27ifykUcFxLkF45w16P6KXob+Hi7ufe9f5qDSdo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jTMV7IZ+JSyMGZBsb5g5+HP+xqivOVbkhqsg0o7s5m/n2ROXoIo0wMJtnEZpf7e+m
         jOnkQ/alKMBMaOiiL0RRZLIubnGkrXmqXr/flv89EL12lxdEp6DZgh0yw6DnTNNaIO
         x4VJtRsprIU3jW5huatEoehuFmuDbHRP7Axvu10aI8c3aIE0cNm/kri9vJa5vDbi3p
         Bdh8UwMUhUtJ9QXZm/s/9XqpPQjNJgUSfS0sSd1w7mDb8NOLevzIVks56t6U1WCWYY
         /XOasP08GLHXKb1MopkCjo3enO1uSPHCCAx3HFrKFkMAG21gMmT4j9VGbHCeG2dag2
         uVhgDEiDhdc8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 77CC160A4F;
        Sat, 18 Dec 2021 03:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mtk_eth_soc: delete an unneeded variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163979821648.17814.352129686915909366.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 03:30:16 +0000
References: <20211217070735.GC26548@kili>
In-Reply-To: <20211217070735.GC26548@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     nbd@nbd.name, opensource@vdorst.com, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Dec 2021 10:07:35 +0300 you wrote:
> There is already an "int err" declared at the start of the function so
> re-use that instead of declaring a shadow err variable.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [net-next] net: mtk_eth_soc: delete an unneeded variable
    https://git.kernel.org/netdev/net-next/c/ddfbe18da55c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


