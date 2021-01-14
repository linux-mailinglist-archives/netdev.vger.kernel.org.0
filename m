Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BC82F599A
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbhANDuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:50:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbhANDus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9399A238E1;
        Thu, 14 Jan 2021 03:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610596208;
        bh=FqKlkXM5pZlN5EO2DpB66ke++sPK0R0ln9n3hxJpUCQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RCB7X0f0pKAIsdLCywbUGQeSDx6KVhCl93umTmVv0LXMY+EtkGPfWkxVSO1KVbWAL
         Cm6+sRbJcwmTfBRdTBHtu+2WIlrFEg52GA9kAGThmUkj6jGNMHOvcJBzr6/kWu5SeV
         rN1GElUIK4aheOf1QJmFZ/TW74TJUwa4MuuOBvJI0RZhwZ3le02bsk8TCX66pxTEWM
         VdFhYL295ulHZy+thtInG9ws2PDwQKUYsWGLynjWDFQ7R/zleMUwcJxneIxlXtGmmy
         LjoyZYO/cO8Y6NRPxWjcPq0QW5p/60F19BRvp0ULoZsNjRGo6bdjs0ht8yldiLy6EY
         tCfUDGO6XdwSA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 893E660593;
        Thu, 14 Jan 2021 03:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: assign skb hash after tcp_event_data_sent
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161059620855.12509.5312060757415288336.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 03:50:08 +0000
References: <20210111230552.2704579-1-ycheng@google.com>
In-Reply-To: <20210111230552.2704579-1-ycheng@google.com>
To:     Yuchung Cheng <ycheng@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        ncardwell@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 11 Jan 2021 15:05:52 -0800 you wrote:
> Move skb_set_hash_from_sk s.t. it's called after instead of before
> tcp_event_data_sent is called. This enables congestion control
> modules to change the socket hash right before restarting from
> idle (via the TX_START congestion event).
> 
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: assign skb hash after tcp_event_data_sent
    https://git.kernel.org/netdev/net-next/c/0ae5b43d6dde

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


