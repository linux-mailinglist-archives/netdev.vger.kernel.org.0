Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403133F4195
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 22:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbhHVUuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 16:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232819AbhHVUut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 16:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 214DA61354;
        Sun, 22 Aug 2021 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629665408;
        bh=3StiiUCoQc/73l+OzPYY/uiMM0i1NvmIdaJHoYTPVWM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UtfYHRcJQcV5RcmDuMI924BRXUxNd2IvZOmKuyRZ/Ym00M9UgJZoNFA3G449rBR6e
         wtQGZ8zYnnCdOYnf8+qVwsLsi9rxQgflSXhI2A9txHFsfIEyNmoRJKgXPuqYh9reAd
         uXyg/195KDCsgAZa4IrooBIn3HtmKDw2YqsP2GAwsXBdjY3TVLvXBBNrcYweVk8zSM
         rmENQoOdPuyYpIOr9u+RtM0tMepxnfBG8o4ecalI4pCq7+3gs28M3xO80aLJokWs2W
         KlaNlqSUOitxpbY8RDAZ/uAdNdfhiKkZm0FY1PFYkUs3pOb78aaZg+4+M7Fhl/q4MT
         EHpJ9GdWzwfOg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 12B28609D8;
        Sun, 22 Aug 2021 20:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH 00/10] Miscellaneous fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162966540807.2709.625412987713500074.git-patchwork-notify@kernel.org>
Date:   Sun, 22 Aug 2021 20:50:08 +0000
References: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
In-Reply-To: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 17:32:17 +0530 you wrote:
> This patch series contains a bunch of miscellaneous fixes
> for various issues like
> - Free unallocated memory during driver unload
> - HW reading transmit descriptor from wrong address
> - VF VLAN strip offload MCAM entry installation failure
> - Pkts not being distributed across queues in RSS context
> - Wrong interface backpressure configuration for NIX1 block on 98xx
> - etc
> 
> [...]

Here is the summary with links:
  - [net,01/10] octeontx2-pf: Fix NIX1_RX interface backpressure
    https://git.kernel.org/netdev/net-next/c/e8fb4df1f5d8
  - [net,02/10] octeontx2-af: cn10k: Fix SDP base channel number
    https://git.kernel.org/netdev/net-next/c/477b53f3f95b
  - [net,03/10] octeontx2-af: Handle return value in block reset.
    https://git.kernel.org/netdev/net-next/c/c0fa2cff8822
  - [net,04/10] octeontx2-pf: Don't mask out supported link modes
    https://git.kernel.org/netdev/net-next/c/50602408c8e2
  - [net,05/10] octeontx2-pf: send correct vlan priority mask to npc_install_flow_req
    https://git.kernel.org/netdev/net-next/c/10df5a13ac67
  - [net,06/10] octeontx2-af: Use DMA_ATTR_FORCE_CONTIGUOUS attribute in DMA alloc
    https://git.kernel.org/netdev/net-next/c/73d33dbc0723
  - [net,07/10] octeontx2-af: Check capability flag while freeing ipolicer memory
    https://git.kernel.org/netdev/net-next/c/07cccffdbdd3
  - [net,08/10] octeontx2-pf: Don't install VLAN offload rule if netdev is down
    https://git.kernel.org/netdev/net-next/c/05209e3570e4
  - [net,09/10] octeontx2-pf: Fix algorithm index in MCAM rules with RSS action
    https://git.kernel.org/netdev/net-next/c/e7938365459f
  - [net,10/10] octeontx2-af: cn10k: Use FLIT0 register instead of FLIT1
    https://git.kernel.org/netdev/net-next/c/623da5ca70b7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


