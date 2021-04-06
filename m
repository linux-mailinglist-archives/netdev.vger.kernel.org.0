Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E50355F61
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244436AbhDFXUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236062AbhDFXUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1858C6139B;
        Tue,  6 Apr 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617751209;
        bh=AjndnmsjEsosY7XNbH6ECLzKNhQ2pS49QsXDN6ja4jM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q+pURvIA/8pDmozvWo1Z58vY31lb7e1yI/nJjIPWrgRQIb4qq2FdOeGDa3g77cENm
         5PtpfxYSNQVRlXyHSgydWfgOXh8plQsvG9Hl7YRzQSTIopQXAmHsw+efk6bzniYePW
         i9MOVJ5L7hWefZb0xuws5VLaX2nI7C/d8WJ//SRS9ipzZL3zTQ6v+A7P9Ov1deIAkr
         DWX8HHwUChwmm/+uKk1/aZs8a5Yt8rBORs/zOpMYy71soKtsqpvpFRrXkAZVNAbM86
         Bxd/VAy7YLTwirR2gotpVMYZUvc8zgOdF5gkAw6oik1UHkh7e+8sx4ASrWdS0bkZXt
         1LJrn+BMRQjxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0546760A2A;
        Tue,  6 Apr 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: broadcom: bcm4908enet: Fix a double free in
 bcm4908_enet_dma_alloc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775120901.12262.16738221988151973743.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Apr 2021 23:20:09 +0000
References: <20210402174019.3679-1-lyl2019@mail.ustc.edu.cn>
In-Reply-To: <20210402174019.3679-1-lyl2019@mail.ustc.edu.cn>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  2 Apr 2021 10:40:19 -0700 you wrote:
> In bcm4908_enet_dma_alloc, if callee bcm4908_dma_alloc_buf_descs() failed,
> it will free the ring->cpu_addr by dma_free_coherent() and return error.
> Then bcm4908_enet_dma_free() will be called, and free the same cpu_addr
> by dma_free_coherent() again.
> 
> My patch set ring->cpu_addr to NULL after it is freed in
> bcm4908_dma_alloc_buf_descs() to avoid the double free.
> 
> [...]

Here is the summary with links:
  - net: broadcom: bcm4908enet: Fix a double free in bcm4908_enet_dma_alloc
    https://git.kernel.org/netdev/net/c/b25b343db052

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


