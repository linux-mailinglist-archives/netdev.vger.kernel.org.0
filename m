Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B413509E4
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhCaWA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhCaWAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3CCA161075;
        Wed, 31 Mar 2021 22:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617228011;
        bh=COi+4+QgUfh8QYpjI7MKQZz67LaPq7ecOuBQoAANmhw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MeeDEdmHT9nDhGxPWSpSBAD8NVU4jU3s/G6SHvo7JHTE9BS/TJrRR0kj/L7JbwiyO
         QvQVGiz8VqXWWDcGo/830zTlJGBetarz2/t+v1iNIo3xhonVe+qLynvAR7gNKTUMUP
         uC7F8CzZKYZdWh8dKyBqt7or1h8FngmjBgUuv2CsVQ6iEF4NI3w8CFc20Ocuohdg4F
         D30AwZnilHe7gIOS3ZRbw/OjnkEP2v80Oatrz2ghvsaY1Ly1ailNS2tu4nKJcrWrt/
         WUQXTQzubCTJTAO7RyxvllY+ijGcbw/JYLgt4ZK6MzavFdHUiS9pfF+Lm4OMyBWOtc
         U/hbvfn8BmFPA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2D50A608FA;
        Wed, 31 Mar 2021 22:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/11] xfrm: interface: fix ipv4 pmtu check to honor ip header
 df
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722801118.26765.7659215180324459152.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 22:00:11 +0000
References: <20210331081847.3547641-2-steffen.klassert@secunet.com>
In-Reply-To: <20210331081847.3547641-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 31 Mar 2021 10:18:37 +0200 you wrote:
> From: Eyal Birger <eyal.birger@gmail.com>
> 
> Frag needed should only be sent if the header enables DF.
> 
> This fix allows packets larger than MTU to pass the xfrm interface
> and be fragmented after encapsulation, aligning behavior with
> non-interface xfrm.
> 
> [...]

Here is the summary with links:
  - [01/11] xfrm: interface: fix ipv4 pmtu check to honor ip header df
    https://git.kernel.org/netdev/net/c/8fc0e3b6a866
  - [02/11] vti: fix ipv4 pmtu check to honor ip header df
    https://git.kernel.org/netdev/net/c/c7c1abfd6d42
  - [03/11] vti6: fix ipv4 pmtu check to honor ip header df
    https://git.kernel.org/netdev/net/c/4c38255892c0
  - [04/11] xfrm: Use actual socket sk instead of skb socket for xfrm_output_resume
    https://git.kernel.org/netdev/net/c/9ab1265d5231
  - [05/11] net: xfrm: Localize sequence counter per network namespace
    https://git.kernel.org/netdev/net/c/e88add19f681
  - [06/11] net: xfrm: Use sequence counter with associated spinlock
    https://git.kernel.org/netdev/net/c/bc8e0adff343
  - [07/11] esp: delete NETIF_F_SCTP_CRC bit from features for esp offload
    https://git.kernel.org/netdev/net/c/154deab6a3ba
  - [08/11] xfrm: BEET mode doesn't support fragments for inner packets
    https://git.kernel.org/netdev/net/c/68dc022d04eb
  - [09/11] xfrm: Fix NULL pointer dereference on policy lookup
    https://git.kernel.org/netdev/net/c/b1e3a5607034
  - [10/11] xfrm: Provide private skb extensions for segmented and hw offloaded ESP packets
    https://git.kernel.org/netdev/net/c/c7dbf4c08868
  - [11/11] xfrm/compat: Cleanup WARN()s that can be user-triggered
    https://git.kernel.org/netdev/net/c/ef19e111337f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


