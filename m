Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4D92F6FB6
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 01:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbhAOAuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 19:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726499AbhAOAus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 19:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8412C23AAA;
        Fri, 15 Jan 2021 00:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610671808;
        bh=tO3cd+8KpxkHWUFfWWMrdfZcIP6QzECRkSxdJ7Me59o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q6NSqrda09cwGX0xYwIlVTUva8O7pq/PFOA15b3ZuXXaiV17UEMNxDXDHDP0udJ11
         53+EQACfpP0IsPfBWRFaUFeKJ+0/s0g4eazbm13B0h8pBP4R7R77/kPS0+m7GJ8C8A
         Ndv83Ld6XFD4/xeegr1x6z8mNjaNNY0rhQhwJGLoQ3VBnYaHXB2X8i4OhpXjXOTQUT
         1sgz6tToDbso+tz9TqmbhrsUhWklkk2tIVvaUWkO+dEfKsIpwyctXKKW2MVkvUT9if
         gIsl06qAiSCw6yYUxYbJd33++jpCwbtptcVSFWtaEPdaA/M80TdbOvKgLvwsMK2l7k
         KtUejW6U56QKQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 76AEB60156;
        Fri, 15 Jan 2021 00:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: marvell: prestera: fix uninitialized vid in
 prestera_port_vlans_add
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161067180848.3913.16168009401254422093.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jan 2021 00:50:08 +0000
References: <20210114083556.2274440-1-olteanv@gmail.com>
In-Reply-To: <20210114083556.2274440-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, kurt@linutronix.de, vkochan@marvell.com,
        tchornyi@marvell.com, idosch@nvidia.com,
        clang-built-linux@googlegroups.com, linux-mm@kvack.org,
        kbuild-all@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 14 Jan 2021 10:35:56 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> prestera_bridge_port_vlan_add should have been called with vlan->vid,
> however this was masked by the presence of the local vid variable and I
> did not notice the build warning.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: b7a9e0da2d1c ("net: switchdev: remove vid_begin -> vid_end range from VLAN objects")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: marvell: prestera: fix uninitialized vid in prestera_port_vlans_add
    https://git.kernel.org/netdev/net-next/c/c612fe780803

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


