Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F5E33C74B
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhCOUAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233859AbhCOUAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 16:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 53C9464F06;
        Mon, 15 Mar 2021 20:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615838408;
        bh=goEBYgVM4BekuZjPShxg8SY3IdgbosJ2xWfaJgi7lxk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MQnWoSDxAU24pOl1bmW2jO+Kyub1dYov2Sr0SR1NucxEdT65Pze3KTHwXEgH9oPvp
         +Z+hl44sryTA8zToeES8aeo5Cx7qAn+gxsTpHyvNnyhI2ApPiKToO5fpawiCki0086
         a4qVp0+tmZ3kWO2AnE9/b2PWjPY6H0EQahxU++knMCOLRJXQr3NTSsxlOifv7sZYAh
         9RzLgsiD35zVpa9EFkIqtIkBCMVIXWsUTtkdVCraPDlzQmFsFmJWJvuY2tMjV4JJqR
         Kiw0HDBwLeRDhcgaPWuLDzxZZDPhTKcRCY6+kvyCahLo44Me6/Tskm6PINqArM5MSD
         Y9yHlujsyTqmw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 41EAE60A1A;
        Mon, 15 Mar 2021 20:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: phylink: Fix phylink_err() function name error
 in phylink_major_config
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161583840826.32082.10139210477796684841.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Mar 2021 20:00:08 +0000
References: <20210315043342.26269-1-boon.leong.ong@intel.com>
In-Reply-To: <20210315043342.26269-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 15 Mar 2021 12:33:42 +0800 you wrote:
> if pl->mac_ops->mac_finish() failed, phylink_err should use
> "mac_finish" instead of "mac_prepare".
> 
> Fixes: b7ad14c2fe2d4 ("net: phylink: re-implement interface configuration with PCS")
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> ---
>  drivers/net/phy/phylink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net,1/1] net: phylink: Fix phylink_err() function name error in phylink_major_config
    https://git.kernel.org/netdev/net/c/d82c6c1aaccd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


