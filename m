Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4293012A9
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 04:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbhAWDbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 22:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726411AbhAWDax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 22:30:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3723123B1B;
        Sat, 23 Jan 2021 03:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611372610;
        bh=z9jdhsea+Q6TgBR+mLjLHfv29yeMzHEfdFldrFyLry0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MTWrxmY/SCEETCzrILIUEO7PP4Tua7haMKyVASPFnesIVv1NMHf3nvadFD+/aRPBR
         11166n7rld+G65Btfy36wHbqlOaEEun6SD2YNeEG70kaFZJFHlc0zkQFAcNfynI74r
         tvIyd0EfRmff7s0DmI+3i1gvnhQCyct0ENfm93jrnA8eivaPdlWVsMKdXNv0oXvLvZ
         /WU/cYMnxn4roPXog9eomb4QpQvZ0+O54TzaQ0BEN84nsN1W9U3I1U/DOPSt2ZTDjW
         hVWlJrVPpgl8/E8Gofk0QJJ6P7E8ScgKmPm2tnRagPz21TKbNgqaW1TPA7MOfSRTVb
         HwzxIDayR+ZMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2936861E44;
        Sat, 23 Jan 2021 03:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fec: put child node on error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161137261016.31547.3601501374256728793.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 03:30:10 +0000
References: <20210120122037.83897-1-bianpan2016@163.com>
In-Reply-To: <20210120122037.83897-1-bianpan2016@163.com>
To:     Pan Bian <bianpan2016@163.com>
Cc:     fugang.duan@nxp.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 20 Jan 2021 04:20:37 -0800 you wrote:
> Also decrement the reference count of child device on error path.
> 
> Fixes: 3e782985cb3c ("net: ethernet: fec: Allow configuration of MDIO bus speed")
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - net: fec: put child node on error path
    https://git.kernel.org/netdev/net/c/0607a2cddb60

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


