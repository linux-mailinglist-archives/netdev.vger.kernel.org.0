Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9013E2746
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244540AbhHFJa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhHFJa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 05:30:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0F8F861164;
        Fri,  6 Aug 2021 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628242206;
        bh=BmFFvRbhkRMBT1AROh0Lvw35ncy0VbHfmyiRMh4UMak=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HsRne+DSe6cK6Fbkd+KMh6LHSAmw5qm1LfSIL7tD6d0iMippbPDxn7FKL4TrzkkzP
         fF2a6sSvddfQByjTq/OHhrQ+X/d3BSau+3NeLVYKH0G7BzBG7PkfuR5Ou83BiTWAOg
         vwv6xRp4SmOrSBjfE4Ezo4YFdrpOkdGJ+78wU/r71OBeIUiBJsU/NEQT9eRPxN4Kcs
         62g6+U+tcePmuLpkr80OJAO33XEv2wbVPbomAoK5QH5CWkYzh8WCz1UZRnxoevy7U8
         rejy/5CLcu794wrwX38lbPCO/O6tMpISXiGD/n/mQXFLzLvSf0y77CSopgv0gkOUIg
         +MlDOw5js9c9A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 06CF560A7C;
        Fri,  6 Aug 2021 09:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: ethernet: ti: cpsw/emac: switch to use
 skb_put_padto()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162824220602.18289.6086651097784470216.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Aug 2021 09:30:06 +0000
References: <20210805145555.12182-1-grygorii.strashko@ti.com>
In-Reply-To: <20210805145555.12182-1-grygorii.strashko@ti.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, ben.hutchings@essensium.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org, lokeshvutla@ti.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 5 Aug 2021 17:55:52 +0300 you wrote:
> hi
> 
> Now frame padding in TI TI CPSW/EMAC is implemented in a bit of entangled way as
> frame SKB padded in drivers (without skb->len) while frame length fixed in CPDMA.
> Things became even more confusing hence CPSW switcdev driver need to perform min
> TX frame length correction in switch mode [1].
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: ethernet: ti: cpsw: switch to use skb_put_padto()
    https://git.kernel.org/netdev/net-next/c/1f88d5d566b8
  - [net-next,2/3] net: ethernet: ti: davinci_emac: switch to use skb_put_padto()
    https://git.kernel.org/netdev/net-next/c/61e7a22da75b
  - [net-next,3/3] net: ethernet: ti: davinci_cpdma: drop frame padding
    https://git.kernel.org/netdev/net-next/c/9ffc513f95ee

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


