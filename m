Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A0F42048D
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 02:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhJDAl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 20:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230508AbhJDAl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 20:41:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D90E861362;
        Mon,  4 Oct 2021 00:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633308008;
        bh=BIv1Whxq637eji3IDuAQdKo8gjBB0EqktsdVANA93co=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oFGXf9eAd4OVohoEYiYyTRal727uToEnCCqA7OUUwukwFLCHv5Uu9ddy8B850P0X7
         uRQNKndnbWRzx4X7FFvh2+xBtpm9h/64AZapIksgKDQptptZvJVvQg2K853caDx2ap
         iYBaScse8VbEtYG+wuqZfZZ6Udt5jNFbonQCHzSxrE95qML1CgCzluBLPy2nj6d1jx
         sWPBzN8DfW/GOLvjTjeVpM0xuY+XuxfdAR6Zz+ejxqPYbUknlzSk6epkqYr4QPKDQ6
         A+wDzFP+yiwaWfu4wAZi6UTcWNzVDmcjyMFjjJUBm7Zy6IB2PwKEdYRkG/o5mydj6W
         jGcMzsSmZNHDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C8E6260971;
        Mon,  4 Oct 2021 00:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 00/12] ip: nexthop: cache nexthops and print
 routes' nh info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163330800881.10241.15878981717990557235.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Oct 2021 00:40:08 +0000
References: <20210930113844.1829373-1-razor@blackwall.org>
In-Reply-To: <20210930113844.1829373-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, donaldsharp72@gmail.com,
        dsahern@gmail.com, idosch@idosch.org, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (refs/heads/main):

On Thu, 30 Sep 2021 14:38:32 +0300 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This set tries to help with an old ask that we've had for some time
> which is to print nexthop information while monitoring or dumping routes.
> The core problem is that people cannot follow nexthop changes while
> monitoring route changes, by the time they check the nexthop it could be
> deleted or updated to something else. In order to help them out I've
> added a nexthop cache which is populated (only used if -d / show_details
> is specified) while decoding routes and kept up to date while monitoring.
> The nexthop information is printed on its own line starting with the
> "nh_info" attribute and its embedded inside it if printing JSON. To
> cache the nexthop entries I parse them into structures, in order to
> reuse most of the code the print helpers have been altered so they rely
> on prepared structures. Nexthops are now always parsed into a structure,
> even if they won't be cached, that structure is later used to print the
> nexthop and destroyed if not going to be cached. New nexthops (not found
> in the cache) are retrieved from the kernel using a private netlink
> socket so they don't disrupt an ongoing dump, similar to how interfaces
> are retrieved and cached.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,01/12] ip: print_rta_if takes ifindex as device argument instead of attribute
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=f72789965eff
  - [iproute2-next,02/12] ip: export print_rta_gateway version which outputs prepared gateway string
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=371e889da771
  - [iproute2-next,03/12] ip: nexthop: add resilient group structure
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=cfb0a8729ea4
  - [iproute2-next,04/12] ip: nexthop: split print_nh_res_group into parse and print parts
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=60a7515b89ff
  - [iproute2-next,05/12] ip: nexthop: add nh entry structure
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=7ec1cee630e3
  - [iproute2-next,06/12] ip: nexthop: parse attributes into nh entry structure before printing
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=945c26db686b
  - [iproute2-next,07/12] ip: nexthop: factor out print_nexthop's nh entry printing
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a2ca43121501
  - [iproute2-next,08/12] ip: nexthop: factor out ipnh_get_id rtnl talk into a helper
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=53d7c43bd385
  - [iproute2-next,09/12] ip: nexthop: add cache helpers
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=60a970303288
  - [iproute2-next,10/12] ip: nexthop: add a helper which retrieves and prints cached nh entry
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=cb3d18c29e20
  - [iproute2-next,11/12] ip: route: print and cache detailed nexthop information when requested
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=5d5dc549ce7d
  - [iproute2-next,12/12] ip: nexthop: add print_cache_nexthop which prints and manages the nh cache
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=7ca868a7aa26

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


