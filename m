Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169A13E59C7
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238889AbhHJMU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231678AbhHJMU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 08:20:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B9DE060FC4;
        Tue, 10 Aug 2021 12:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628598005;
        bh=3dFZKIF+Zsxgd8Xlui1GCsSJd+CBbPdoffRbnA6DYRw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NGcKkUlvtyHmq5ECZXA6ClIIs4HiZQQ+aYxzoOeb4jlkxJWf1xvIpn2ypWk4PnDaP
         T4Dt82+AIwKTOp0CMCKpzhFq4mH+hn1yDIIt8cijfXyYgkWE9tsy5ueNTIg4x4lI5I
         iMX/phiNx5ylbM4UOWoIboBz6KQeRQUUJh0TMomLUulBgPD4KPR1fj4nC1agrb6EjR
         8dZs8jt4FvJE3f+8DTltIz1KruCPGeSze4X8H2ATwMmInmLaYuEmEo1Gvqmq/HJzGj
         RXsegFdLs3khjYVzsk7upgPCPfn+dr7be14pkWK3lrIT2IhpnvWCxDsV9rtB3cD/I+
         bkrqtPkCLHffg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AD4AF60A3B;
        Tue, 10 Aug 2021 12:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] Fix broken backpressure during FDB dump in DSA
 drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162859800570.4617.4885000656236273521.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Aug 2021 12:20:05 +0000
References: <20210810111956.1609499-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210810111956.1609499-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, kurt@linutronix.de, hauke@hauke-m.de,
        privat@egil-hjelmeland.no
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 10 Aug 2021 14:19:52 +0300 you wrote:
> rtnl_fdb_dump() has logic to split a dump of PF_BRIDGE neighbors into
> multiple netlink skbs if the buffer provided by user space is too small
> (one buffer will typically handle a few hundred FDB entries).
> 
> When the current buffer becomes full, nlmsg_put() in
> dsa_slave_port_fdb_do_dump() returns -EMSGSIZE and DSA saves the index
> of the last dumped FDB entry, returns to rtnl_fdb_dump() up to that
> point, and then the dump resumes on the same port with a new skb, and
> FDB entries up to the saved index are simply skipped.
> 
> [...]

Here is the summary with links:
  - [net,1/4] net: dsa: hellcreek: fix broken backpressure in .port_fdb_dump
    https://git.kernel.org/netdev/net/c/cd391280bf46
  - [net,2/4] net: dsa: lan9303: fix broken backpressure in .port_fdb_dump
    https://git.kernel.org/netdev/net/c/ada2fee185d8
  - [net,3/4] net: dsa: lantiq: fix broken backpressure in .port_fdb_dump
    https://git.kernel.org/netdev/net/c/871a73a1c8f5
  - [net,4/4] net: dsa: sja1105: fix broken backpressure in .port_fdb_dump
    https://git.kernel.org/netdev/net/c/21b52fed928e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


