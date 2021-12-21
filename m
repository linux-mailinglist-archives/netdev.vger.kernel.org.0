Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1047547B8E5
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 04:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbhLUDKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 22:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbhLUDKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 22:10:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28295C06173E
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 19:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73BEA613F8
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 03:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8682C36AE8;
        Tue, 21 Dec 2021 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640056210;
        bh=rHNVjMBkUGtxGxsprlJU93igDUO8ugSzjLJSXDiGa5o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YCJakJkPegmK4zWhxtg1A6cj1aVUXLbv8pV+NMeruI8CKjvmpal36DOpD4JvqlGly
         ipt6XSYx8rCrMVdrn9GnGNJZXfx4Dfz9FEw26tV4yFaOeJhh/3NhlmtUmUaNl8M8Wc
         BKFYGMc0x+TUEbWG3TKivFp9jpc3k70VVxLjWx0S8p2HUREliK5TswglO7fNdC3vIu
         3lPJcuiE65Sn4cVobtYIVeCozS+icA2/lr+/etlbU7gkLmrujnJkwxLtTS5dHTsLVD
         Tus3HRZk3iReSI/5qLYN2n1D9xMJ/7oZgoD3ijiWX+OlcOXkzpSb5Yd1eFcwDOghWJ
         hR9JIX9nKnPLQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AFC5760A27;
        Tue, 21 Dec 2021 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] inet: fully convert sk->sk_rx_dst to RCU rules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164005621071.30905.7955653646894121997.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Dec 2021 03:10:10 +0000
References: <20211220143330.680945-1-eric.dumazet@gmail.com>
In-Reply-To: <20211220143330.680945-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Dec 2021 06:33:30 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot reported various issues around early demux,
> one being included in this changelog [1]
> 
> sk->sk_rx_dst is using RCU protection without clearly
> documenting it.
> 
> [...]

Here is the summary with links:
  - [net] inet: fully convert sk->sk_rx_dst to RCU rules
    https://git.kernel.org/netdev/net/c/8f905c0e7354

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


