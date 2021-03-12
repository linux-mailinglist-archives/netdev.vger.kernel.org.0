Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1229338397
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 03:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhCLCa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 21:30:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhCLCaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 21:30:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AA94664F87;
        Fri, 12 Mar 2021 02:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615516215;
        bh=K1cKbMu1413kwl67WyGtQTjDk0adzVnhNRNcNWatSBY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sUNaNSLzjqLC5mlhV+TEXQRdXaY0XKB7MBLAUMRqUJJ71OmRafL2t2LZliZQpwdWZ
         loaE8AQt3AhQUhZ92fyVPEiAZQE3MRF0LuKbtg6GSVxUnZBSZ/sQlGzZlzVeybVR2E
         uNegxS20CiUk+YRKwOrAANueYnanDvXSSTFq1xljxI3CTj6kh6GDEVVsDyYrlfrjx+
         daKjfzjXlSINw7OZnqw3OI4TbDHnjKtlX8G8ysMqBVq8+STG3A+YrBk4GQmCcvOsUo
         y2L5qdejt+UOcaby5KggP+rHKLnXbu0kv4AmxYcVJtLbVZ+FQzTV1ZAHTwyS9cg64z
         N5gvuV1Q84T+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9D73E609F0;
        Fri, 12 Mar 2021 02:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: phy: broadcom: Add power down exit reset state
 delay
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161551621564.2118.1091684416709078434.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 02:30:15 +0000
References: <20210311045343.3259383-1-f.fainelli@gmail.com>
In-Reply-To: <20210311045343.3259383-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 10 Mar 2021 20:53:42 -0800 you wrote:
> Per the datasheet, when we clear the power down bit, the PHY remains in
> an internal reset state for 40us and then resume normal operation.
> Account for that delay to avoid any issues in the future if
> genphy_resume() changes.
> 
> Fixes: fe26821fa614 ("net: phy: broadcom: Wire suspend/resume for BCM54810")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: phy: broadcom: Add power down exit reset state delay
    https://git.kernel.org/netdev/net/c/7a1468ba0e02

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


