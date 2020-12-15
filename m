Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FF72DA6EF
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgLODnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:43:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgLODk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:40:56 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608003608;
        bh=Rq63vfGZKoinRw+btLa60qWLU6anZcR4B/wpKsmY9WA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l+/aMBLOb7eilKN0L0sQ0UztENgJrNa/LYesCc7v4z6P15p7hFV7AWkfa7dzNWj7v
         Wg3hOMiLNHCYJCBv344Eo5SbrZRbz4VAt9cjJA/vfedaVOqoLLIa/+HB7xaP0Eeke1
         2TbJstIQz0eadPn3L+BPf3u5N0kOvkyCEO+t/7VA+2I/pDrFncRf9pHYFkfVEHQeOa
         o23STjdyiSXfmDAZa3eqo9iyvpv9s/KbAh6vE5rMXESSyREIhsvqAKScf69il3D0nT
         BvmYIIThd7X03VQfPGd7LuRQo0/mEnDvtFJokVozi5XN0USZLfb6XCA1psjTzVmAk8
         dwvoTNReNLY5A==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v3] tcp: Add logic to check for SYN w/ data in
 tcp_simple_retransmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800360859.3580.14122715935384328144.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 03:40:08 +0000
References: <160780498125.3272.15437756269539236825.stgit@localhost.localdomain>
In-Reply-To: <160780498125.3272.15437756269539236825.stgit@localhost.localdomain>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        ycheng@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kafai@fb.com,
        kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 12 Dec 2020 12:31:24 -0800 you wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> There are cases where a fastopen SYN may trigger either a ICMP_TOOBIG
> message in the case of IPv6 or a fragmentation request in the case of
> IPv4. This results in the socket stalling for a second or more as it does
> not respond to the message by retransmitting the SYN frame.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] tcp: Add logic to check for SYN w/ data in tcp_simple_retransmit
    https://git.kernel.org/netdev/net-next/c/c31b70c9968f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


