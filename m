Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4E13A2053
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhFIWme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230134AbhFIWmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 62E1C613F2;
        Wed,  9 Jun 2021 22:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623278425;
        bh=KE7NfEJmLueislrgsxoRI/4LuNgtYIy5fAtTYzEQuo4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s5ax1pNU2dYm9oBxWQVKX/qeu1bzURmcFS6hpnBdCzw6jj3S/hswWUk9G/biw2sMM
         AHCmwriApEAsus6P6WAF+YUZh0H4wnWxYZmCReM3MxoqGMU4d9qEjUrFp0Gw/cad0F
         AoWWIJ+czN5YlntHYU/WZucSZOiKombCxBalQ12pqBhg/ZR0Dm6Lw8fdh63TfKEQCY
         bCMBA3W1hz06kJ+lkAw8g7y9QqSRDDpIk0eAE9zGNrT8ws8ngJI4EezvYf06CSpB98
         +QSnlx/lev9mVqqvXi3IRpcjhr3GLxUk4t+Rf2MbtKj5jpzTo3XTKDsGziWh5r4vca
         MMWPL44aKtmBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5358060A53;
        Wed,  9 Jun 2021 22:40:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: phy: realtek: net: Fix less than zero comparison
 of a u16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327842533.25473.14455359274708008016.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:40:25 +0000
References: <20210609171748.298027-1-colin.king@canonical.com>
In-Reply-To: <20210609171748.298027-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, qiangqing.zhang@nxp.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 18:17:48 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The comparisons of the u16 values priv->phycr1 and priv->phycr2 to less
> than zero always false because they are unsigned. Fix this by using an
> int for the assignment and less than zero check.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: 0a4355c2b7f8 ("net: phy: realtek: add dt property to disable CLKOUT clock")
> Fixes: d90db36a9e74 ("net: phy: realtek: add dt property to enable ALDPS mode")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - [next] net: phy: realtek: net: Fix less than zero comparison of a u16
    https://git.kernel.org/netdev/net-next/c/f25247d88708

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


