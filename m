Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9131B30D135
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 03:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhBCCA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 21:00:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhBCCAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 21:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id F21E864F7C;
        Wed,  3 Feb 2021 02:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612317611;
        bh=AfJ8todIRiNP4HHEFY0agqhM0+tc5VMp8hn1tFwBK58=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DkUxOCnxOIORsAqSrRJBKdGp5g5Arl4xHtgobHor8X2JN9vHw3+ot6ukdqsUUTTjJ
         1XHxxN7ItmRUtYqqZCo5w84rOY4OAw9sMeUC/8Do8F76tUxFxLYkCTyFPTTi0J50nj
         H5jHK0wul9/H3Spps/ZahfWwauid/3cjYJt6OaCcknwqLZCrsDhy7dAOSppxETWhrs
         7QjVptPFfmX9nlTEh++Jn9Txo+t+ptLDVGwM1agaNFgiIHshC8OR3SloorwRz9xBHo
         WaQ0/yy13BfSWm1h7UDVk73FP/nNZeHFtKvg7e1AC/40+JcEPhDyfB3Fd8vnLTIbc8
         Etgg/3o8LuieQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DB8C8609E3;
        Wed,  3 Feb 2021 02:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fix up truesize of cloned skb in
 skb_prepare_for_shift()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161231761089.3354.12212298299944124109.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 02:00:10 +0000
References: <20210201160420.2826895-1-elver@google.com>
In-Reply-To: <20210201160420.2826895-1-elver@google.com>
To:     Marco Elver <elver@google.com>
Cc:     linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        davem@davemloft.net, kuba@kernel.org, jonathan.lemon@gmail.com,
        willemb@google.com, linmiaohe@huawei.com, gnault@redhat.com,
        dseok.yi@samsung.com, kyk.segfault@gmail.com,
        viro@zeniv.linux.org.uk, netdev@vger.kernel.org, glider@google.com,
        syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  1 Feb 2021 17:04:20 +0100 you wrote:
> Avoid the assumption that ksize(kmalloc(S)) == ksize(kmalloc(S)): when
> cloning an skb, save and restore truesize after pskb_expand_head(). This
> can occur if the allocator decides to service an allocation of the same
> size differently (e.g. use a different size class, or pass the
> allocation on to KFENCE).
> 
> Because truesize is used for bookkeeping (such as sk_wmem_queued), a
> modified truesize of a cloned skb may result in corrupt bookkeeping and
> relevant warnings (such as in sk_stream_kill_queues()).
> 
> [...]

Here is the summary with links:
  - [net-next] net: fix up truesize of cloned skb in skb_prepare_for_shift()
    https://git.kernel.org/netdev/net-next/c/097b9146c0e2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


