Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763C82BB80E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 22:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbgKTVAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 16:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:41024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbgKTVAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 16:00:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605906006;
        bh=rtuW+ab5Bb2RDx2Stbn5gwpOXsN3uWDHTj9UJM+06Jw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gtynu3GABCU5G2rasW7qXjxuILOShE+IVtmL/m0d8OwxI/irzEeRiCngb5Kvbewdh
         paMf2D94SGezVVCrIUTYz8cT1RTKHmQdJALcq0IaHk+1F5GnpkGGQK7o+peAQzDIdu
         NK43ilOL1dHhqXxIw5Y2LVgaWZkctI8p8LasFJAk=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stream: fix TCP references when INET is not
 enabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160590600598.16933.15043827876982832532.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Nov 2020 21:00:05 +0000
References: <20201118194438.674-1-rdunlap@infradead.org>
In-Reply-To: <20201118194438.674-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Nov 2020 11:44:38 -0800 you wrote:
> Fix build of net/core/stream.o when CONFIG_INET is not enabled.
> Fixes these build errors (sample):
> 
> ld: net/core/stream.o: in function `sk_stream_write_space':
> (.text+0x27e): undefined reference to `tcp_stream_memory_free'
> ld: (.text+0x29c): undefined reference to `tcp_stream_memory_free'
> ld: (.text+0x2ab): undefined reference to `tcp_stream_memory_free'
> ld: net/core/stream.o: in function `sk_stream_wait_memory':
> (.text+0x5a1): undefined reference to `tcp_stream_memory_free'
> ld: (.text+0x5bf): undefined reference to `tcp_stream_memory_free'
> 
> [...]

Here is the summary with links:
  - [net-next] net: stream: fix TCP references when INET is not enabled
    https://git.kernel.org/netdev/net-next/c/fc9840fbef0c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


