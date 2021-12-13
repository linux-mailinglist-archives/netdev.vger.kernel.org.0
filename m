Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0EB472F8F
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239633AbhLMOkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhLMOkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 09:40:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBCFC06173F
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 06:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 711D36111D
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9767C34602;
        Mon, 13 Dec 2021 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639406408;
        bh=aiKSbjt9lhRIQIuroPumXQHt6X6UZ/zCBmNwWrNq9/M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PLFv4w5kXgn1uuK8C+w1NcQyvkaNrQQuTtctIJlLrLM6S5246KryDrubnFO0eP/A3
         BoVMlzLmB4aS4CcpTWoOPaK1OFLlYbKFTFLLPLlSyvNmAP419s8go+OfaaBHJVMwND
         8kSk0mV/CioI9NRc6DCASjE7W7P1dFL3yuYMjjQ3OjrgFVL4yavDYsRw1Aas6s4R3J
         4li1FO3kswmYTBlU6h7JA5jTUjwSKppSN1o+luvsyaO8EmCcfMOT8OU1ccbLY3jr3R
         mFueryjp6XRI6xbgxE9Z+2hUm2MPg1S2GAsFWm0ChPPYuJJjywTimHuFJQof4ZZie4
         XzK9UaWpOvN+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B23A7609F5;
        Mon, 13 Dec 2021 14:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests/net: toeplitz: fix udp option
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940640872.17097.10109989597832077341.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 14:40:08 +0000
References: <20211211193031.2178614-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20211211193031.2178614-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 11 Dec 2021 14:30:31 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Tiny fix. Option -u ("use udp") does not take an argument.
> 
> It can cause the next argument to silently be ignored.
> 
> Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> 
> [...]

Here is the summary with links:
  - [net] selftests/net: toeplitz: fix udp option
    https://git.kernel.org/netdev/net/c/a8d13611b4a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


