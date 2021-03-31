Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E104350988
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 23:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhCaVaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 17:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233318AbhCaVaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 17:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BC44D6108F;
        Wed, 31 Mar 2021 21:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617226208;
        bh=/LOUnpXKtZX+muoaR0nqnHx0JFwyCJ9JFuBX9Y9Ovsw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ioTQbvD6u0FqigWQ1xfa8BTSZKjKL4hxmLjl9DyvaibbJB+CSqnrMWl8pgLVj6FB8
         dUEd6Fl07+155gUjqCla3ru0HGws1TsLz1AHw8P9+xApZV9+5B2eBHpd4TGa1KWqdl
         4CGIvcZ8fELj67SQIbGZuxsMn3lclhjJrB5dmQc1mQKLy5QOsitawdgPp4NNYmANIp
         QTi+OhVEbNuTLhPZx5fvvtcWkyRx0w0SVQVDpa73SxSoO3Cm4iTpdbu/05lYj1T5Hq
         2Yb/fSaAtqz8TOVlrhOu4TI7QIOtrEipxDfWIsNHuPxtZGufiDRsWHK391yBKrQ2yF
         OlHELqQfbBbSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B80DA60283;
        Wed, 31 Mar 2021 21:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ip6_tunnel: sit: proper dev_{hold|put} in
 ndo_[un]init methods
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722620875.13975.4203481888812927253.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 21:30:08 +0000
References: <20210330064551.545964-1-eric.dumazet@gmail.com>
In-Reply-To: <20210330064551.545964-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 23:45:51 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Same reasons than for the previous commits :
> 6289a98f0817 ("sit: proper dev_{hold|put} in ndo_[un]init methods")
> 40cb881b5aaa ("ip6_vti: proper dev_{hold|put} in ndo_[un]init methods")
> 7f700334be9a ("ip6_gre: proper dev_{hold|put} in ndo_[un]init methods")
> 
> [...]

Here is the summary with links:
  - [net-next] ip6_tunnel: sit: proper dev_{hold|put} in ndo_[un]init methods
    https://git.kernel.org/netdev/net-next/c/48bb5697269a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


