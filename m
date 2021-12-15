Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245D3475122
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 04:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbhLODAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 22:00:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36466 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhLODAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 22:00:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95E4E617C0
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1084C3460D;
        Wed, 15 Dec 2021 03:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639537211;
        bh=t2j3l8XTbGHmoBeKclfuUi6fmlvdjWwSLXirr4MfAvA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pv8fhi5YGIZHqHD8SnHaVqBZzPkU0jBwYonpBayM0+vG/rRRSy7OFnO8muoby0P1b
         +iLmmdgJaZWAwnsHL9KTP/NFdKHWT12VxhWPOBvJ8bYfj+XMODW5o3AZuB2e+tvAdU
         OEZQsskWNcFYXDNKqKekmSXWVjI0rUnahrZoSmRk9r3uGYM2L+IOc8b9yNeFYjvZcU
         fc7VaeHB0o6r/NVw512eKbtYB/RjRqEiBPXhyFbxax4y6ZL+OvTB4A4RGZhUFLm4YP
         Xo144f1guH9OO91vCWS6xAbCqurTQaRyNROrQ1I9dHNCxgCccsM7Fs7AUXeCTF8pfC
         6v+HFoOj/G9vQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D9F4B60A2F;
        Wed, 15 Dec 2021 03:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: use GFP_ATOMIC in rt6_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163953721088.25069.16896182383106766220.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 03:00:10 +0000
References: <20211214025806.3456382-1-eric.dumazet@gmail.com>
In-Reply-To: <20211214025806.3456382-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 13 Dec 2021 18:58:06 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot reminded me that rt6_probe() can run from
> atomic contexts.
> 
> stack backtrace:
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: use GFP_ATOMIC in rt6_probe()
    https://git.kernel.org/netdev/net-next/c/8b40a9d53d4f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


