Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E3834B25E
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCZXAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229986AbhCZXAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 19:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9449461A21;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616799612;
        bh=6WtEF5UlVkpKu1h/9A8YKlArvdpJ5cgCBFw+HVMUQFE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G4bH1F5506Eyg8ElIAcFrP2cylwjH+/EVw8bE3A90S8XCAFkieq71zGxslWUzvhd0
         sqLMiouDHizpwmw3f8V4UGxoUDVPFzuMwrcPYxikMGPAYDfhACOvqS3EJ8YE9faCDS
         Oc+YzhJhhaSvlWCAFSb0O14mqJRppiwloVsOzPAQHp69XHOkJxZkuPY4qPiuDsG/4g
         thgpQRflFFWwoUQhmjyaBvG7DR5AIUYP2hjxtt/piu8sRnSViTBFrM2pRRDtztZwiN
         5/4cSoEWwho+PDz7/3EfFIcsQ24vCvcC89ikC4BeNEv4fjshmR6VTuug3w0uPUxdle
         cDZVo6l+muzww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 77BFB60971;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: remove duplicated include
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679961248.14639.5462729926726566402.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 23:00:12 +0000
References: <20210326024046.2800216-1-xujia39@huawei.com>
In-Reply-To: <20210326024046.2800216-1-xujia39@huawei.com>
To:     Xu Jia <xujia39@huawei.com>
Cc:     nbd@nbd.name, sean.wang@mediatek.com, kuba@kernel.org,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org, hulkcommits@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 26 Mar 2021 10:40:46 +0800 you wrote:
> Remove duplicated include from mtk_ppe_offload.c.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Xu Jia <xujia39@huawei.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [net-next] net: ethernet: remove duplicated include
    https://git.kernel.org/netdev/net-next/c/aeab5cfbc8c7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


