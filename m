Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE423F4946
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbhHWLBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236274AbhHWLAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DF223613AB;
        Mon, 23 Aug 2021 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629716407;
        bh=MzSwV0lTBk4i1KqT3TrHU4iVl4GKTIU7ZXH1YvSTZeo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WxVX5YlfC3+vF2iWCUAQ4SWwzmMLs7HfQzg5JI9HEz5d51EpVMvLL5fpxVYX5qp/Z
         Q/y/IQ6fiTjXI1wNSQa03YmLtW6MhsHb0EW/uVhZRJAmn4igHXgtJDIRBtxDIxUWv8
         x3GDDkd0NU34XhlmZi22mfe7GAm2a8YdluER0rDYuMlQRsHAWrYdP518Pe4jz8Ze4J
         ShtKGgHgzZhpYnEQWgyE4to19InCTr7eQGbEmiZXypsYFKopxgTprfKK5vpB+n/MfT
         ZQnLirjgU5GVoQ3BKEbL6SDtLMiftveM7LaEfAmbkUsXJCcx8x+713A3/ga6pK79Lb
         cJMbCOtWH53aw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D6063609E6;
        Mon, 23 Aug 2021 11:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: atlantic: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971640787.3591.426575431897714096.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:00:07 +0000
References: <b263cad7a606091efb10392a81ee45f294f16bab.1629611296.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <b263cad7a606091efb10392a81ee45f294f16bab.1629611296.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     irusskikh@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 07:49:42 +0200 you wrote:
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
  - net: atlantic: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/3852e54e6736

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


