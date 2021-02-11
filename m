Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6693195B7
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhBKWUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:20:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229693AbhBKWUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4FCED64E4B;
        Thu, 11 Feb 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613082007;
        bh=nBUveRKGTJ5R8962CGvB+Th9LLlIlXuzrkhaRpczqo4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AjZIwWx6E16b8TixO7LwlkvPCfONso3jGO9g1ZS4kBbeqtNPhJvWODCGCGS7Cdrv5
         QwcsQgsRybhClo1BtaKSkqJYTKtqY1ZZza1y/X02k9ABzzBXn4+GEiWjBZkBdDrRh9
         Fu2OR1Pd7b5fz2PrpOSn+e3jYv9ezhD9OVFiJM1fIibBTRHnSwlFcgJJgj80JBRhw+
         4EzN/gKUq+rSjEW5LpD19IyEI1KJfPJHFyQrPuvv70rp1L2WSWhxpHIXbCg/aewetw
         rm2nzYuOAuZTwqZfe1zNWY9KvqneQIVnGr8kWJXIc6VX7ljVHjk+OhmPdF6KeAnG2e
         ms110paFpljdw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4B37060A0F;
        Thu, 11 Feb 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: re-configure WOL settings on resume from
 hibernation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308200730.4488.11955650152424732762.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:20:07 +0000
References: <7b756293-35ec-d8bd-928c-1e00ded60328@gmail.com>
In-Reply-To: <7b756293-35ec-d8bd-928c-1e00ded60328@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Feb 2021 15:33:20 +0100 you wrote:
> So far we don't re-configure WOL-related register bits when waking up
> from hibernation. I'm not aware of any problem reports, but better
> play safe and call __rtl8169_set_wol() in the resume() path too.
> To achieve this move calling __rtl8169_set_wol() to
> rtl8169_net_resume() and rename the function to rtl8169_runtime_resume().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: re-configure WOL settings on resume from hibernation
    https://git.kernel.org/netdev/net-next/c/06e56697bd98

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


