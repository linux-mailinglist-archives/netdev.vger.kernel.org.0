Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE84F379930
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 23:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbhEJVbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 17:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231617AbhEJVbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 17:31:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 573CD61465;
        Mon, 10 May 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620682210;
        bh=DsprG27637zOiSjhbn2owZ7m7xFVPW+am+KuF9+Ac0A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h7u3iot7cNdbq1eXuT9Vb7osmfINimaCU4PWqZxM5ZIyEFyqxOwxZjOXl8hwFLiey
         wyLfpkNYSr4xO5JWuo2zhNdI/G6VOR/gvCRqLHjw8SObZZiysBRUMhRlV52qD1avyw
         BDYQZvTsyq4Z6ZsksC0TYAvJHKswBVh56PBNSCjKyPlQpJkB0okrFH4B9e5wt5M+bo
         OAMAdsVXstnS1QHZnYyjHeGF87kxUSxsQzfe0f/u87p2mChRNsIsIeY7pAAf6XJNsO
         H9k5X8b0gvKInLMEgkemaJEnCc1/ItDYNCZ3cXQRCijiJnSMcTmVJgM90jy4ONMW28
         1yTRTmcFcyvxA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 45B7E609AC;
        Mon, 10 May 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: netcp: Fix an error message
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068221028.28006.2233147599257942332.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 21:30:10 +0000
References: <1a0db6d47ee2efb03c725948613f8a0167ce1439.1620452171.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <1a0db6d47ee2efb03c725948613f8a0167ce1439.1620452171.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        michael@walle.cc, w-kwok2@ti.com, m-karicheri2@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat,  8 May 2021 07:38:22 +0200 you wrote:
> 'ret' is known to be 0 here.
> The expected error code is stored in 'tx_pipe->dma_queue', so use it
> instead.
> 
> While at it, switch from %d to %pe which is more user friendly.
> 
> Fixes: 84640e27f230 ("net: netcp: Add Keystone NetCP core ethernet driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: netcp: Fix an error message
    https://git.kernel.org/netdev/net/c/ddb6e00f8413

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


