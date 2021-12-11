Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311C14711AE
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 06:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhLKFXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 00:23:49 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40992 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhLKFXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 00:23:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 40B9FCE2F26
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 05:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EBCDC341C3;
        Sat, 11 Dec 2021 05:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639200009;
        bh=OteVokvSttejBH4EmwQvxc9GhjG2usNgJF4pnSak4FY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WynmtVW50J5X845R5lRUZlFdHFVWZWhO8M7QrfTqsSwENLqqL88nqQgDIg9FDo+1d
         3iaqHP2HrcAfme3ZmcbC3c9S5+9FCpCeehgQgVKoSYYOxJJnUGkq4tmJymkYn2GClP
         aKoCtGKcfe9eiTQveryWqhWIA03aOmsp9h7uNgpM7uMRDAcuquElXFqY4oEmmIQ397
         IaOhduYIKKyJ41RZ0mwex/aAGS3naKphkzsIUdDw/f+iz8NB0uEQ9gcVfI94zLER7j
         Xca86MwkmulbmuqEs0ICinFb4rpXerkMzEwl63xA8n+1cgkG/Wp24xbG1ONmvnJDLK
         wlQrp0jxlTkrQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4CA5860A4D;
        Sat, 11 Dec 2021 05:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] inet_diag: fix kernel-infoleak for UDP sockets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163920000930.8891.6458972639342461127.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Dec 2021 05:20:09 +0000
References: <20211209185058.53917-1-eric.dumazet@gmail.com>
In-Reply-To: <20211209185058.53917-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 10:50:58 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> KMSAN reported a kernel-infoleak [1], that can exploited
> by unpriv users.
> 
> After analysis it turned out UDP was not initializing
> r->idiag_expires. Other users of inet_sk_diag_fill()
> might make the same mistake in the future, so fix this
> in inet_sk_diag_fill().
> 
> [...]

Here is the summary with links:
  - [net] inet_diag: fix kernel-infoleak for UDP sockets
    https://git.kernel.org/netdev/net/c/71ddeac8cd1d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


