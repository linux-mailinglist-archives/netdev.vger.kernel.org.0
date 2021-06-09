Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCDA3A1EDC
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhFIVWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229705AbhFIVWA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 17:22:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6F111613FA;
        Wed,  9 Jun 2021 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623273605;
        bh=RHgQaaanHOxiL9haoXsk34WiTVm8rODB788ONt6JJ2Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dXF4phI+yz8LF/EaOUEL+fzuekwa95ZV/F2JGBBbMULaWDnrKi3PQlPV60xs3KwgB
         gnNqpDPT5rSzxk/y4GOdqPFfzldBVcEqXtiNOf14JtM4I0CaTC6ordJMxFqGVqrp88
         +G7z8OsnCg0oO9/sByx4IADh+bC6FRItg7JmCn0m9Drb/EcAJ2S8cQxVJ4HTeAuklp
         QYCVDG0/Nskbrd2BcfOJibCYO0X/nDGuwgsarh8tA+IJu4YgMyXvwHF8bTsGcXh9js
         M+b3mgJ5d8R7qjnPQkHC8usEib71eI1Jg/ltdcpu2COXgQuqHUhM+HovCj7sqWCYnF
         vKwFkwSlpzXPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 66B1D60CD8;
        Wed,  9 Jun 2021 21:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2 net-next] net: dsa: qca8k: fix an endian bug in
 qca8k_get_ethtool_stats()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327360541.22106.9196909386261954573.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 21:20:05 +0000
References: <YMCPTLkZumD3Vv/X@mwanda>
In-Reply-To: <YMCPTLkZumD3Vv/X@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     andrew@lunn.ch, yangyingliang@huawei.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 12:52:12 +0300 you wrote:
> The "hi" variable is a u64 but the qca8k_read() writes to the top 32
> bits of it.  That will work on little endian systems but it's a bit
> subtle.  It's cleaner to make declare "hi" as a u32.  We will still need
> to cast it when we shift it later on in the function but that's fine.
> 
> Fixes: 7c9896e37807 ("net: dsa: qca8k: check return value of read functions correctly")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [1/2,net-next] net: dsa: qca8k: fix an endian bug in qca8k_get_ethtool_stats()
    https://git.kernel.org/netdev/net-next/c/aa3d020b22cb
  - [2/2,net-next] net: dsa: qca8k: check the correct variable in qca8k_set_mac_eee()
    https://git.kernel.org/netdev/net-next/c/3d0167f2a627

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


