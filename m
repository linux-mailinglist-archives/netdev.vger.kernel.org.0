Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5873CE87A
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350634AbhGSQlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353380AbhGSQjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:39:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 155826101E;
        Mon, 19 Jul 2021 17:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626715205;
        bh=wpxkpGGhxYEzToTN7nJvkUlq82USDwYQKInFItl5CQc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nf6n+PNPzk1QxHag3Y9vlaiKM9S7E3BgCrjFrNN/a5Pb/i3xzlVQnOO42Mi5gT91y
         AMevAY4X/ozWPyZx61q24AWTf1gs7x07asgYRln/DT/JR0FnmeKri00nQctgBx8eme
         w4n3g1271YDvyVltbzpz+jHtAJtlop9YMZfN2zhNMKe9ld4he7QOP9n7NYCAWcYfRK
         0FdtCpxarYR7Q7B2rrie9+AZVR880ypTXLICXrbf8sxv1NzOHNoBrmyhYCm1ol1nDH
         /N25O/rW+1tA07tOPcxt6b1RZffMsDl27PtJwMDbk2FVjkb7E8wEC75CARWOPAsVo9
         3DtDAEWzYsoHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0917460C09;
        Mon, 19 Jul 2021 17:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/tcp_fastopen: fix data races around
 tfo_active_disable_stamp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162671520502.15523.17626312338971341332.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Jul 2021 17:20:05 +0000
References: <20210719091218.2969611-1-eric.dumazet@gmail.com>
In-Reply-To: <20210719091218.2969611-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, weiwan@google.com, ycheng@google.com,
        ncardwell@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 19 Jul 2021 02:12:18 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> tfo_active_disable_stamp is read and written locklessly.
> We need to annotate these accesses appropriately.
> 
> Then, we need to perform the atomic_inc(tfo_active_disable_times)
> after the timestamp has been updated, and thus add barriers
> to make sure tcp_fastopen_active_should_disable() wont read
> a stale timestamp.
> 
> [...]

Here is the summary with links:
  - [net] net/tcp_fastopen: fix data races around tfo_active_disable_stamp
    https://git.kernel.org/netdev/net/c/6f20c8adb181

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


