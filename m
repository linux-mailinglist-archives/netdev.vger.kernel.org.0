Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F5C47F163
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 00:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhLXXAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 18:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhLXXAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 18:00:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7200C061401;
        Fri, 24 Dec 2021 15:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02E5CB8234D;
        Fri, 24 Dec 2021 23:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B69D6C36AEC;
        Fri, 24 Dec 2021 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640386809;
        bh=pIE1wVV5FBZbGAYH/4kt/cNIGYApjrutCawBkgG4yYg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YzXVKAVgGO/QTuE5Sk1JUKQWjQwBU+e7kxrYMYDG87wRtPoWad5GBPJ+laTgTGh0U
         CpzUMmUNyP7K+CSwOjEj/o+WPndOfp2ULVzr1zPRcJ8NzwtcusIMJbQrVehyGgGBaK
         Un+wmEVVuLoDITolk56ZcKf5fzZ7Dkrkd3/+naJd0Taa+ns7+0iz8lEGDPPzMU7LAS
         DajVR/YlPKCYrVLD9xTa7xGPQENqIt0iaXQQHSSX5flLFYeVIP7nPFAIMpH9iCrxyY
         gLXi/IjSAh5ttXBr2hmWmA/bsviRJUSK/5b1HinZWZEu4/do40/cL+oRQtEy6u1kxq
         3TVnJtdikQYMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1DE1EAC068;
        Fri, 24 Dec 2021 23:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in
 __fixed_phy_register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164038680965.25397.3716151863541011855.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Dec 2021 23:00:09 +0000
References: <20211224021500.10362-1-linmq006@gmail.com>
In-Reply-To: <20211224021500.10362-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 24 Dec 2021 02:14:59 +0000 you wrote:
> The fixed_phy_get_gpiod function() returns NULL, it doesn't return error
> pointers, using NULL checking to fix this.i
> 
> Fixes: 5468e82f7034 ("net: phy: fixed-phy: Drop GPIO from fixed_phy_add()")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  drivers/net/phy/fixed_phy.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register
    https://git.kernel.org/netdev/net/c/b45396afa417

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


