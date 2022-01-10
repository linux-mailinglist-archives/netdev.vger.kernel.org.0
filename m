Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F89488DD5
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237885AbiAJBBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237710AbiAJBAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33251C06173F;
        Sun,  9 Jan 2022 17:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1F67B8107E;
        Mon, 10 Jan 2022 01:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E106BC36B00;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776413;
        bh=VpangOOnpt0ukTyq24Jtwcc3dfIcvFjJbhrGOehektc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MMaKBLyZAWByIs3kl+XrCxXinaxcOaR3k5coH5bvTMVLeiv9RjVQs7vAjOmSI4HOI
         7UO+Qv5rJH2/Ml1DBUlJF/6q/cx6U9SZNkqPJzTez+Ob4cfyX0/aw+3bme5drzIkmJ
         DqRrGQs5qqOKiqT1IdX5fVhKWf1GtAEAeAioJJGrQJhcLRPfiLAtracaAin/KMUKaN
         SAV7mDfY0V58JdfYSli9XsoFLDGyMF/pvzgzlFvxS8/ANIyk16JTRq4Vga3+4PAZXs
         3SlpMWp3wU6of4qGoLSQF5x5rdjvBo4wamO6Y1MhPA4i09GGB90/z4++XQPE3hXnlk
         ogwG4gS4Qui5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC19CF60791;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cxgb4vf: Remove useless DMA-32 fallback configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641383.18208.3252343831825663806.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:13 +0000
References: <b14986ea39cea2ca9a6cd0476a3fc167c853ee67.1641736772.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <b14986ea39cea2ca9a6cd0476a3fc167c853ee67.1641736772.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 14:59:48 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> So, if dma_set_mask_and_coherent() succeeds, 'pci_using_dac' is known to be
> 1.
> 
> [...]

Here is the summary with links:
  - cxgb4vf: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/030f9ce8c739

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


