Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126E934F56B
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhCaAUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhCaAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 93FA5619CA;
        Wed, 31 Mar 2021 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617150010;
        bh=Y5GQzBPNfY//2d4uyp62pSL1+FMN36WsP467wP9hrLk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sx1RyJVZU2HUV18cDo+l+Hoi0U96jprxciZ196iVvwwfWzJiReSeJV796VjQBu8aj
         +dEVtwu2H1Ygj1sGQ4Dp7DkXcJm0ih7GdglhwcSTW5Q6ZewHciJSwG2g1jhqoGmY0q
         eHBGA1mEmyBXVEQtxNLVToIDIRETu+/gYWhHDhCwnTfkMTpxtrVY0b4yYyLt0ELzj9
         KgZx/oUHD5JObp72hFupqvAdSRuBVBhqb/XPXiZFkWozw8BHJ7dEtwck/T4CiHw6Zr
         553vOS5bXXFMYaXgvRhPABv/w4K8jwxwdGT+yYIzRdYvfYm0pGLbq+FT71mYU5MK5y
         MprMHBiSJQ+6Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8324960A5B;
        Wed, 31 Mar 2021 00:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/8] udp: GRO L4 improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161715001053.3850.9092742275313404295.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 00:20:10 +0000
References: <cover.1617099959.git.pabeni@redhat.com>
In-Reply-To: <cover.1617099959.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        steffen.klassert@secunet.com, willemb@google.com, alobakin@pm.me
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 12:28:48 +0200 you wrote:
> This series improves the UDP L4 - either 'forward' or 'frag_list' -
> co-existence with UDP tunnel GRO, allowing the first to take place
> correctly even for encapsulated UDP traffic.
> 
> The first for patches are mostly bugfixes, addressing some GRO
> edge-cases when both tunnels and L4 are present, enabled and in use.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/8] udp: fixup csum for GSO receive slow path
    https://git.kernel.org/netdev/net-next/c/000ac44da7d0
  - [net-next,v3,2/8] udp: skip L4 aggregation for UDP tunnel packets
    https://git.kernel.org/netdev/net-next/c/18f25dc39990
  - [net-next,v3,3/8] udp: properly complete L4 GRO over UDP tunnel packet
    https://git.kernel.org/netdev/net-next/c/e0e3070a9bc9
  - [net-next,v3,4/8] udp: never accept GSO_FRAGLIST packets
    https://git.kernel.org/netdev/net-next/c/78352f73dc50
  - [net-next,v3,5/8] vxlan: allow L4 GRO passthrough
    https://git.kernel.org/netdev/net-next/c/d18931a92a0b
  - [net-next,v3,6/8] geneve: allow UDP L4 GRO passthrou
    https://git.kernel.org/netdev/net-next/c/61630c4f052b
  - [net-next,v3,7/8] bareudp: allow UDP L4 GRO passthrou
    https://git.kernel.org/netdev/net-next/c/b03ef676ba6d
  - [net-next,v3,8/8] selftests: net: add UDP GRO forwarding self-tests
    https://git.kernel.org/netdev/net-next/c/a062260a9d5f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


