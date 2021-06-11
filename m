Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197973A499D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhFKTwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhFKTwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 15:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2E0A1613D2;
        Fri, 11 Jun 2021 19:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623441006;
        bh=iYKEnI3mHnFC00UHH4ayZvqSXM4YakryJ7rwF+k5iLE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kbeLN5YQRu9PBAWtNsZ5+0sAdiouh1zltJCoWICFLOwdKgXNobDFn3vMs/XLH4kV8
         Vx6L5+8vQnHMPbrU5A5M63NdNtSI9gHLh+wgmDnikbhm62efPvGwm4j3mPpVTbcS9r
         s3lUrk5KWs241MflKiXs14WA1m1MeK+qd3/MpRLBHW2i0b8/bZGllbV25ZuzSqU1rx
         3/7ptAh741eCI9lA9+FQb5Ogx1Pw0qLWpr8rOhYZ3FMoXjbXadEKycmXc/T5l+dCMa
         aNkmcljf8XM9BgIm8DqAVkuCC3+wKW2Mka3BqTbOHNyvL49Ty93aZxB5FAbV37REOE
         g5kZbmyReneIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 20716609E4;
        Fri, 11 Jun 2021 19:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 00/10] DSA tagging driver for NXP SJA1110
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344100612.31473.9219537976281390378.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 19:50:06 +0000
References: <20210611190131.2362911-1-olteanv@gmail.com>
In-Reply-To: <20210611190131.2362911-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        richardcochran@gmail.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 22:01:21 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series adds support for tagging data and control packets on the new
> NXP SJA1110 switch (supported by the sja1105 driver). Up to this point
> it used the sja1105 driver, which allowed it to send data packets, but
> not PDUs as those required by STP and PTP.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,01/10] net: dsa: sja1105: enable the TTEthernet engine on SJA1110
    https://git.kernel.org/netdev/net-next/c/29305260d29e
  - [v3,net-next,02/10] net: dsa: sja1105: allow RX timestamps to be taken on all ports for SJA1110
    https://git.kernel.org/netdev/net-next/c/6c0de59b3d73
  - [v3,net-next,03/10] net: dsa: generalize overhead for taggers that use both headers and trailers
    https://git.kernel.org/netdev/net-next/c/4e50025129ef
  - [v3,net-next,04/10] net: dsa: tag_sja1105: stop resetting network and transport headers
    https://git.kernel.org/netdev/net-next/c/baa3ad08de6d
  - [v3,net-next,05/10] net: dsa: tag_8021q: remove shim declarations
    https://git.kernel.org/netdev/net-next/c/ab6a303c5440
  - [v3,net-next,06/10] net: dsa: tag_8021q: refactor RX VLAN parsing into a dedicated function
    https://git.kernel.org/netdev/net-next/c/233697b3b3f6
  - [v3,net-next,07/10] net: dsa: sja1105: make SJA1105_SKB_CB fit a full timestamp
    https://git.kernel.org/netdev/net-next/c/617ef8d9377b
  - [v3,net-next,08/10] net: dsa: add support for the SJA1110 native tagging protocol
    https://git.kernel.org/netdev/net-next/c/4913b8ebf8a9
  - [v3,net-next,09/10] net: dsa: sja1105: add the RX timestamping procedure for SJA1110
    https://git.kernel.org/netdev/net-next/c/30b73242e679
  - [v3,net-next,10/10] net: dsa: sja1105: implement TX timestamping for SJA1110
    https://git.kernel.org/netdev/net-next/c/566b18c8b752

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


