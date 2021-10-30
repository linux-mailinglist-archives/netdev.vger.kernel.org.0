Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6EA44077B
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 06:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhJ3Emo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 00:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231664AbhJ3Emh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 00:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2423D6103E;
        Sat, 30 Oct 2021 04:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635568808;
        bh=ME15JTBtRhbmY8byg9sHjWHJBuhLgAMtuU7FGSHaVyE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rQJfIq9TKR855JZDF6cCgDMzMqneiYP2ESwz6kmpuVHyrFNDFV7B716PriAy0mQsV
         udxzfQ0ORe4U6PDU9U7zCO/Bmb1we1KlC7m4l2JELPxFYqsTrU0MWv7Op82Lij2kxH
         9TMkb0r0CB7sxu0rdYuoMEIPo2xleeBmj4CqqQ2P6LmYZYnteSizS770SdrQjal6VP
         M6m7BsLPceuOKTLppbZckNvbLzCkbs8NEyvIfUWiPeWGw58pDYQ1EKDrcHn0hIrMhZ
         z0Spx/7t4aBqd74MD4x3AyUjYpHZp/5HlQjUVffP1mgwum28NJeCeU53Gk4IDbt5Gj
         WhFg9SGxMvmQA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0163C60A47;
        Sat, 30 Oct 2021 04:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: switchdev: fix shim definition for
 br_switchdev_mdb_notify
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163556880800.10957.12949174206170467469.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Oct 2021 04:40:08 +0000
References: <20211029223606.3450523-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211029223606.3450523-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@nvidia.com, idosch@nvidia.com,
        kuba@kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 30 Oct 2021 01:36:06 +0300 you wrote:
> br_switchdev_mdb_notify() is conditionally compiled only when
> CONFIG_NET_SWITCHDEV=y and CONFIG_BRIDGE_IGMP_SNOOPING=y. It is called
> from br_mdb.c, which is conditionally compiled only when
> CONFIG_BRIDGE_IGMP_SNOOPING=y.
> 
> The shim definition of br_switchdev_mdb_notify() is therefore needed for
> the case where CONFIG_NET_SWITCHDEV=n, however we mistakenly put it
> there for the case where CONFIG_BRIDGE_IGMP_SNOOPING=n. This results in
> build failures when CONFIG_BRIDGE_IGMP_SNOOPING=y and
> CONFIG_NET_SWITCHDEV=n.
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: switchdev: fix shim definition for br_switchdev_mdb_notify
    https://git.kernel.org/netdev/net-next/c/ae0393500e3b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


