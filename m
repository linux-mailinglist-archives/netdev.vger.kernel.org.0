Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B81743FD23
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 15:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhJ2NMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 09:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231401AbhJ2NMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 09:12:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 42BA461177;
        Fri, 29 Oct 2021 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635513007;
        bh=Pau3e3oknw4QrQXHYil27X9egBLiH4uwmv9x75hnXak=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k09UnCjTx/Wf7Wqi25diaZRseS6+aVEGCnK60BlKwMLZg1b1dv7cx5/IgzeT5r/6V
         iHjdhtZPMcZZiqN6Ak4VSqUvEU0x3QVizltPncJmeEpv9qpwXx92AAXsBK5x5p+5zk
         1owgQOUCZBYuKQnGeMx9xI3TSCRD+1wxoBjle5Lfh/7W53jtIYjXx+KYXqzKOHoS0Z
         6s05r0WCD3+L7YlRuF4ShbO2TYFI/p/TxZ+XqMSG6k8kKaLrNFDmVyMy/oMal/ZOI5
         wQyrIEjd+6R5IeBJw+/G9cDu3tdy4vFEINWXotkWpRnyW8EGIVfJw5ta5XiUA2f/ea
         lUzRzOjIHZ00Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3B38060A17;
        Fri, 29 Oct 2021 13:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [net-next] ifb: fix building without CONFIG_NET_CLS_ACT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163551300723.9482.9164183459360227411.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 13:10:07 +0000
References: <20211029113102.769823-1-arnd@kernel.org>
In-Reply-To: <20211029113102.769823-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, lukas@wunner.de,
        arnd@arndb.de, willemb@google.com, tanghui20@huawei.com,
        kernel@esmil.dk, pablo@netfilter.org, alobakin@pm.me,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Oct 2021 13:30:51 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The driver no longer depends on this option, but it fails to
> build if it's disabled because the skb->tc_skip_classify is
> hidden behind an #ifdef:
> 
> drivers/net/ifb.c:81:8: error: no member named 'tc_skip_classify' in 'struct sk_buff'
>                 skb->tc_skip_classify = 1;
> 
> [...]

Here is the summary with links:
  - [net-next] ifb: fix building without CONFIG_NET_CLS_ACT
    https://git.kernel.org/netdev/net-next/c/7444d706be31

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


