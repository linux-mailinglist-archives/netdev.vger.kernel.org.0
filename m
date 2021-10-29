Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29D043FB87
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhJ2Lml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231910AbhJ2Lmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 07:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E683D611C0;
        Fri, 29 Oct 2021 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635507609;
        bh=Un2PWZDIINEDg72l3qq2tMfq/nXrwCT5Ihooa+SxmIM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HKfoEleujR1PTGMn5r3wHO3CMcSfhOu2co5K/f/CRWVWxQvoGr502M6nIKoscMN+x
         9G6k7+Ivnzdyzi+z3bb5GH2MOUfjmnbaQDAxgKmXs/Q6Q9sIS+CTpNo8Nm3oy7ryBZ
         65yByIEvymeauFNxRYd2cSKTZR3M0lD6zbZ2cDlQ9Poc77PxVJppz0lKFL8X7jYbrD
         r6dFdpohqjId8jJiQtzn0Tasni6k7cquNaw/Y9xlqNarINuAtS4h+ZtJCzbbEmhcOL
         xsMxERKcjXowe2qNaSuAMIDP/Q4Ptjxzt8/k7Kb7azaVLd5yRMI6aK4t/Bkyk9eHZd
         j9mCLw42g9ryw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CF91A60A17;
        Fri, 29 Oct 2021 11:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net,v3] net: amd-xgbe: Toggle PLL settings during rate change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163550760984.31573.4052732278064061942.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 11:40:09 +0000
References: <20211027095727.2072881-1-Shyam-sundar.S-k@amd.com>
In-Reply-To: <20211027095727.2072881-1-Shyam-sundar.S-k@amd.com>
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Raju.Rangoju@amd.com,
        sudheesh.mavila@amd.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Oct 2021 15:27:27 +0530 you wrote:
> For each rate change command submission, the FW has to do a phy
> power off sequence internally. For this to happen correctly, the
> PLL re-initialization control setting has to be turned off before
> sending mailbox commands and re-enabled once the command submission
> is complete.
> 
> Without the PLL control setting, the link up takes longer time in a
> fixed phy configuration.
> 
> [...]

Here is the summary with links:
  - [net,v3] net: amd-xgbe: Toggle PLL settings during rate change
    https://git.kernel.org/netdev/net/c/daf182d360e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


