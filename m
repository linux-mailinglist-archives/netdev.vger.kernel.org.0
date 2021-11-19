Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DA945707D
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbhKSOXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:23:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234153AbhKSOXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:23:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 737A161AD0;
        Fri, 19 Nov 2021 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637331609;
        bh=pjpzP9H3wrBaZrYocYGO8qrHvgn5vKMBZS1Zg+A2dZs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lyKSqcQrOB3rmrtZvv132yaGMwMrTX9NC0PSogPTKazSaOmL0+r95F11tcQmRLfRH
         4d/jtdikxoOqGu11XMXjBy59uBpE2xSAfmFddByT17I8EnJHoHS11fB7LtZQl4QSh3
         9Nt6sHpN+v7kna/ak+Qzod2BDDrI7LkazQwp77sWbyp0haZNpoeqtAjhlBO2wDE6YV
         Vy7jdgFTCMHHc6eQeHUs5Fzx8FMEca+D1jqVatqtrbez7+VL+ElSPf3x+N6chpsvge
         eu0WRoO4zHykRQwIx5lK1M3v12wc/zFD/4XZ0T1V+f3+7wRDKUA4qlOsL2alCLUSgy
         pEgffhjkVer/w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 62C206096E;
        Fri, 19 Nov 2021 14:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/bridge: replace simple_strtoul to kstrtol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163733160939.14640.16666157203692458688.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 14:20:09 +0000
References: <20211119020642.108397-1-bernard@vivo.com>
In-Reply-To: <20211119020642.108397-1-bernard@vivo.com>
To:     Bernard Zhao <bernard@vivo.com>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 18:06:42 -0800 you wrote:
> simple_strtoull is obsolete, use kstrtol instead.
> 
> Signed-off-by: Bernard Zhao <bernard@vivo.com>
> ---
>  net/bridge/br_sysfs_br.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Here is the summary with links:
  - net/bridge: replace simple_strtoul to kstrtol
    https://git.kernel.org/netdev/net-next/c/520fbdf7fb19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


