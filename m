Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931D94796DF
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 23:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhLQWK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 17:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhLQWKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 17:10:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA51DC061574;
        Fri, 17 Dec 2021 14:10:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B00B62401;
        Fri, 17 Dec 2021 22:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8599C36AE8;
        Fri, 17 Dec 2021 22:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639779024;
        bh=eCwuaM5Hq7ahxhYiqyO5qTiwgdNOn6mixY1cgRqc8Cg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SmkQuvG1GWg/BS7biYgQ1S6AGsJifZuaMBml+iyAMHTmFln/yXo6fGl4R3MvX6ZFF
         khDpN99IdbkchdkniiG59BJsqbka14qqwjwjx0pd/shQAgLIiKmp85y6CtzJW+qdqp
         pcX09Wt4QuevwQ0bFRKoWnZKt0s7Qh4Pn3Tatwn/XE7JJdFbm7Xe3OeXwcy4/1s41R
         lwBnA8ldWuq+V6QMJ+Kw/Zt/zNwh3KQsm08Dc8bM4U20klxHMqC7B37JIE18FRbklv
         hHjnpr1fhFfqg9PpjepW71KHBdiKggz/yCH9l5w7fNJFu9jI7tTKRkTgYdNB2StvwM
         0fQL0qvhrrP5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9CAE060A39;
        Fri, 17 Dec 2021 22:10:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] Revert "xsk: Do not sleep in poll() when need_wakeup set"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163977902463.11601.4121762492603698901.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Dec 2021 22:10:24 +0000
References: <20211217145646.26449-1-magnus.karlsson@gmail.com>
In-Reply-To: <20211217145646.26449-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 17 Dec 2021 15:56:46 +0100 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> This reverts commit bd0687c18e635b63233dc87f38058cd728802ab4.
> 
> This patch causes a Tx only workload to go to sleep even when it does
> not have to, leading to misserable performance in skb mode. It fixed
> one rare problem but created a much worse one, so this need to be
> reverted while I try to craft a proper solution to the original
> problem.
> 
> [...]

Here is the summary with links:
  - [bpf] Revert "xsk: Do not sleep in poll() when need_wakeup set"
    https://git.kernel.org/bpf/bpf/c/0706a78f31c4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


