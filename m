Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD5F4A97F5
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 11:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351220AbiBDKkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 05:40:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58444 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbiBDKkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 05:40:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71DCEB83708
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25DB7C340F0;
        Fri,  4 Feb 2022 10:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643971213;
        bh=FfHcUg/o6n8gVrRV1oLJQLwERDtmZcVxvTN2NH1IlE0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A+ny9FmRX726+UWbsT9sDS8Xfk4lFwwc/E/JO2OuH79Mf62rERnfcOm6rc+K9PIKC
         HZKXbVxLkkRUdlJMgs2+TU0EAiVCQ2LkQrSatZ5f7mVUGtS0IieWsis/Qdg3ZPk/u0
         inqUs6h4QOiY2Grt8cb5C8usXo6DWedswPydbXKMuhEs7PjZzvs77cYKbVQgk5Mm/K
         AkvjnKCNQTr9tT9R/SWP+U6PpkJ0o/bSMNsmdoI7vd8oub40aqrFwiYUihZHqKJFgE
         0gkwklmCOtSJoIf5p+P1Mvc9yiUOAIe/KnafTvZJM49xGuAig/U9HnMwFC72R1LF1Z
         f66NBLadmWjjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05D12E6D3DA;
        Fri,  4 Feb 2022 10:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: realtek: convert to
 phylink_generic_validate()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164397121301.5815.18327945100502330970.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Feb 2022 10:40:13 +0000
References: <E1nFIVZ-006Lgp-0o@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nFIVZ-006Lgp-0o@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 02 Feb 2022 16:29:25 +0000 you wrote:
> Populate the supported interfaces and MAC capabilities for the Realtek
> rtl8365 DSA switch and remove the old validate implementation to allow
> DSA to use phylink_generic_validate() for this switch driver.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> I seem to have missed this driver, so here's an update for it - but only
> build tested.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: realtek: convert to phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/6ff6064605e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


