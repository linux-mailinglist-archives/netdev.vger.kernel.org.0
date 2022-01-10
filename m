Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89818488DBD
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237834AbiAJBAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237706AbiAJBAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ED7C061759;
        Sun,  9 Jan 2022 17:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99B08610B1;
        Mon, 10 Jan 2022 01:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E3F8C36B05;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776414;
        bh=5sGKHwQLcc0uI7UUKPMUMJ+K16sM+enGXEpslH1mAoM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EVYxy1Xi5FWf0mDyniZPi/nJBn1f0F0aLrqDc2KXGPMQiVKc8ujwEaUTHw1lLwM8E
         ZG7gDEzdyPSAheNvNWLaeYe3Sb8B3BvPiO3CVgnULGb7+0h3nzvSYLv3pDivWCfvsH
         h8s1V+o6AEaVGsq+3QGQVab9ghcbrZQ3052KZUj8tvUdHKm2eoEjHfuBJ+E/uWQDN+
         byW33LOq2DVrjQYYR45NjnzurHKEC8uV4RgCzWjM6SmJ49aXZEFBfn+qsYJbL+cbfI
         eY8EIv1iV5Mimpuo74Dfu13OuMK3GSp4W3kWncYpFGuUncZ9EyigDkHEb7cqOQ0c7z
         IW+n0JIznk9Lw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F0A36F60790;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] et131x: Remove useless DMA-32 fallback configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641397.18208.6020269866763474619.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:13 +0000
References: <b9aa46e7e5a5aa61f56aac5ea439930f41ad9946.1641726804.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <b9aa46e7e5a5aa61f56aac5ea439930f41ad9946.1641726804.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     mark.einon@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 12:13:47 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> Moreover, dma_set_mask_and_coherent() returns 0 or -EIO, so the return
> code of the function can be used directly. There is no need to 'rc = -EIO'
> explicitly.
> 
> [...]

Here is the summary with links:
  - et131x: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/948f6b297f6d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


