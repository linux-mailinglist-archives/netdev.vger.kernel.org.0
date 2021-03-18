Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AA6340F91
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhCRVKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhCRVK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 17:10:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 977DD64F11;
        Thu, 18 Mar 2021 21:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616101827;
        bh=+wntOZ6iutlvRX1VMrIYEl/MgvWD0gweBc2N8aIbHsc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MCZEoGKk7IrHRu/qlLTHBG+HSteg1j+BrvMfopDNk/WHdLxyJqr4ngqhGNUhhC9C9
         ggAxmEirM7fLSXaZ5xIoHCIGkP8i5pgM0r0Pesd6glpAugpn7jzwwLSijudr7y8sut
         1hYJnkTGuLuwReB3BpPSPTwtSev58KD+oaqRKNZ9mTOsQg0u+0A77ftff32fTCESJJ
         PBKZt1vW+n+5j2LkBuNIe8C66KlOzacS6lkMlxWazNP/M5nESAW7GKg29D+hx3r/AA
         9XzOu786EPD/fJXR2QaNEulzk0TYEAiJbeZ84UGOMhEQeuxYjd09+8kukN0THw/Djd
         r0DsIaX6FJ/eQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8739660951;
        Thu, 18 Mar 2021 21:10:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] Add tc hardware offloads
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161610182755.7876.15039328288164755025.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 21:10:27 +0000
References: <20210318100215.15795-1-naveenm@marvell.com>
In-Reply-To: <20210318100215.15795-1-naveenm@marvell.com>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        sgoutham@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
        jerinj@marvell.com, lcherian@marvell.com, gakula@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 15:32:11 +0530 you wrote:
> This patch series adds support for tc hardware offloads.
> 
> Patch #1 adds support for offloading flows that matches IP tos and IP
>          protocol which will be used by tc hw offload support. Also
>          added ethtool n-tuple filter to code to offload the flows
>          matching the above fields.
> Patch #2 adds tc flower hardware offload support on ingress traffic.
> Patch #3 adds TC flower offload stats.
> Patch #4 adds tc TC_MATCHALL egress ratelimiting offload.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] octeontx2-pf: Add ip tos and ip proto icmp/icmpv6 flow offload support
    https://git.kernel.org/netdev/net-next/c/2b9cef667902
  - [net-next,2/4] octeontx2-pf: Add tc flower hardware offload on ingress traffic
    https://git.kernel.org/netdev/net-next/c/1d4d9e42c240
  - [net-next,3/4] octeontx2-pf: add tc flower stats handler for hw offloads
    https://git.kernel.org/netdev/net-next/c/d8ce30e0cf76
  - [net-next,4/4] octeontx2-pf: TC_MATCHALL egress ratelimiting offload
    https://git.kernel.org/netdev/net-next/c/e638a83f167e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


