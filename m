Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70E364AB32
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbiLLXKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiLLXKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:10:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9ED6472;
        Mon, 12 Dec 2022 15:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6463AB80EE4;
        Mon, 12 Dec 2022 23:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FA75C433F0;
        Mon, 12 Dec 2022 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670886615;
        bh=Hknz5jw/1uBB2Nb9IJWA50cf1l1Nvwff1YSP0MoPF7A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pywKoH4ZtLi7fNz0cJvkevfg0IxippRg+0TgIkPHZdq3x8Alabs6X7sQoO/n3V4NZ
         kHyA9hVUD9OEUPGba5PJ8Clq0doYTZLUbntmU9xpZ5RPArvviJ06YHi9nQvwwVBaPv
         qJYKF+y22FNrmdH5j58zbjUeAbj07DD33GdAvat0zI6tZHNecQiI14nsJWZBdoBntm
         RcKD+oIMaXj803OeZLAAWagUkg48/26hVIX52Fdg65jFTb9tg5gnDpkgPXjGQ64i13
         ytxJ/V58xnKEl9WSKjENgBu5ZaAdWl6EDKLEcYDKY4wDwICz9MtEY3SRsJZ+G5Y/V+
         7j7eMz/h5caIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02C24C41612;
        Mon, 12 Dec 2022 23:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-af: cn10k: mcs: Fix a resource leak in the probe
 and remove functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088661500.21170.1496583521302674850.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 23:10:15 +0000
References: <69f153db5152a141069f990206e7389f961d41ec.1670693669.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <69f153db5152a141069f990206e7389f961d41ec.1670693669.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vattunuru@marvell.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 10 Dec 2022 18:35:00 +0100 you wrote:
> In mcs_register_interrupts(), a call to request_irq() is not balanced by a
> corresponding free_irq(), neither in the error handling path, nor in the
> remove function.
> 
> Add the missing calls.
> 
> Fixes: 6c635f78c474 ("octeontx2-af: cn10k: mcs: Handle MCS block interrupts")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - octeontx2-af: cn10k: mcs: Fix a resource leak in the probe and remove functions
    https://git.kernel.org/netdev/net/c/87c978123ef1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


