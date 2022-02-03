Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8F54A8351
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 12:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243757AbiBCLuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 06:50:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32828 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiBCLuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 06:50:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DA7CB833FD
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 11:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17AC4C340EF;
        Thu,  3 Feb 2022 11:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643889012;
        bh=BuGSXex6Pe10DlrfXhgfCqp3gasLh3ZP8j0LxIMO4Fk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H296HEYjahHigXQtvuUU2ORhtCcWvDROu9oCxmR0X29vHWH3H+SbubkXuNyn/kClH
         YOSv0VPQnMeQv+5Q7ricZWEdZ8QHnuErB4t9kdGtc8UhbDxkHKK0S1kI69ar/QEHoG
         hoNKoCsPRJWywL/rF9F+oYZV2dwbmc7TUUkwETq4CSvU0SLLOC6o2+6OBCNK2n8iIS
         +UozpsYWPm+assyOJUNZ1TxPWgtkKgLfy6Gp0h8mSfhDdRHe/MNNZpIZSyAJ+rl369
         h/a2Pio9AUd5NCxmDLt5KtHndxo4v1TRSzcyDgBG1dpHNZg5QImP9mAEorfBCMtApo
         GXXXEiteGswfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02BBAE5869F;
        Thu,  3 Feb 2022 11:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] Trivial DSA conversions to
 phylink_generic_validate()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164388901200.18714.8276173640550647554.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 11:50:12 +0000
References: <YfpbTzsE1MWz5Lr/@shell.armlinux.org.uk>
In-Reply-To: <YfpbTzsE1MWz5Lr/@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        george.mccollister@gmail.com, kuba@kernel.org,
        vivien.didelot@gmail.com, olteanv@gmail.com,
        woojung.huh@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 2 Feb 2022 10:22:07 +0000 you wrote:
> Hi,
> 
> This series converts five DSA drivers to use phylink_generic_validate().
> No feedback or testing reports were received from the CFT posting.
> 
>  drivers/net/dsa/bcm_sf2.c           | 54 +++++++++---------------------
>  drivers/net/dsa/microchip/ksz8795.c | 45 +++++++------------------
>  drivers/net/dsa/qca/ar9331.c        | 45 ++++++-------------------
>  drivers/net/dsa/qca8k.c             | 66 +++++++++++--------------------------
>  drivers/net/dsa/xrs700x/xrs700x.c   | 29 +++++++---------
>  5 files changed, 67 insertions(+), 172 deletions(-)

Here is the summary with links:
  - [net-next,1/5] net: dsa: ar9331: convert to phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/2a229ef44e73
  - [net-next,2/5] net: dsa: bcm_sf2: convert to phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/927c9daea9b5
  - [net-next,3/5] net: dsa: ksz8795: convert to phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/82fdbb917462
  - [net-next,4/5] net: dsa: qca8k: convert to phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/9865b881a513
  - [net-next,5/5] net: dsa: xrs700x: convert to phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/1f8d99de1d1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


