Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0713F4937
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbhHWLBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234701AbhHWLAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C8476613A6;
        Mon, 23 Aug 2021 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629716407;
        bh=cz0bbQ1Q1z+9sVj/VZB0K/O5fBrJ3Z/yni9bjnkicKA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mDCtx/XI8C8sYuwNF/QNkRANpMsxaah83lhX/g84E7nJQ1y17yBTSw9xvUGxoFvII
         DXZrCwqXdUvIsl22QoS+qwccb6cC/DKZEYZzW60DSf/Qmxvx6hX9JABzbW2iRWicmt
         1y1tB5Z5ENi/sRMsMdC4y6/3mXMPehxzj/Q5EBZ8fqtyBJA7AFwVNNeWdCSKAGJGmK
         wLSOj2g+Vyj6RV7ilu1+mp5Z2dN1jjh5VdCAcC15rgF2BQARnAvoS4k6EP9tujIP3z
         qjF+Ob01GXVrxoAbiCOAZ44OGjkZeL9RW1MKTpI+AMRDRbp7h/RsIxyFtIbSkNZcjI
         pLeHwLH7J4HOg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C11BC60075;
        Mon, 23 Aug 2021 11:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] forcedeth: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971640778.3591.18261447981272325514.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:00:07 +0000
References: <099a3b5974f6b2be8770e180823e2883209a3691.1629615550.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <099a3b5974f6b2be8770e180823e2883209a3691.1629615550.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     rain.1986.08.12@gmail.com, zyjzyj2000@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 08:59:56 +0200 you wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below.
> 
> It has been hand modified to use 'dma_set_mask_and_coherent()' instead of
> 'pci_set_dma_mask()/pci_set_consistent_dma_mask()' when applicable.
> This is less verbose.
> 
> [...]

Here is the summary with links:
  - forcedeth: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/e5c88bc91bf6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


