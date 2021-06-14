Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4ED93A6F71
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbhFNTwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234775AbhFNTwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:52:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B4616128A;
        Mon, 14 Jun 2021 19:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623700221;
        bh=+0GdRQLh6jMtIy8tf/i9oX+4iTW6iZNcTkjIL55M95g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W+SRizWmAy2M5w47/phZf+6xmQs7ejaGNo2PHV7A8eZv7JkzwzlBLrd0NxsOOpGGj
         ndu3wpr6pDcXsmzHRnzMdHS/XsQKvJy/liqJIvjG0trPlyU7rPQeCffiqqBlv03e9b
         OHeVOC+mz2ELcx64KVaPsFljBxFcj9OGKcstAHKiRcqAvL4Ssr7P64lOvC/rmjZ96G
         dxSeAXHtVMwkkG0RY7gutSjkQRbgiOzDKnYadWZAETyYSfN6jQ87Hw5Tfd0brBZkw0
         wqrfeK1r/h3elUKp8u5ITtZ/xNDglv9+IB5n/W/UqBCBI1Gjy8wwzUkd2gZ6+MLOzl
         mYah9NjC+EH7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 77ABA60BE1;
        Mon, 14 Jun 2021 19:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mld: avoid unnecessary high order page allocation in
 mld_newpack()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370022148.10983.17902352871685491201.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 19:50:21 +0000
References: <20210613144344.31311-1-ap420073@gmail.com>
In-Reply-To: <20210613144344.31311-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 13 Jun 2021 14:43:44 +0000 you wrote:
> If link mtu is too big, mld_newpack() allocates high-order page.
> But most mld packets don't need high-order page.
> So, it might waste unnecessary pages.
> To avoid this, it makes mld_newpack() try to allocate order-0 page.
> 
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] mld: avoid unnecessary high order page allocation in mld_newpack()
    https://git.kernel.org/netdev/net-next/c/ffa85b73c3c4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


