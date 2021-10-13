Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1153442CEF7
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 01:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhJMXMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 19:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhJMXML (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 19:12:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1C72610E5;
        Wed, 13 Oct 2021 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634166607;
        bh=YT88HvwtQqCkRzXG01FoXCYDxGZOiK9aoCMX0zpekuw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pFugk1ojBgBxgoedTzStZPPBu/FIbV2LjCzHtGtZRAkcV7dPh15qnslKYiTCKTlin
         DnLxM76SlEhJBt0gEHTRZpmknkD5h1OBWcqPsFljEbSqOly6t7MkVrXReo3jU351ss
         XTJb2VGs6lGc+OYNrpvD2ToldKoOt0APJs8+1HLjcrc9dK+4a+BeOro/kIzI2W7u0V
         LPCwpb980tucC2lEdBIzzDauLusId70WKOPO2cga3WJyikODwgcZAOhOVxDpcRQaIT
         O3N2kIB5vu30TyWQZOkAboOtMemHjm1CYo9ZnlxBznqoWoJgWF+zqJil92KzAlfqN8
         f9h+Txmlh1vGQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A186A609EF;
        Wed, 13 Oct 2021 23:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: enetc: fix check for allocation failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163416660765.3789.13047481487353758359.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 23:10:07 +0000
References: <20211013080456.GC6010@kili>
In-Reply-To: <20211013080456.GC6010@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     claudiu.manoil@nxp.com, ioana.ciornei@nxp.com, davem@davemloft.net,
        kuba@kernel.org, vladimir.oltean@nxp.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 11:04:56 +0300 you wrote:
> This was supposed to be a check for if dma_alloc_coherent() failed
> but it has a copy and paste bug so it will not work.
> 
> Fixes: fb8629e2cbfc ("net: enetc: add support for software TSO")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: enetc: fix check for allocation failure
    https://git.kernel.org/netdev/net-next/c/e79d82643a69

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


