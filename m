Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055EF350A25
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhCaWUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231818AbhCaWUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9EE5660D07;
        Wed, 31 Mar 2021 22:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617229218;
        bh=nWBUabEuBvadvmh3tg9wCzfvRiaDmjrroXoWOy8EylI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E7UpqtTlkQ1zHCXa6K18HaLb5pDkic+FsX4VcuZgAL9xcttKDxt3cIekYjGAKfGXS
         UyP9EBp4OHhdX+E8MkoDfit9akKm5C5UrFojDY0sC1AfE8nsw7KaKVjS6E6jODYze1
         WGjB5FUOOudCBB6v8rZJGpjj/y6gGqGrPcSi6AJpjPULnQ0VPedswOlJQX6f0UDAnr
         RV9WubqqXdQnWoDoSlqlCZmt5mbOK3QLNmDvzThm56gs4C8G4CGgxNBBCbOJun8Yzz
         DqR5vnBRQkb8qjPdbzCB54OkAQXe2JuLhr4XHYwROPEz7UiC1Q09ApGxrijCUox9cs
         9MZ1gqMmEEgTw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 92FB9608FB;
        Wed, 31 Mar 2021 22:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net/tipc: fix missing destroy_workqueue() on error in
 tipc_crypto_start()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722921859.2890.18015466898059145514.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 22:20:18 +0000
References: <20210331083602.2089030-1-yangyingliang@huawei.com>
In-Reply-To: <20210331083602.2089030-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 31 Mar 2021 16:36:02 +0800 you wrote:
> Add the missing destroy_workqueue() before return from
> tipc_crypto_start() in the error handling case.
> 
> Fixes: 1ef6f7c9390f ("tipc: add automatic session key exchange")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] net/tipc: fix missing destroy_workqueue() on error in tipc_crypto_start()
    https://git.kernel.org/netdev/net-next/c/ac1db7acea67

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


