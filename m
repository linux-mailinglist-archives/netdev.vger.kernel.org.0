Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8E6482B14
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 13:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbiABMaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 07:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbiABMaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 07:30:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A62C06173E;
        Sun,  2 Jan 2022 04:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED54FB80B33;
        Sun,  2 Jan 2022 12:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90FDAC36AE7;
        Sun,  2 Jan 2022 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641126609;
        bh=v6ktzdYTB7iZC4vjZ2GYDLoq6WSG7WNKtd1JQHJmHF4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AIvMQk2b9eecfGDwG6qgYQ6ffZGFDjNafC1d9Cw5TkK4k6MKMfddtrsaKq5LCKQuS
         BgWVQDGO8HTGtpfn143BMpDwxHOUcjFUADVfMhtkixBsGyFlVdAnUr8vLjPb43BW/j
         sTIRZdu36HkICE/Vb6ll2bJ/On19ZC8ApijAQFstjHrPbnt9fFtUZ/Sr9SSqEaLc5E
         RoIQAbt8MOVgypf1Lju5kWPiMq4hVKju17H+Dry1q1YRVN9yxUCUrHM7wjQ6FToX4w
         ZSh7tqV5rrtV9dQk8ULXN5+1giqPktARJFQVb2PDrmicqArVzxqEJ6PkrPyAp68wCF
         dRDeQ3I9iSEEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B3BFC395EB;
        Sun,  2 Jan 2022 12:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] enic: Use dma_set_mask_and_coherent()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164112660950.27407.17009004966403932689.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 12:30:09 +0000
References: <f926eab883a3e5c4dbfd3eb5108b3e1828e6513b.1641045708.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <f926eab883a3e5c4dbfd3eb5108b3e1828e6513b.1641045708.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     benve@cisco.com, govind@gmx.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  1 Jan 2022 15:02:45 +0100 you wrote:
> Use dma_set_mask_and_coherent() instead of unrolling it with some
> dma_set_mask()+dma_set_coherent_mask().
> 
> This simplifies code and removes some dead code (dma_set_coherent_mask()
> can not fail after a successful dma_set_mask())
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - enic: Use dma_set_mask_and_coherent()
    https://git.kernel.org/netdev/net-next/c/c5180ad0c278

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


