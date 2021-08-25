Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38B83F734F
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239940AbhHYKa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239716AbhHYKaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:30:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B4CD9613D3;
        Wed, 25 Aug 2021 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629887409;
        bh=OdSv3mHcVF4P5vCREWxTKV6RCNyk591gKitGrtTN8q4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uH8MFftJMTf6m0j63fRdJUKL87/v8+2vV3RKm4V94ssExV/7+BYZM9wASVkkFWgv6
         9lpZju/W08xLWbc9FUJ7xWsLgt8c9SMH/8pCew6ymRDS2ahZM6bIslIN4HxEoztaCC
         /y3b02wTOC8j4zP81D9FmaTvMyER8XHlJdWFwszgnImgVbKMlc/XDHAxQKOuBs0B/0
         YPaFLVunfnE+mCrPBYRcxaNuPNrIrNq8YZkvl6Xsp+9nE6jmB5csu1LhoYllYuHb6c
         huTN8N+F47fRgEpvTouB9dxJiFkDBNFOQqNZXCiEk13lkXR2FcoxNT1OPfQl51CQo2
         L2PfLs9bwEkDg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A6CF260A02;
        Wed, 25 Aug 2021 10:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/13] Add Factorisation code to support Gigabit
 Ethernet driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988740967.13655.14613353702366041003.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:30:09 +0000
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
In-Reply-To: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
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

On Wed, 25 Aug 2021 08:01:41 +0100 you wrote:
> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
> similar to the R-Car Ethernet AVB IP.
> 
> The Gigabit Ethernet IP consists of Ethernet controller (E-MAC), Internal
> TCP/IP Offload Engine (TOE)  and Dedicated Direct memory access controller
> (DMAC).
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] ravb: Remove the macros NUM_TX_DESC_GEN[23]
    https://git.kernel.org/netdev/net-next/c/c81d894226b9
  - [net-next,02/13] ravb: Add multi_irq to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/6de19fa0e9f7
  - [net-next,03/13] ravb: Add no_ptp_cfg_active to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/8f27219a6191
  - [net-next,04/13] ravb: Add ptp_cfg_active to struct ravb_hw_info
    https://git.kernel.org/netdev/net-next/c/a69a3d094de3
  - [net-next,05/13] ravb: Factorise ravb_ring_free function
    https://git.kernel.org/netdev/net-next/c/bf46b7578404
  - [net-next,06/13] ravb: Factorise ravb_ring_format function
    https://git.kernel.org/netdev/net-next/c/1ae22c19e75c
  - [net-next,07/13] ravb: Factorise ravb_ring_init function
    https://git.kernel.org/netdev/net-next/c/7870a41848ab
  - [net-next,08/13] ravb: Factorise ravb_rx function
    https://git.kernel.org/netdev/net-next/c/d5d95c11365b
  - [net-next,09/13] ravb: Factorise ravb_adjust_link function
    https://git.kernel.org/netdev/net-next/c/cb21104f2c35
  - [net-next,10/13] ravb: Factorise ravb_set_features
    https://git.kernel.org/netdev/net-next/c/80f35a0df086
  - [net-next,11/13] ravb: Factorise ravb_dmac_init function
    https://git.kernel.org/netdev/net-next/c/eb4fd127448b
  - [net-next,12/13] ravb: Factorise ravb_emac_init function
    https://git.kernel.org/netdev/net-next/c/511d74d9d86c
  - [net-next,13/13] ravb: Add reset support
    https://git.kernel.org/netdev/net-next/c/0d13a1a464a0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


