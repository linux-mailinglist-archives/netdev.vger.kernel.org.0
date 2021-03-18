Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E08340FF8
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhCRVkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231371AbhCRVkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 17:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EA9B664F3B;
        Thu, 18 Mar 2021 21:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616103608;
        bh=m0zAM4hUYTKSk5fWq28xqrahxA1pDK50rl728x2+qNw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ibQqE7dpbLy69XRrWkHA43MRtRu3jh2gBoSB/ePSlt7ByypyWm+LMHw16bbO+Ord9
         bfgmP664wsMOs2THkMrZyVJnR8azMBSS3BMQ9hoGT7j8QaaaAEC03lMT2c29YPG18p
         JoR2pAeJKZSGl+M6XSMdtOgp0+hcq2bEM3zhETdNEWvVjBKSmmAswPqFEN51bY5304
         zc3UC5tG1gBlcD2r9tHgoNoZJvUiiKI1m67koEbMK4B9ODML5TZeY6w1+Cefm46MRB
         86fo+u0gVTg2dLf8TujLwyDgG1MX6PFbydPJJ+p6b/g9lP89iYE/GXnzoyRUQI0ayV
         oQv/ixuMB4mwA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DB8606097B;
        Thu, 18 Mar 2021 21:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next] net: dsa: b53: mmap: Add device tree support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161610360789.19574.15150183094848218576.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 21:40:07 +0000
References: <20210317092317.3922-1-noltari@gmail.com>
In-Reply-To: <20210317092317.3922-1-noltari@gmail.com>
To:     =?utf-8?q?=C3=81lvaro_Fern=C3=A1ndez_Rojas_=3Cnoltari=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     jonas.gorski@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Mar 2021 10:23:17 +0100 you wrote:
> Add device tree support to b53_mmap.c while keeping platform devices support.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_mmap.c | 55 ++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)

Here is the summary with links:
  - [v3,net-next] net: dsa: b53: mmap: Add device tree support
    https://git.kernel.org/netdev/net-next/c/a5538a777b73

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


