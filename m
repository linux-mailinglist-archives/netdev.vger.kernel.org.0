Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA976E057B
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 05:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjDMDuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 23:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjDMDuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 23:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B59610EB
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 20:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 051BD638EB
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57371C433EF;
        Thu, 13 Apr 2023 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681357818;
        bh=7v5o9rM/ouA/vFabAN6rImvjgHh0Yk4lQMZ98Q+OjK4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KzCi/dwf0FgROhRRgNB3TqfTAypoB8eq5UH/ULi9d2H0PJSGNcXpiAir2FPzNnDlR
         JylRS13be+eghwaqK+mf6WRYCQamugcBBe3oPeLga16aG5SRkdOQ+934G+5M7iT5LN
         2/FkGT+N7Iv+LCo2NTSqt4i1MwrnfrS1NEY9W4P24BghidMLHDt7Hs4eccURooFliA
         XxI74MNycsdhtIRn3Wid5i5mK4oc0FCmbBmsBPe4JVEB0Rt7jf1csvFYeQaPNDNBVT
         eZ6cISHxjvhNeETPgOEIOm1/eQCGr+2cMggmDXu9RH/foJgXYa/QafVW/Q7mG6KPIL
         NFXnvlkuRk03Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D036E5244E;
        Thu, 13 Apr 2023 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: Add missing depends on MDIO_DEVRES
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168135781824.31465.13259436947870186840.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 03:50:18 +0000
References: <20230409150204.2346231-1-andrew@lunn.ch>
In-Reply-To: <20230409150204.2346231-1-andrew@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        rmk+kernel@armlinux.org.uk
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Apr 2023 17:02:04 +0200 you wrote:
> A number of MDIO drivers make use of devm_mdiobus_alloc_size(). This
> is only available when CONFIG_MDIO_DEVRES is enabled. Add missing
> depends or selects, depending on if there are circular dependencies or
> not. This avoids linker errors, especially for randconfig builds.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> [...]

Here is the summary with links:
  - net: ethernet: Add missing depends on MDIO_DEVRES
    https://git.kernel.org/netdev/net-next/c/37f9b2a6c086

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


