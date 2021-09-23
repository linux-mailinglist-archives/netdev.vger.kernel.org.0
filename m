Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108EC415D62
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240790AbhIWMBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240783AbhIWMBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 08:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1604C6124C;
        Thu, 23 Sep 2021 12:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632398409;
        bh=1H7uKKhJHWNSEcY8wVrZnw2klP2t4ALYFHM5mVIqJ6Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KAZAW/N+C9UhYBUg4Do5MN6wg65JbTSJLq/Q3Ulb/4v0/0QvEBmHUw25d0EYCf2Fr
         xnawJv4xfnMyRi3/7tlNfSzzMVFcvMif8qEuotXHMmeYJEeEw392MYaSRBQ9qtwUYp
         gweWhXOdQaaVYB5g9YuSkB3vvDZeLUoowmUvuYMOyuj72MF6eJw8/YZReDhxGgibry
         6JextBym2kLyTx0BV2VMjS2KQfThqbmbRqnv3jz6UEapYKBWnJUrbxk9MfcGV0wyFE
         8o57rz03oPuDRUPk8i9UcrijlSD+HO+1dos9wW+Yhrxd2WRngYzs/UkedLNcaUodok
         H9xPc+Y8Aexnw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0FB7660A3A;
        Thu, 23 Sep 2021 12:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: remove sk skb caches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163239840906.772.15552905440434440410.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Sep 2021 12:00:09 +0000
References: <cover.1632318035.git.pabeni@redhat.com>
In-Reply-To: <cover.1632318035.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, edumazet@google.com,
        mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 22 Sep 2021 19:26:39 +0200 you wrote:
> Eric noted we would be better off reverting the sk
> skb caches.
> 
> MPTCP relies on such a feature, so we need a
> little refactor of the MPTCP tx path before the mentioned
> revert.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] tcp: expose the tcp_mark_push() and tcp_skb_entail() helpers
    https://git.kernel.org/netdev/net-next/c/04d8825c30b7
  - [net-next,2/4] mptcp: stop relying on tcp_tx_skb_cache
    https://git.kernel.org/netdev/net-next/c/f70cad1085d1
  - [net-next,3/4] tcp: make tcp_build_frag() static
    https://git.kernel.org/netdev/net-next/c/ff6fb083a07f
  - [net-next,4/4] tcp: remove sk_{tr}x_skb_cache
    https://git.kernel.org/netdev/net-next/c/d8b81175e412

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


