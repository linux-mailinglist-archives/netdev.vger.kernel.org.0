Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0681E42C630
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbhJMQWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhJMQWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 12:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 25556611BD;
        Wed, 13 Oct 2021 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634142011;
        bh=6zeBuwcYZ+VQY4PXrTu59wRZdlj9oYJkOMhjYcehcpg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NUFZ3hw2xLJETDhIerxF2fxtTNJ7tAq0a5LNV5rpZ0fHJmI+WRycVKCg3wQP1BoN7
         tId1nCaAHeJGWrey3Ei++iiuN9GIWLhP+kerOsF3hH3d4q725JFhApYZ9R4MmqOAyJ
         Ju8fxu0Dn1XnGNIOti4Hm5W2zUdFwiALsx1jMiYMgA1yof5QXwFzVb10WE/TlKLstL
         0pZ/hsXiPmpa2tlTbNfVnYlVNnkmuNOYSagnavATQ7qh4D3ik9dpAjjJzCdzmhnSuY
         auXxtT2DzA/SRo7N3lnLmP2vhT//9XK7pi0Hiwr90uTzVJiqybyeGpmJicLYrzecr7
         gB7XXmHittNfA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 12CE960173;
        Wed, 13 Oct 2021 16:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/14] Add functional support for Gigabit Ethernet
 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163414201107.13761.9091083859002281113.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 16:20:11 +0000
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
In-Reply-To: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     davem@davemloft.net, kuba@kernel.org, s.shtylyov@omp.ru,
        sergei.shtylyov@gmail.com, prabhakar.mahadev-lad.rj@bp.renesas.com,
        andrew@lunn.ch, geert+renesas@glider.be, aford173@gmail.com,
        yoshihiro.shimoda.uh@renesas.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, Chris.Paterson2@renesas.com,
        biju.das@bp.renesas.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 17:35:59 +0100 you wrote:
> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
> similar to the R-Car Ethernet AVB IP.
> 
> The Gigabit Ethernet IP consists of Ethernet controller (E-MAC), Internal
> TCP/IP Offload Engine (TOE)  and Dedicated Direct memory access controller
> (DMAC).
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/14] ravb: Use ALIGN macro for max_rx_len
    https://git.kernel.org/netdev/net-next/c/23144a915684
  - [net-next,v3,02/14] ravb: Add rx_max_buf_size to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/2e95e08ac009
  - [net-next,v3,03/14] ravb: Fillup ravb_alloc_rx_desc_gbeth() stub
    https://git.kernel.org/netdev/net-next/c/3d4e37df882b
  - [net-next,v3,04/14] ravb: Fillup ravb_rx_ring_free_gbeth() stub
    https://git.kernel.org/netdev/net-next/c/2458b8edb887
  - [net-next,v3,05/14] ravb: Fillup ravb_rx_ring_format_gbeth() stub
    https://git.kernel.org/netdev/net-next/c/16a6e245a9f3
  - [net-next,v3,06/14] ravb: Fillup ravb_rx_gbeth() stub
    https://git.kernel.org/netdev/net-next/c/1c59eb678cbd
  - [net-next,v3,07/14] ravb: Add carrier_counters to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/b6a4ee6e74de
  - [net-next,v3,08/14] ravb: Add support to retrieve stats for GbEthernet
    https://git.kernel.org/netdev/net-next/c/0ee65bc14ff2
  - [net-next,v3,09/14] ravb: Rename "tsrq" variable
    https://git.kernel.org/netdev/net-next/c/4ea3167bad27
  - [net-next,v3,10/14] ravb: Optimize ravb_emac_init_gbeth function
    https://git.kernel.org/netdev/net-next/c/030634f37db9
  - [net-next,v3,11/14] ravb: Rename "nc_queue" feature bit
    https://git.kernel.org/netdev/net-next/c/1091da579d7c
  - [net-next,v3,12/14] ravb: Document PFRI register bit
    https://git.kernel.org/netdev/net-next/c/95e99b10482d
  - [net-next,v3,13/14] ravb: Update ravb_emac_init_gbeth()
    https://git.kernel.org/netdev/net-next/c/3d6b24a2ada3
  - [net-next,v3,14/14] ravb: Fix typo AVB->DMAC
    https://git.kernel.org/netdev/net-next/c/940409264647

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


