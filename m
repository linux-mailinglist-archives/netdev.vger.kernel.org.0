Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C088F2A1B7A
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 01:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgKAAaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 20:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgKAAaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 20:30:05 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604190604;
        bh=UEhdv3Q0+TKErpw5C66NTGav85um6DAu9uHRU7e6R3M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=w6grmRErPARoacuU/197yOLE9l0KTVAYxfogl6Ee0uuc3WzOE6Vah7HUNEiYyvbp3
         UpeRUv15M81/INF5SOUtjzXWbkGtOvcr/F5rEP1IrnGkRqgXRYl4fgnGgP5oeeenEi
         j3+lvp8+sWdgaFNGn2iMlpM2qWAF/cqd6jWtBvB8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: mcast: fix stub definition of
 br_multicast_querier_exists
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160419060462.13806.6288188533680087053.git-patchwork-notify@kernel.org>
Date:   Sun, 01 Nov 2020 00:30:04 +0000
References: <20201101000845.190009-1-vladimir.oltean@nxp.com>
In-Reply-To: <20201101000845.190009-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  1 Nov 2020 02:08:45 +0200 you wrote:
> The commit cited below has changed only the functional prototype of
> br_multicast_querier_exists, but forgot to do that for the stub
> prototype (the one where CONFIG_BRIDGE_IGMP_SNOOPING is disabled).
> 
> Fixes: 955062b03fa6 ("net: bridge: mcast: add support for raw L2 multicast groups")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: mcast: fix stub definition of br_multicast_querier_exists
    https://git.kernel.org/netdev/net-next/c/c43fd36f7fec

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


