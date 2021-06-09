Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946113A1E94
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhFIVL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhFIVL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 17:11:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CBF90613EF;
        Wed,  9 Jun 2021 21:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623273003;
        bh=q2I26SsXN75u07xcWzSWoEtvoQx1EDGGFj+1YS47jRA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TQGXNWGqvUckZOAReto2PUF1WnzBUcddQ70AuupC13YY2KQm+zYnsJK9m0L7nAM0h
         wt9B6zrjmTF88aRlfy6gA6Sj/Oiw23XcZvrUuY6BdggbLK+5c1shrvo32di3Qs00pp
         Gmhn9xLnmSHCnviqXb+VB9duwmjm19zs4nxWdKbOtSj4TP2PzGQRO6ByZpMBhtTjek
         O7bJN0VEdYSboddTHKwjU7Ja7+30xI8oHPJY2Yh0tkZ70LRfjF1iovd5uBMTiZakHv
         +8onuRX/w6U2/FxiAi6LJUjlX+RAxrzghYjZVj2I2CBQLjMMkFHZ26EwQEmYcAUIrS
         SFnxwBtdaQojw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BB69A60A0C;
        Wed,  9 Jun 2021 21:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] inet: annotate data race in inet_send_prepare() and
 inet_dgram_connect()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327300376.16455.4468909198794441431.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 21:10:03 +0000
References: <20210609075945.3976469-1-eric.dumazet@gmail.com>
In-Reply-To: <20210609075945.3976469-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  9 Jun 2021 00:59:45 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Both functions are known to be racy when reading inet_num
> as we do not want to grab locks for the common case the socket
> has been bound already. The race is resolved in inet_autobind()
> by reading again inet_num under the socket lock.
> 
> [...]

Here is the summary with links:
  - [net] inet: annotate data race in inet_send_prepare() and inet_dgram_connect()
    https://git.kernel.org/netdev/net/c/dcd01eeac144

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


