Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E977137EE99
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347617AbhELVyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237616AbhELVLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 17:11:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BCEE261406;
        Wed, 12 May 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620853810;
        bh=mo9JAJAZO1+EYpVeXiY2Wy9tImvw6V6BMPdk7k7W6dU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C56o2t8EW/navsNCQgLK/KfPzbp+Fvpmb7nzYN49tmlWHDVISdIyQHWREgNE1Vx+M
         9tuUEKCZgPJxKCw7f9JGauO+hKahWEoeqz6VTjBTjxTJSiCl3Z5+KvNMfK/eFCeYq3
         5Q8KEQx+Vyj/G0Y82dgx9M2F31C05rx9ohd3Tb6EaWcxVMibCQHCfPrQmWyG7AWJZl
         1gmUTQ9XJj6aFIW2lwKtBTYhNt+aH+xebeVthNCNYkmQ7utAzhHyjZ0rkq6GQqel3y
         9+2UoqcwTF1IP/hXw8AG3fAwmanzv0QPhvuUVKfif6InL8cGTTbydwPePe7ithFoZU
         HF0KecDMDQa7A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AAA8A60A27;
        Wed, 12 May 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ptp: ocp: Fix a resource leak in an error handling path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162085381069.5514.11486827619265689281.git-patchwork-notify@kernel.org>
Date:   Wed, 12 May 2021 21:10:10 +0000
References: <141cd7dc7b44385ead176b1d0eb139573b47f110.1620818043.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <141cd7dc7b44385ead176b1d0eb139573b47f110.1620818043.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     richardcochran@gmail.com, kuba@kernel.org,
        jonathan.lemon@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 12 May 2021 13:15:29 +0200 you wrote:
> If an error occurs after a successful 'pci_ioremap_bar()' call, it must be
> undone by a corresponding 'pci_iounmap()' call, as already done in the
> remove function.
> 
> Fixes: a7e1abad13f3 ("ptp: Add clock driver for the OpenCompute TimeCard.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - ptp: ocp: Fix a resource leak in an error handling path
    https://git.kernel.org/netdev/net/c/9c1bb37f8cad

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


