Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15363485896
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243115AbiAESkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243111AbiAESkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:40:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04163C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F3C4618D6
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 18:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09CACC36AE0;
        Wed,  5 Jan 2022 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641408010;
        bh=b+wk8sKpaksJaEyPx8gPnmFy4ZQLTQYE+MTCKLcjtqc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TjZYoFkKnW20pT1+pORLpH1X4TY/3Y5v4p+pM17rcGjtS1yxqy2txDVR7STdHBYsI
         ZxBlO4uBfQ/7vwFkp1uDnWqjJnFJYNaBb29UALr3hTYkquDwzzSjILFBFvW1f48I+y
         ntq8xC69BF4wbBrQsDs9NLzITAg86M00H0MAuL6Twoe66qKjmGonUH0ilqo1fSeq3E
         7RhHSGtE8vbGsL5lqk3DsHPOHubJH+0f0GGB6b8a731OfI3fFVuHkK7vgeAdNvXl6W
         crIDUE4OXRi243k+W6MkpBLiU8zpcMSLBK495T/gVEqaXE5ZC39gmsu0r7rM062/73
         Cjk0g11PlYGBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DFD78F7940C;
        Wed,  5 Jan 2022 18:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: gemini: allow any RGMII interface mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164140800991.26997.2579550480629301772.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 18:40:09 +0000
References: <E1n4mpT-002PLd-Ha@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1n4mpT-002PLd-Ha@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 04 Jan 2022 16:38:31 +0000 you wrote:
> The four RGMII interface modes take care of the required RGMII delay
> configuration at the PHY and should not be limited by the network MAC
> driver. Sadly, gemini was only permitting RGMII mode with no delays,
> which would require the required delay to be inserted via PCB tracking
> or by the MAC.
> 
> However, there are designs that require the PHY to add the delay, which
> is impossible without Gemini permitting the other three PHY interface
> modes. Fix the driver to allow these.
> 
> [...]

Here is the summary with links:
  - [net-next] net: gemini: allow any RGMII interface mode
    https://git.kernel.org/netdev/net-next/c/4e4f325a0a55

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


