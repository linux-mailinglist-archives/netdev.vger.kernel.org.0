Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7B143F540
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 05:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhJ2DMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 23:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231603AbhJ2DMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 23:12:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 19FF6610CF;
        Fri, 29 Oct 2021 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635477009;
        bh=dwkACdS6H9/53wEhM4zzYe8QWQ2phsR052rDyAADiHI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mmoykt6jdCfqw1ytlakvegLaPuh4hY5AlA+zTmGDUPVbG5xAzSo1qyYnZJjR9ySTU
         SSiA7oCeoosP/1L0prdjidiD9B1Rs9REN6cTXD4vZ7ST0gJpQeIeqiwVTafF/ddtgH
         eIk7/96wvE3LnNPFt1r7q7kMQDJbIAA8lSN1uFLQw833qAtcpJBQGvbkB4CvJp0HOc
         eTvATQjaqAtnvMKAPEKRGPluRoXg+rudSZWW7nj0NC2Ux0gS32U4jR4tCG9TC/dJA4
         u0t7omqZlvosQwlVoVG53qf0rP6pN7nE+WJ7dgkZr3mnO+2tB9K9KbT8F6cwf/DTDp
         NeRQqQdmSdHaQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0CF5560A25;
        Fri, 29 Oct 2021 03:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] Code movement to br_switchdev.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163547700904.18853.17271389972838832922.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 03:10:09 +0000
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        roopa@nvidia.com, nikolay@nvidia.com, jiri@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Oct 2021 19:21:14 +0300 you wrote:
> This is one more refactoring patch set for the Linux bridge, where more
> logic that is specific to switchdev is moved into br_switchdev.c, which
> is compiled out when CONFIG_NET_SWITCHDEV is disabled.
> 
> Vladimir Oltean (5):
>   net: bridge: provide shim definition for br_vlan_flags
>   net: bridge: move br_vlan_replay to br_switchdev.c
>   net: bridge: split out the switchdev portion of br_mdb_notify
>   net: bridge: mdb: move all switchdev logic to br_switchdev.c
>   net: bridge: switchdev: consistent function naming
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: bridge: provide shim definition for br_vlan_flags
    https://git.kernel.org/netdev/net-next/c/c5f6e5ebc2af
  - [net-next,2/5] net: bridge: move br_vlan_replay to br_switchdev.c
    https://git.kernel.org/netdev/net-next/c/4a6849e46173
  - [net-next,3/5] net: bridge: split out the switchdev portion of br_mdb_notify
    https://git.kernel.org/netdev/net-next/c/9ae9ff994b0e
  - [net-next,4/5] net: bridge: mdb: move all switchdev logic to br_switchdev.c
    https://git.kernel.org/netdev/net-next/c/9776457c784f
  - [net-next,5/5] net: bridge: switchdev: consistent function naming
    https://git.kernel.org/netdev/net-next/c/326b212e9cd6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


