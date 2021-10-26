Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6BF43B23A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbhJZMWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235883AbhJZMWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:22:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B4EB661057;
        Tue, 26 Oct 2021 12:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635250806;
        bh=40fY76V4SlvvS83hpSYE6HKAN0YPV+WRGoLc/HDIkmI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ThoO8NsEq/hCWGl+OprwJoQ6qFpYtn/vdo1ip+z883V7NB8kGoMecNokxtTr/SY8i
         ALyDO1YrJExG/xJ163pDiEB0JJzIGxrpivnKdYbiFcWlDRLWDmeKmXOKkgvRr8czix
         bptg9ajpkWYKYcRp7A5Da8xZF3qpE0mdqJB5MNMPXqDgCKaITHOaPMU53nuVwgfw3I
         lUt+knM7RU9W+s2wH7NBuu2tCC63HZQ6yn6nnB9n8U841P4NNiseI0LgUwpMD0SBPG
         UGMKwNPoJge1bHYIwJyZW5i1lPBYXaGP3VdSNfGh/2tvFZo+EqcyTU6IFmZQ7bkrw0
         TXrvopQsGu5Ag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A8F44609CC;
        Tue, 26 Oct 2021 12:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v1] tcp: don't free a FIN sk_buff in tcp_remove_empty_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525080668.27254.5317697458188609155.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 12:20:06 +0000
References: <20211024235903.371430-1-jmaxwell37@gmail.com>
In-Reply-To: <20211024235903.371430-1-jmaxwell37@gmail.com>
To:     Jon Maxwell <jmaxwell37@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 10:59:03 +1100 you wrote:
> v1: Implement a more general statement as recommended by Eric Dumazet. The
> sequence number will be advanced, so this check will fix the FIN case and
> other cases.
> 
> A customer reported sockets stuck in the CLOSING state. A Vmcore revealed that
> the write_queue was not empty as determined by tcp_write_queue_empty() but the
> sk_buff containing the FIN flag had been freed and the socket was zombied in
> that state. Corresponding pcaps show no FIN from the Linux kernel on the wire.
> 
> [...]

Here is the summary with links:
  - [net-next,v1] tcp: don't free a FIN sk_buff in tcp_remove_empty_skb()
    https://git.kernel.org/netdev/net-next/c/cf12e6f91246

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


