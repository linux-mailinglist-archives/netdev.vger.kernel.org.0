Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815AD3F493A
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbhHWLBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236269AbhHWLAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D55C0613A7;
        Mon, 23 Aug 2021 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629716407;
        bh=YDmPxn6ibvTY4yIYjKkUrg9Wu6+dMx75j9x1ug6wGMI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VslGUTiXXxtqHaO9M/d44QWX9K3TPVsXdnPFIT7erhiFbYSqk8nt0SdcM9wAp54Aj
         +J7z7+pCW6sgTruwFIGj/oCm6oZNNcS8bfL9yZXsvJsfPkXD8fcw40YraoAbMr66c/
         6LEPA5hhFqLIXjIn3LlypvHHey/CyFJE/uhDhaE2tHKFv3DEl+PvK9J8Ld8RcTv6bY
         rTuCSX73boTO2P/9ir3zOqH//xDidZC8yRK8YXlh8TGKpOlBleltd+XJhPiqIxhgHk
         6tSnnEIL7XHxRXgJWfv9riqsQUymODflBQPIO3yypdKrKX4Qg7IXzXVXJj8q5q6xpp
         Lr2sdYchj3yDA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CB5EB60A14;
        Mon, 23 Aug 2021 11:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: chelsio: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971640782.3591.7688018892852379784.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:00:07 +0000
References: <0be58ad9de650bfe430a3a02b64f2294457e0669.1629612718.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <0be58ad9de650bfe430a3a02b64f2294457e0669.1629612718.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 08:14:03 +0200 you wrote:
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
  - net: chelsio: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/4489d8f528d4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


