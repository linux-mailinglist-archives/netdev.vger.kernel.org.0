Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164714A76B2
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 18:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346218AbiBBRUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 12:20:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46048 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiBBRUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 12:20:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC244617E3;
        Wed,  2 Feb 2022 17:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44AFAC340ED;
        Wed,  2 Feb 2022 17:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643822410;
        bh=1khkt3/JcCulRHYzhGquD0jyR/SW2E9+oMa5CW14XiU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GPFi/OfU9uK1X2tyil9VCNsxixh0uyLySs2aGWcQnv4TO3BdGotHACbVC3LRKQuem
         dh70Vp8VOZskwkOGZugll0XPBxsisOzmXGA7bJ2/L6jXGXK9GXXR8mjqclaEcuo1IQ
         yM2TmbApRdZ+f7Fdi40gT0qaimTXVADn91nNTyF64x81Jv5OLevXp3an1EywsdoHlo
         liFiJy8XaoGMAobnCYbIdnnlwosU1Xa1BD1W4b92RnLnfqTXdcc4FeSB/9pEUU23It
         UaQ6VwmYYhwTZKJF+cGe6jczzU+RJt9Iybh4WuHUKjWKZBe0rjsC8Qv8+Ik22jdGLe
         0Gfzob6sMPTWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1A198E6BB30;
        Wed,  2 Feb 2022 17:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: sparx5: do not refer to skb after passing it on
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164382241009.2143.7850351482664563943.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 17:20:10 +0000
References: <20220202083039.3774851-1-steen.hegelund@microchip.com>
In-Reply-To: <20220202083039.3774851-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 2 Feb 2022 09:30:39 +0100 you wrote:
> Do not try to use any SKB fields after the packet has been passed up in the
> receive stack.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: sparx5: do not refer to skb after passing it on
    https://git.kernel.org/netdev/net/c/81eb8b0b1878

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


