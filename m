Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC94482BE5
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbiABQUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:20:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49606 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbiABQUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 383C1B80DC0;
        Sun,  2 Jan 2022 16:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06207C36AFA;
        Sun,  2 Jan 2022 16:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641140410;
        bh=3IKkUpkgQY4/Z4KSOOJNzWd8+Mxwytd8v5Qlwl+PGIQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TwXTHXDNcU4oIx0uo6m6SAxaKxDEXD0QcV6vb5y7V7ZLqgOhPpIU1cGxXqTyjhTo1
         eH3teyJOExCy/ag0RjCNa4xqUGYokj0AXgp2TRCCaL2GEsNqa01/qpiSbPQ+RkrVhC
         K5+HEoPiLkfTLZqku0o135wI1pmraG1U/1VOyLbIUEKXAOBGMe0mbY35LVqE2wwtrZ
         2nLxmo1vptbUeHhSnl/kYmbxZrDm2db8/WviTP9NNqq++wBb6ivamAmu2OJT2YBTKe
         H6yYPrd2VFlTHpI7mcLfAD/qOwCtu98sXpgvbYPr0xCH9nQw+V+csfvcJsCugWnZUW
         M4yZ+jBeCMMdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6E53C395E5;
        Sun,  2 Jan 2022 16:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: Use dma_set_mask_and_coherent() and simplify code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164114040994.20715.4612362659004680767.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 16:20:09 +0000
References: <40af8d810ef06bb10f45e54a61494b5c42038841.1641115135.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <40af8d810ef06bb10f45e54a61494b5c42038841.1641115135.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  2 Jan 2022 10:20:05 +0100 you wrote:
> Use dma_set_mask_and_coherent() instead of unrolling it with some
> dma_set_mask()+dma_set_coherent_mask().
> 
> Moreover, as stated in [1], dma_set_mask() with a 64-bit mask will never
> fail if dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> [...]

Here is the summary with links:
  - qed: Use dma_set_mask_and_coherent() and simplify code
    https://git.kernel.org/netdev/net-next/c/4f9f531e1505

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


