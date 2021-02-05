Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48B0310422
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 05:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhBEEkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:40:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230138AbhBEEks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 23:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 89D7564FC1;
        Fri,  5 Feb 2021 04:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612500007;
        bh=PPi4uX5/bWHSO28ML8Yqmk7CF0iEy/CbpOzJ+mYq2q8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a5RRkAIFvEw1uQKxzOwpgghxpjr+YhYLaR3I/GUMHYjnLofRdfPTk6k5dwcBfXayL
         osQXJqwYPGOox2m7GiHXzhf7tm4y8ma3pGA9NlJr05uaBM5kvt+MsumKg8N+7Z+89b
         p3KfEYjKiAoSZJVgFTyM7ivHFQ+CbTRDOiQ1O8mxkaDsuyvA9gHdow2ox0S0tZTbQy
         pYQBcBaOfXcT/Dor8kiIlhSWUbAgdoqrvBamB8t3WMszH/mTCYze+D7eYElMOuecrS
         GylkC82pGtwz7bkH62QsZ18djWzJdL3XpKPiF62JSAAiyyRa5eMAhIFcbky2IcELai
         4KfXW1tnBuBGQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7503C609F5;
        Fri,  5 Feb 2021 04:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: call teardown method on probe failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161250000747.27819.14304402689656646774.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 04:40:07 +0000
References: <20210204163351.2929670-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210204163351.2929670-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Feb 2021 18:33:51 +0200 you wrote:
> Since teardown is supposed to undo the effects of the setup method, it
> should be called in the error path for dsa_switch_setup, not just in
> dsa_switch_teardown.
> 
> Fixes: 5e3f847a02aa ("net: dsa: Add teardown callback for drivers")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: call teardown method on probe failure
    https://git.kernel.org/netdev/net/c/8fd54a73b7cd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


