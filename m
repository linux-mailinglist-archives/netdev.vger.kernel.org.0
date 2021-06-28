Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1893B6A2C
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 23:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237923AbhF1VX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 17:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237869AbhF1VXX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2826461D04;
        Mon, 28 Jun 2021 21:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915257;
        bh=Xc670gwzlMDeUMeamYpbTZ0F0Ee3L3zccg1muFuc1is=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HPvPCTOShteaPLwg3idEgx3A83MQixv2/tgCyMhrDn6MDR0K4jgcI9iUWiTIKHFdC
         wT943CJgxYrt0VcMBLt3rqizOXjrzzVcdzhseB+eggW6WRplUAciAwhZTpzzS75HaA
         nMjHfCqXx/1hkqwSTdbdk9JwE+CXc81F2Y6FkAyHsM5NecpcJj++ABIqIezng9pVjD
         mlsbuvKEIZPqG7PhDlc3JxLpHGXS1Xiqlm8hlTlymE29OkWajqZwcsDiOsiV5c8Wgx
         HWq+jJFEt8kK8WF1Usmy3njvBO/uP4NnxS/GmHP6naz8F/Y6sqeJGT7TkVwyc583DK
         F+Xibp/2PfzfA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2256E60CE2;
        Mon, 28 Jun 2021 21:20:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/8] Cleanup for the bridge replay helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491525713.9606.11689769405895980151.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 21:20:57 +0000
References: <20210627115429.1084203-1-olteanv@gmail.com>
In-Reply-To: <20210627115429.1084203-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tobias@waldekranz.com, jiri@resnulli.us, idosch@idosch.org,
        roopa@nvidia.com, nikolay@nvidia.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 27 Jun 2021 14:54:21 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This patch series brings some improvements to the logic added to the
> bridge and DSA to handle LAG interfaces sandwiched between a bridge and
> a DSA switch port.
> 
>         br0
>         /  \
>        /    \
>      bond0  swp2
>      /  \
>     /    \
>   swp0  swp1
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/8] net: bridge: include the is_local bit in br_fdb_replay
    https://git.kernel.org/netdev/net-next/c/e887b2df6251
  - [v2,net-next,2/8] net: ocelot: delete call to br_fdb_replay
    https://git.kernel.org/netdev/net-next/c/97558e880f63
  - [v2,net-next,3/8] net: switchdev: add a context void pointer to struct switchdev_notifier_info
    https://git.kernel.org/netdev/net-next/c/69bfac968a06
  - [v2,net-next,4/8] net: bridge: ignore switchdev events for LAG ports which didn't request replay
    https://git.kernel.org/netdev/net-next/c/0d2cfbd41c4a
  - [v2,net-next,5/8] net: bridge: constify variables in the replay helpers
    https://git.kernel.org/netdev/net-next/c/bdf123b455ce
  - [v2,net-next,6/8] net: bridge: allow the switchdev replay functions to be called for deletion
    https://git.kernel.org/netdev/net-next/c/7e8c18586daf
  - [v2,net-next,7/8] net: dsa: refactor the prechangeupper sanity checks into a dedicated function
    https://git.kernel.org/netdev/net-next/c/4ede74e73b5b
  - [v2,net-next,8/8] net: dsa: replay a deletion of switchdev objects for ports leaving a bridged LAG
    https://git.kernel.org/netdev/net-next/c/749189453234

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


