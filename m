Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BA73A36A7
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhFJVwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhFJVwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CEBE4613E9;
        Thu, 10 Jun 2021 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623361805;
        bh=FIvv5oraFhhY29I3YGqi23pBnmObIPqnLyGlY3VjM5I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dXhBWJh994GIx79SWVhGH9ucLseZ49qPQyoONXy1PAq+lw+M8sMP5bbka+zjVv9SW
         QYZfD6Gklgt7hFnyJMsb6kJ94eARKiM4/Igz7JcWP63TbEcr14RNOQDGGeg92G0z+/
         aSLfvhlx+GmE2OCT5UGxFP6LyePMWzipd47LK07vV5ZA+KgAfEeEGF3acfKyBzjXm/
         BsVWvmcLk2Ckv9nq/j6IU8bIlx77J23o92qxwSenlxXE0mbTf5EGc5fUXpTZ3COftA
         kb0Ru4J6Dd1utmPCuCWeIvgjWidh2Qe+ZJrMTjzpgozCI/Q8A8JFxVzPiA3dXviUP6
         SW/iCe6+58olw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C044560A53;
        Thu, 10 Jun 2021 21:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] Fix out of bounds when parsing TCP options
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162336180578.29138.2109462655525046867.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:50:05 +0000
References: <20210610164031.3412479-1-maximmi@nvidia.com>
In-Reply-To: <20210610164031.3412479-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, davem@davemloft.net, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, toke@toke.dk, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kaber@trash.net,
        brouer@redhat.com, pabeni@redhat.com, cpaasch@apple.com,
        peter.krystad@linux.intel.com, 92siuyang@gmail.com,
        netdev@vger.kernel.org, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 10 Jun 2021 19:40:28 +0300 you wrote:
> This series fixes out-of-bounds access in various places in the kernel
> where parsing of TCP options takes place. Fortunately, many more
> occurrences don't have this bug.
> 
> v2 changes:
> 
> synproxy: Added an early return when length < 0 to avoid calling
> skb_header_pointer with negative length.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] netfilter: synproxy: Fix out of bounds when parsing TCP options
    https://git.kernel.org/netdev/net/c/5fc177ab7594
  - [net,v2,2/3] mptcp: Fix out of bounds when parsing TCP options
    https://git.kernel.org/netdev/net/c/07718be26568
  - [net,v2,3/3] sch_cake: Fix out of bounds when parsing TCP options and header
    https://git.kernel.org/netdev/net/c/ba91c49dedbd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


