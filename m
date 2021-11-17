Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4034453EDC
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhKQDXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:23:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:43650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhKQDXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 22:23:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 920B563222;
        Wed, 17 Nov 2021 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637119210;
        bh=InroTyq+9Za5mF7YGfSJhzatQjwZgcjH+68M+WGxd4s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fcUPzy2t6eRNc3OG0RQ1yqee/9B/knshTiVkK7D02rKRIwMomEQ3rHCDdz9hpQUam
         baYiSpIdktc3MGv/J7xyUkv1DQLSsw5NzU9bBPlk1OZtWMn3460xJe9Z94iSulTgH+
         TRQIB6g3/bvE3MfConwFXphzow4DCvStsT5NuG0pAWrhN0zIenFn8pypuR4rftr00T
         Lk365L2b8zsHkd5GM+pmPgYDiUbJwLXpG4FznnEnB54q+gNFmz11l+ffz/Mfz821lR
         HC4WWolFdX92StH5PmhszYhBN5E6AKkdNB7uJvWZCJmL/orWF5v9eCt7t52S4yANr/
         NZTBbwSyJ1BBA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7EA1960BBF;
        Wed, 17 Nov 2021 03:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: enable ASPM L1/L1.1 from RTL8168h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163711921051.1664.4443726363758899670.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 03:20:10 +0000
References: <36feb8c4-a0b6-422a-899c-e61f2e869dfe@gmail.com>
In-Reply-To: <36feb8c4-a0b6-422a-899c-e61f2e869dfe@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Nov 2021 21:17:56 +0100 you wrote:
> With newer chip versions ASPM-related issues seem to occur only if
> L1.2 is enabled. I have a test system with RTL8168h that gives a
> number of rx_missed errors when running iperf and L1.2 is enabled.
> With L1.2 disabled (and L1 + L1.1 active) everything is fine.
> See also [0]. Can't test this, but L1 + L1.1 being active should be
> sufficient to reach higher package power saving states.
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: enable ASPM L1/L1.1 from RTL8168h
    https://git.kernel.org/netdev/net-next/c/4b5f82f6aaef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


