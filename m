Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8962CFF08
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgLEVAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEVAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 16:00:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607202007;
        bh=ulM03XC5TbUaASbHvFFhzGy6LzmlAbsp+3RyQAy/4/o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tSG+FB2UADf680bxMxHnpnB9CwzZu9zC05s8i9IhKN3E0MLsj00qcaqNqiOzRilHF
         b5Y+fvN+qEWnLhSuKc+UiAWCWG/vjXoVvFuh1SksaXfsJuZMnuazhy6JL1KkbgW639
         Og+SZa0Om+qamMMdUY+7ESlkWGCYv4D9uSqyI8kKTnNyW2ChvhzoEfbdvg2u3y/ujF
         pAg6LsXObjrl79iBhqzCcw+QambA/4KvdDbdOhpwmhqNK7OlNJVT6YxXcNkXhZXUVe
         fbXNKoweBNvrfg21ub8wwzRy8SUrnt2xF/4BqrA0Ud1p7X0rcj6PnjMynzOhnJJLtX
         lQOREdj6lv9/Q==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ch_ktls: fix build warning for ipv4-only config
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160720200717.27606.5148059074958417567.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Dec 2020 21:00:07 +0000
References: <20201203222641.964234-1-arnd@kernel.org>
In-Reply-To: <20201203222641.964234-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     ayush.sawal@chelsio.com, vinay.yadav@chelsio.com,
        rohitm@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de, natechancellor@gmail.com, ndesaulniers@google.com,
        yuehaibing@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  3 Dec 2020 23:26:16 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When CONFIG_IPV6 is disabled, clang complains that a variable
> is uninitialized for non-IPv4 data:
> 
> drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1046:6: error: variable 'cntrl1' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>         if (tx_info->ip_family == AF_INET) {
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1059:2: note: uninitialized use occurs here
>         cntrl1 |= T6_TXPKT_ETHHDR_LEN_V(maclen - ETH_HLEN) |
>         ^~~~~~
> 
> [...]

Here is the summary with links:
  - ch_ktls: fix build warning for ipv4-only config
    https://git.kernel.org/netdev/net/c/a54ba3465d86

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


