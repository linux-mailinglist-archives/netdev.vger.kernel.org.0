Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785E5369BE4
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244036AbhDWVKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232657AbhDWVKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 17:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B4811613CB;
        Fri, 23 Apr 2021 21:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619212208;
        bh=BzRxPELrv1dH0wmTZqU14KTBnV3YOn2NYQUF+cvnzZc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V/wJNYzn9NSUTEKcWknTMs3//VXKtWwW6F9mJBHesxdsW2d9Z9NnW5AjE4US3+F1s
         QThOQf74FHqTKM4ADeYWyjlk0lcH/Fb9VzViMYiv9Y7nWiz5WdV1KC1+Ll02L21H9E
         dRRC87HMxTH33RA7bv4bJDJ8jpZgpdBHBWYiekgvZYkzHI3FL739Og+Rc6ZifYHHnJ
         6nk+psvY0gNjujP3P9kT1B+si08vfupC5BjQoNskRiz8zZGhjEcDj29gvvD22/3srK
         ByKqIylg1pBWca+WcNtMRonzJDMZ2heH1Wxxz6Dm/6+ROG0yETyPs7bKn2V4QKMq+f
         hMgxFaD2//3VQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB6CE608FB;
        Fri, 23 Apr 2021 21:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mptcp: Retransmit DATA_FIN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161921220869.24005.14221721038180375971.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 21:10:08 +0000
References: <20210423164033.264095-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210423164033.264095-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        pabeni@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Apr 2021 09:40:33 -0700 you wrote:
> With this change, the MPTCP-level retransmission timer is used to resend
> DATA_FIN. The retranmit timer is not stopped while waiting for a
> MPTCP-level ACK of DATA_FIN, and retransmitted DATA_FINs are sent on all
> subflows. The retry interval starts at TCP_RTO_MIN and then doubles on
> each attempt, up to TCP_RTO_MAX.
> 
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/146
> Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net] mptcp: Retransmit DATA_FIN
    https://git.kernel.org/netdev/net/c/6477dd39e62c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


