Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8386445CD5
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 01:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhKEACt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 20:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232458AbhKEACr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 20:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AD72461245;
        Fri,  5 Nov 2021 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636070408;
        bh=5CVgBcfUF2o4cyw5J5pZ4v5IWj28u2trKtaJNSY1Gqg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IASOwcstSVdo461WvbI57Z3P6IDRusKX6QXM5D8a49KwMcnUW2iEeO4fL+JhmSGn9
         Vta01x5ciB6y76qvD71+EE77finGQfS0DE83K8VwCs0PkwooYb1VJBD1Ek/L9r9mjl
         OXnuYlFt2k5GRvLD9QBOXyvPh1NXdT0cnFpHIKDu7y/0LttG4FqiRLQEh+8EwHSzrM
         4L+qRse1N34TK4x2nHq8ACHkKEk+mU9t2YVkSo7y7Kl/n6l9hCS4e7VEtlw+WgI06G
         k/0CMv15A7faieM5CBGKCasD07TqVZo3mjPOnW/1TKO8DIemcHufkPN/dZ+Hr0xgXF
         4BWvsl9VVCrig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A1A9B60A2F;
        Fri,  5 Nov 2021 00:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: fix duplex out of sync problem while changing
 settings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163607040865.859.15423980570457187665.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 00:00:08 +0000
References: <7b8b9456-a93f-abbc-1dc5-a2c2542f932c@gmail.com>
In-Reply-To: <7b8b9456-a93f-abbc-1dc5-a2c2542f932c@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        zhangchangzhong@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 3 Nov 2021 22:08:28 +0100 you wrote:
> As reported by Zhang there's a small issue if in forced mode the duplex
> mode changes with the link staying up [0]. In this case the MAC isn't
> notified about the change.
> 
> The proposed patch relies on the phylib state machine and ignores the
> fact that there are drivers that uses phylib but not the phylib state
> machine. So let's don't change the behavior for such drivers and fix
> it w/o re-adding state PHY_FORCING for the case that phylib state
> machine is used.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: fix duplex out of sync problem while changing settings
    https://git.kernel.org/netdev/net/c/a4db9055fdb9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


