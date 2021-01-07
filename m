Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B9B2EE9F4
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 00:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbhAGXuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 18:50:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729377AbhAGXuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 18:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 26CB22368A;
        Thu,  7 Jan 2021 23:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610063411;
        bh=WsBGKxsLoIyXRmSK+5Qiuf8DW89sKuzB8eC7xN+Mz1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wlk1S0H8MnKOu9Iz1PR6zcYmQWWAQRA+7nGmBTUi0N8figMo0rHV+uzPOOC2Peg1R
         tb/l/VT7VcoiBu8KmszETRFy/IAJOCLBVwbhOKMuncEu2elldTldkDxQZtxbGbVI+7
         9XusnuDaA2loha+TBtObwkEmlHpTXXPaMJemWJVxqrNB1ykSuRZi6lHf9jy7sFap1I
         S+GAlhUU94MxDTjng9coQH1sjcml/m0oNBmE8bW4ZHfWpbqJBwCWJtMohRMBCPwkXW
         uf18keyqAtJ6kZiNdoxrz4qh63XzDirTTLGA6uRJJ5iwf0Bgqh0koM2yNxCwEs8dwI
         k1pcJCfl5fBnw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 1405860385;
        Thu,  7 Jan 2021 23:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/7] Offload software learnt bridge addresses to
 DSA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161006341107.8293.17599601765854120224.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jan 2021 23:50:11 +0000
References: <20210106095136.224739-1-olteanv@gmail.com>
In-Reply-To: <20210106095136.224739-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        dqfext@gmail.com, tobias@waldekranz.com, marek.behun@nic.cz,
        linux@armlinux.org.uk, wintera@linux.ibm.com, jiri@resnulli.us,
        idosch@idosch.org, claudiu.manoil@nxp.com,
        UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  6 Jan 2021 11:51:29 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series tries to make DSA behave a bit more sanely when bridged with
> "foreign" (non-DSA) interfaces and source address learning is not
> supported on the hardware CPU port (which would make things work more
> seamlessly without software intervention). When a station A connected to
> a DSA switch port needs to talk to another station B connected to a
> non-DSA port through the Linux bridge, DSA must explicitly add a route
> for station B towards its CPU port.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/7] net: bridge: notify switchdev of disappearance of old FDB entry upon migration
    https://git.kernel.org/netdev/net-next/c/90dc8fd36078
  - [v4,net-next,2/7] net: dsa: be louder when a non-legacy FDB operation fails
    https://git.kernel.org/netdev/net-next/c/2fd186501b1c
  - [v4,net-next,3/7] net: dsa: don't use switchdev_notifier_fdb_info in dsa_switchdev_event_work
    https://git.kernel.org/netdev/net-next/c/c4bb76a9a0ef
  - [v4,net-next,4/7] net: dsa: move switchdev event implementation under the same switch/case statement
    https://git.kernel.org/netdev/net-next/c/447d290a58bd
  - [v4,net-next,5/7] net: dsa: exit early in dsa_slave_switchdev_event if we can't program the FDB
    https://git.kernel.org/netdev/net-next/c/5fb4a451a87d
  - [v4,net-next,6/7] net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
    https://git.kernel.org/netdev/net-next/c/d5f19486cee7
  - [v4,net-next,7/7] net: dsa: ocelot: request DSA to fix up lack of address learning on CPU port
    https://git.kernel.org/netdev/net-next/c/c54913c1d4ee

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


