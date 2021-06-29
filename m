Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A653B7767
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 19:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbhF2Rwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 13:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhF2Rwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 13:52:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E49A61DC8;
        Tue, 29 Jun 2021 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624989006;
        bh=D7zX8Vvn5Nvdr5GMBCI1hETZd+uLvp8YCBT4Kb/r/gY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XW2Av6Pcul9X//Ci6wwv88LqKV5LjOcCEkWuy19tsD17hpVvoUccO+cahctB+Z6Rk
         uuTgnw71xwQ3bvUjDvx2SWk/SnRTuMaQRjtKJ0m1UQY2QYk3ia+XZZZ45M5+PG/2GS
         UZ4CBvEepdV7s0dA8c7Wqks2opPCGZM6oJkvtLWaqJEVe5gTIBg1xmCix/B+7QJfkV
         rEhBlnOLx8gm+Dv3dK+bDpfrRrjRc0rNZ+8qGZQGymwaXXpgahHCqaW0o4cOuE3n38
         Hv4RgVB9vgeqZVCr15hILRtu68uUBZnKO72cM3aZTWveBifrYudUjkO5aajtY8yaQr
         yH5Ts5lIYC1pw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5DE6860ACA;
        Tue, 29 Jun 2021 17:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 00/15] RX filtering in DSA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162498900637.32370.6838402243574308383.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Jun 2021 17:50:06 +0000
References: <20210629140658.2510288-1-olteanv@gmail.com>
In-Reply-To: <20210629140658.2510288-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@resnulli.us, idosch@idosch.org, tobias@waldekranz.com,
        roopa@nvidia.com, nikolay@nvidia.com,
        bridge@lists.linux-foundation.org, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 29 Jun 2021 17:06:43 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is my 5th stab at creating a list of unicast and multicast
> addresses that the DSA CPU ports must trap. I am reusing a lot of
> Tobias's work which he submitted here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210116012515.3152-1-tobias@waldekranz.com/
> 
> [...]

Here is the summary with links:
  - [v5,net-next,01/15] net: bridge: use READ_ONCE() and WRITE_ONCE() compiler barriers for fdb->dst
    https://git.kernel.org/netdev/net-next/c/3e19ae7c6fd6
  - [v5,net-next,02/15] net: bridge: switchdev: send FDB notifications for host addresses
    https://git.kernel.org/netdev/net-next/c/6eb38bf8eb90
  - [v5,net-next,03/15] net: bridge: allow br_fdb_replay to be called for the bridge device
    https://git.kernel.org/netdev/net-next/c/f851a721a638
  - [v5,net-next,04/15] net: dsa: delete dsa_legacy_fdb_add and dsa_legacy_fdb_del
    https://git.kernel.org/netdev/net-next/c/b117e1e8a86d
  - [v5,net-next,05/15] net: dsa: introduce dsa_is_upstream_port and dsa_switch_is_upstream_of
    https://git.kernel.org/netdev/net-next/c/63609c8fac40
  - [v5,net-next,06/15] net: dsa: introduce a separate cross-chip notifier type for host MDBs
    https://git.kernel.org/netdev/net-next/c/b8e997c49003
  - [v5,net-next,07/15] net: dsa: reference count the MDB entries at the cross-chip notifier level
    https://git.kernel.org/netdev/net-next/c/161ca59d39e9
  - [v5,net-next,08/15] net: dsa: introduce a separate cross-chip notifier type for host FDBs
    https://git.kernel.org/netdev/net-next/c/3dc80afc5098
  - [v5,net-next,09/15] net: dsa: reference count the FDB addresses at the cross-chip notifier level
    https://git.kernel.org/netdev/net-next/c/3f6e32f92a02
  - [v5,net-next,10/15] net: dsa: install the host MDB and FDB entries in the master's RX filter
    https://git.kernel.org/netdev/net-next/c/26ee7b06a4d3
  - [v5,net-next,11/15] net: dsa: sync static FDB entries on foreign interfaces to hardware
    https://git.kernel.org/netdev/net-next/c/3068d466a67e
  - [v5,net-next,12/15] net: dsa: include bridge addresses which are local in the host fdb list
    https://git.kernel.org/netdev/net-next/c/10fae4ac89ce
  - [v5,net-next,13/15] net: dsa: include fdb entries pointing to bridge in the host fdb list
    https://git.kernel.org/netdev/net-next/c/81a619f78759
  - [v5,net-next,14/15] net: dsa: ensure during dsa_fdb_offload_notify that dev_hold and dev_put are on the same dev
    https://git.kernel.org/netdev/net-next/c/4bed397c3e65
  - [v5,net-next,15/15] net: dsa: replay the local bridge FDB entries pointing to the bridge dev too
    https://git.kernel.org/netdev/net-next/c/63c51453c82c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


