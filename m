Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8D93D11F8
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239324AbhGUO32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239284AbhGUO31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 10:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 88E336121E;
        Wed, 21 Jul 2021 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626880204;
        bh=PKE3udJjMagC6Lfjaax0/FWXkExJoszm5k6qeYM1tX8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l1BCnsPfVo+SDujpEVHpJZEUyfKSh6MJQ8zirqgZJ4NKyyAIbecJp0JkybUG6EtoV
         yoec7GUPT9s3M5sUPUnWIiIJJgnGPWxhHnCoos7jXjWzimtq/asO1JOXXU9iVXu9E9
         UR1qF9UrhZwg60ylEFbbrORq2knmIcKM5DRSPF7XPgkteGT0P7x9/7gNGYN2bd0SyU
         BIhgI4PPQLu4Ji7xH380XAsn6yI1c3iw4vyP4ouK6imT2LXa4lE3tfk8bfmsOSYVN8
         w4wGkrIvvdgfp5Xg4h4JU970XkikVBdTRVfa5hL8Du1J9VWufkpvJ2lzUuPmMfCEue
         DTLpiN460pyPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D15660A0B;
        Wed, 21 Jul 2021 15:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Fixes for the switchdev FDB fan-out helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162688020450.31691.17418849685262628598.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 15:10:04 +0000
References: <20210720173557.999534-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210720173557.999534-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 20:35:55 +0300 you wrote:
> Hi,
> 
> There are already two fixes for the newly added helpers to multiply a
> switchdev FDB add/del event times the number of lower interfaces of a
> bridge. These are:
> 
> (1) the shim definition of switchdev_handle_fdb_del_to_device() is
>     broken, as reported by the kernel test robot.
> (2) while checking where switchdev_handle_fdb_del_to_device() is called
>     from, I realized it is called once from where it shouldn't, aka from
>     __switchdev_handle_fdb_del_to_device(). That shouldn't happen,
>     instead that function should recurse into itself directly.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: switchdev: remove stray semicolon in switchdev_handle_fdb_del_to_device shim
    https://git.kernel.org/netdev/net-next/c/94111dfc18b8
  - [net-next,2/2] net: switchdev: recurse into __switchdev_handle_fdb_del_to_device
    https://git.kernel.org/netdev/net-next/c/71f4f89a0324

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


