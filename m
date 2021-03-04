Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F34F32DD04
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbhCDWaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229580AbhCDWaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:30:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CEDE964F4B;
        Thu,  4 Mar 2021 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614897007;
        bh=wT+tjbKC8paUl2xAF0d9Lr7i6fkGdDKRndhPFzm2ZSM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I/ts6bY/4Agr8ViNDQPqCZ12HeiGZLauBqsE5UfM6vi2jhz9+W2RNm02143b8CCO1
         lrpNtMDHdiShQb5pmfZ7fZ6uIldLSquZJEMpwk/TPLBFuNatdcKkrownIYU8/Abtx2
         I7MBJ8ignodTiwOxuxvGW2bcq8aDaSVc+dUAxFnq6PNIX181XWLuJ68Cb0zsA3nOt6
         MW+xF1NFXPR8ISKLVY7AetEXMRxY3qwDmNCFG+GNq8woORCpxqsCC3b5g9YJ4adkOt
         0jz8LEXhPdMWuASTqIyO6qdHaQaaQJjL68KIFicMVIw0GLJKBMb9n64UiVDf9TbB/+
         AiwfWpE9xDXqw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C45B0609EA;
        Thu,  4 Mar 2021 22:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] net: dsa: sja1105: fix SGMII PCS being forced to
 SPEED_UNKNOWN instead of SPEED_10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161489700779.12854.8703147097417753157.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 22:30:07 +0000
References: <20210304105654.873554-1-olteanv@gmail.com>
In-Reply-To: <20210304105654.873554-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Mar 2021 12:56:53 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When using MLO_AN_PHY or MLO_AN_FIXED, the MII_BMCR of the SGMII PCS is
> read before resetting the switch so it can be reprogrammed afterwards.
> This works for the speeds of 1Gbps and 100Mbps, but not for 10Mbps,
> because SPEED_10 is actually 0, so AND-ing anything with 0 is false,
> therefore that last branch is dead code.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: dsa: sja1105: fix SGMII PCS being forced to SPEED_UNKNOWN instead of SPEED_10
    https://git.kernel.org/netdev/net/c/053d8ad10d58
  - [net,2/2] net: dsa: sja1105: fix ucast/bcast flooding always remaining enabled
    https://git.kernel.org/netdev/net/c/6a5166e07c02

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


