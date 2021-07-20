Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013AF3CFBA5
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239382AbhGTN2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239581AbhGTNT1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:19:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2BD316113C;
        Tue, 20 Jul 2021 14:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626789606;
        bh=z7Xxct4ZdTo7+Pf+bv3s3vIyGRuOusBnDQby+AtdVxg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T3s/NHKvZrzHbXE79ISLrvC+wQVReksEUhxGiXtcuC+m0vb+sxCCXEP1I/9cC99ze
         iy/5hBX2Lx3ktjiZQVZkax4LiQ1HMNs5iEOumVEgyMV47ZqIJZZEhSp9Dx//pnAThj
         EkynjyU10Rmq88tm1vVmgAX0ayghiN5VSLwEhu0CTOOnjuaULHDCcEusZs17B3XG+Z
         yXh70sVpwmHedNLs2MskGN3sum9C4sB0KXMQ8dOgPszKrGX1wKGRdCptg7cw6iWsMj
         nUExAGNUc3z3CjdplpR6/k+cE0z8Ljegd4bZj1hlZtKqd+bBtp0VCvBJvP7lvW3Wi1
         ZqVyHJL0xE8kg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1FF8960CCF;
        Tue, 20 Jul 2021 14:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] Proper cross-chip support for tag_8021q
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162678960612.2598.15355771539929660841.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:00:06 +0000
References: <20210719171452.463775-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210719171452.463775-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Jul 2021 20:14:41 +0300 you wrote:
> The cross-chip bridging support for tag_8021q/sja1105 introduced here:
> https://patchwork.ozlabs.org/project/netdev/cover/20200510163743.18032-1-olteanv@gmail.com/
> 
> took some shortcuts and is not reusable in other topologies except for
> the one it was written for: disjoint DSA trees. A diagram of this
> topology can be seen here:
> https://patchwork.ozlabs.org/project/netdev/patch/20200510163743.18032-3-olteanv@gmail.com/
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] net: dsa: sja1105: delete the best_effort_vlan_filtering mode
    https://git.kernel.org/netdev/net-next/c/0fac6aa098ed
  - [net-next,02/11] net: dsa: tag_8021q: use "err" consistently instead of "rc"
    https://git.kernel.org/netdev/net-next/c/a81a45744ba5
  - [net-next,03/11] net: dsa: tag_8021q: use symbolic error names
    https://git.kernel.org/netdev/net-next/c/69ebb3706471
  - [net-next,04/11] net: dsa: tag_8021q: remove struct packet_type declaration
    https://git.kernel.org/netdev/net-next/c/8afbea187d31
  - [net-next,05/11] net: dsa: tag_8021q: create dsa_tag_8021q_{register,unregister} helpers
    https://git.kernel.org/netdev/net-next/c/cedf467064b6
  - [net-next,06/11] net: dsa: build tag_8021q.c as part of DSA core
    https://git.kernel.org/netdev/net-next/c/8b6e638b4be2
  - [net-next,07/11] net: dsa: let the core manage the tag_8021q context
    https://git.kernel.org/netdev/net-next/c/d7b1fd520d5d
  - [net-next,08/11] net: dsa: make tag_8021q operations part of the core
    https://git.kernel.org/netdev/net-next/c/5da11eb40734
  - [net-next,09/11] net: dsa: tag_8021q: absorb dsa_8021q_setup into dsa_tag_8021q_{,un}register
    https://git.kernel.org/netdev/net-next/c/328621f6131f
  - [net-next,10/11] net: dsa: tag_8021q: manage RX VLANs dynamically at bridge join/leave time
    https://git.kernel.org/netdev/net-next/c/e19cc13c9c8a
  - [net-next,11/11] net: dsa: tag_8021q: add proper cross-chip notifier support
    https://git.kernel.org/netdev/net-next/c/c64b9c05045a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


