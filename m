Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A483A6F0C
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234817AbhFNTcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234339AbhFNTcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:32:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 648ED61378;
        Mon, 14 Jun 2021 19:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623699004;
        bh=2NH1cr0c8Act9aA8nRCHg6oXxbEfi7PvgyrAb7ILmAc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FSTS2JH2gmzrbylT9RPp5qMxyx4jYHTzURmI7GdMUnP4vUh1hOwjV/CZ83Info62Q
         5nzPJAjYyLTffCA8ojLGaaB2uhFGdnsmBOZD4QvQtbAX83g28Y4+Gci7fNrqfrQ8RE
         Ai+ZTZ63fhjydbcFKpUl2ljJRp2KEMFrNVCYJ7oIWrgLyQ7JqujyCVARdFs+R1lE51
         W/KqNDnll5h9Pe5fvR7RVz7jY7jt4I7XVrNoy2xZTjs4gjygDVqcObmYW+mIXhZMiQ
         fkvOH7AvOTMpk9MRMMWQ9uaDN9tuccfHoXvzFABGl9l0wbrNwU5c6uQiQ1UBWRJ3Z8
         IobjUOUu4f7nA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E88D609E7;
        Mon, 14 Jun 2021 19:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nexthops: Add selftests for cleanup of known bad
 route add
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162369900438.32080.13319110629502294564.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 19:30:04 +0000
References: <20210612163215.62110-1-dsahern@kernel.org>
In-Reply-To: <20210612163215.62110-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        lixiaoyan@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 12 Jun 2021 10:32:15 -0600 you wrote:
> Test cleanup path for routes usinig nexthop objects before the
> reference is taken on the nexthop. Specifically, bad metric for
> ipv4 and ipv6 and source routing for ipv6.
> 
> Selftests that correspond to the recent bug fix:
>     821bbf79fe46 ("ipv6: Fix KASAN: slab-out-of-bounds Read in fib6_nh_flush_exceptions")
> 
> [...]

Here is the summary with links:
  - [net-next] nexthops: Add selftests for cleanup of known bad route add
    https://git.kernel.org/netdev/net-next/c/2d7ff2d83cac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


