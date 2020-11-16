Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E0F2B5124
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 20:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgKPTaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 14:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgKPTaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 14:30:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605555007;
        bh=GnOIxD6PRJW3g0uVkXTY9gCQ+5cEB1Q/ybHNqYKKgmg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kLPQQNN0mH83k1y6Cu0uPariI5pkXp7dp5K8CapRfYVgQUJT51zVrUXTICb5deuiG
         3mLs06wJrfReYsoyLBBgCsTz/9PZSijrKDipj0YuwfEAgtNef8qiGMVQ3NbM2DTa9T
         3XMR8LkDFiHoXYKc9xrIxNPy3k0ZtQ205PnEjcYc=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/13] mptcp: improve multiple xmit streams
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160555500737.21076.15593778409106734018.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Nov 2020 19:30:07 +0000
References: <cover.1605458224.git.pabeni@redhat.com>
In-Reply-To: <cover.1605458224.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, mptcp@lists.01.org,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 16 Nov 2020 10:48:01 +0100 you wrote:
> This series improves MPTCP handling of multiple concurrent
> xmit streams.
> 
> The to-be-transmitted data is enqueued to a subflow only when
> the send window is open, keeping the subflows xmit queue shorter
> and allowing for faster switch-over.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/13] tcp: factor out tcp_build_frag()
    https://git.kernel.org/netdev/net-next/c/b796d04bd014
  - [net-next,v3,02/13] mptcp: use tcp_build_frag()
    https://git.kernel.org/netdev/net-next/c/e2223995a287
  - [net-next,v3,03/13] tcp: factor out __tcp_close() helper
    https://git.kernel.org/netdev/net-next/c/77c3c9563752
  - [net-next,v3,04/13] mptcp: introduce mptcp_schedule_work
    https://git.kernel.org/netdev/net-next/c/ba8f48f7a4d7
  - [net-next,v3,05/13] mptcp: reduce the arguments of mptcp_sendmsg_frag
    https://git.kernel.org/netdev/net-next/c/caf971df01b8
  - [net-next,v3,06/13] mptcp: add accounting for pending data
    https://git.kernel.org/netdev/net-next/c/f0e6a4cf11f1
  - [net-next,v3,07/13] mptcp: introduce MPTCP snd_nxt
    https://git.kernel.org/netdev/net-next/c/eaa2ffabfc35
  - [net-next,v3,08/13] mptcp: refactor shutdown and close
    https://git.kernel.org/netdev/net-next/c/e16163b6e2b7
  - [net-next,v3,09/13] mptcp: move page frag allocation in mptcp_sendmsg()
    https://git.kernel.org/netdev/net-next/c/d9ca1de8c0cd
  - [net-next,v3,10/13] mptcp: try to push pending data on snd una updates
    https://git.kernel.org/netdev/net-next/c/813e0a683d4c
  - [net-next,v3,11/13] mptcp: rework poll+nospace handling
    https://git.kernel.org/netdev/net-next/c/8edf08649eed
  - [net-next,v3,12/13] mptcp: keep track of advertised windows right edge
    https://git.kernel.org/netdev/net-next/c/6f8a612a33e4
  - [net-next,v3,13/13] mptcp: send explicit ack on delayed ack_seq incr
    https://git.kernel.org/netdev/net-next/c/7ed90803a213

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


