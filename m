Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C457D41FC33
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 15:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbhJBNV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 09:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233103AbhJBNVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 09:21:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1750A61B1F;
        Sat,  2 Oct 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633180808;
        bh=4Dk1cJ9w7ww7PUOxb8VbDNCISKgj+dEcgTYv06r61I0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rp5fsjYcjexFzv6mK165/HBNPHIm++3c4Dbg3lC5OHeWV5vGPOkqAOUbgIgscByQG
         LMUm2q1KZEOH/lw7DeBtHfhdtgOPMbaW3yR6sGhudVV8LLcObBDmaC5ADQrZLCLsqf
         xLM/cO99Ad3OjcC02tmO/u28nCnMRAzTbx7G5ZExkxFMjltl83LjNN3+ByZdRvO+OB
         jDEd9r0OKhOf3sLH4DG5OBlFp8ZoMvyEpR4fc0rt8ARUmoF38BZRwDqYV7lhpEyWSg
         +ryd+mEy2531c6c01aqqq0sgzlMrww/vccGkrwgDawHgFyMm9MtTPYiZnRqik+iycw
         UGGCbyB+zJwRg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0FC5F609D6;
        Sat,  2 Oct 2021 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] Egress VLAN modification using VCAP ES0 on
 Ocelot switches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163318080805.29287.16850670192072060783.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Oct 2021 13:20:08 +0000
References: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        UNGLinuxDriver@microchip.com, xiaoliang.yang_1@nxp.com,
        po.liu@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  1 Oct 2021 18:15:25 +0300 you wrote:
> This patch set adds support for modifying a VLAN ID at the egress stage
> of Ocelot/Felix switch ports. It is useful for replicating a packet on
> multiple ports, and each egress port sends it using a different VLAN ID.
> 
> Tested by rewriting the VLAN ID of both
> (a) packets injected from the CPU port
> (b) packets received from an external station on a front-facing port
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: mscc: ocelot: support egress VLAN rewriting via VCAP ES0
    https://git.kernel.org/netdev/net-next/c/de5bbb6f7e4c
  - [net-next,2/6] net: mscc: ocelot: write full VLAN TCI in the injection header
    https://git.kernel.org/netdev/net-next/c/e8c0722927e8
  - [net-next,3/6] net: dsa: tag_ocelot: set the classified VLAN during xmit
    https://git.kernel.org/netdev/net-next/c/5ca721c54d86
  - [net-next,4/6] selftests: net: mscc: ocelot: bring up the ports automatically
    https://git.kernel.org/netdev/net-next/c/239f163ceabb
  - [net-next,5/6] selftests: net: mscc: ocelot: rename the VLAN modification test to ingress
    https://git.kernel.org/netdev/net-next/c/4a907f659461
  - [net-next,6/6] selftests: net: mscc: ocelot: add a test for egress VLAN modification
    https://git.kernel.org/netdev/net-next/c/434ef35095d6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


