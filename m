Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552AD43350C
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbhJSLwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235424AbhJSLwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E11046135E;
        Tue, 19 Oct 2021 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634644210;
        bh=yrCKAtJRKARWO1pv7kgSVgDZL0nsVkfziNVKEGnxBOw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AmmSEl12jYWGKBiaO131HxgYkw2oadrf8AA3dMIb4MAYTzwNyh+ngaIBWZk1OPE9f
         PE97Y+pgNTpXY8KCntvEx5Vv0a14MBygPeafGny01UpELXSQHNGd8q/mXgD4QTp6LO
         zliUlHMtIs8qV4BLz0Gm3vOQ/k/qcFmim/yv/ji8tkwk9XhN7FuhjH9GebM4kPVpkw
         Yv510VLtW87AMmYPHY4uFNkP28We9qOcpMf1LWHy9r0YSSchXsZUC7ULCYxX+cteqi
         8xRUKW6l5HbzyG99jtTo+KdmcMj4qEiE3ork2JhoVWztLxmyKPgRIodUf496+uJ9fu
         BmNSJKWQ4jbPw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CF10A60A2E;
        Tue, 19 Oct 2021 11:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] ethernet: add eth_hw_addr_gen() for switches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163464421084.25315.11913258060341461680.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Oct 2021 11:50:10 +0000
References: <20211018211007.1185777-1-kuba@kernel.org>
In-Reply-To: <20211018211007.1185777-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, olteanv@gmail.com,
        andrew@lunn.ch, idosch@idosch.org, f.fainelli@gmail.com,
        snelson@pensando.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Oct 2021 14:10:01 -0700 you wrote:
> While doing the last polishing of the drivers/ethernet
> changes I realized we have a handful of drivers offsetting
> some base MAC addr by an id. So I decided to add a helper
> for it. The helper takes care of wrapping which is probably
> not 100% necessary but seems like a good idea. And it saves
> driver side LoC (the diffstat is actually negative if we
> compare against the changes I'd have to make if I was to
> convert all these drivers to not operate directly on
> netdev->dev_addr).
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] ethernet: add a helper for assigning port addresses
    https://git.kernel.org/netdev/net-next/c/e80094a473ee
  - [net-next,2/6] ethernet: ocelot: use eth_hw_addr_gen()
    https://git.kernel.org/netdev/net-next/c/53fdcce6ab93
  - [net-next,3/6] ethernet: prestera: use eth_hw_addr_gen()
    https://git.kernel.org/netdev/net-next/c/8eb8192ea291
  - [net-next,4/6] ethernet: fec: use eth_hw_addr_gen()
    https://git.kernel.org/netdev/net-next/c/ba3fdfe32bb9
  - [net-next,5/6] ethernet: mlxsw: use eth_hw_addr_gen()
    https://git.kernel.org/netdev/net-next/c/be7550549e26
  - [net-next,6/6] ethernet: sparx5: use eth_hw_addr_gen()
    https://git.kernel.org/netdev/net-next/c/07a7ec9bdafe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


