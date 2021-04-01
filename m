Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A231C352361
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbhDAXU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235894AbhDAXUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A17D16112F;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617319209;
        bh=pLiQ8amewypxkECnufapOHlQnrpAKldAdA/i6rrspqI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mEh8Ub8C/Wh1j2LYUnWKHGIAZPgNSKFpWgDJTK854r3IE+yssi41zJQxqNv7fSscT
         BLYpXwJMMCcKnr5a/+56Bq4ceXpHhuqVLyt7HpS3L+kyy0lHyRW/aoTIOpov9Gs3xA
         rUjK1c3a0Gw7UqxsuD2Lw3OE5L5lEY+75iqLp8hUKe4/mjuUerFLe8wjCwBIWKUDGB
         OXrOmqKHc11fSYygcyyCAJV4iHiFQWPtBFPrAyj4iVoe16ylUmqOJCSiqUXYZOAQFy
         zUjHieJ5GczZsxGQuOUSj3eICW7GmOeXIExENvsaLYuMRycnoMjCcdGOlmg4a6rWdp
         Dwv/6rRj9RS2A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9536A608FE;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: broadcom: Add statistics for all Gigabit
 PHYs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731920960.16404.16996848885733391860.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 23:20:09 +0000
References: <20210401164233.1672002-1-f.fainelli@gmail.com>
In-Reply-To: <20210401164233.1672002-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  1 Apr 2021 09:42:33 -0700 you wrote:
> All Gigabit PHYs use the same register layout as far as fetching
> statistics goes. Fast Ethernet PHYs do not all support statistics, and
> the BCM54616S would require some switching between the coper and fiber
> modes to fetch the appropriate statistics which is not supported yet.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: broadcom: Add statistics for all Gigabit PHYs
    https://git.kernel.org/netdev/net-next/c/5a32fcdb1e68

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


