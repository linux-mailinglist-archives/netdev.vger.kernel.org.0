Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496D6354744
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 22:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240363AbhDEUA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 16:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233249AbhDEUAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 16:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B0ECF613C0;
        Mon,  5 Apr 2021 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617652809;
        bh=WbT/UKVWj+KUn3PA6KxIbaYxIHA9B7gcTtm1ADGJSL0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IwlzG2ieHpXHeOF2kEcdkGHinuJx9zlibOmVdqSJrh0ydj0hvBqjrj3ugmBsqbrE+
         KJ/lxCnau3BhZJmkYsfdeH3QRVmMtMbVsTovD8qXj+jCdiI3stKZUpE3kzwLo6sCcV
         AKZs8EtI12GNL6APyr8zOlmHH0j7Qax5dDhfPxkJ1XHXzCxoUdsYi7BH+j0jmKIBVn
         qiDXC2HMLC7ZpF0l9w58PQXx1IBdJBnPBVt6c+ctc3HT4qqEqBXV4bk1XHswhsywPA
         GF6zcgVbWH4zGd7cy+TPYcmtId9RKVHe8aRl/K3iCjpudH8xCZUs4X64fHabHOSwdy
         JcM6uEQng7NVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A76C860A00;
        Mon,  5 Apr 2021 20:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] mld: change lockdep annotation for
 ip6_sf_socklist and ipv6_mc_socklist
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161765280968.6353.18220031386238138462.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 20:00:09 +0000
References: <20210404133823.15509-1-ap420073@gmail.com>
In-Reply-To: <20210404133823.15509-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        jmaloy@redhat.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  4 Apr 2021 13:38:23 +0000 you wrote:
> struct ip6_sf_socklist and ipv6_mc_socklist are per-socket MLD data.
> These data are protected by rtnl lock, socket lock, and RCU.
> So, when these are used, it verifies whether rtnl lock is acquired or not.
> 
> ip6_mc_msfget() is called by do_ipv6_getsockopt().
> But caller doesn't acquire rtnl lock.
> So, when these data are used in the ip6_mc_msfget() lockdep warns about it.
> But accessing these is actually safe because socket lock was acquired by
> do_ipv6_getsockopt().
> 
> [...]

Here is the summary with links:
  - [v2,net-next] mld: change lockdep annotation for ip6_sf_socklist and ipv6_mc_socklist
    https://git.kernel.org/netdev/net-next/c/4b4b84468aa2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


