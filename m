Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253A839AE16
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhFCWcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhFCWbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:31:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E2F5161417;
        Thu,  3 Jun 2021 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622759407;
        bh=YADHj5X1MR+ih6mEtIDQZbCMDit+bUoKpdJ/UWex1Lw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ascy7VUQBaaptSkxfYvApBR5QQ0oKbPSv+cHYtYdkglpsbBQ6GiApqdre8oMdnSa8
         xFl+yun+GLKIQQpJHQvDbNhoSG4iBpFIHNrHjbJsvPyHr6GGSSoAotw5AGtxGXpox2
         RL4t7qlfS5EOUWPkWWDMyodyQuYpzB/o682E0h79VjmnMZjeGz/V2zWtYeNgclyBLq
         xyodUQPbnrJJ9FvFcMjtOwoFZ5gKoV04VT9uLwgnpek7Ht3VS6XsrGQgbjTXLB2gdB
         VQtqhV1RMrA24q9O+r8usCAke8zwjGjceVUglgxa/w3pVOx/PDyQTX8I3MVXrjeM/i
         zFB8dcIjwkCWg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D838A60A6C;
        Thu,  3 Jun 2021 22:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: marvell: use phy_modify_changed() for
 marvell_set_polarity()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275940788.8870.11405401453777076361.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:30:07 +0000
References: <E1lomyE-0003mc-RP@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1lomyE-0003mc-RP@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 03 Jun 2021 14:01:10 +0100 you wrote:
> Rather than open-coding the phy_modify_changed() sequence, use this
> helper in marvell_set_polarity().
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/marvell.c | 27 ++++++---------------------
>  1 file changed, 6 insertions(+), 21 deletions(-)

Here is the summary with links:
  - [net-next] net: phy: marvell: use phy_modify_changed() for marvell_set_polarity()
    https://git.kernel.org/netdev/net-next/c/feb938fad63f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


