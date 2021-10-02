Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8D841FBFE
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 15:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhJBNBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 09:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233093AbhJBNBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 09:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E838B61B08;
        Sat,  2 Oct 2021 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633179608;
        bh=wmjfw/tNBJqZDKcvzEcUF8UGlmBxeS3fGwMOtzmwuSQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DS3XYRjarfi48FnGz52xjE05Z9vgXLMIqT5xwUd9j0AqTMsUMk37psPiPO5nZVWYA
         5bDzIZMfe82wN3NwCLwQjPCYLYxjpODOflP7JzHuVapVWQBNC4V308L/PBPr5jCi7k
         gS5V6ZTK2MHo9XJTLRgSXRpy/y7HE3awNNmswMhEpz+xp0Wtixn0RnkEDet8JD/hkS
         9iccqYXPjThkdhLavzwQpUe52dqLjtv9Rq9atyUgKrPRvQ8io9tQH/ZkfHLDm7I73i
         kR3jjwndPQik2SE7pejz0LBI8F9Fkan4GWsUeSxv5EqGUmaG4dLzY2Zhlo33NstfHD
         ZImxdbZ9sxpIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DB2CD609D6;
        Sat,  2 Oct 2021 13:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/10] Add Gigabit Ethernet driver support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163317960789.20123.6630687472734688411.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Oct 2021 13:00:07 +0000
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
In-Reply-To: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     davem@davemloft.net, kuba@kernel.org, s.shtylyov@omp.ru,
        prabhakar.mahadev-lad.rj@bp.renesas.com, andrew@lunn.ch,
        sergei.shtylyov@gmail.com, geert+renesas@glider.be,
        aford173@gmail.com, yoshihiro.shimoda.uh@renesas.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris.Paterson2@renesas.com, biju.das@bp.renesas.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  1 Oct 2021 16:06:26 +0100 you wrote:
> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
> similar to the R-Car Ethernet AVB IP.
> 
> The Gigabit Ethernet IP consists of Ethernet controller (E-MAC), Internal
> TCP/IP Offload Engine (TOE)  and Dedicated Direct memory access controller
> (DMAC).
> 
> [...]

Here is the summary with links:
  - [01/10] ravb: Rename "ravb_set_features_rx_csum" function to "ravb_set_features_rcar"
    https://git.kernel.org/netdev/net-next/c/d9bc9ec45e01
  - [02/10] ravb: Rename "no_ptp_cfg_active" and "ptp_cfg_active" variables
    https://git.kernel.org/netdev/net-next/c/2b061b545cd0
  - [03/10] ravb: Add nc_queue to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/a92f4f0662bf
  - [04/10] ravb: Add support for RZ/G2L SoC
    https://git.kernel.org/netdev/net-next/c/feab85c7ccea
  - [05/10] ravb: Initialize GbEthernet DMAC
    https://git.kernel.org/netdev/net-next/c/660e3d95e21a
  - [06/10] ravb: Exclude gPTP feature support for RZ/G2L
    https://git.kernel.org/netdev/net-next/c/7e09a052dc4e
  - [07/10] ravb: Add tsrq to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/0b395f289451
  - [08/10] ravb: Add magic_pkt to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/ebd5df063ce4
  - [09/10] ravb: Add half_duplex to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/68aa0763c045
  - [10/10] ravb: Initialize GbEthernet E-MAC
    https://git.kernel.org/netdev/net-next/c/16a235199235

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


