Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182043B9632
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhGASmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhGASme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:42:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 21F3461406;
        Thu,  1 Jul 2021 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625164804;
        bh=I5Q5ZRClVobEHwo46H0qpm6Dv1sl27G12pLsE/42/WM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n1PSOH01pqbbguEg2h1QgGSlyAW9a3XYHpIwGvFjiaQcIaufVCYGPeXltQOa/LIjh
         LJEiqitKbMnQszVw7J2VYH6T+KZy0A0FgzVHdxUOa/tIPLgPjSKu5bIj2jq/wXtq1e
         rq4T58W70ZxA3WW9gPCsmpEM1axNbQep8UaclAmqJwq07DGKXrGZRtV9C4MXbXbr7+
         VayFVR2u1Qt8PazK2pCyIQalFe5UHv2pnNtYFUBAc4yegX/BYnj3oXoeRybmY1LR8I
         554HhVSUcW+f7aJNUUVNIKgwKTXSsSr2wT2njw+mwIi5arF2SJdzwRyn3HhIIpVb4L
         F+BzhyGYkns8A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 10AAE60A17;
        Thu,  1 Jul 2021 18:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: return -EOPNOTSUPP when driver does not
 implement .port_lag_join
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162516480406.21656.16205874493520440945.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 18:40:04 +0000
References: <20210629203215.2639720-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210629203215.2639720-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 29 Jun 2021 23:32:15 +0300 you wrote:
> The DSA core has a layered structure, and even though we end up
> returning 0 (success) to user space when setting a bonding/team upper
> that can't be offloaded, some parts of the framework actually need to
> know that we couldn't offload that.
> 
> For example, if dsa_switch_lag_join returns 0 as it currently does,
> dsa_port_lag_join has no way to tell a successful offload from a
> software fallback, and it will call dsa_port_bridge_join afterwards.
> Then we'll think we're offloading the bridge master of the LAG, when in
> fact we're not even offloading the LAG. In turn, this will make us set
> skb->offload_fwd_mark = true, which is incorrect and the bridge doesn't
> like it.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: return -EOPNOTSUPP when driver does not implement .port_lag_join
    https://git.kernel.org/netdev/net-next/c/b71d09871566

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


