Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E503E4F68
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 00:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbhHIWka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 18:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231509AbhHIWk0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 18:40:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C49EE60FC2;
        Mon,  9 Aug 2021 22:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628548805;
        bh=8oU1mblLT9kyRWQedn1Ldyo0qupZ2Lc6LxoJ03jYr4s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tBicHFMe++GWVZOfh1fK5YK4WT3EeHyylvSc5BgXrg4EDTw8KXJhdCXwlgWsiTfDH
         i1a8UrihLsFyOOHogG1EpgZ6fi9Z63qdyBuCNz05aSe8eSFJ8IIYoDkRM0JqFrWMx+
         ZPqGaxRHJqadrPLLGX5plFiQit+5/Pw3DFMGkwg4Tfo+XoBz6oJjsJJDvtegdNekfA
         GtUXqxI6knZnVebaWV3UR8bMvjLA2qisnKRJJi/jC/tZAJHBdFFDeKiJ52NPO0slY9
         mtLG0EsEtaifQwalQDbD4qT4Lk8PW+ixjp0Bqm9zZgUeVmaJQjyJ8zNdHBY5vQg1C9
         Be62HMo+z+WZw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B90B660A2A;
        Mon,  9 Aug 2021 22:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bareudp: Fix invalid read beyond skb's linear data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162854880575.3525.10456721681070857521.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 22:40:05 +0000
References: <7741c46545c6ef02e70c80a9b32814b22d9616b3.1628264975.git.gnault@redhat.com>
In-Reply-To: <7741c46545c6ef02e70c80a9b32814b22d9616b3.1628264975.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        martin.varghese@nokia.com, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 6 Aug 2021 17:52:06 +0200 you wrote:
> Data beyond the UDP header might not be part of the skb's linear data.
> Use skb_copy_bits() instead of direct access to skb->data+X, so that
> we read the correct bytes even on a fragmented skb.
> 
> Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] bareudp: Fix invalid read beyond skb's linear data
    https://git.kernel.org/netdev/net/c/143a8526ab5f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


