Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5799488DC1
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbiAJBAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50630 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237701AbiAJBAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C32D0B81074;
        Mon, 10 Jan 2022 01:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA282C36AFF;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776414;
        bh=vN6e6D6ePi/7XcPvpUOrxzvwt3BwPKO6Jc1pk/krqXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AaH717dhuoa4E4y4g1Cjhqw9e6IphmoR+zrfaV/de6ZoEjvgQ/wrwVhUtUafc/VvN
         jjJNXVnXQ/6BcCwqS63wBIMFJ1nFxJbqTD91zXTEHPPsfB45bh150baI5TsaOyEOS3
         tuWE2hd/HL9f2X1RBEN3bCvLaNKeGyztbyU/+5BnjqKt1PRxzMdVW+OKGry9HmNYjt
         sqberu9XIyNNQj2rksKi76mycqjK01me1KaVPVEHsUnwYa0OVVD79O9dmB1KdNG9oo
         qzJSTvHmDI7iaWH6zfunmmwPecROIo6uJzrejFDMrsF+n2C3e/JMRoVkF1SkwrMTtx
         XMZ9dOf8Kt0bw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D77EDF6078A;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] lan743x: Remove useless DMA-32 fallback configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641387.18208.17152384682238321722.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:13 +0000
References: <ef548716606f257939df9738a801f15b6edf2568.1641743405.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <ef548716606f257939df9738a801f15b6edf2568.1641743405.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 16:50:19 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> Simplify code and remove some dead code accordingly.
> 
> [1]: https://lkml.org/lkml/2021/6/7/398
> 
> [...]

Here is the summary with links:
  - lan743x: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/e20a471256b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


