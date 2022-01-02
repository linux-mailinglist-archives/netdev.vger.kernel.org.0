Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FACB482BE3
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbiABQUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:20:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49602 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbiABQUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D50EB80DBE;
        Sun,  2 Jan 2022 16:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2C7CC36AF2;
        Sun,  2 Jan 2022 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641140409;
        bh=MkbRx2G9HQtHNdDdCkTPNo/vksJZg+ZBdMRHMC7jVto=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nOrqt5YWgyDEHp9ljy7XCTOO0++WtFgO4brqRldoi4JQN4ppyLaP2QLCdO06lcfes
         Q+l4bPvnUnrXN5E/fn7jnaftJIvRhB4vHwfukLBiVOgR4MRYWHw7hQrkJlS0fRbAzm
         RKypoCta9LCiN3e+YKR54dd8gbm2Jc/7zfP4kgP152p0EvpAE1KX6MtNJWCDKrEa4s
         1GGuv2XA8r8ZoHsbnI8G7yrYmsKBhzUM2ls+7Zy2psQWfR7ADqjgt7IvsCF/hnkjrr
         JJ2C+FQFx39QXXaFaexUrC6nsIGdFms4BZYR8YAnUvlo1+CJRaHcoHM+kJi8KSAx5V
         RjACg6+n4iamw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF330C32795;
        Sun,  2 Jan 2022 16:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sun/cassini: Use dma_set_mask_and_coherent() and simplify
 code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164114040977.20715.10088664674731936619.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 16:20:09 +0000
References: <9608eda38887c50ac7399ea1b41f977709678ea3.1641063795.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <9608eda38887c50ac7399ea1b41f977709678ea3.1641063795.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jgg@ziepe.ca, davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        tanghui20@huawei.com, gustavoars@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  1 Jan 2022 20:04:45 +0100 you wrote:
> Use dma_set_mask_and_coherent() instead of unrolling it with some
> dma_set_mask()+dma_set_coherent_mask().
> 
> Moreover, as stated in [1], dma_set_mask() with a 64-bit mask will never
> fail if dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> [...]

Here is the summary with links:
  - sun/cassini: Use dma_set_mask_and_coherent() and simplify code
    https://git.kernel.org/netdev/net-next/c/584c61cedb12

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


