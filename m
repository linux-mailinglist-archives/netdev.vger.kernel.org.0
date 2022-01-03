Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422D9483011
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 11:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbiACKuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 05:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbiACKuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 05:50:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DA6C061784;
        Mon,  3 Jan 2022 02:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DBEC61025;
        Mon,  3 Jan 2022 10:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C3B1C36AF2;
        Mon,  3 Jan 2022 10:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641207009;
        bh=SbzhVYDA7q36z2bKdgU4rcWBPtBR6G7zZfQLH8PrWFk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UUX0YiaPjWOw7LxiIw0L/VEoiFtHiHVJOnAJNbXkWakqO4TXkfp0U7h7gPy6KguCy
         LVioZVqAEVO1LVvygfQobxYbhS1y/s6LJkUqsaTd6yMAN1wzUz9QbGbIBFUuj2oMHS
         TxjUMpORGWAj/oQcri0ahqzWslqWG9OxrIgE6xzpW69LcsYkEQ15c2ajeAjJ2MRTy5
         cYxKXTsuWRWucWUrHmn0PqpJqTc3LdiMGuQG+iEoAgm+Pafn3k69r6euoHeCslBzmw
         MrXAmftLb1ksLXqoiZZBhUAbPCKS6EGNabWEB/fOhMFb+FVT0JfGbA4q7cSHmjTUSU
         4DdNwGXnN9WSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7FD0EF79406;
        Mon,  3 Jan 2022 10:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: s2io: Use dma_set_mask_and_coherent() and simplify
 code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164120700951.2591.15379662570045379334.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Jan 2022 10:50:09 +0000
References: <e53afd59c8938bfaaa94cadd4621d40f54ec2102.1641155181.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <e53afd59c8938bfaaa94cadd4621d40f54ec2102.1641155181.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jdmason@kudzu.us, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  2 Jan 2022 21:27:39 +0100 you wrote:
> Use dma_set_mask_and_coherent() instead of unrolling it with some
> dma_set_mask()+dma_set_coherent_mask().
> 
> Moreover, as stated in [1], dma_set_mask() with a 64-bit mask will never
> fail if dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> [...]

Here is the summary with links:
  - ethernet: s2io: Use dma_set_mask_and_coherent() and simplify code
    https://git.kernel.org/netdev/net-next/c/7120075ec41a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


