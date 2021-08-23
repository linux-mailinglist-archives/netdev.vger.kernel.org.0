Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172033F4978
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236639AbhHWLLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236327AbhHWLK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:10:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8CFBE613B1;
        Mon, 23 Aug 2021 11:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629717015;
        bh=5mnGAY1S2smK5cym/PowpIkQEKvf0bvBIurkYoyPCs8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rgvjcbYD/CmLFZGxWO63BZI4GHMkLmTltc9WzrhZM56+7rIm0kxb4zHXsSRQ8gPSe
         scIjOE7HpcIG/bFot7sfWODt3izhAr4Aqy8TfShoSIq7Mt9INr5irRB/Jre5CS7RUg
         kN9ozejydwVJx0+ihZHw1EqFeSb+hnvqP22JtLe+we6OuX0uKJatRhQh7DKpKSx8lD
         XZ1VkzI7+HVOoL9DLZvhDP2nOaBiJnKJBBtMnFJqUohv5pBq69xkPeuM/pewB8kt3o
         odpAV4D//s4KihIBOVxZIPXZHw3+UvK1MqQpuV9BEAm+yp65e5Oo3KWwcrWYYfm5+0
         n8w2M5F/Aow7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7E1B4609E6;
        Mon, 23 Aug 2021 11:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vmxnet3: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971701551.8269.10344194039542238601.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:10:15 +0000
References: <ef30cd7e2d3c14460ff5bc7ba6224d464722e8d9.1629644906.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <ef30cd7e2d3c14460ff5bc7ba6224d464722e8d9.1629644906.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 17:09:48 +0200 you wrote:
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
  - vmxnet3: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/bf7bec462035

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


