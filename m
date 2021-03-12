Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45FB338252
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhCLAa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:30:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231234AbhCLAaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 19:30:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id F2CE164F9A;
        Fri, 12 Mar 2021 00:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615509015;
        bh=yjoJT+XJCfIs36gwS6832fcUkp9vsHEpItPmYOvQnWA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KeTWVa12wQbNf847bmu1XlTOwMVEsF4kB97URiIae0yvIZBwOYivBcKZSwTRynYde
         +L3GEH9yb3Fxi9V9pCL0tlm2eYOoFkJ6l84xe93vlklbcjbJqHK27QG81iuHEMo0A6
         q5RrJ1sXZoegSJRplJymUssVErjgjdoQZ+c+TR9YLf0KW41YyTtn1pL9HRIuhSkD57
         lu+2jGzwCwnKHMxBwKybEKF3Ec5lLslh6BmxNz0U8yEBB5Wa1AUtbf9LhjCjHZQnLz
         6zhLWJu32pNip9JrFIfN7i70JVHkbsoGWJvinwtnoYipW8vnGUoc1P64l6HW251+Ec
         By8fQ+wdLnpZw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E2953609F0;
        Fri, 12 Mar 2021 00:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/14] nexthop: Resilient next-hop groups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161550901492.18262.4907275951287000292.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 00:30:14 +0000
References: <cover.1615485052.git.petrm@nvidia.com>
In-Reply-To: <cover.1615485052.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, idosch@nvidia.com, dsahern@kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Mar 2021 19:03:11 +0100 you wrote:
> At this moment, there is only one type of next-hop group: an mpath group.
> Mpath groups implement the hash-threshold algorithm, described in RFC
> 2992[1].
> 
> To select a next hop, hash-threshold algorithm first assigns a range of
> hashes to each next hop in the group, and then selects the next hop by
> comparing the SKB hash with the individual ranges. When a next hop is
> removed from the group, the ranges are recomputed, which leads to
> reassignment of parts of hash space from one next hop to another. RFC 2992
> illustrates it thus:
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/14] nexthop: Pass nh_config to replace_nexthop()
    https://git.kernel.org/netdev/net-next/c/597f48e46b6e
  - [net-next,v2,02/14] nexthop: __nh_notifier_single_info_init(): Make nh_info an argument
    https://git.kernel.org/netdev/net-next/c/96a856256a43
  - [net-next,v2,03/14] nexthop: Add a dedicated flag for multipath next-hop groups
    https://git.kernel.org/netdev/net-next/c/90e1a9e21326
  - [net-next,v2,04/14] nexthop: Add netlink defines and enumerators for resilient NH groups
    https://git.kernel.org/netdev/net-next/c/710ec5622306
  - [net-next,v2,05/14] nexthop: Add implementation of resilient next-hop groups
    https://git.kernel.org/netdev/net-next/c/283a72a5599e
  - [net-next,v2,06/14] nexthop: Add data structures for resilient group notifications
    https://git.kernel.org/netdev/net-next/c/b8f090d0beb1
  - [net-next,v2,07/14] nexthop: Implement notifiers for resilient nexthop groups
    https://git.kernel.org/netdev/net-next/c/7c37c7e00411
  - [net-next,v2,08/14] nexthop: Allow setting "offload" and "trap" indication of nexthop buckets
    https://git.kernel.org/netdev/net-next/c/56ad5ba344de
  - [net-next,v2,09/14] nexthop: Allow reporting activity of nexthop buckets
    https://git.kernel.org/netdev/net-next/c/cfc15c1dbb0b
  - [net-next,v2,10/14] nexthop: Add netlink handlers for resilient nexthop groups
    https://git.kernel.org/netdev/net-next/c/a2601e2b1e7e
  - [net-next,v2,11/14] nexthop: Add netlink handlers for bucket dump
    https://git.kernel.org/netdev/net-next/c/8a1bbabb034d
  - [net-next,v2,12/14] nexthop: Add netlink handlers for bucket get
    https://git.kernel.org/netdev/net-next/c/187d4c6b9796
  - [net-next,v2,13/14] nexthop: Notify userspace about bucket migrations
    https://git.kernel.org/netdev/net-next/c/0b4818aabcd6
  - [net-next,v2,14/14] nexthop: Enable resilient next-hop groups
    https://git.kernel.org/netdev/net-next/c/15e1dd570306

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


