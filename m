Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25F5490C96
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 17:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbiAQQkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 11:40:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39248 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237683AbiAQQkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 11:40:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 783FEB810F3
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 16:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46E40C36AEC;
        Mon, 17 Jan 2022 16:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642437609;
        bh=gbsLfLWC1EW3Lbg6SDXHbLF9JAUl0CvcoOPwnFnQJ0M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aZ8d75o7dymLo72ncTDIUJqOopuDCiqFf66XgXM9JLja+DnnbU+dHhfBMWRT2jE2S
         j6k+tSYPpaP4JugbgC3K+G3qSYdFn16jhsDAtGIyXBSaQF02Tr8nBHQkD8wCnFVVPf
         4L/8GsatNR5vuNMt4vuyWzCHiseV7fM3vqvkm0lvXBEeZktuMM1W+IFl09Ehc5m6oL
         ZgLOoUq4CO+1nqOnQHxxXMXY6bmA2zy9kLBgL3MYDZgSqmsoJMz7M86oo85en+mN5o
         YTGK6nfOcT9F5tV6B0ixvH7eXugquIef3wTNr7nkKmWX4liC4zeTqyNFiq3AQPvJpK
         OM8fFRxr/xjZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2DB3BF6079A;
        Mon, 17 Jan 2022 16:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sfp: fix high power modules without diagnostic
 monitoring
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164243760918.27988.9049593181239477923.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Jan 2022 16:40:09 +0000
References: <E1n9TN3-004CzC-TI@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1n9TN3-004CzC-TI@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        bjorn@mork.no, chunkeey@gmail.com, hkallweit1@gmail.com,
        teruyama@springboard-inc.jp, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Jan 2022 14:52:33 +0000 you wrote:
> Commit 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change
> modules") unintetionally changed the semantics for high power modules
> without the digital diagnostics monitoring. We repeatedly attempt to
> read the power status from the non-existing 0xa2 address in a futile
> hope this failure is temporary:
> 
> [    8.856051] sfp sfp-eth3: module NTT              0000000000000000 rev 0000  sn 0000000000000000 dc 160408
> [    8.865843] mvpp2 f4000000.ethernet eth3: switched to inband/1000base-x link mode
> [    8.873469] sfp sfp-eth3: Failed to read EEPROM: -5
> [    8.983251] sfp sfp-eth3: Failed to read EEPROM: -5
> [    9.103250] sfp sfp-eth3: Failed to read EEPROM: -5
> 
> [...]

Here is the summary with links:
  - [net] net: sfp: fix high power modules without diagnostic monitoring
    https://git.kernel.org/netdev/net/c/5765cee119bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


