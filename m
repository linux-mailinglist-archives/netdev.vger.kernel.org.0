Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8559346DEC9
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 00:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241006AbhLHXDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 18:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241003AbhLHXDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 18:03:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F14C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 15:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 609E9B82317
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 23:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10CD3C00446;
        Wed,  8 Dec 2021 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639004409;
        bh=J5WmQn+QRSfLVZJyM0UzR0xSKooJdQrxprZd6td1GqQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dDxvuHNudH49E5t2b7F8PYceoaTjU6yRVfuxv107L9OJWw/+rXj6Ddijm7WT2rYgG
         mRSKikcgDbP6zSxG5MvtX7I2yQfIuv3j5m9pgOMuJgfpHZD1pQ4i1bXIkEoGYk7LBl
         Nsuo1H1aKaTgZgZLfO3RC2Zyy3hubbgFLwUoCi5zmDNX8yc48nIsHyY8N4TzSXqIdb
         Q0uqO44Z0a+a0kdEPzyHmb7qSGoNWHs2nyk4mPl1xK9ymSYXvysk5kKJ3/YDHADuzm
         QU3HHMAFhx3qPdUcPUzRXJGZ9oK84kFAG38yGmM4RR6kUgIxT9A7h6HBVscXhyGVlc
         +x9u3I3B1jZNw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E82AC60A39;
        Wed,  8 Dec 2021 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on
 internal PHY's"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163900440894.10579.7932204724499091378.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 23:00:08 +0000
References: <E1muXm7-00EwJB-7n@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1muXm7-00EwJB-7n@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     maarten.zanders@mind.be, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, maxime.chevallier@bootlin.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 07 Dec 2021 10:32:43 +0000 you wrote:
> This commit fixes a misunderstanding in commit 4a3e0aeddf09 ("net: dsa:
> mv88e6xxx: don't use PHY_DETECT on internal PHY's").
> 
> For Marvell DSA switches with the PHY_DETECT bit (for non-6250 family
> devices), controls whether the PPU polls the PHY to retrieve the link,
> speed, duplex and pause status to update the port configuration. This
> applies for both internal and external PHYs.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on internal PHY's"
    https://git.kernel.org/netdev/net/c/2b29cb9e3f7f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


