Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A36631743E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbhBJXUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232203AbhBJXUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 18:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B17464EBB;
        Wed, 10 Feb 2021 23:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612999207;
        bh=PM44njfniTass+bmeLZbi7kn3P6ZIeGjTVErDcMIVpg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B6HDXFFjxlhlyn4n+T3cqBHRAWTx22fwioJRPqke8zrMvoAuCn5KpGook05pLD0An
         0r3xUjMtsMVvnFMBiPimcDkFPms2RfGQKYqmZk0M3NC/NP51cFbbbHQWjSH5wTWqlh
         GC0mq2A5i2L02cowYAbGOs2OIxDN7UGMiYK0fKURAnK2Goe+V+U/3OHxxr8mQsocoi
         QvI1miIZIgy5p27TuMmui/flN8jpNCCu59oZWrp4fAB2LdD0Knf/KLskheaIr86TOK
         pHxQEhw2UWFyBJW/rKKWYepTtNiyQ6BPP5BieAKnj75dZW4FkITsuWuHtgx+K9aT3C
         U57htHtA3u61A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6A3F7609F1;
        Wed, 10 Feb 2021 23:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: octeontx2: Fix the confusion in buffer alloc
 failure path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161299920743.13771.4953397169592654903.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Feb 2021 23:20:07 +0000
References: <20210209101516.7536-1-haokexin@gmail.com>
In-Reply-To: <20210209101516.7536-1-haokexin@gmail.com>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
        netdev@vger.kernel.org, pavel@ucw.cz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  9 Feb 2021 18:15:16 +0800 you wrote:
> Pavel pointed that the return of dma_addr_t in
> otx2_alloc_rbuf/__otx2_alloc_rbuf() seem suspicious because a negative
> error code may be returned in some cases. For a dma_addr_t, the error
> code such as -ENOMEM does seem a valid value, so we can't judge if the
> buffer allocation fail or not based on that value. Add a parameter for
> otx2_alloc_rbuf/__otx2_alloc_rbuf() to store the dma address and make
> the return value to indicate if the buffer allocation really fail or
> not.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: octeontx2: Fix the confusion in buffer alloc failure path
    https://git.kernel.org/netdev/net-next/c/1fb3ca767529

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


