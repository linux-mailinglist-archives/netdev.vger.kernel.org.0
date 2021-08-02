Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2EE3DD2F5
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 11:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhHBJaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 05:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232699AbhHBJaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 05:30:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CD69461057;
        Mon,  2 Aug 2021 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627896605;
        bh=/p9RYEjJdr7uT34i6TVXqq14vMktqK9ecnQ1JwtdxI4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kodDxXQ6GmIcAUes/h/hQNiIwK7pQNxfXWn0AlG9qPKiqC2PWtS9C1IKZ2b0viGtf
         3T1SXDY0LKDyk7bdVw4CWbGoBFdU+lam9suSAGlSoaHG8/h62DzkuFuNe46MUNLU9i
         InfZS8np3OKLMNZcex7HnGn3CC9qhk5lXuSMTYzd5O2e1rx1aLzCTOIVQZykDFBD5X
         oHR/2G6MNia2UdAMOBx5rBqckofwUQhPcDgeOGOwjP+TY0rLLrC2o3RvjNX62/S/XS
         7qGFg9XJ2MHc7lgDUjYNN4xiNsJADVgOuBe+ZYLp8Rm1JoLZuzj8yVSDYILZuCeR3a
         cnSr7CErsJEDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C1862609D2;
        Mon,  2 Aug 2021 09:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net,
 gro: Set inner transport header offset in tcp/udp GRO hook
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162789660578.5679.15809002627634611396.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 09:30:05 +0000
References: <20210729134820.221151-1-jakub@cloudflare.com>
In-Reply-To: <20210729134820.221151-1-jakub@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        fw@strlen.de, pabeni@redhat.com, aforster@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 29 Jul 2021 15:48:20 +0200 you wrote:
> GSO expects inner transport header offset to be valid when
> skb->encapsulation flag is set. GSO uses this value to calculate the length
> of an individual segment of a GSO packet in skb_gso_transport_seglen().
> 
> However, tcp/udp gro_complete callbacks don't update the
> skb->inner_transport_header when processing an encapsulated TCP/UDP
> segment. As a result a GRO skb has ->inner_transport_header set to a value
> carried over from earlier skb processing.
> 
> [...]

Here is the summary with links:
  - [net] net, gro: Set inner transport header offset in tcp/udp GRO hook
    https://git.kernel.org/netdev/net/c/d51c5907e980

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


