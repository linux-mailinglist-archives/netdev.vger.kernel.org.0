Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFAE33DC73
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239951AbhCPSUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239929AbhCPSUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 14:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1073365118;
        Tue, 16 Mar 2021 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615918809;
        bh=HvcsB/hi5GN9lTrvJwCAV4Ygw98ipyEXZHU/H6nrkYE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lwbhQPWFZYljWTV/CYYGHr1cEnwJrwdQkAKZ37PTdM1dI6jbRGEU2mxOrdMN/c7Gt
         Sp2HlPP40hF78aiiXMr6fBH8tYEfeebFqkKoJqP+BwiFQHA9cVXAj+UURyQ/VJtWXS
         Ef544AKbK6tEMVvKG+7iksYP56fPcln02NFFB/5YZvbox4LntUneFWDXJZFN22xZfp
         uIGyLuUzlClQB0f+PrvTyUdSLXDdC63wxDEulJRpcqSOxh9vBMiGeixw8zpKQwhCti
         b1/OB/qSJPfz7jHDGWrlZvHuVchWk0y6cqc2vG++Q/fiWBULebd6fMOEFdeXp+JH6x
         UOWYoa3rKxWYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 01D3260A64;
        Tue, 16 Mar 2021 18:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: b53: spi: allow device tree probing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161591880900.7330.14719960948156317517.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 18:20:09 +0000
References: <20210315141423.1373-1-noltari@gmail.com>
In-Reply-To: <20210315141423.1373-1-noltari@gmail.com>
To:     =?utf-8?q?=C3=81lvaro_Fern=C3=A1ndez_Rojas_=3Cnoltari=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Mar 2021 15:14:23 +0100 you wrote:
> Add missing of_match_table to allow device tree probing.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_spi.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

Here is the summary with links:
  - [net-next] net: dsa: b53: spi: allow device tree probing
    https://git.kernel.org/netdev/net-next/c/6d16eadab6db

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


