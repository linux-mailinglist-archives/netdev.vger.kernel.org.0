Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E57441BC9
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhKANji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:39:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231867AbhKANjh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:39:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C2AD610A2;
        Mon,  1 Nov 2021 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635773408;
        bh=Iz6auN8gbtJOpyYFD4BZiDgoen1ATD6b9AkJq/feGnk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HIHPQh+vPsNoZYqMB4paoNJEOKIgKqTrxOGvjqLwcldECX8akpem4xcC7dybTR8XL
         kWzJ60SWkfW139S6vOwVEO0eUTeDV7HC0n5y5eMp3MVj56nbcMOtLRAn2lQVS4ZplS
         tuYItw6IWPX3cvBC0OZIa3jkBwfTTFX2y9GW8lD6VJq69LbNkJGumLHZrAKCz1H/2a
         hc9uAbuvAVMOa/54RkyW9MBJpPJxfgMIpTdjD0xNlO9M4MYf7wtWUUab2CuKND3Y7Q
         W7BSTDyygS1G5Xb7dHJlKqPfIU/h0ng5wBkpnVaQdx7W37Ecs7DN7QLScNma59J0tF
         GTO75l2A79oaw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 64C5F60A94;
        Mon,  1 Nov 2021 13:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] improve ethtool/rtnl vs devlink locking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163577340840.3113.1602919922827934638.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 13:30:08 +0000
References: <20211030171851.1822583-1-kuba@kernel.org>
In-Reply-To: <20211030171851.1822583-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        leon@kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        f.fainelli@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 30 Oct 2021 10:18:47 -0700 you wrote:
> During ethtool netlink development we decided to move some of
> the commmands to devlink. Since we don't want drivers to implement
> both devlink and ethtool version of the commands ethtool ioctl
> falls back to calling devlink. Unfortunately devlink locks must
> be taken before rtnl_lock. This results in a questionable
> dev_hold() / rtnl_unlock() / devlink / rtnl_lock() / dev_put()
> pattern.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] ethtool: push the rtnl_lock into dev_ethtool()
    https://git.kernel.org/netdev/net-next/c/f49deaa64af1
  - [net-next,v2,2/4] ethtool: handle info/flash data copying outside rtnl_lock
    https://git.kernel.org/netdev/net-next/c/095cfcfe13e5
  - [net-next,v2,3/4] devlink: expose get/put functions
    https://git.kernel.org/netdev/net-next/c/46db1b77cd4f
  - [net-next,v2,4/4] ethtool: don't drop the rtnl_lock half way thru the ioctl
    https://git.kernel.org/netdev/net-next/c/1af0a0948e28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


