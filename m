Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06662F04D6
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 04:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbhAJDKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 22:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAJDKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 22:10:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C894422509;
        Sun, 10 Jan 2021 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610248209;
        bh=6JChLzXP0jvhx2g3Pe7Bz3wLfYlBVsBbxp/RbROPX+E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=feVjxg2nFU4zw8HicYn8Ar8KxPbkbxiQ7Nl4xXFaoDPDxOESf5+OSnwkgYqJQ1YZB
         hkpJLNKXpJ/MbL7+bjSzYAEein3YBWHTpMlPqo3dww5LZS55S1I+o1gCTvekjSI35y
         Q5EiT/Q3qO4dW/uoGu1VMtMYJxe7MzZbwHKD6VVP7RtbgMqf3nS6kBh745nBKHHAze
         PwIeKvo2Phr6ZS/9BvQig+CCOyspB6PqUYGE4pW1QskIBeTA3sLYuV8AcJwiWWzvjA
         A5/U4Y4AtvaEzEH1H9+8W/ONghou/bpAKinKsnGV9yoV7O9Ie1/+RZu9ytL6xqZM6T
         2m3qG+JU+6T0A==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id B98EC6013F;
        Sun, 10 Jan 2021 03:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] MPTCP: Add MP_PRIO support and rework local
 address IDs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161024820975.15339.2337592500355833538.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Jan 2021 03:10:09 +0000
References: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mptcp@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  8 Jan 2021 16:47:54 -0800 you wrote:
> Here are some patches we've merged in the MPTCP tree that are ready for
> net-next.
> 
> Patches 1 and 2 rework the assignment of local address IDs to allow them
> to be assigned by a userspace path manager, and add corresponding self
> tests.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mptcp: add the address ID assignment bitmap
    https://git.kernel.org/netdev/net-next/c/efd5a4c04e18
  - [net-next,2/8] selftests: mptcp: add testcases for setting the address ID
    https://git.kernel.org/netdev/net-next/c/dc8eb10e95a8
  - [net-next,3/8] mptcp: add the outgoing MP_PRIO support
    https://git.kernel.org/netdev/net-next/c/067065422fcd
  - [net-next,4/8] mptcp: add the incoming MP_PRIO support
    https://git.kernel.org/netdev/net-next/c/40453a5c61f4
  - [net-next,5/8] mptcp: add set_flags command in PM netlink
    https://git.kernel.org/netdev/net-next/c/0f9f696a502e
  - [net-next,6/8] selftests: mptcp: add set_flags command in pm_nl_ctl
    https://git.kernel.org/netdev/net-next/c/6e8b244a3e9d
  - [net-next,7/8] mptcp: add the mibs for MP_PRIO
    https://git.kernel.org/netdev/net-next/c/0be2ac287bcc
  - [net-next,8/8] selftests: mptcp: add the MP_PRIO testcases
    https://git.kernel.org/netdev/net-next/c/718eb44e5c1e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


