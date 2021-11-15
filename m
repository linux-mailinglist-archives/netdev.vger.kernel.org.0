Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06B54506FA
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhKOOd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:33:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231889AbhKOOdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:33:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B0A8161B66;
        Mon, 15 Nov 2021 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636986609;
        bh=kS2GeY4/5G6kuEiLE0GEWGQPP+MVUm/E3x5jzPmZLfk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UFwp1Uzke1mC+BTRa53nU2UVOQkBK41QqpsAiSw/APmgr/f867KfjUUuSJ3LSHj1G
         N/auafdGSbHVb81oXQB2d9jj+bDismgIMvPkoKElP+XFLoVImWVZKWHsVnpsYEHD2f
         YYZJ5x3WNs0MeDDWh99SJ24Fam1s9N2HUdeXSx7vs88xfvEAY6jtk+C25SNXn3Z0ah
         Y0T7JA2aUWO9EoCSRrYU48blmA1CnDp4bqFnUt1wpX1EmHcNQxWLWw0mpfWwDird+V
         I1i6BzemajBuuM3O29n8EC4egbnJojvH86mEMYVeEANwcYO4GXy7MgQs+joJEOP5HI
         fj7gntaFPrksA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A5C1F6095A;
        Mon, 15 Nov 2021 14:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: only accept encrypted MSG_CRYPTO msgs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698660967.25242.6544784214334757611.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:30:09 +0000
References: <127f576a209dfaa9a4ada59b298e575296f6bc10.1636980324.git.lucien.xin@gmail.com>
In-Reply-To: <127f576a209dfaa9a4ada59b298e575296f6bc10.1636980324.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        jmaloy@redhat.com, ying.xue@windriver.com,
        tuong.t.lien@dektech.com.au, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Nov 2021 07:45:24 -0500 you wrote:
> The MSG_CRYPTO msgs are always encrypted and sent to other nodes
> for keys' deployment. But when receiving in peers, if those nodes
> do not validate it and make sure it's encrypted, one could craft
> a malicious MSG_CRYPTO msg to deploy its key with no need to know
> other nodes' keys.
> 
> This patch is to do that by checking TIPC_SKB_CB(skb)->decrypted
> and discard it if this packet never got decrypted.
> 
> [...]

Here is the summary with links:
  - [net] tipc: only accept encrypted MSG_CRYPTO msgs
    https://git.kernel.org/netdev/net/c/271351d255b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


