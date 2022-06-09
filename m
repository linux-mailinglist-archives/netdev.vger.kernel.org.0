Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C351254425C
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237786AbiFIEKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236691AbiFIEKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EC495A02;
        Wed,  8 Jun 2022 21:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38708B82BFA;
        Thu,  9 Jun 2022 04:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED738C341C0;
        Thu,  9 Jun 2022 04:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654747814;
        bh=5xD9l0i3vK+cXdJzqABkTsK6e7a8w/hZrEaZVJZexx0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fut+gmz6OndaA1Pe6k7mBqnfPDkq7XD42HhTPNQrGgxsZccVDdtH6D8UUrFe9L02q
         5O0JOSFKapeqMyi1r7020YriZWrLEDXrVxT72cq58n0Zp6yjuIsJJQ5rz/rGoSItS/
         bSi2fd6elC9pKZ+QdE9sMBGtAW0S84t1BqtyIHcvIRUAKaA7QV0foMU1CKLK0DhYwo
         jijjq322PP9SzFksIYV7i/dKAUTc4PFeV3b3z1PSk4rk/BBYxF1Wm9UlI/DH5HR38G
         MVyyGzjmfydcl/WngdUqYyDthQ5gwuVt8JN2DzzDWekyM+42BRaTvrtwbcs/4TwQxT
         UEwzAXKRqfFHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0F14E73803;
        Thu,  9 Jun 2022 04:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: dsa: realtek: rtl8365mb: fix GMII caps for ports
 with internal PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165474781384.435.17125151758553454031.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 04:10:13 +0000
References: <20220607184624.417641-1-alvin@pqrs.dk>
In-Reply-To: <20220607184624.417641-1-alvin@pqrs.dk>
To:     =?utf-8?b?QWx2aW4gxaBpcHJhZ2EgPGFsdmluQHBxcnMuZGs+?=@ci.codeaurora.org
Cc:     luizluca@gmail.com, linus.walleij@linaro.org, alsi@bang-olufsen.dk,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        rmk+kernel@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Jun 2022 20:46:24 +0200 you wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Since commit a18e6521a7d9 ("net: phylink: handle NA interface mode in
> phylink_fwnode_phy_connect()"), phylib defaults to GMII when no phy-mode
> or phy-connection-type property is specified in a DSA port node of the
> device tree. The same commit caused a regression in rtl8365mb whereby
> phylink would fail to connect, because the driver did not advertise
> support for GMII for ports with internal PHY.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: dsa: realtek: rtl8365mb: fix GMII caps for ports with internal PHY
    https://git.kernel.org/netdev/net/c/487994ff7588

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


