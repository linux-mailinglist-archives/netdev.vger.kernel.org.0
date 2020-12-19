Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45772DECB7
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 03:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgLSCUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 21:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbgLSCUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 21:20:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608344407;
        bh=t/ZMNv1gskt11IV+ROnYRkOh3ia8oRvUB9T7Pba6E50=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QXQBuImGXSyy635QDSS5rIDGXfzbIeLXCmiIN7uPlVZpclddLn6QnuJd+RJ3lmzW8
         2Pr4CpYVSitf6qkJFYC1CkzYkiApSDNOMzxSo11UlwacxiVrnz7zw2C52WHQ8jWu9n
         OJdO8reQ3odLnI9E6dxwKSWnVCgy0UYJQpZRmji8qx7xze7hqOzhtT3Dq5lz1vR8x1
         mZkA+vIL8Yf+K4ymTcMraxeDvvuzhfKJ5R73DPVaVl+n/H1tbVTPmV3WKQNXg6AEwY
         YnqJwNRwYSuFr15QqT4AyUg3nBX4L/Dl1oB4aMPLGFvUHYd0xkgGMEXa5qzaoNDorW
         6vsbbFtiKZfgg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: nftables: fix incorrect increment of loop
 counter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160834440783.3580.17563690550363177479.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Dec 2020 02:20:07 +0000
References: <20201218120409.3659-2-pablo@netfilter.org>
In-Reply-To: <20201218120409.3659-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Dec 2020 13:04:06 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The intention of the err_expr cleanup path is to iterate over the
> allocated expr_array objects and free them, starting from i - 1 and
> working down to the start of the array. Currently the loop counter
> is being incremented instead of decremented and also the index i is
> being used instead of k, repeatedly destroying the same expr_array
> element.  Fix this by decrementing k and using k as the index into
> expr_array.
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: nftables: fix incorrect increment of loop counter
    https://git.kernel.org/netdev/net/c/161b838e25c6
  - [net,2/4] netfilter: x_tables: Update remaining dereference to RCU
    https://git.kernel.org/netdev/net/c/443d6e86f821
  - [net,3/4] netfilter: ipset: fixes possible oops in mtype_resize
    https://git.kernel.org/netdev/net/c/2b33d6ffa9e3
  - [net,4/4] netfilter: ipset: fix shift-out-of-bounds in htable_bits()
    https://git.kernel.org/netdev/net/c/5c8193f568ae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


