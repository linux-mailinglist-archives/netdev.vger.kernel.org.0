Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200452F52B8
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 19:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbhAMSut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 13:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbhAMSus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 13:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4D535207B5;
        Wed, 13 Jan 2021 18:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610563808;
        bh=I2NQq37r81nX9WW9hD6QbUbvjSDEHWYim8uzxI9yy8E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fFM3SJB/1/X3nUnPKQdjvsO2a9H5KTClBgQTsQCmP73KQsxUk2qiGADbgaRRH1A+4
         WA7SlJ5GRjUeYxx5iZ4xAgiWxnl08hdbij5xSwECVqedqptOrIcRf+QyOGBRQ0ZdKm
         2uvSpAcw6imLCsW0sTxi/XbrO6w18GOQIsIi7xVdHqxXGaL85PQC52MVvcOxjccjjS
         esMO/+bjJmFw49I57bGyJPBGdAuOnXcfJ/qpvZOoWuSVe3v50YOTYWPpBbd6kkEaoj
         Zrruqjzp3Abf5GPhwMY3oUW7ioykZDJDEHvi/t0z0O63ZSkFYIga79eAfbbSPNIyJX
         Yitnjnjo2fpAQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 41DB4604E9;
        Wed, 13 Jan 2021 18:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Fix handling of an unsupported token type in
 rxrpc_read()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161056380826.22635.6329144263801911858.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jan 2021 18:50:08 +0000
References: <161046503122.2445787.16714129930607546635.stgit@warthog.procyon.org.uk>
In-Reply-To: <161046503122.2445787.16714129930607546635.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, trix@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 12 Jan 2021 15:23:51 +0000 you wrote:
> Clang static analysis reports the following:
> 
> net/rxrpc/key.c:657:11: warning: Assigned value is garbage or undefined
>                 toksize = toksizes[tok++];
>                         ^ ~~~~~~~~~~~~~~~
> 
> rxrpc_read() contains two consecutive loops.  The first loop calculates the
> token sizes and stores the results in toksizes[] and the second one uses
> the array.  When there is an error in identifying the token in the first
> loop, the token is skipped, no change is made to the toksizes[] array.
> When the same error happens in the second loop, the token is not skipped.
> This will cause the toksizes[] array to be out of step and will overrun
> past the calculated sizes.
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Fix handling of an unsupported token type in rxrpc_read()
    https://git.kernel.org/netdev/net/c/d52e419ac8b5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


