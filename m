Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7AD362C64
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 02:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbhDQAUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 20:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235037AbhDQAUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 20:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E3BE2611AC;
        Sat, 17 Apr 2021 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618618813;
        bh=9wWq4k3tWpU6QjWArF710iLxNEdprit2kzmU8hh3djM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZJH/UburGVdy1iX+ILYrcjqEAk4LQtd6bKuN2Cx2bPtXAHWEVETxtDitELtYdVhqa
         BQnoFLsj57pTc+56hR0l48RgWamwWkuF1uSLXVz4CQ+LASu8LBMloMJ6aen8+G0E7l
         uh9vZbHRN4xDg/acWqj8uHGZjagB1Gjp14d7S8iV//TwIDSefJOZB0VGZYu+qDam4+
         Dzvv/tmJUyXQgI5S20a9pH/8iMZN0vnSvNVfzfo09+jwwaS+b3gsjocO23HSapThOc
         N49CzS7rq4+Uz3WBsiEWvWp0u/PsxSGsOedvMV5xWMste3ubBc1EG8/RzRJalpodET
         fUoOQD4EL1OuA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D561060CD8;
        Sat, 17 Apr 2021 00:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mptcp: Fixes and tracepoints from the mptcp tree
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861881386.3813.9063075073359203442.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Apr 2021 00:20:13 +0000
References: <20210416223808.298842-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210416223808.298842-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 15:38:00 -0700 you wrote:
> Here's one more batch of changes that we've tested out in the MPTCP tree.
> 
> 
> Patch 1 makes the MPTCP KUnit config symbol more consistent with other
> subsystems.
> 
> Patch 2 fixes a couple of format specifiers in pr_debug()s
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] kunit: mptcp: adhere to KUNIT formatting standard
    https://git.kernel.org/netdev/net-next/c/3fcc8a25e391
  - [net-next,2/8] mptcp: fix format specifiers for unsigned int
    https://git.kernel.org/netdev/net-next/c/e4b6135134a7
  - [net-next,3/8] mptcp: export mptcp_subflow_active
    https://git.kernel.org/netdev/net-next/c/43f1140b9678
  - [net-next,4/8] mptcp: add tracepoint in mptcp_subflow_get_send
    https://git.kernel.org/netdev/net-next/c/e10a98920976
  - [net-next,5/8] mptcp: add tracepoint in get_mapping_status
    https://git.kernel.org/netdev/net-next/c/0918e34b85c7
  - [net-next,6/8] mptcp: add tracepoint in ack_update_msk
    https://git.kernel.org/netdev/net-next/c/ed66bfb4ce34
  - [net-next,7/8] mptcp: add tracepoint in subflow_check_data_avail
    https://git.kernel.org/netdev/net-next/c/d96a838a7ce2
  - [net-next,8/8] mptcp: use mptcp_for_each_subflow in mptcp_close
    https://git.kernel.org/netdev/net-next/c/442279154c73

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


