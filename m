Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BF138DF0B
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 04:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhEXCBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 22:01:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231744AbhEXCBi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 22:01:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 541CC610FA;
        Mon, 24 May 2021 02:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621821609;
        bh=uge5Dg7VE4PLgrFz8mpzqnYhf/xY4NpY9/Haz6SYHXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o98bkmHFnp8vkfLmG+8ieQe8E5XVlqa7XXetAUqyKxSruztv45QV0I6AGbBuyB+rO
         Jtu6Fab2cr3ypPbhgPpctwOEusCVYO5/iX7WlW+bdS5J2qA1ARXOXvbrUhLfREjXF0
         JZwtNCgBX0sFZCOao7kXyiC1Vg00O2NUThy/rgx9D7L/DdGw7hgZ79vLnNdNAcKwoJ
         So6WpV3gTFyoRpzqCOc9YyDSOkmCztt5E/LX8w5ey8n2uGVvyIJDNg/HjWO8TE4T5H
         c0Ly+tCTTfWbf/2PuiI70Jngug446YFcyq/I1f7n1vljq1x8SgWsEwdXPkekuPWkHN
         hE2JfgPYjKZiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 48B8660BD8;
        Mon, 24 May 2021 02:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] ethernet: ucc_geth: Use kmemdup() rather than
 kmalloc+memcpy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162182160929.2555.6400143269658856505.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 02:00:09 +0000
References: <20210524010701.24596-1-yuehaibing@huawei.com>
In-Reply-To: <20210524010701.24596-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     leoyang.li@nxp.com, davem@davemloft.net, kuba@kernel.org,
        rasmus.villemoes@prevas.dk, andrew@lunn.ch,
        christophe.leroy@csgroup.eu, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 24 May 2021 09:07:01 +0800 you wrote:
> Issue identified with Coccinelle.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: keep kmemdup oneline
> 
>  drivers/net/ethernet/freescale/ucc_geth.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [v2,net-next] ethernet: ucc_geth: Use kmemdup() rather than kmalloc+memcpy
    https://git.kernel.org/netdev/net-next/c/ec7d6dd870d4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


