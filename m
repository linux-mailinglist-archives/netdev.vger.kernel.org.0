Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1719443FB86
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhJ2Lmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231807AbhJ2Lmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 07:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B3E5761167;
        Fri, 29 Oct 2021 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635507609;
        bh=Ova+fHEyLv3Ydj/WhLWHTiMkcz4ifleXZG+pkn6V3Uw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KbTMTuE4gwKNfsPpI9kpSIFhMsGg4/4lkp2HFgYrf6DnBpKpm93cBQ9wzPfCtxdEU
         lQ4uWrZEd4pxz6GOHV5xiwzBZPjKbE31cI0KnV4XYtUgz9nghodbpDpYqjATeU3bBy
         rZu1XzKdX2jUFyfObbYOquUoFaV/vWCjChyWcK1SsdXFID0giZ63agYIpWI0cROIBv
         lVifpL3qfdu0mB1KN2IcZSzhPQ1YacbtlRztjP3Fn9xZxArli5yVDewCapcE7itjHR
         ylnCv0soQCmhw34VGP9maNJlnHP/dgo2pWSjKfzmrKvgxNbyLv1BnX6qTDdIe7y3vW
         1DzAwVhRpLBIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A75B960A1B;
        Fri, 29 Oct 2021 11:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] sctp: a couple of fixes for PLPMTUD
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163550760967.31573.4777989715064942637.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 11:40:09 +0000
References: <cover.1635413715.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1635413715.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 05:36:00 -0400 you wrote:
> Four fixes included in this patchset:
> 
>   - fix the packet sending in Error state.
>   - fix the timer stop when transport update dst.
>   - fix the outer header len calculation.
>   - fix the return value for toobig processing.
> 
> [...]

Here is the summary with links:
  - [net,1/4] sctp: allow IP fragmentation when PLPMTUD enters Error state
    https://git.kernel.org/netdev/net/c/40171248bb89
  - [net,2/4] sctp: reset probe_timer in sctp_transport_pl_update
    https://git.kernel.org/netdev/net/c/c6ea04ea692f
  - [net,3/4] sctp: subtract sctphdr len in sctp_transport_pl_hlen
    https://git.kernel.org/netdev/net/c/cc4665ca646c
  - [net,4/4] sctp: return true only for pathmtu update in sctp_transport_pl_toobig
    https://git.kernel.org/netdev/net/c/75cf662c64dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


