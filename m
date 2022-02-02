Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBF94A6B11
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244637AbiBBEuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244628AbiBBEuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:50:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4995CC061714;
        Tue,  1 Feb 2022 20:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2945CE1B30;
        Wed,  2 Feb 2022 04:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3A67C340EB;
        Wed,  2 Feb 2022 04:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643777409;
        bh=S1N+LKKmMr5oFefOOaMLMoDXO5iNBnO6JoUi5MjN7+c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mJjPOzhCn7V+phwr2ahKN8y3DK4gX6j2ABMpvECYSKyu3/VRdQKN52R0xOkEnFK0W
         2ER3twklWbfPbQ0q7sDEPpKNqaTE+tfeU5lxl8hdGK8q5ujsL8rvrE1OketWPDA79y
         afHW012oXjsGJ+WDk4TH+zKQbFPkfk07h3IoGD0QdUmnftuWhRyZ9QEbZILT8M0nG6
         8Nifgy7Z9VtaXHj5ql2PfRvd9BStjisjNiVHcbdEQWqGL2pyncoHQoi+m8YzGrE1ac
         q3kHXkBwq8Qph5Q71VcmpRm8kgxGqH4x7P6fVbWGrqhOgzKtN8QK8IqqXvO/kxx3Vg
         iJRAc3e1TZrfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C79CDE6BB76;
        Wed,  2 Feb 2022 04:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: macsec: Verify that send_sci is on when setting Tx
 sci explicitly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164377740980.22410.8708955715372677220.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 04:50:09 +0000
References: <1643542672-29403-1-git-send-email-raeds@nvidia.com>
In-Reply-To: <1643542672-29403-1-git-send-email-raeds@nvidia.com>
To:     Raed Salem <raeds@nvidia.com>
Cc:     sd@queasysnail.net, kuba@kernel.org, hannes@stressinduktion.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liorna@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 30 Jan 2022 13:37:52 +0200 you wrote:
> From: Lior Nahmanson <liorna@nvidia.com>
> 
> When setting Tx sci explicit, the Rx side is expected to use this
> sci and not recalculate it from the packet.However, in case of Tx sci
> is explicit and send_sci is off, the receiver is wrongly recalculate
> the sci from the source MAC address which most likely be different
> than the explicit sci.
> 
> [...]

Here is the summary with links:
  - [net] net: macsec: Verify that send_sci is on when setting Tx sci explicitly
    https://git.kernel.org/netdev/net/c/d0cfa548dbde

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


