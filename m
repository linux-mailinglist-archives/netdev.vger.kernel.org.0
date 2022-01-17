Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2467B49093E
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 14:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240129AbiAQNKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 08:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiAQNKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 08:10:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED60BC06161C
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 05:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADF5DB80EFF
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 13:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C040C36AE7;
        Mon, 17 Jan 2022 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642425009;
        bh=uVIeGaPTaK2xsrMnS6J8XDttZXULRtjWUugRKpnf25o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BQUswxoM+vEtoF2mRjwaAt1Npkr0S7tK8ZRlG+A3OnLOgtATYWugHM4PFzDXEOFkY
         6GSZ0jcsRVK/m0SWmeuEkTnAl5YoyXyyjpnsMTUJoPKMj0Sbbie3GjGqJZzoZtIe6U
         ROl/g/6PwO1XGtyVwdScMk7YpMJBMbd25NBE4FunRnpIzNeF4FcAYHSi0NxjqJi/Yu
         oMla3s1ixBacMA8f4sMdFEmQeaj03vbvkP9hKt1pv2Ft4LHxRu4B7X31xaI3tgioS5
         jNDRiyh/2Iqja+Bc7foNfxFCV0eIxojKH73tctjTVoj/f4Hhdf5QwYdQeUGHw4Px7D
         EIowPMWx8wOwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D849F60795;
        Mon, 17 Jan 2022 13:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Couple of skb memory leak fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164242500937.15907.17083517762593514431.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Jan 2022 13:10:09 +0000
References: <20220117092733.6627-1-gal@nvidia.com>
In-Reply-To: <20220117092733.6627-1-gal@nvidia.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     edumazet@google.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, tariqt@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Jan 2022 11:27:31 +0200 you wrote:
> As discussed in:
> https://lore.kernel.org/netdev/20220102081253.9123-1-gal@nvidia.com/
> 
> These are the two followup suggestions from Eric and Jakub.
> Patch #1 adds a sk_defer_free_flush() call to the kTLS splice_read
> handler.
> Patch #2 verifies the defer list is empty on socket destroy, and calls a
> defer free flush as well.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/tls: Fix another skb memory leak when running kTLS traffic
    https://git.kernel.org/netdev/net/c/db094aa8140e
  - [net,2/2] net: Flush deferred skb free on socket destroy
    https://git.kernel.org/netdev/net/c/79074a72d335

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


