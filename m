Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9A04AA99E
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358097AbiBEPUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:20:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37136 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346522AbiBEPUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:20:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D95760F6B
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 15:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB562C340F4;
        Sat,  5 Feb 2022 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644074409;
        bh=SFpcsVNI/BxcB7YO33Qeoi4sGl6kgzpSf9nRD9qYAvw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JkBfyEPEOYCtLCK6VVBQKItdnuQo+tWjEBW3TJZ+Sr4EkgmsemAtyTO4Uug1xIr6B
         DLHWNKbjwzhJYILchJOsVpeSHvRFoKJpby3uGYDcQk+8sLqxBQxIKapAcm6Vu+WhwP
         pzwu3+27NWqGSem7vF5QurXK7r4VJ1OijwKdQ0uyXgMjsYPkoSlnjJb+ZfiQwW0zH2
         vcNBBYprYP2/9+Xd9JLfKEIeDFEbpDKxsYCXfIZKSAc8uNBJo4EfqZBgHA93f6xUwm
         e1rp7jtiiW19BMI/n47gqMcxn/wd/z5rWrGUED4bR8rENJ6Mbe8/YYSQfMrNnD6P2U
         cgHb0k6Zm3uPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E091E6D3DD;
        Sat,  5 Feb 2022 15:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: remove phylink_set_10g_modes()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164407440957.21243.8212067600237443660.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 15:20:09 +0000
References: <E1nFwyg-006Yqs-4C@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nFwyg-006Yqs-4C@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 04 Feb 2022 11:42:10 +0000 you wrote:
> phylink_set_10g_modes() is no longer used with the conversion of
> drivers to phylink_generic_validate(), so we can remove it.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 11 -----------
>  include/linux/phylink.h   |  1 -
>  2 files changed, 12 deletions(-)

Here is the summary with links:
  - [net-next] net: phylink: remove phylink_set_10g_modes()
    https://git.kernel.org/netdev/net-next/c/0463e320421b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


