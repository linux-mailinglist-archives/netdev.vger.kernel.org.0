Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAF149695B
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 03:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbiAVCKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 21:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiAVCKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 21:10:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73129C06173B;
        Fri, 21 Jan 2022 18:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 166E9B82104;
        Sat, 22 Jan 2022 02:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 951E9C340E3;
        Sat, 22 Jan 2022 02:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642817409;
        bh=qTVHJiVNdGBzwhERuT4ixYNnz7ZM3ozc50sja8d8h5c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G2R8Aj1i4Wfe8Tx0OW2SesVEHTVnLxoncqU+BzuTioK7C6iDJmV4vMJgDqXNQcw1I
         X1CaEw+AslOphQWyRaRDBjjZzh6xQS6YwnePGPhsAWyzIUgr6wij102pFdnAgCyI60
         OqypfmbigcQI8fPLeceZa67LwN505hhNoBP9GU87+/1zFx1AfYjAoIHrf9WCONuZc6
         nPpkN9Upzvzj1G+SM/x1HJPfHiYKRzDaOhRw2XuomPNMdj91qAaBzHYeV8VzbkXqMj
         fu5+unZu89iBPCzhbcAoI1hIIRFyewvyXxsocCoxiZb2q2ImQlUmslC2xZZV+jFP+C
         dTkVEdzmG3NQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D4F3F6079C;
        Sat, 22 Jan 2022 02:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Adjust retransmission backoff
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164281740950.28924.10169907906956854557.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Jan 2022 02:10:09 +0000
References: <164280677857.1397447.9028458701099013997.stgit@warthog.procyon.org.uk>
In-Reply-To: <164280677857.1397447.9028458701099013997.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, marc.dionne@auristor.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Jan 2022 23:12:58 +0000 you wrote:
> Improve retransmission backoff by only backing off when we retransmit data
> packets rather than when we set the lost ack timer.
> 
> To this end:
> 
>  (1) In rxrpc_resend(), use rxrpc_get_rto_backoff() when setting the
>      retransmission timer and only tell it that we are retransmitting if we
>      actually have things to retransmit.
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Adjust retransmission backoff
    https://git.kernel.org/netdev/net/c/2c13c05c5ff4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


