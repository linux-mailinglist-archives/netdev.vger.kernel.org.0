Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2E03DAE1E
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 23:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbhG2VUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 17:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230180AbhG2VUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 17:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CA3E860FED;
        Thu, 29 Jul 2021 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627593605;
        bh=W6j6VhJVmJ+zilp6szYslrBSpmRlIBjMbUADVxc11PI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kc5XARq1lhAB2ZkdDIfU9h8l+FTfGIw0ztsWb3yDd4wbuXmWRiJgjjjsKZu9pGswK
         RMvR/bRs4kkv5gjHLbRKDu4+0+OLEFRuUgxiBX0Ieo+3ybfAutucslvUg42YYPk1OZ
         dIYy7h9X4FkaWyQL1AhwNwa24ByzNa//Ut2oQ1dKnfI0u6skqkfD1fRQgNGRHsnh37
         v6ysodmQcOsFPRdnt5XumctAm2q1J0SQZAaN6Zs2I7AOHn7q4EDLwKUxz1s62+c0cA
         yvYj6I9YtW9hgoPi0u1U715tbAAUgN8cGHE8J5ekdH3n6qc02kR8LOnPwURpl9mE5V
         mcMvWo4RsQuKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BFE6760A7F;
        Thu, 29 Jul 2021 21:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipvlan: Add handling of NETDEV_UP events
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162759360578.14384.13077245399190990156.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Jul 2021 21:20:05 +0000
References: <20210729131930.1991-1-zhudi21@huawei.com>
In-Reply-To: <20210729131930.1991-1-zhudi21@huawei.com>
To:     Di Zhu <zhudi21@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, maheshb@google.com,
        netdev@vger.kernel.org, rose.chen@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 29 Jul 2021 21:19:30 +0800 you wrote:
> When an ipvlan device is created on a bond device, the link state
> of the ipvlan device may be abnormal. This is because bonding device
> allows to add physical network card device in the down state and so
> NETDEV_CHANGE event will not be notified to other listeners, so ipvlan
> has no chance to update its link status.
> 
> The following steps can cause such problems:
> 	1) bond0 is down
> 	2) ip link add link bond0 name ipvlan type ipvlan mode l2
> 	3) echo +enp2s7 >/sys/class/net/bond0/bonding/slaves
> 	4) ip link set bond0 up
> 
> [...]

Here is the summary with links:
  - ipvlan: Add handling of NETDEV_UP events
    https://git.kernel.org/netdev/net-next/c/57fb346cc7d0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


