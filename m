Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48E2357693
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 23:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhDGVUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 17:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232117AbhDGVUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 17:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A617F61165;
        Wed,  7 Apr 2021 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617830409;
        bh=pCLMyqnJDD1VVCk4gXA8cCqi7eNQ1EAd+hUO4lutMb0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hywaqpTYYWkljPws9vanzh+WDZToQRLX2kKUu8vF2KNFaIyHUMLz5eEPUTO+shNCh
         PO9zXJ4vh00LJs1Phhtj9tDR9bYpqimMlUM1uWJq/xg/eTRF6lNoHAyaZseClfHlIr
         z8vhZ5Em3y4+In/EqeqE6WjDH412FAzqLKr0gStaYFluxq++0KHNA9z9/95yXtt8xX
         9Z8Pry2N9xCDY05fcHtAfuDHGplOP/M3ekNmXijjIKcWxHbBQIyugPc1Yf/m97E4+w
         uKM9DwttIuwct6q0RS+TvesUkx7MJZgFtH7gAP5pvYWyPUaufDzmjWQxNCgJNKom+k
         J5/yXFkn6p9cw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C596609B6;
        Wed,  7 Apr 2021 21:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mptcp: Cleanup, a new test case,
 and header trimming
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783040963.17539.8738946559411722537.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 21:20:09 +0000
References: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  6 Apr 2021 17:15:56 -0700 you wrote:
> Some more patches to include from the MPTCP tree:
> 
> Patches 1-6 refactor an address-related data structure and reduce some
> duplicate code that handles IPv4 and IPv6 addresses.
> 
> Patch 7 adds a test case for the MPTCP netlink interface, passing a
> specific ifindex to the kernel.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mptcp: move flags and ifindex out of mptcp_addr_info
    https://git.kernel.org/netdev/net-next/c/daa83ab03954
  - [net-next,2/8] mptcp: use mptcp_addr_info in mptcp_out_options
    https://git.kernel.org/netdev/net-next/c/30f60bae8092
  - [net-next,3/8] mptcp: drop OPTION_MPTCP_ADD_ADDR6
    https://git.kernel.org/netdev/net-next/c/fef6b7ecfbd4
  - [net-next,4/8] mptcp: use mptcp_addr_info in mptcp_options_received
    https://git.kernel.org/netdev/net-next/c/f7dafee18538
  - [net-next,5/8] mptcp: drop MPTCP_ADDR_IPVERSION_4/6
    https://git.kernel.org/netdev/net-next/c/1b1a6ef597c7
  - [net-next,6/8] mptcp: unify add_addr(6)_generate_hmac
    https://git.kernel.org/netdev/net-next/c/761c124ed969
  - [net-next,7/8] selftests: mptcp: add the net device name testcase
    https://git.kernel.org/netdev/net-next/c/c3eaa5f667cb
  - [net-next,8/8] mptcp: drop all sub-options except ADD_ADDR when the echo bit is set
    https://git.kernel.org/netdev/net-next/c/07f8252fe0e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


