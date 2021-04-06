Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745F4355F72
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344434AbhDFXa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242824AbhDFXaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:30:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 51C79613C0;
        Tue,  6 Apr 2021 23:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617751810;
        bh=ZIUFsrMXmGIIHPw5n0/I5aDetMQFS18Ze+FEc3jJQjQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D6FIaM2Pefyj/JFnRiRVFJGC09E4o8VZXp2EbNlRAKZPk2KOH7Zx1V+MCwu+6gNvF
         /E4tcVdAPANPtMZ7qYrcROXhFe4h40Px7k0HT7fW5LYN2NrMqn2upByNV4HTS7Dm8r
         rOrb6Od8ow87iESnVTqmIA40G88Hvbm5HT4n3MCCFb25uC4K5YDtLJdhRc1Op6rutH
         q4j0x9mrUIV6yvsXNnWcM+snkAD8kBVtmoX2WRQ+0esCaMaBCBVfqDm8yYm0GXRA6H
         WgegEfzfDc8ShT1H+C+1fCpjTd/3v2gOYS0KYl3XF6ipV0NwNjVgbqxfl6mFUsSymf
         /7pqHHXKgME0A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4B41C609FF;
        Tue,  6 Apr 2021 23:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: remove unneeded
 semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775181030.15996.4622517435029624196.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Apr 2021 23:30:10 +0000
References: <20210406030433.6540-1-linqiheng@huawei.com>
In-Reply-To: <20210406030433.6540-1-linqiheng@huawei.com>
To:     Qiheng Lin <linqiheng@huawei.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 6 Apr 2021 11:04:33 +0800 you wrote:
> Eliminate the following coccicheck warning:
>  drivers/net/ethernet/mediatek/mtk_ppe.c:270:2-3: Unneeded semicolon
> 
> Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: ethernet: mtk_eth_soc: remove unneeded semicolon
    https://git.kernel.org/netdev/net-next/c/3b2c32f96edc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


