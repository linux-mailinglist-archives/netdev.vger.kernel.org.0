Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080633019A6
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 06:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbhAXFU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 00:20:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbhAXFUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 00:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 219B722C9F;
        Sun, 24 Jan 2021 05:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611465610;
        bh=XQAyljCTeoPLjH7R46uB+f6nJPk3HdHW+6ZH781W++Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R53ehTbif+Scu4y8QK7LOz/rVtxdGZVhCJq6wDuVX2F4A2yjbWGlZG6yreuFwGjLJ
         0E+iL4XeGuGKYNvR9hXqQ5Y9J8XstlMN154ipitqHe2YMw8KttjiT07TMESsH97enO
         aVXuNRKPRDTxmsJqpr2oQWAseInSOi78ra7K6PKCr7b2SK0bi0OdDbyJTaaQI/flg5
         ilFg6euqOLwwyGiekHJifwuBC0TX4n/srpiuX28t7pkgjiPkGIztxWlrBfVzhFMPmR
         qNyiYR+V5W851YGvWWSIvmgnmWheM9+MgcjAmkcWKckJT/FiOD9a/yhVqf2dE6jFQW
         eNN5EeNM0pGUQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1236D652F4;
        Sun, 24 Jan 2021 05:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/2] udp: allow forwarding of plain
 (non-fraglisted) UDP GRO packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161146561006.2035.8336075906979964296.git-patchwork-notify@kernel.org>
Date:   Sun, 24 Jan 2021 05:20:10 +0000
References: <20210122181909.36340-1-alobakin@pm.me>
In-Reply-To: <20210122181909.36340-1-alobakin@pm.me>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        willemb@google.com, steffen.klassert@secunet.com,
        alexander.duyck@gmail.com, pabeni@redhat.com,
        irusskikh@marvell.com, mchehab+huawei@kernel.org,
        linmiaohe@huawei.com, atenart@kernel.org, mkubecek@suse.cz,
        andrew@lunn.ch, meirl@mellanox.com, ayal@mellanox.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 22 Jan 2021 18:19:36 +0000 you wrote:
> This series allows to form UDP GRO packets in cases without sockets
> (for forwarding). To not change the current datapath, this is
> performed only when the new corresponding netdev feature is enabled
> via Ethtool (and fraglisted GRO is disabled).
> Prior to this point, only fraglisted UDP GRO was available. Plain UDP
> GRO shows better forwarding performance when a target NIC is capable
> of GSO UDP offload.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/2] net: introduce a netdev feature for UDP GRO forwarding
    https://git.kernel.org/netdev/net-next/c/6f1c0ea133a6
  - [v4,net-next,2/2] udp: allow forwarding of plain (non-fraglisted) UDP GRO packets
    https://git.kernel.org/netdev/net-next/c/36707061d6ba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


