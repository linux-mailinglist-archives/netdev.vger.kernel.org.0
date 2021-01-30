Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8913092C8
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhA3I7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 03:59:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230484AbhA3FMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 00:12:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 39D8464E06;
        Sat, 30 Jan 2021 05:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611983407;
        bh=2gCuAY1Fxt4ElVBdsLIqIp+cO21IA2A4dUDlD1wvPjU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dzR6mnB18BSWDs5IcOShAPB2LjU5NiqucXG3M/QqBNC8vGUA/8qU7mcCUGsftdtoO
         eNRzeiWm8eRMm2/UYZfRkzTN7Vzm7UbLzi3kJ/s6cT1dnsf4HxFW7EtR3tMMCA8FHv
         aoGEFxAcDp7xwA38a9xeamNqdV/CBlSJfJMMpKJiatX3UvaBSTGcATrYhWDF8uZ785
         eNmrl+AEKieilxE9GtAAQMCOtzNoG4S/+/uAS90zomzCXKP4LH+K4oDGAg2vckN1ST
         S8U1YTYVw+kV5FZbpztx/bqmwcWagh2itXhuULjB7cUF24XJ+oB7bBmUZP6xfpYpEN
         tWzjXIKI5vbFA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2AD8260983;
        Sat, 30 Jan 2021 05:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next] net: Remove redundant calls of
 sk_tx_queue_clear().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161198340716.22188.10513485012044993469.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 05:10:07 +0000
References: <20210128150217.6060-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210128150217.6060-1-kuniyu@amazon.co.jp>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        tariqt@nvidia.com, ttoukan.linux@gmail.com, aams@amazon.de,
        kuni1840@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tariqt@mellanox.com,
        borisp@mellanox.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 29 Jan 2021 00:02:17 +0900 you wrote:
> The commit 41b14fb8724d ("net: Do not clear the sock TX queue in
> sk_set_socket()") removes sk_tx_queue_clear() from sk_set_socket() and adds
> it instead in sk_alloc() and sk_clone_lock() to fix an issue introduced in
> the commit e022f0b4a03f ("net: Introduce sk_tx_queue_mapping"). On the
> other hand, the original commit had already put sk_tx_queue_clear() in
> sk_prot_alloc(): the callee of sk_alloc() and sk_clone_lock(). Thus
> sk_tx_queue_clear() is called twice in each path.
> 
> [...]

Here is the summary with links:
  - [v5,net-next] net: Remove redundant calls of sk_tx_queue_clear().
    https://git.kernel.org/netdev/net-next/c/df610cd9163b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


