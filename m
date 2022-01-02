Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459EE482B10
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 13:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbiABMaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 07:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiABMaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 07:30:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4729AC061574;
        Sun,  2 Jan 2022 04:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DEDF60DB7;
        Sun,  2 Jan 2022 12:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89071C36AEF;
        Sun,  2 Jan 2022 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641126609;
        bh=Wx+p0zyVVdHGduaZN7x2rcFLrjFDa5RSk/huOH4JUpY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZAwfxGSD29qU50hP6WBT3AMPAcVCkz954SKPZdHTf424PXKYZ+oxxkUezK0yAtBjh
         r5Y4xVtql8ZmVCY0sOIqxWzEMfqlItP62brstQkfphL3MDw6VHo2AtUblTALbXQMJ2
         1IU2PFPmFhiqn7WZF96SyMVraZCOWypUA0BPws/6krkFxjBKTkSE1J5g5RiFGCR5X5
         F8LNe9Y5l36Z9s0UG6xYrhv9pOAe+MzeLWI3QzatTVbj4N1iwvP2SoMLrWcxZPXokg
         MrL7BSmR/gbD+S3L8sfR/Sc912024y5WbYqV+Ur6cu7DHseJSE1HHDj3PdbI0ZcgQd
         Q0zEybP0APZvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7075FC32795;
        Sun,  2 Jan 2022 12:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tehuti: Use dma_set_mask_and_coherent() and simplify code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164112660945.27407.16970759722892876593.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 12:30:09 +0000
References: <b1efca5650e17c5e21cb880dbdf71c93e3c77f36.1641048461.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <b1efca5650e17c5e21cb880dbdf71c93e3c77f36.1641048461.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  1 Jan 2022 15:48:25 +0100 you wrote:
> Use dma_set_mask_and_coherent() instead of unrolling it with some
> dma_set_mask()+dma_set_coherent_mask().
> 
> Moreover, as stated in [1], dma_set_mask_and_coherent() with a 64-bit mask
> will never fail if dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> [...]

Here is the summary with links:
  - tehuti: Use dma_set_mask_and_coherent() and simplify code
    https://git.kernel.org/netdev/net-next/c/c95e078069bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


