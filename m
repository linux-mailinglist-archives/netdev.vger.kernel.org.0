Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B21488DC8
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237917AbiAJBAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237733AbiAJBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9F4C061751;
        Sun,  9 Jan 2022 17:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B506B8108E;
        Mon, 10 Jan 2022 01:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39C30C36B0C;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776414;
        bh=7Nuqy5cbvoYALOLWhivsBWhhOpiniaWaV5F+QOXK7m0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DOR8qbDPFCT6btjCrublBauBlDGgudGoY2qbR6ZgYcZ9IYPeg2Bnf1Vm3Px3j3hJM
         uxpC2JA2DRw6W0koSCOeAwSbc0ltJYNiODPcn8wnDWmy7CU1C5OSakFas7dLtZpeog
         Oypi+1PToXDQb4pZqW75nmtpTg97ab/Vq6UJw41Hwf8HoANZ2m+jGqo+kexVfg3tK+
         J4U+IFQTLkD0r5npCyi8TCgpBroSaXCAjpbEw4fVnu06p71nY4C4osvyf9yvsSc2iQ
         sgaqA7gD0bejfHXLFdKrtk15PjpN5Z/ARI3h0sm/97Dv+biIdWdZLnqY1yHMsSMK7w
         xn8/f0SGeqv4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 278C2F6078A;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnx2x: Remove useless DMA-32 fallback configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641415.18208.6978874619681470579.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:14 +0000
References: <29608a525876afddceabf8f11b2ba606da8748fc.1641730747.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <29608a525876afddceabf8f11b2ba606da8748fc.1641730747.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 13:19:28 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> Moreover, dma_set_mask_and_coherent() returns 0 or -EIO, so the return
> code of the function can be used directly.
> 
> [...]

Here is the summary with links:
  - bnx2x: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/3aa440503be5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


