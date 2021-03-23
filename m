Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBEC346B8F
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 23:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhCWWA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 18:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233752AbhCWWAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 18:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 52EFF619D1;
        Tue, 23 Mar 2021 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616536810;
        bh=UqdmPjzkBMkGpEoz/xGIJUyvpKm2m45avXdl9Jp2vSk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mlwSNPAUJTFuPsY7PValXn+yvPkCN+0HkTqdOan4G6j/twKRFiGdf5GCSzc/u+wHG
         iaZtKMazQPYDLzYtCRbVAWxhTkSMb4GoMzQEAJVXkro1knq6FYIH0uIA9fGrebNQBr
         rMd0/p43xIAx2Lb65SisDaP/c81+eeb5YyUzuU97ZVYmkBi2n60qei7bAkqvCgHvEr
         Nf9PkyhXkQZOSYnW3Td3NHwsYKwojfw4gu3EpDk/uo4PHh1SvDg3eS89ZVDxpyjuns
         773or6irkjcEgtXyfleCBOhbVqVmrwYILVwdTEqpocghstUUqk69Wa9Y3MpJatzD29
         ixEZEyAgjaDvw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 429CB60A0E;
        Tue, 23 Mar 2021 22:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 00/11] Better support for sandwiched LAGs with
 bridge and DSA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161653681026.23298.16920654325980262719.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Mar 2021 22:00:10 +0000
References: <20210322235152.268695-1-olteanv@gmail.com>
In-Reply-To: <20210322235152.268695-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        tobias@waldekranz.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        roopa@nvidia.com, nikolay@nvidia.com, jiri@resnulli.us,
        idosch@idosch.org, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ivecera@redhat.com,
        linux-omap@vger.kernel.org, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 23 Mar 2021 01:51:41 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Changes in v4:
> - Added missing EXPORT_SYMBOL_GPL
> - Using READ_ONCE(fdb->dst)
> - Split patches into (a) adding the bridge helpers (b) making DSA use them
> - br_mdb_replay went back to the v1 approach where it allocated memory
>   in atomic context
> - Created a br_switchdev_mdb_populate which reduces some of the code
>   duplication
> - Fixed the error message in dsa_port_clear_brport_flags
> - Replaced "dsa_port_vlan_filtering(dp, br, extack)" with
>   "dsa_port_vlan_filtering(dp, br_vlan_enabled(br), extack)" (duh)
> - Added review tags (sorry if I missed any)
> 
> [...]

Here is the summary with links:
  - [v4,net-next,01/11] net: bridge: add helper for retrieving the current bridge port STP state
    https://git.kernel.org/netdev/net-next/c/c0e715bbd50e
  - [v4,net-next,02/11] net: bridge: add helper to retrieve the current ageing time
    https://git.kernel.org/netdev/net-next/c/f1d42ea10056
  - [v4,net-next,03/11] net: bridge: add helper to replay port and host-joined mdb entries
    https://git.kernel.org/netdev/net-next/c/4f2673b3a2b6
  - [v4,net-next,04/11] net: bridge: add helper to replay port and local fdb entries
    https://git.kernel.org/netdev/net-next/c/04846f903b53
  - [v4,net-next,05/11] net: bridge: add helper to replay VLANs installed on port
    https://git.kernel.org/netdev/net-next/c/22f67cdfae6a
  - [v4,net-next,06/11] net: dsa: call dsa_port_bridge_join when joining a LAG that is already in a bridge
    https://git.kernel.org/netdev/net-next/c/185c9a760a61
  - [v4,net-next,07/11] net: dsa: pass extack to dsa_port_{bridge,lag}_join
    https://git.kernel.org/netdev/net-next/c/2afc526ab342
  - [v4,net-next,08/11] net: dsa: inherit the actual bridge port flags at join time
    https://git.kernel.org/netdev/net-next/c/5961d6a12c13
  - [v4,net-next,09/11] net: dsa: sync up switchdev objects and port attributes when joining the bridge
    https://git.kernel.org/netdev/net-next/c/010e269f91be
  - [v4,net-next,10/11] net: ocelot: call ocelot_netdevice_bridge_join when joining a bridged LAG
    https://git.kernel.org/netdev/net-next/c/81ef35e7619a
  - [v4,net-next,11/11] net: ocelot: replay switchdev events when joining bridge
    https://git.kernel.org/netdev/net-next/c/e4bd44e89dcf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


