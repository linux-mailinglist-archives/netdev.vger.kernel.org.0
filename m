Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4073BDC52
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 19:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhGFRcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 13:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229949AbhGFRcn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 13:32:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 23B49619D2;
        Tue,  6 Jul 2021 17:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625592604;
        bh=Xzj+Ap6qnObfZhhM49pqnw2oz2W0rUlEmt2M2tbC0hs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vy/KN9RPswzmUHtLq2C+UA4snQstufVtlGNLWJd0VSDwZVJIKufxwo8O/xrepKABf
         Szu3RgjUyfHcIMJx80dc2mXLn5bUjlkHZS4GM9ajELw4cVThUBFPfKtc411m976z16
         iVnCZLxss6z2ZfWeeq1xPdfN90AwELpqiT40ZqhPCWlReZiLPh+crVVfRQ9+gIcJl2
         VTokWYXywHjbyMEGma2tr+5wDhg81chLqnCBJQ5JjvlnzgB5ZxDfeynvlanSsEqNim
         k7224SIzz1gFIjzDqX9hcgaf3EbEjjTkOnAUtkX6bWMwgNVvTodzqanrZu5pgDV+Rv
         Lu1f48Z7pENig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 18E3760BE2;
        Tue,  6 Jul 2021 17:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] skbuff: Release nfct refcount on napi stolen or
 re-used skbs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162559260409.15284.11972045379958101158.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Jul 2021 17:30:04 +0000
References: <1625482491-17536-1-git-send-email-paulb@nvidia.com>
In-Reply-To: <1625482491-17536-1-git-send-email-paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        davem@davemloft.net, kuba@kernel.org, mika.penttila@nextfour.com,
        ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        saeedm@nvidia.com, ozsh@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 5 Jul 2021 13:54:51 +0300 you wrote:
> When multiple SKBs are merged to a new skb under napi GRO,
> or SKB is re-used by napi, if nfct was set for them in the
> driver, it will not be released while freeing their stolen
> head state or on re-use.
> 
> Release nfct on napi's stolen or re-used SKBs, and
> in gro_list_prepare, check conntrack metadata diff.
> 
> [...]

Here is the summary with links:
  - [net,v3] skbuff: Release nfct refcount on napi stolen or re-used skbs
    https://git.kernel.org/netdev/net/c/8550ff8d8c75

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


