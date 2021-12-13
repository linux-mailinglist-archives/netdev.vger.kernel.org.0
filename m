Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBC8472FE9
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239413AbhLMPAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:00:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57816 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbhLMPAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:00:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 731E761119
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 15:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCA73C34602;
        Mon, 13 Dec 2021 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639407609;
        bh=P1592NTiHlTihHZqOzz39eV+sIWt9FM4nDuB4rh89cg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=enVZhgmPjrCI+8CcF0W54RNGrKkikp3XZuyhzwc6fs785/jEaGHHYhR/ZA9tN6eyY
         4V39Ya/AnUvr+sqWguhJnONvE4mfn5G9+apCe63zRQBSYi9Inp6ECMy+1BO5NLF5tz
         FzBxXfQ/UQxODjAMkdeYHhkkcVRzO6UsFEhn7gWFCVd7fh9JxRapCbl/A+RgQZWYwF
         t627FORVb5vPGicRGEniN9nLixEsIyOZxHWtQcLABDp645ho74KjKlJGHSm2CdRyhV
         KWaEnW9/fQo9AP2WxgScmXAWykjqiBdCsPy/P4NIhZIf2DGrZkj6jYHAv310sWlq5H
         GnOeeqnmLU2XA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B5D916098C;
        Mon, 13 Dec 2021 15:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: add a note about refcounting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940760974.26947.9407847088781132753.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 15:00:09 +0000
References: <E1mwj8r-00FjNH-Ix@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mwj8r-00FjNH-Ix@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Dec 2021 11:05:13 +0000 you wrote:
> Recently, a patch has been submitted to "fix" the refcounting for a DT
> node in of_mdiobus_link_mdiodev(). This is not a leaked refcount. The
> refcount is passed to the new device.
> 
> Sadly, coccicheck identifies this location as a leaked refcount, which
> means we're likely to keep getting patches to "fix" this. However,
> fixing this will cause breakage. Add a comment to state that the lack
> of of_node_put() here is intentional.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: add a note about refcounting
    https://git.kernel.org/netdev/net/c/d33dae51645c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


