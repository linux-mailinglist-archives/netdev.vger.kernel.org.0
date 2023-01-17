Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3427F66DCD4
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbjAQLuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbjAQLuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F51305F7
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02529B80DC9
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A703FC433F0;
        Tue, 17 Jan 2023 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673956216;
        bh=x8ujYvIssNTDzn6gKr3Qre7PpMNAmba/QXQ17Fn4dN4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PmoViritPOxblnRVhLvnqpxOhKNFDXbE7bW7m6hcY+KIje1678DuS2Jry9L/Ffxno
         dDnCpBJ2lw4Vdykp8/3z91+3P8kOSyRwiF73XioPBE1h6+6nHQV8aZ4Dq++efCzJro
         Lc+Nu2SFhQ2q98FfgqMadNKxDgGqf+9XUI8+Au7/m6ykrD0Jh2KTD6duwszWSrWMzZ
         mlzZZYDwYrfJ92QwA35J7/JvsSRsXHe1lbEhYM6QmWwZ6LTkqZ+OnvcbEp5rT8dBSR
         YGVMNdfPBegvBZNGwiLTeio4YB0TmF3hBgXYZZhMEyb+oZyK7hJBT2Q3tyto4TO2Xn
         wJ5RHQM5t1MBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8EEC4C43147;
        Tue, 17 Jan 2023 11:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mdio: validate parameter addr in mdiobus_get_phy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167395621658.741.1266845429640247394.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Jan 2023 11:50:16 +0000
References: <cdf664ea-3312-e915-73f8-021678d08887@gmail.com>
In-Reply-To: <cdf664ea-3312-e915-73f8-021678d08887@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 15 Jan 2023 11:54:06 +0100 you wrote:
> The caller may pass any value as addr, what may result in an out-of-bounds
> access to array mdio_map. One existing case is stmmac_init_phy() that
> may pass -1 as addr. Therefore validate addr before using it.
> 
> Fixes: 7f854420fbfe ("phy: Add API for {un}registering an mdio device to a bus.")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: mdio: validate parameter addr in mdiobus_get_phy()
    https://git.kernel.org/netdev/net/c/867dbe784c50

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


