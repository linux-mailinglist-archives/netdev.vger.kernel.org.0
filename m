Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0535E41AED1
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240717AbhI1MVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240529AbhI1MVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:21:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0CE666101A;
        Tue, 28 Sep 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632831607;
        bh=DaCu//g3isYBrUB+oTN5FtlME6iv9BMcwwGgCgULzoY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I5Mu/8ZLP2sTHdN++wGRrOjeOGP2bFCdNhN4iIw+zgYwVsPPQa3krGvHJnmTmsikd
         JFxspRx8PwxqG0GrmlF2KZ5BXsGd8u9ndZ1Y1pTZTtOznlW78B6eFpXRge70ZKdatE
         PYswObEMpfUHW2sZgA7bBCmd6a3mUAtxqPhwLMqVhKK39hX14V0OIS8AYcf9ytl/Oc
         hVI/+0FC3oyWhNAel1LprC+vf8vL5u/soTDaURmqCe2FGKSxvpruupM2JrSabBRsp7
         rD/xpVZHrrUYCl/OeUrdYOOUHHHBhT0KcltITG2Y70qxZcimrtkDd8DTguAg8MtHp3
         7yeUDK4fwxGQw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 010CF609D2;
        Tue, 28 Sep 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2021-09-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283160699.2416.2539156319469157037.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:20:06 +0000
References: <20210927171640.1842507-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210927171640.1842507-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 27 Sep 2021 10:16:38 -0700 you wrote:
> This series contains updates to e100 driver only.
> 
> Jake corrects under allocation of register buffer due to incorrect
> calculations and fixes buffer overrun of register dump.
> 
> The following are changes since commit 3b1b6e82fb5e08e2cb355d7b2ee8644ec289de66:
>   net: phy: enhance GPY115 loopback disable function
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE
> 
> [...]

Here is the summary with links:
  - [net,1/2] e100: fix length calculation in e100_get_regs_len
    https://git.kernel.org/netdev/net/c/4329c8dc110b
  - [net,2/2] e100: fix buffer overrun in e100_get_regs
    https://git.kernel.org/netdev/net/c/51032e6f17ce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


