Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114A5450788
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhKOOxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229661AbhKOOxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:53:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 95CE963210;
        Mon, 15 Nov 2021 14:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636987808;
        bh=OduRMaYoWZ50aq6QqlHRFad+aATEFuiz3vqGqVTukO8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tolMupHayptmQepYR4Koy5zb/k/FTIUDVLfBZHvkjXI1eDXsQpsHdy29wniHnnxI2
         uY5ydclE5zVV4rSw6vmEe8X619pKi9uBdbjbO2rjn2OWNR7lETCbFFHkLQpPlWfZ3H
         S6O4lsaopPkGiT2i/WpN5iJMSNDbR7HCLgg4arF+5Y0Q0a91yXTHx1OhRirkblK6Pb
         IAb0YrCrxMDi0vqhE0N9b8GyNxoFkq/np9I/Lwh05EGPR5bYk0DAslkfxd1n33VT8R
         gr1tTDruhqKbp11KVt5sbB4Rsc2dXJSP/elpdch5D/gM9faQOmdMvVF0nxVXY1F877
         uggsqyVyfe45A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 84F1060A88;
        Mon, 15 Nov 2021 14:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] sock: fix /proc/net/sockstat underflow in sk_clone_lock()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698780854.3779.2306010069762632945.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:50:08 +0000
References: <8ef55b45-8850-f811-b996-5a16ee4dd97f@i-love.sakura.ne.jp>
In-Reply-To: <8ef55b45-8850-f811-b996-5a16ee4dd97f@i-love.sakura.ne.jp>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Nov 2021 19:16:56 +0900 you wrote:
> sk_clone_lock() needs to call sock_inuse_add(1) before entering the
> sk_free_unlock_clone() error path, for __sk_free() from sk_free() from
> sk_free_unlock_clone() calls sock_inuse_add(-1).
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Fixes: 648845ab7e200993 ("sock: Move the socket inuse to namespace.")
> 
> [...]

Here is the summary with links:
  - [v2] sock: fix /proc/net/sockstat underflow in sk_clone_lock()
    https://git.kernel.org/netdev/net/c/938cca9e4109

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


