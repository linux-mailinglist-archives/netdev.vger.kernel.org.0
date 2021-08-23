Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F973F4964
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236406AbhHWLK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236171AbhHWLK5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:10:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5551260FE6;
        Mon, 23 Aug 2021 11:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629717015;
        bh=uS0Sjvh8f0Gai+BJ6zkK6AdR8qljsXQuXeW8LgxHIbg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p8oxnZluV2/Wwlkvax8CutbYURln7FQ8KwR9ck/m4gM+i8Pg9d57aa49mzKBCpQl3
         ptvcOq03ITF4u21y3NulHSlq0ITiNSiIgp3dCMrAp6UJIBpE+KnFQ7vu+ZJJsmjOB3
         JOaIs5LzolAjdnubIWy7ZIZUNZ3gyWjny0NVRObsv28dx+so1FyX+NopTPBHsHglPG
         4m8zBqy5TvzpAlvVXFsUhADB0QnurY1hm/4/keTZ5svlC20R50xmglMOoETAZAwe5Z
         kEqvN8Hfpk1EdRPaH9xxtxhzdVJmoL/soz/RBKturjqLWo+qWPKGasbvsToyM8Uk+d
         TLzqNRMtylK5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 497E160A14;
        Mon, 23 Aug 2021 11:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: 8139cp: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971701529.8269.10434461713833292262.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:10:15 +0000
References: <7d235ccb64d5713b2eec38f10e75d425c15ceef7.1629658846.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <7d235ccb64d5713b2eec38f10e75d425c15ceef7.1629658846.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 21:02:23 +0200 you wrote:
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
  - net: 8139cp: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/a0991bf441d5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


