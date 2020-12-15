Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F390B2DA5D1
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 02:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgLOBvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 20:51:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgLOBvp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 20:51:45 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607997065;
        bh=SINRVJLnoZUVJiv6pdjdcEuZKkf96gmNRWlTryCUVEI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dkwaXWtrBHD20KWsjg1iue5DSWThwSkN9PACJ9Rx2f8QiCVkwryT4efVPjOrAe6v2
         NuP3Kb6vSnnQMabeo/gk6jPpM3mb9onCSZZ8fSnsA5nFW8XWTvsWlgHFy0K2utpMHN
         880/SvTt47SnSWm9SFauAKhkBFwmILNQjKs91V3N7Mj/BVFAmg9Uj9rHYRpFNOmVMM
         ixC0+UfjUyWsGJujW6TJB8mMPy0yF/FiI5bLk2aeMsJI9RjSQHOx5M1L9e7yrN0n7j
         SGHk6XOtQfH/2UcmuGe9ReCaPBGgeV+ZPg+1AX/LsveSr2h/KJ/cEgZSM/kjqYnfry
         TmTAbmCFkVLQQ==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] mptcp: Another set of miscellaneous MPTCP fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160799706497.8846.3593836390503051441.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 01:51:04 +0000
References: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mptcp@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 10 Dec 2020 14:24:57 -0800 you wrote:
> This is another collection of MPTCP fixes and enhancements that we have
> tested in the MPTCP tree:
> 
> Patch 1 cleans up cgroup attachment for in-kernel subflow sockets.
> 
> Patches 2 and 3 make sure that deletion of advertised addresses by an
> MPTCP path manager when flushing all addresses behaves similarly to the
> remove-single-address operation, and adds related tests.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] mptcp: attach subflow socket to parent cgroup
    https://git.kernel.org/bpf/bpf-next/c/3764b0c5651e
  - [net-next,2/9] mptcp: remove address when netlink flushes addrs
    https://git.kernel.org/bpf/bpf-next/c/141694df6573
  - [net-next,3/9] selftests: mptcp: add the flush addrs testcase
    https://git.kernel.org/bpf/bpf-next/c/6fe4ccdc3dab
  - [net-next,4/9] mptcp: use MPTCPOPT_HMAC_LEN macro
    https://git.kernel.org/bpf/bpf-next/c/ba34c3de71ce
  - [net-next,5/9] mptcp: hold mptcp socket before calling tcp_done
    https://git.kernel.org/bpf/bpf-next/c/ab82e996a1fa
  - [net-next,6/9] tcp: parse mptcp options contained in reset packets
    https://git.kernel.org/bpf/bpf-next/c/049fe386d353
  - [net-next,7/9] mptcp: parse and act on incoming FASTCLOSE option
    https://git.kernel.org/bpf/bpf-next/c/50c504a20a75
  - [net-next,8/9] mptcp: pm: simplify select_local_address()
    https://git.kernel.org/bpf/bpf-next/c/1bc7327b5fea
  - [net-next,9/9] mptcp: let MPTCP create max size skbs
    https://git.kernel.org/bpf/bpf-next/c/15e6ca974b14

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


