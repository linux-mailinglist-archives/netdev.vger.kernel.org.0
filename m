Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AF3431883
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhJRMMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhJRMMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 08:12:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3D2D161351;
        Mon, 18 Oct 2021 12:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634559011;
        bh=HqaSPhUMlFlcfNoprF3LE///eSpUVIhd/IiotTyQ6o4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lNk3VSo6ST1EAX8d4naHiv4PcjmuiBL57/1MdRtVgD7TbouYUP39Vpq49Kye9Xy3Z
         MU9nso5x0zCzVmXkWgqgUHwttllaNAfhyTMT2lHxtsdZYdEf+V4hs9BtqCSUKmei8D
         4ItRpDCRo56EtBYbwfG2jjvKakDUCqHWp42FTtBbUgusyvJOv6Ds54oM6yyjzEZKSx
         MtoDJeRoGFa1z8j3rS5q5h/6HMrLOz02OLcXVSFMCt51gnhljdrrZXwMkb/b6pdLeo
         xlvJ4RmqV+F9YipzHKdvRFNmFFNWYMlSvMgWR3XU0CjYAvtCp3w+jrzZS5p2uVd093
         jCsDbtQ0BtXKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 35F0860971;
        Mon, 18 Oct 2021 12:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next] net: make use of helper netif_is_bridge_master()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163455901121.7340.10701802688930426386.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 12:10:11 +0000
References: <20211016112137.18858-1-acadx0@gmail.com>
In-Reply-To: <20211016112137.18858-1-acadx0@gmail.com>
To:     Kyungrok Chung <acadx0@gmail.com>
Cc:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, nikolay@nvidia.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 16 Oct 2021 20:21:36 +0900 you wrote:
> Make use of netdev helper functions to improve code readability.
> Replace 'dev->priv_flags & IFF_EBRIDGE' with netif_is_bridge_master(dev).
> 
> Signed-off-by: Kyungrok Chung <acadx0@gmail.com>
> ---
> 
> v1->v2:
>   - Apply fixes to batman-adv, core too.
> 
> [...]

Here is the summary with links:
  - [v3,net-next] net: make use of helper netif_is_bridge_master()
    https://git.kernel.org/netdev/net-next/c/254ec036db11

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


