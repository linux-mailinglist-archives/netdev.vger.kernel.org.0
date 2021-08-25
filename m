Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4859B3F7420
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 13:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhHYLK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 07:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239348AbhHYLKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 07:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B728A61176;
        Wed, 25 Aug 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629889806;
        bh=MW6WfsVF/MBHVUSWsNSjGMbloXBquDJfpjTU7Qwxtsk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dZuWjHedMm91y/t5yzNzWcQTmG0HXhMiEPj8iAvSGR1lB4av3Gl06nZZIB0cDx51s
         +9c/dd9HheVWRxavvl6h+WBWXyQojhZ7ahy3vYED3ongjlnUTavEDPKrOVVRKLPVeF
         yjhWk+80u6zscbQUt4lC0UM42b6YZdV/K/Wkx1Is6QAOUGYjEA9PYGIqN5CXpngXs/
         7Oag0sbw8BF/Kqm1krB2R/vtH2XWcOZTEzJjD3yiqEs8wLr2Z8a0REBQesuEeBc0Kw
         7V/gyeU/Gr0lj0Bnw0+VMRCe0z0jurJ5+Uf5kWuCXrogRygPS1DUflLMMeOzO+oK19
         ST0T9RITQLjCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AF45D60A12;
        Wed, 25 Aug 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-af: cn10k: Set cache lines for NPA batch
 alloc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988980671.32654.4066360381521838364.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 11:10:06 +0000
References: <20210825053503.3506-1-gakula@marvell.com>
In-Reply-To: <20210825053503.3506-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 11:05:03 +0530 you wrote:
> Set NPA batch allocation engine to process 35 cache lines
> per turn on CN10k platform.
> 
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h    |  1 +
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c | 11 +++++++++++
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h |  1 +
>  3 files changed, 13 insertions(+)

Here is the summary with links:
  - [net-next] octeontx2-af: cn10k: Set cache lines for NPA batch alloc
    https://git.kernel.org/netdev/net-next/c/ae2c341eb010

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


