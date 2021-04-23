Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF90369BB5
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244027AbhDWVAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243797AbhDWVAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 17:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 321E66144E;
        Fri, 23 Apr 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619211613;
        bh=qcnWhsG+IuHq4y2rRfmfmfF8Z9Aj2JAVCwOhPjy8g14=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EFT8Wyk/V1LL6Z7jEhG8NHusjEBjeFvkxQGuJHGHLlRaSWp23pSpzYsC5Ioi8jG+y
         R+iW/2pxr4eFtEg6BpE8d/M/fHgRfoF5kneann+UGytYAPMD/MMqjVetzjdwg53hxU
         2wJz7VnhgAC6UQXyr9f522tdiDf3ek/E3c8In2PNXqV9r6L+H+/23kUxp70piq78vs
         xUEOhZSsBK7+6dgS/LNy/oVFzHD5I4YwnDWd4jaz9246F5G+tXO6t8lOPhPl667Oae
         fUgMtstFXIv3PAlgkSBOlnz4vfE6PXxGCXCtoXq2jjij3u/YIk1pPPTxmCINyXpGG4
         Hho8zOG/uLglQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 24D4D60C08;
        Fri, 23 Apr 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/15] mtk_eth_soc: fixes and performance
 improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161921161314.19917.14237701035571279323.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 21:00:13 +0000
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Apr 2021 22:20:53 -0700 you wrote:
> Most of these changes come from OpenWrt where they have been present and
> tested for months.
> 
> First three patches are bug fixes. The rest are performance
> improvements. The last patch is a cleanup to use the iopoll.h macro for
> busy-waiting instead of a custom loop.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/15] net: ethernet: mtk_eth_soc: fix RX VLAN offload
    https://git.kernel.org/netdev/net-next/c/3f57d8c40fea
  - [net-next,v2,02/15] net: ethernet: mtk_eth_soc: unmap RX data before calling build_skb
    https://git.kernel.org/netdev/net-next/c/5196c4178549
  - [net-next,v2,03/15] net: ethernet: mtk_eth_soc: fix build_skb cleanup
    https://git.kernel.org/netdev/net-next/c/787082ab9f7b
  - [net-next,v2,04/15] net: ethernet: mtk_eth_soc: use napi_consume_skb
    https://git.kernel.org/netdev/net-next/c/c30c4a827390
  - [net-next,v2,05/15] net: ethernet: mtk_eth_soc: reduce MDIO bus access latency
    https://git.kernel.org/netdev/net-next/c/3630d519d7c3
  - [net-next,v2,06/15] net: ethernet: mtk_eth_soc: remove unnecessary TX queue stops
    https://git.kernel.org/netdev/net-next/c/16ef670789b2
  - [net-next,v2,07/15] net: ethernet: mtk_eth_soc: use larger burst size for QDMA TX
    https://git.kernel.org/netdev/net-next/c/59555a8d0dd3
  - [net-next,v2,08/15] net: ethernet: mtk_eth_soc: increase DMA ring sizes
    https://git.kernel.org/netdev/net-next/c/6b4423b258b9
  - [net-next,v2,09/15] net: ethernet: mtk_eth_soc: implement dynamic interrupt moderation
    https://git.kernel.org/netdev/net-next/c/e9229ffd550b
  - [net-next,v2,10/15] net: ethernet: mtk_eth_soc: cache HW pointer of last freed TX descriptor
    https://git.kernel.org/netdev/net-next/c/4e6bf609569c
  - [net-next,v2,11/15] net: ethernet: mtk_eth_soc: only read the full RX descriptor if DMA is done
    https://git.kernel.org/netdev/net-next/c/816ac3e6e67b
  - [net-next,v2,12/15] net: ethernet: mtk_eth_soc: reduce unnecessary interrupts
    https://git.kernel.org/netdev/net-next/c/16769a8923fa
  - [net-next,v2,13/15] net: ethernet: mtk_eth_soc: rework NAPI callbacks
    https://git.kernel.org/netdev/net-next/c/db2c7b353db3
  - [net-next,v2,14/15] net: ethernet: mtk_eth_soc: set PPE flow hash as skb hash if present
    https://git.kernel.org/netdev/net-next/c/fa817272c37e
  - [net-next,v2,15/15] net: ethernet: mtk_eth_soc: use iopoll.h macro for DMA init
    https://git.kernel.org/netdev/net-next/c/3bc8e0aff23b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


