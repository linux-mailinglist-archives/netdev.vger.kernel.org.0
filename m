Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2F93F496D
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbhHWLLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236305AbhHWLK5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:10:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 72B19613AB;
        Mon, 23 Aug 2021 11:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629717015;
        bh=XA4lhd5hVjOd5YQ4OftpoR+iCsOsXnaZ32f0w5itAi8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QWlBKyNSs/jRzJf40z0AoPJyGjJpkJMOshj/tvR8X3k+jT58SmxFBH1+fC4L291js
         s8hAvOzQMvfS9oi6kjLWUyFP741LSFeUQdifRlrwGhbq3gQZyFHo9hDZgHu9TRzSk6
         asvCog/R20hp2FNd9J8i2q++Vx1kVfimjQfvQPtQ8msXl4S/XgfZTswLHNCzmIZ1ke
         fIMNday2/61lQhf0SQnzE16Q2iGz8YMxibpQIDkJ//5wpEV8MWJ8c3KZfd6zGbraNm
         9/OR5stW4RX3Upm1kguy1IJIU37fgWsT8H1XDy8Xt4obbxWVG8AxFLpPDfLAahDbsb
         XTD+xBp7VBdBQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 69FBF60075;
        Mon, 23 Aug 2021 11:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hinic: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971701543.8269.16956515397890741225.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:10:15 +0000
References: <b5a92ba4aef427a07d0b35e5cc48a9555634b8ec.1629665282.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <b5a92ba4aef427a07d0b35e5cc48a9555634b8ec.1629665282.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     luobin9@huawei.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 22:49:12 +0200 you wrote:
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
  - hinic: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/609c1308fbc6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


