Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4EE47986A
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 04:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhLRDaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 22:30:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58520 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbhLRDaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 22:30:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C99162492;
        Sat, 18 Dec 2021 03:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 933C5C36AED;
        Sat, 18 Dec 2021 03:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639798216;
        bh=ZikG/15coMre1pXztLPrHk0ZpmcRbgYIZXdmNJXzSVM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=niXgulO1aqK9TB/yK5VZZ7Oztzpj7ZX22g8gegYBVbo1tXyn5G7v3ice6BpmRMqsg
         FTzmdUugxXVnGpc045cw/NwtTzeUFZ59GPYLnBIk69bN6nG2Ba9yINAl71gCejq2iz
         BEsY4wTt8xO2u1oRo7FsId65ltHmi6dx35d+uutJtA/pM7xWv3+Tapb0qWYf9vEcZI
         QusazQ5xBlvqirsukRrWFheRC8KNdVa4bSkztLQrMSDQurCDArnE+2dnj7fmF9m7Hy
         GVlKK6sG0UpY2GN88Su7DdFfsDjmEdFI/fF26q3otpWgD9Sk8BL9/v5RwPcdzq9Jyf
         hSVHVmj+gfQCw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 82F4D60A2F;
        Sat, 18 Dec 2021 03:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: delete some dead code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163979821653.17814.5434717978147982554.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 03:30:16 +0000
References: <20211217071037.GE26548@kili>
In-Reply-To: <20211217071037.GE26548@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Dec 2021 10:10:37 +0300 you wrote:
> The debugfs_create_dir() function never returns NULL.  It does return
> error pointers but in normal situations like this there is no need to
> check for errors.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c | 3 ---
>  1 file changed, 3 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: mtk_eth_soc: delete some dead code
    https://git.kernel.org/netdev/net-next/c/ab9d0e2171be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


