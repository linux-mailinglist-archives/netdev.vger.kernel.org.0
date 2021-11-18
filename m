Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97458455B46
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344551AbhKRMNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:13:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344561AbhKRMNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 07:13:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4DE7861544;
        Thu, 18 Nov 2021 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637237410;
        bh=IcsP72e372rPYqCwnwiT6l7K3SwCXX9/c7BTEI3tff8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=noUH/uOHoK+3FWFUXO8pJloQ0+M6Ec8FTSaTjMohRrZVUTd7qs8bXU/zq4HQJdJmz
         eGg7D5DQVctYo7u5PcLG37EDpQB9YXs9fXYYoZHyElv699nn1+XYjzBqWCtSxpxth1
         YFnIVq9eVWUpgWfO6NlNTvAeV3Vo1wZQmy7uY4Ap25JB9Z/xT8Ti5ra2Zr6/USH9V9
         NEK5Dvry410ltQ6u81E4RoijPOjSbRaym1kGHb3Awb+9g2xgRwidTVQj0ykO7/5Q5B
         mfaA+KGQWu3PXSgGGQueFuNqAnaZzy1IqzWfXnQZCnlCdn5840ZIWDi1Qmv/08gM66
         GRgQmplpc7kOw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4581D609CD;
        Thu, 18 Nov 2021 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: add missing htmldocs for skb->ll_node and
 sk->defer_list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723741028.26371.11174909878861193245.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 12:10:10 +0000
References: <20211118015729.994115-1-eric.dumazet@gmail.com>
In-Reply-To: <20211118015729.994115-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, sfr@canb.auug.org.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Nov 2021 17:57:29 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Add missing entries to fix these "make htmldocs" warnings.
> 
> ./include/linux/skbuff.h:953: warning: Function parameter or member 'll_node' not described in 'sk_buff'
> ./include/net/sock.h:540: warning: Function parameter or member 'defer_list' not described in 'sock'
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: add missing htmldocs for skb->ll_node and sk->defer_list
    https://git.kernel.org/netdev/net-next/c/df6160deb3de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


