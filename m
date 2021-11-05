Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAEC44621C
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 11:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhKEKWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 06:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232787AbhKEKWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 06:22:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6D38261284;
        Fri,  5 Nov 2021 10:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636107608;
        bh=U/Xq3fs1HP1WRH+4oXRkxIVYvODT9jT28QGt/1AugWU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OCS0hb6ACpt4YW90mBUBx2hz21aGTu5LKzNu8HRwlfJnxzRtpMwx7e/xadcX27x3f
         nzBKp5QQc00tTI67qYeh0f4O6bQo7Y2AQP+6fynshxRoL2vxmkT1MtC86OIrPNJAFp
         KJ7LjgYx9J84PFTd0QNKpQq4mwPqo2rTB3KM+VQBH+D7lVTXZI76jREdndw2K+66z4
         xJrB/ECdWlO9J6YtPeQsdA7pGT/pSp9fYJon4PUvt8bISv8jGq+aNszegy3JxRwB9I
         K9nQZy4W3OR+yqIiliTMT0Po2hB/ciBPodavMeq0/hxFnGACCHeUaWM1/m/Cm6elOj
         ayrXG7iPmSCGg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6037260A0E;
        Fri,  5 Nov 2021 10:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: litex: Remove unnecessary print function
 dev_err()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163610760838.10303.2701217711088972051.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 10:20:08 +0000
References: <20211105014217.38681-1-vulab@iscas.ac.cn>
In-Reply-To: <20211105014217.38681-1-vulab@iscas.ac.cn>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     joel@jms.id.au, caihuoqing@baidu.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  5 Nov 2021 01:42:17 +0000 you wrote:
> The print function dev_err() is redundant because
> platform_get_irq() already prints an error.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  drivers/net/ethernet/litex/litex_liteeth.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - net: ethernet: litex: Remove unnecessary print function dev_err()
    https://git.kernel.org/netdev/net/c/827beb7781d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


