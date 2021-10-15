Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D706E42F3FA
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239873AbhJONmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239868AbhJONmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 09:42:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1F313611CE;
        Fri, 15 Oct 2021 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634305209;
        bh=OEDhgFC6ch+MW07UQtgTddweZE+GxVXlaKAjxrNLbqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mm13N90To5pi3HD9y6vLtO6lpAS37IL4Dor5yX4s0tppRAYBV98NsxPwEnp5XJnpG
         CQ+csgVWJa3inntWdd5/BpR6BkTyGg4rOjIqxjBR2nZGGlV5QUXgHMTcWrbM6pFGWQ
         DK3kc2VA1H3loTR2tB8oP5WYoYX+iOCRvcwRjxoTohOF96pEgXbIdBRHhCvKBj71tD
         xQy7cS6564JlZDJ05DYRbJyMtihzdCrchCFj79Ii+M9QVTDECdwLxPy0LA/Qu8cHKo
         NJRTUjfKzIB/NgkC3oTkIsthTR634+YOREAr5kcOHcDkx+GSOaUycb5odNiWxAYdD8
         cHdKYf9FclCkg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 196BA60A4D;
        Fri, 15 Oct 2021 13:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/5] dpaa2-eth: add support for IRQ coalescing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163430520909.23472.12152819261939474415.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 13:40:09 +0000
References: <20211015090127.241910-1-ioana.ciornei@nxp.com>
In-Reply-To: <20211015090127.241910-1-ioana.ciornei@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, youri.querry_1@nxp.com,
        leoyang.li@nxp.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Oct 2021 12:01:22 +0300 you wrote:
> This patch set adds support for interrupts coalescing in dpaa2-eth.
> The first patches add support for the hardware level configuration of
> the IRQ coalescing in the dpio driver, while the ones that touch the
> dpaa2-eth driver are responsible for the ethtool user interraction.
> 
> With the adaptive IRQ coalescing in place and enabled we have observed
> the following changes in interrupt rates on one A72 core @2.2GHz
> (LX2160A) while running a Rx TCP flow.  The TCP stream is sent on a
> 10Gbit link and the only cpu that does Rx is fully utilized.
>                                 IRQ rate (irqs / sec)
> before:   4.59 Gbits/sec                24k
> after:    5.67 Gbits/sec                1.3k
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/5] soc: fsl: dpio: extract the QBMAN clock frequency from the attributes
    https://git.kernel.org/netdev/net-next/c/2cf0b6fe9bd3
  - [v2,net-next,2/5] soc: fsl: dpio: add support for irq coalescing per software portal
    https://git.kernel.org/netdev/net-next/c/ed1d2143fee5
  - [v2,net-next,3/5] net: dpaa2: add support for manual setup of IRQ coalesing
    https://git.kernel.org/netdev/net-next/c/a64b44213766
  - [v2,net-next,4/5] soc: fsl: dpio: add Net DIM integration
    https://git.kernel.org/netdev/net-next/c/69651bd8d303
  - [v2,net-next,5/5] net: dpaa2: add adaptive interrupt coalescing
    https://git.kernel.org/netdev/net-next/c/fc398bec0387

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


