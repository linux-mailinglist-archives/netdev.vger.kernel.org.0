Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367DF426DAB
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 17:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243114AbhJHPmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 11:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243052AbhJHPmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 11:42:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A3B596103C;
        Fri,  8 Oct 2021 15:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633707608;
        bh=tPHoIFdUmrY2e7fNoJQc0Xi9bcrcgHLGqGJEugrXyRg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a9QkcuZHTiicJvI+sUKOAHFH3lx6tBV81sA0R3q+nYJveZI4I9My5JkiPku0BMkSF
         j3WMfdNh3bpw3So9z39ig6hV+AIDMqpTyM6LoSpoBGHuq6FPGPTccN+HliTBxbK0Lw
         /O0KO7YA+uYbSwribkrX6HNn4hVNQQtzUbNQhZIXtCWpBE6fLTOk57tzJRQ2r24hg9
         x1w+SF8tLfKo8FxEuFjl8P3gwqNqkBRbBLsuJTsIDkA7FforNnyLuU22OL4vFZGGLI
         CTGHsFyLmIGPzsuTTjYbOZywaGGEkg1k33hvxLJrpRXnui3LxWmTYJDeHA2xrwTcB+
         e+gGhcHUUfzDA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9CD0360A44;
        Fri,  8 Oct 2021 15:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 1/2] vsock: Refactor vsock_*_getsockopt to resemble
 sock_getsockopt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163370760863.7751.9806482518021821229.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 15:40:08 +0000
References: <20211008100053.29806-1-rpalethorpe@suse.com>
In-Reply-To: <20211008100053.29806-1-rpalethorpe@suse.com>
To:     Richard Palethorpe <rpalethorpe@suse.com>
Cc:     arnd@arndb.de, kuba@kernel.org, davem@davemloft.net,
        sgarzare@redhat.com, andraprs@amazon.com, edumazet@google.com,
        arseny.krasnov@kaspersky.com, willemb@google.com,
        deepa.kernel@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rpalethorpe@richiejp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Oct 2021 11:00:52 +0100 you wrote:
> In preparation for sharing the implementation of sock_get_timeout.
> 
> Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
> Cc: Richard Palethorpe <rpalethorpe@richiejp.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  net/vmw_vsock/af_vsock.c | 65 +++++++++++++++++-----------------------
>  1 file changed, 28 insertions(+), 37 deletions(-)

Here is the summary with links:
  - [v3,1/2] vsock: Refactor vsock_*_getsockopt to resemble sock_getsockopt
    https://git.kernel.org/netdev/net-next/c/685c3f2fba29
  - [v3,2/2] vsock: Enable y2038 safe timeval for timeout
    https://git.kernel.org/netdev/net-next/c/4c1e34c0dbff

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


