Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A88430113
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239735AbhJPIMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239398AbhJPIMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 04:12:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 14838611F0;
        Sat, 16 Oct 2021 08:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634371807;
        bh=3aruxhkDAtzpUZg1n67ezdx9Cllz1zxbsPnvySf5HP0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AGfOJAJ2rSDmMXr5CKjS4gi/z6XOFNdkvCMUPQiQm5+Fx78+Ff6TbojWNqKvsElRu
         vGgvyTJN/PO8/2MnxP+yXbmJe6SbROf9GkCU2if+7cInUHPyyUrVEeT4JYCKypU3QH
         3WeHSASBHEmzBo7kqd86ZoAuQsX+Nzr4NU1r9vZxiPjuUjPlA48SGSViW/nVyQBidU
         W7KyEzQMsDYBtBUQvyBhCJbIa/x0Tq3kSOw83difLUJPfNxYRWEVJK0Gl/phlRttvR
         1tVa1XckGNtI4v4R5OIW4xDEbymaQR5vaKkhe0mQB5lrDtbi38r7GI5hNDJf2H+we3
         obGTGdPgL1hfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0389C60A44;
        Sat, 16 Oct 2021 08:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stream: don't purge sk_error_queue in
 sk_stream_kill_queues()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163437180701.32516.13947520205268396589.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Oct 2021 08:10:07 +0000
References: <20211015133739.672915-1-kuba@kernel.org>
In-Reply-To: <20211015133739.672915-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, eric.dumazet@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Oct 2021 06:37:39 -0700 you wrote:
> sk_stream_kill_queues() can be called on close when there are
> still outstanding skbs to transmit. Those skbs may try to queue
> notifications to the error queue (e.g. timestamps).
> If sk_stream_kill_queues() purges the queue without taking
> its lock the queue may get corrupted, and skbs leaked.
> 
> This shows up as a warning about an rmem leak:
> 
> [...]

Here is the summary with links:
  - [net-next] net: stream: don't purge sk_error_queue in sk_stream_kill_queues()
    https://git.kernel.org/netdev/net-next/c/24bcbe1cc69f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


