Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1333D45E712
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 06:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344168AbhKZFPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 00:15:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344301AbhKZFNW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 00:13:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B804761041;
        Fri, 26 Nov 2021 05:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637903409;
        bh=+Mz4WZSqsuzOmd4rEHyMvoz0CBw1B7FPZbrNiy6C5ds=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ijwVLvhDCSfkVRmDqbseZ13C/TaNNYy4Sb4RKmhZ7NWyUgwwpiYWJII/8lyEFxbr4
         //KNGQhv9L9WZdgjL1u+2bwy1v5gHFkpxHBLjexzZWJN5mOwg/TxogjleRhasc/bDt
         ckF82VU6CPDPPVVhokEcHnRmeTKnxfDBuf4XjXh9hL32LZQXuxnmVtrGwHgET+jRsw
         JrAmbtrUnidlOGfT9lPfEhwzl2zllIja9p4YbVH9JunMcMKIrL+jbUEPWJuk6MMeLM
         Ce0EnUP2pZ4PGrMo3ezqulVEQ7P4tqUrEzS8Z+Wgn+V6BzBv0H5XG5ETdqaB5Q9BBE
         dvFvYLm3hSvSA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C84960A4E;
        Fri, 26 Nov 2021 05:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tipc: delete the unlikely branch in
 tipc_aead_encrypt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163790340963.15462.7702014656238817068.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 05:10:09 +0000
References: <47a478da0b6095b76e3cbe7a75cbd25d9da1df9a.1637773872.git.lucien.xin@gmail.com>
In-Reply-To: <47a478da0b6095b76e3cbe7a75cbd25d9da1df9a.1637773872.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        jmaloy@redhat.com, ying.xue@windriver.com,
        tuong.t.lien@dektech.com.au, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 12:11:12 -0500 you wrote:
> When a skb comes to tipc_aead_encrypt(), it's always linear. The
> unlikely check 'skb_cloned(skb) && tailen <= skb_tailroom(skb)'
> can completely be taken care of in skb_cow_data() by the code
> in branch "if (!skb_has_frag_list())".
> 
> Also, remove the 'TODO:' annotation, as the pages in skbs are not
> writable, see more on commit 3cf4375a0904 ("tipc: do not write
> skb_shinfo frags when doing decrytion").
> 
> [...]

Here is the summary with links:
  - [net-next] tipc: delete the unlikely branch in tipc_aead_encrypt
    https://git.kernel.org/netdev/net-next/c/0c51dffcc8a2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


