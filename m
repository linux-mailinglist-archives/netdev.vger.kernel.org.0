Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FD05B1B69
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiIHLaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiIHLaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB302CC82
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 04:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E0B661CB8
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 11:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2C61C433B5;
        Thu,  8 Sep 2022 11:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662636615;
        bh=l7alf7NB7PNWZO0VQ2RCFiNPtsnMJQyC9t7Ck2aGRdI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BDbOxPT1ffhPOdlaRQX/YPeerq1PM07ilI21R4RdG0Vjk7KuLW2bjrzbeyimwM68P
         PVQDwyVOFGAgANdOxczEzDHwI5weUcKdX8/sU+WNKcoYkFR2zszqI4AmylxqnMoRoH
         Ycwt0+onwT0zAIUUj9d00dJ2g4PnNFV39rEa+nyrd8wxjBdGlG/9gm4tDQvcLEmXGt
         C/GzXW0teGYnESJgaYQcxKShqUsdCHXFItzXdRXAi5uqHuwpw1FrWk77msho5NCAr8
         +7q9/v7QHfM2SqSjnjNfe9Oxfbv0pvJK7z4oRuvRAADAvBHF5O5+Wlm8eV88NSxRqi
         W9TfnhW4Pqq6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ADB96E1CABD;
        Thu,  8 Sep 2022 11:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: merge support for chip versions 10, 13, 16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166263661570.19056.4217903243926517154.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Sep 2022 11:30:15 +0000
References: <469d27e0-1d06-9b15-6c96-6098b3a52e35@gmail.com>
In-Reply-To: <469d27e0-1d06-9b15-6c96-6098b3a52e35@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 5 Sep 2022 21:23:12 +0200 you wrote:
> These chip versions are closely related and all of them have no
> chip-specific MAC/PHY initialization. Therefore merge support
> for the three chip versions.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169.h            |  4 ++--
>  drivers/net/ethernet/realtek/r8169_main.c       | 11 ++---------
>  drivers/net/ethernet/realtek/r8169_phy_config.c |  2 --
>  3 files changed, 4 insertions(+), 13 deletions(-)

Here is the summary with links:
  - [net-next] r8169: merge support for chip versions 10, 13, 16
    https://git.kernel.org/netdev/net-next/c/e66d6586843e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


