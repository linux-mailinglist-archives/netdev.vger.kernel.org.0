Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947FD53066D
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 00:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351805AbiEVWKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 18:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350502AbiEVWKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 18:10:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850C3381A4
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 15:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E34F6CE10EF
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 22:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2802FC385B8;
        Sun, 22 May 2022 22:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653257412;
        bh=0N6izllcvWFLMF5ARgwmcntKeN7CYIUZAfOZuVHaGjs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b2zDwnPavQwCSoNPtz81VYcjvld22d7meR8B3I8HptAtm689pX3W5LjjRRYzNYfD7
         +pgTwRah+Fo/4xT0Unt3KoTCD3R0RYbJNyDG4UwlsX0Io9hGhX2Y2zNNoYBB57646Z
         nbpw/xhtVAKet8HCozHCn/7bkNZStM1baGfRghN/v4EUewYSQny9ZItt6f7j0f3bRb
         aOsQrge/CcOquUKJfUv8aIAhLt7mYrUzQF90LG3LcMnJcAtyQMXHLe5WKwOsutoPc2
         f7zjhduz7cJ/mLdSTFucoxbizN6brzzdUWW8AP3tNYf/4xdNuSwf7WEJPHzCm1h0XQ
         9rk8du8GIGmCA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F11F8F03938;
        Sun, 22 May 2022 22:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: restrict SMSC_LAN9303_I2C kconfig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165325741198.24339.2057653862735564436.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 22:10:11 +0000
References: <20220520051523.10281-1-rdunlap@infradead.org>
In-Reply-To: <20220520051523.10281-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, patches@lists.linux.dev, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        jbe@pengutronix.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mans@mansr.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 19 May 2022 22:15:23 -0700 you wrote:
> Since kconfig 'select' does not follow dependency chains, if symbol KSA
> selects KSB, then KSA should also depend on the same symbols that KSB
> depends on, in order to prevent Kconfig warnings and possible build
> errors.
> 
> Change NET_DSA_SMSC_LAN9303_I2C and NET_DSA_SMSC_LAN9303_MDIO so that
> they are limited to VLAN_8021Q if the latter is enabled. This prevents
> the Kconfig warning:
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: restrict SMSC_LAN9303_I2C kconfig
    https://git.kernel.org/netdev/net/c/0a3ad7d32368

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


