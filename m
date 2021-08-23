Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD3E3F4948
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbhHWLBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236235AbhHWLAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:00:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 09C20613B1;
        Mon, 23 Aug 2021 11:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629716408;
        bh=8HGclWzR81QL4Yk4wfsRv82YFp1to8I/OHLbpHAmeII=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tRs+aHuhvSIxuuStj4nSWbyxYIzDqOBVNjqvH7KX6gUBT1twOhZyQQlHMQpkhHqKo
         hBVC/vSB1BIfzlG/2H60MA9kNNHmZpp6cYBMXLZwRmtdXJ+Cw5MCXXvN9MM05o0VFY
         U5WRDAYEOUk4we9Uz+54FHPgS9pb4NEwL7Asfu0NJxjER3ksEJaYE5jL6hlW2Ykj2O
         M1uYNejaon+mtbMImYW7C9j4VDCq5vdNr+RjYEEbCtLNeiet2AIxISI6e9nRfxiH75
         GRq6rGtNalZk11HUFkeBkkmNVK0XVAHsWfsqySGsZfbf0xIe/88sdOsRi4scmMijeh
         ts/qLJ3U/aoWQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 00AF760A27;
        Mon, 23 Aug 2021 11:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wwan: iosm: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971640799.3591.7646976374159678225.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:00:07 +0000
References: <a0a70eb0a65f16d870ecf2a14d7a8e931bc63d2e.1629579202.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <a0a70eb0a65f16d870ecf2a14d7a8e931bc63d2e.1629579202.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 21 Aug 2021 22:54:57 +0200 you wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> 'ipc_protocol_init()' can use GFP_KERNEL, because this flag is already used
> by a 'kzalloc()' call a few lines above.
> 
> [...]

Here is the summary with links:
  - net: wwan: iosm: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/44ee76581dec

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


