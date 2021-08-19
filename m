Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213D23F17BE
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 13:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238533AbhHSLKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 07:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238079AbhHSLKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 07:10:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 040D86113E;
        Thu, 19 Aug 2021 11:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629371407;
        bh=rTZ3soS6t4MCZrC4yO5vSLk6S/T807Fuu4TcfoTKNsw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=STUDo/w1/vv/RFdqN+4E6iXnjqs+Um3PXZDI5Zupjy4ORjX1PGzEwTBpbJVc2D0A6
         +fdlfHksL79Ebo80ZqWxnqcCUA7h5jtWNs0IWw9Exse+b5db2HIgGC63ileGD12CIW
         Jb09AY6iXacaqDw1J1jzX+V8TnO+rMYuYXOIZNT1H0+L8SjwOHftPiIEPh0A6c3Gct
         17mGiE3HRM9n4fC7P2NIBiwyBp6OD1Anvhfcxht+Bkq/3leC73bx5lHco7X08XI9CU
         B68htndhV2G3KGFnp77eKV2+4p66gQ/QzEFcs29CnLVGVYEdmn2RSLn6vAhIGTMGmv
         uy6+5dk4ZWg4g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EA04260A50;
        Thu, 19 Aug 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/9] Add Gigabit Ethernet driver support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162937140695.9830.1977811163674506658.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Aug 2021 11:10:06 +0000
References: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
In-Reply-To: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     davem@davemloft.net, kuba@kernel.org, sergei.shtylyov@gmail.com,
        geert+renesas@glider.be, s.shtylyov@omprussia.ru,
        aford173@gmail.com, andrew@lunn.ch, ashiduka@fujitsu.com,
        yoshihiro.shimoda.uh@renesas.com, yangyingliang@huawei.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris.Paterson2@renesas.com, biju.das@bp.renesas.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Aug 2021 20:07:51 +0100 you wrote:
> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
> similar to the R-Car Ethernet AVB IP.
> 
> The Gigabit Ethernet IP consists of Ethernet controller (E-MAC), Internal
> TCP/IP Offload Engine (TOE)  and Dedicated Direct memory access controller
> (DMAC).
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/9] ravb: Use unsigned int for num_tx_desc variable in struct ravb_private
    https://git.kernel.org/netdev/net-next/c/cb537b241725
  - [net-next,v3,2/9] ravb: Add struct ravb_hw_info to driver data
    https://git.kernel.org/netdev/net-next/c/ebb091461a9e
  - [net-next,v3,3/9] ravb: Add aligned_tx to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/68ca3c923213
  - [net-next,v3,4/9] ravb: Add max_rx_len to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/cb01c672c2a7
  - [net-next,v3,5/9] ravb: Add stats_len to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/25154301fc2b
  - [net-next,v3,6/9] ravb: Add gstrings_stats and gstrings_size to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/896a818e0e1d
  - [net-next,v3,7/9] ravb: Add net_features and net_hw_features to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/8912ed25daf6
  - [net-next,v3,8/9] ravb: Add internal delay hw feature to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/8bc4caa0abaf
  - [net-next,v3,9/9] ravb: Add tx_counters to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/0b81d6731167

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


