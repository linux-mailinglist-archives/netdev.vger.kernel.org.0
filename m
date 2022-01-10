Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB85488DAD
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbiAJBAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58964 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbiAJBAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8332A61024;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B27FCC36AF7;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776413;
        bh=+ziE6u4gMHEoVtKMZJxBxQqbLWQeAVqY75kUV7mJldY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jZvjAh3CGlofvUXk9YKjbTsCWzJxP7TVuznsirZzZrRr6ROCVLJf/WZ8rwTDEX3WK
         E0ki3VOpfPdyIahqTdG4d8G0vvCZGgAgOW9C+vWCcSRkLTcdZWl9PyeW2eEAOfUY3i
         BFQCrHPQL1WUnQ34Z5KGpq0a+gHjp0E7YxNUY7NrmMbIa0gmVvfPM/BZACWkdeNSQ+
         k1t5UvAC70z/nhUNmDKj5TqGV2uobyakx6aRkJdvv5EoRSzd2adQzEYVFiOBI6UmZr
         09uyU4VzZVRITzxx3fsteMDuExo9lgLj0YfXxEKn0ZscEIwcLS0SO3r+tEYThcQuNg
         6IoFoeeQ08fJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9DA32F6078A;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/qla3xxx: Remove useless DMA-32 fallback configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641363.18208.17313046529605342305.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:13 +0000
References: <3011689e8c77d49d7e44509d5a8241320ec408c5.1641754134.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <3011689e8c77d49d7e44509d5a8241320ec408c5.1641754134.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 19:49:09 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> So, if dma_set_mask_and_coherent() succeeds, 'pci_using_dac' is known to be
> 1.
> 
> [...]

Here is the summary with links:
  - net/qla3xxx: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/0959a82ab3e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


