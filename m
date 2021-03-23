Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51AA3453DF
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhCWAao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230186AbhCWAaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 20:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A30B5619A9;
        Tue, 23 Mar 2021 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616459409;
        bh=rN2KkvFup9+EGFuI8m1YsmmC4/mKr9QZZqnu1RwXrcE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b5SIjS2KO3coZHGcIBaZ1shJKpGHQM7/+fi1ps61H3R4bY82/U7PbnNqhvNfwwBYR
         eNunOJVOZmY5S0gZf7m6MaaqFpzKB6WpNHzncTZEvX6Y63g/U44ghUcHOTIK2W+hdT
         hWXhz+owhMTiuajAosfQfO+ri92ViSKsxXSm06Xi9/NKgiYx+hd9SOil/qhdSphn54
         rpC/7e2cnV0UuJ7tS5NtqyGDhETUwg+JztC5CLpkW9o7HZ5+QOWiEtKCpeB22Bda7s
         cYzvGwGsZngQ7yfFGX0TG3K6+ft8ucX2zLWCIgh2KfxPUy1W8n0J9e8GCmUDUqHuuX
         Ps8lk1rfYEIkw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 90B0060A3E;
        Tue, 23 Mar 2021 00:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: don't assign an error value to tag_ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161645940958.31154.2773844035842131201.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Mar 2021 00:30:09 +0000
References: <20210322202650.45776-1-george.mccollister@gmail.com>
In-Reply-To: <20210322202650.45776-1-george.mccollister@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 22 Mar 2021 15:26:50 -0500 you wrote:
> Use a temporary variable to hold the return value from
> dsa_tag_driver_get() instead of assigning it to dst->tag_ops. Leaving
> an error value in dst->tag_ops can result in deferencing an invalid
> pointer when a deferred switch configuration happens later.
> 
> Fixes: 357f203bb3b5 ("net: dsa: keep a copy of the tagging protocol in the DSA switch tree")
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: don't assign an error value to tag_ops
    https://git.kernel.org/netdev/net/c/e0c755a45f6f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


