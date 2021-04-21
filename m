Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34D23662BD
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 02:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhDUAA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 20:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234508AbhDUAAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 20:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F2AD861420;
        Wed, 21 Apr 2021 00:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618963211;
        bh=PccywLwqVukZ9Bepj0ZPuwfmtZ6lNIDIH+XroWXQybA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VBx/0CPjlaw6kdi0RFXQKAannhb7BfqtM4UQzxtbesLLTcJfv2ULYvxSm1pdgP72f
         gN7bPkiHgo5HRoNRC0Fn9wPNuxqQWHWoGJ8DpE1fPZ7wP4PdmP3Z/ZbCW4o2Kj6Sav
         lWDedv6pOkedVLoFRK+2Elyy2dYhcxeCru6/zyxr9XvEvtXzZ6aEek3G9rlLlC9XTx
         xfKIeKV5fhIFZgT7v8Ul9VrOqzZymNwQJHMUTogIIR2CEL2JKJaaVhtSuvPs3464AG
         +9ekeGJMmmWuyYzi9t4EJAuN9xrdM34+Uk1kN8s5G4pIpgmx/QshijBGziJAMMbPey
         UtFDQ1eHwH9Hg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EAF2860A0B;
        Wed, 21 Apr 2021 00:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] phy: nxp-c45-tja11xx: fix phase offset calculation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896321095.2554.12227022806402774471.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 00:00:10 +0000
References: <20210420131133.370259-1-radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20210420131133.370259-1-radu-nicolae.pirea@oss.nxp.com>
To:     Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Apr 2021 16:11:33 +0300 you wrote:
> Fix phase offset calculation.
> 
> Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
> ---
>  drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> [...]

Here is the summary with links:
  - phy: nxp-c45-tja11xx: fix phase offset calculation
    https://git.kernel.org/netdev/net-next/c/6b3a63100ded

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


