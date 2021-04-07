Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73883357692
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 23:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhDGVUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 17:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232017AbhDGVUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 17:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9DCF1611CC;
        Wed,  7 Apr 2021 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617830409;
        bh=xnJGt82pAEssjL3cr+7CjzyByULwUwRGOhibDvGHKiQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VBVhOeH642mTkyYY8qfpoExgQntchP0zYztPpEgLEHnTumpcTxbGh0z5WbITUzYOs
         G2ksc8ZviUsK4YWQaUE8boWzzWxihhv0l1Uil1ghWxpOfHq/qI//VDqaw6yKWtKLcE
         qpS81oalbUJKUbjNO/XTY8V1QCPc9Rxtj9sx38ReJceHdwq5/suj2avJ/WoKcF5yjQ
         EIy3y4YkG0OujsTIkBr7AgS9ehrnOhHKh26g25qQTKA8Kd22yVaakShUBiOZuc9ATB
         tp0t/Xy0SZ9x7h0NAd832p/ic/El3+xXnTiZpUogGYJMVkLidCkyMBCePXg3Ix7gNU
         skAXzld5lkAwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 938CB60A71;
        Wed,  7 Apr 2021 21:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethtool: document PHY tunable callbacks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783040959.17539.15270408165269480949.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 21:20:09 +0000
References: <20210407002359.1860770-1-kuba@kernel.org>
In-Reply-To: <20210407002359.1860770-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, mkubecek@suse.cz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  6 Apr 2021 17:23:59 -0700 you wrote:
> Add missing kdoc for phy tunable callbacks.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Targetting net-next to avoid conflict with upcoming patches.
> Should apply cleanly to both trees.
> 
> [...]

Here is the summary with links:
  - [net-next] ethtool: document PHY tunable callbacks
    https://git.kernel.org/netdev/net-next/c/56f15e2cb1f7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


