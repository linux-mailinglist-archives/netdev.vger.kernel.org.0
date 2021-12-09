Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1893C46E014
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238658AbhLIBNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbhLIBNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:13:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE69CC061746;
        Wed,  8 Dec 2021 17:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2A18B82266;
        Thu,  9 Dec 2021 01:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71EFEC00446;
        Thu,  9 Dec 2021 01:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639012210;
        bh=tcNRHlF7GR2lZdIy9WjbF+9Dbp1ChM/aCjxSTUoFcP0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BbtcRHuGfNqN7J72Wf7dZNhJx7T2cPQregS3XPqJlNDdrpZJkQvdQVVSfH/oBKqpL
         +SJAFcjfXW4P7fv5giyKmOi0M0ex5jUexCHaExJv8vCLW1Qx9+i4h8j5wYTu2skqMM
         5CnhTP6qOc9b4vsZ8mTr9Rc9k7ribW1AWYGhOkyXepUyNj0jR6pdx/WAafO3FVIaQA
         SIfEB9LZSiqbxQSQ1iHUmGYqTRGQIkgO0k4Wk9FYD1/Qp6PV+89NcKj720vccj3ILZ
         IRJKzyir8Q3eQx8CoPM0GVtcjDOEv/lhAeR0elmFjcMFJXpbwVHxC/fTmmvkHREQjC
         yGmdsIibEsDOw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 541EA60966;
        Thu,  9 Dec 2021 01:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/7] netfilter: nfnetlink_queue: silence bogus compiler
 warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163901221033.29390.14819390704011545716.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 01:10:10 +0000
References: <20211209000847.102598-2-pablo@netfilter.org>
In-Reply-To: <20211209000847.102598-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  9 Dec 2021 01:08:41 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> net/netfilter/nfnetlink_queue.c:601:36: warning: variable 'ctinfo' is
> uninitialized when used here [-Wuninitialized]
>    if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
> 
> ctinfo is only uninitialized if ct == NULL.  Init it to 0 to silence this.
> 
> [...]

Here is the summary with links:
  - [net,1/7] netfilter: nfnetlink_queue: silence bogus compiler warning
    https://git.kernel.org/netdev/net/c/b43c2793f5e9
  - [net,2/7] vrf: don't run conntrack on vrf with !dflt qdisc
    https://git.kernel.org/netdev/net/c/d43b75fbc23f
  - [net,3/7] nft_set_pipapo: Fix bucket load in AVX2 lookup routine for six 8-bit groups
    https://git.kernel.org/netdev/net/c/b7e945e228d7
  - [net,4/7] selftests: netfilter: Add correctness test for mac,net set type
    https://git.kernel.org/netdev/net/c/0de53b0ffb5b
  - [net,5/7] netfilter: nft_exthdr: break evaluation if setting TCP option fails
    https://git.kernel.org/netdev/net/c/962e5a403587
  - [net,6/7] selftests: netfilter: switch zone stress to socat
    https://git.kernel.org/netdev/net/c/d46cea0e6933
  - [net,7/7] netfilter: conntrack: annotate data-races around ct->timeout
    https://git.kernel.org/netdev/net/c/802a7dc5cf1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


