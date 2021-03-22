Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB0D34509E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhCVUUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230060AbhCVUUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1DACE61992;
        Mon, 22 Mar 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616444408;
        bh=RKJLsMuuPVjLOqSAugNpnCjMxH5h0lHuTvEFxz9bC1A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fTUGFlAuma+82AqQJl4i2J9uP5/8w1Il/9AnSdelS5ce3JlGtxRbJOKqzgI109CW3
         xrdUv6sRH43e1p/ra5Ur/+cg2A6NPYAUB5pfY67xf9stVXx++b38/64bxgX4k8Rsd6
         xt5VeY8CHpnzoyf7hPWrJ8M3f74rbvOsNu6MDxbIckkVJczmwNMuKR4SgMiOsZzuOb
         JELGOu5qfI1lqk+gkggptQnC4ZY26l9rH1eJydH6/bLcQr2r3Xia+ZjudeE5Q2aoYi
         R4k4u9La8wXEwdXaJmy2/pqnyuVU4l2wZPUciWtPeIKIzIZ6EzcTnaYs5XpglzVZHm
         pHuQEBJMWq8Ew==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0C85160A49;
        Mon, 22 Mar 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: fix up kerneldoc some more
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644440804.26518.8381053935417453240.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:20:08 +0000
References: <20210322093009.3677265-1-olteanv@gmail.com>
In-Reply-To: <20210322093009.3677265-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 11:30:09 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Commit 0b5294483c35 ("net: dsa: mv88e6xxx: scratch: Fixup kerneldoc")
> has addressed some but not all kerneldoc warnings for the Global 2
> Scratch register accessors. Namely, we have some mismatches between
> the function names in the kerneldoc and the ones in the actual code.
> Let's adjust the comments so that they match the functions they're
> sitting next to.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: mv88e6xxx: fix up kerneldoc some more
    https://git.kernel.org/netdev/net-next/c/3de43dc98615

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


