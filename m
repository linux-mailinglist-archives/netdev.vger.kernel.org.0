Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EAC350A22
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhCaWUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229486AbhCaWUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:20:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D460360D07;
        Wed, 31 Mar 2021 22:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617229214;
        bh=K5gbFqrpLZZ4jN0nigsKhCDZ+BcTBJCqLcTHSDxIZoQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CKvxjCcO/NACrIpT+fF8GHKuJxQl25CXDBamdQ6pTFC1Bg4XDkSBeb6QSafLoTyKF
         mQfUkUJfiH0QUTfCoqa6lq2RNPvPY7LtY74578TR5BiWt7xlF0RUZMC99kYwcdjO33
         fkr+TFbrYR4yJurkXWXU6pxm0j4OgY+OntAj7/UVIyM0e8DUkySXrA0emJk4SmSlCB
         vvpMJlOcLiKrnx0Sn7FD10R+6bURQJ7DibHJGujn5G5eEwvxNp+rUNFmokbu+HQMFz
         ydkYoFZAkJzH8fZrQzuNZ6Q9ypgaJsHPUjFWEnHsgXUZaSIM7qZ3wfXxoxLG+xbhK3
         UgR3rSp0v/rUQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CA97360727;
        Wed, 31 Mar 2021 22:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net: correct sk_acceptq_is_full()"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722921482.2890.1311529057436285312.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 22:20:14 +0000
References: <20210331163512.577893-1-eric.dumazet@gmail.com>
In-Reply-To: <20210331163512.577893-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, yacanliu@163.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 31 Mar 2021 09:35:12 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This reverts commit f211ac154577ec9ccf07c15f18a6abf0d9bdb4ab.
> 
> We had similar attempt in the past, and we reverted it.
> 
> History:
> 
> [...]

Here is the summary with links:
  - [net] Revert "net: correct sk_acceptq_is_full()"
    https://git.kernel.org/netdev/net/c/c609e6aae4ef

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


