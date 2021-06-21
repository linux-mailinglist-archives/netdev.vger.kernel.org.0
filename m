Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A3F3AF80E
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 23:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbhFUVw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 17:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230263AbhFUVwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 17:52:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1FFD861358;
        Mon, 21 Jun 2021 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624312205;
        bh=/a/tGm/0AH0ASd66gGhtsEXHiRnkM68Ab2RnC6aVfVo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BrObahxaqLE6IcSIEMXSRxxNj98Q9qaivU83uRgUGUSlakHXa/BL6Ylb+D6kV8p5h
         Wxynqq/otlrDCFz8I452Gu/vbLVPrYrNw/LqWiU8EhHCvhsDrOVJzWVj88LRoBJHnb
         scutW9f1nXyxL/QuKyZ4dqfKUWoNMmdh9CcVCb2nsIYtWIG/TmGpgoaHm9xser/ADs
         ghliebwxQiQ2Lyk220CIGH+GoTK1cWk6fxCOtWNVlPnSBt2byQit1twhKuTN3hZaSY
         P6RMtQKlzM9VrH1By5Di9LBiaecCHwlQnQZcVgy28o+lVlweO9wdc/wwtU+oOSmAQC
         HKkmveyPfid8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 19C5C60952;
        Mon, 21 Jun 2021 21:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ll_temac: Remove left-over debug message
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162431220510.17422.10756500778546076606.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 21:50:05 +0000
References: <bd834ced7d5a7f6980e9b2d358f7876c215185b5.1624263139.git.esben@geanix.com>
In-Reply-To: <bd834ced7d5a7f6980e9b2d358f7876c215185b5.1624263139.git.esben@geanix.com>
To:     Esben Haabendal <esben@geanix.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 21 Jun 2021 10:20:08 +0200 you wrote:
> Fixes: f63963411942 ("net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY")
> Signed-off-by: Esben Haabendal <esben@geanix.com>
> ---
>  drivers/net/ethernet/xilinx/ll_temac_main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - net: ll_temac: Remove left-over debug message
    https://git.kernel.org/netdev/net-next/c/ce03b94ba682

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


