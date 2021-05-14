Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C133A381387
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhENWLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhENWLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 68E2C6144B;
        Fri, 14 May 2021 22:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621030210;
        bh=cGxMkc+WjwkN0n5pvSHNp8hX7/3cfZcjPwNj2h8VKLc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=incbnrlmY5xhp1IeZx1kBAc66sRVM7qyDqyyK3OcVKJrCxQ+uipHZBrWoChy2itJM
         UBspdeIL62W4VvwdGyoXrKEgJ0A0pbcdxNHy+KTPYMIPfWU0lM8zDe+gCwaLqAw5zs
         1dGYtyvxqiFG00V8qzDU92S0A4cBKpgV4E+xvaSC3b9zBsRw1THNOaLRfF1PxLDyXn
         FKosdH0jZCoRX7L7rqWH/xi2DZELlqAHfBBofp3dpjiG61Q91xkOgK4/HvLfKzWzCi
         pJaWqW7j5oRTQ5OnsSdQ1KjtgDYVrYu+oSlVWRvI0IBhnqQdtE8xo3wUsSjJDnXrfs
         H41Gbq0hbpQLQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5D54260727;
        Fri, 14 May 2021 22:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] Revert "net:tipc: Fix a double free in tipc_sk_mcast_rcv"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103021037.1424.641148387270376542.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 22:10:10 +0000
References: <20210514012303.6177-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20210514012303.6177-1-hoang.h.le@dektech.com.au>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, tung.q.nguyen@dektech.com.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 14 May 2021 08:23:03 +0700 you wrote:
> This reverts commit 6bf24dc0cc0cc43b29ba344b66d78590e687e046.
> Above fix is not correct and caused memory leak issue.
> 
> Fixes: 6bf24dc0cc0c ("net:tipc: Fix a double free in tipc_sk_mcast_rcv")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> 
> [...]

Here is the summary with links:
  - [net] Revert "net:tipc: Fix a double free in tipc_sk_mcast_rcv"
    https://git.kernel.org/netdev/net/c/75016891357a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


