Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B634106CE
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 15:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbhIRNbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 09:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238371AbhIRNbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 09:31:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 90AA961353;
        Sat, 18 Sep 2021 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631971807;
        bh=bySlvwCav4Ttv+uFQJi8sgKtCicRVJ/thbrcPXi8+zk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VeFP+EGun06czHyPPTIX2VzLTU0uLJk+43gzLIHgVKPKgkctJQbDxDfB0sG+SXyRS
         9emA+FWbBHJ9X5YnyI2uGzKkDyebUqx3Gq9EzxGF3zzUKnrIr8L791RBv1GF7PpMka
         tavxQ1dvanTGQYIpDemxjP/lmglRasOlvuM0o5snQ6dQizDVdk9gPDKlK119F/ol2X
         4YUu4rietxMkWXyhwUbMM+QppdCUtRLacgF6+IMqBPwv2J2wiv/tRXVC2LyoN8czs8
         Kem8TD32xhfUF/e+reibG4c+PZxXo5R/KqDCf6nRv4SMaQrgG8jC9t/tZl0xP3yaV/
         M8AMXot+hKGrQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 838C260965;
        Sat, 18 Sep 2021 13:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] mptcp: Add SOL_MPTCP getsockopt support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163197180753.27784.6426845271823052999.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Sep 2021 13:30:07 +0000
References: <20210917233322.271789-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210917233322.271789-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev, fw@strlen.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 17 Sep 2021 16:33:17 -0700 you wrote:
> Here's the first new MPTCP feature for the v5.16 cycle, and I'll defer
> to Florian's helpful description of the series implementing some new
> MPTCP socket options:
> 
> ========
> 
> This adds the MPTCP_INFO, MPTCP_TCPINFO and MPTCP_SUBFLOW_ADDRS
> mptcp getsockopt optnames.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] mptcp: add new mptcp_fill_diag helper
    https://git.kernel.org/netdev/net-next/c/61bc6e82f92e
  - [net-next,2/5] mptcp: add MPTCP_INFO getsockopt
    https://git.kernel.org/netdev/net-next/c/55c42fa7fa33
  - [net-next,3/5] mptcp: add MPTCP_TCPINFO getsockopt support
    https://git.kernel.org/netdev/net-next/c/06f15cee3695
  - [net-next,4/5] mptcp: add MPTCP_SUBFLOW_ADDRS getsockopt support
    https://git.kernel.org/netdev/net-next/c/c11c5906bc0a
  - [net-next,5/5] selftests: mptcp: add mptcp getsockopt test cases
    https://git.kernel.org/netdev/net-next/c/ce9979129a0b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


