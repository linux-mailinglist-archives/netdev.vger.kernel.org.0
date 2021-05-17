Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A08386C00
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244839AbhEQVL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:11:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237403AbhEQVL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 17:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 91A6B611C1;
        Mon, 17 May 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621285810;
        bh=TEA/wBQ2bfJOzNxSwWzS/isOhOdg6bEZLH5gpZAr1YQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kX/p3SUbSJ5Em+5TjR47pCooSq2H2gJjgg0UaYfSv/l441HCyDi7QEzCLaHyk5MuW
         qB/V6v/m1UyV8qB2txIqJdxIiUiIl+pVa5mh9yClmgyi9p6LUHwEXc30P1eijX2PFZ
         LzXSj2eWBG6vxhPANxtJAl+hI3QsIMV3dEnypP96rbXE0dm9jpeCYrloS5rKDr/3fh
         DiDp6xYrkEthRBqkDDmND+LbZmQk/yK8JOajoaCtkJNL/uWFL98K7SFXtOqkpQFhn7
         jgXvhy7YNuYHvz7Z9r1MixsnFPXLwHlxNGW6jKRqxtHcCNd1UWUI75E4q4DJj7OR/1
         KKYxqnxB6XPxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 84A8460963;
        Mon, 17 May 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] isdn: mISDN: netjet: Fix crash in nj_probe:
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162128581053.6429.12390001025467093897.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 21:10:10 +0000
References: <1621149100-23604-1-git-send-email-zheyuma97@gmail.com>
In-Reply-To: <1621149100-23604-1-git-send-email-zheyuma97@gmail.com>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     isdn@linux-pingi.de, christophe.jaillet@wanadoo.fr,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 16 May 2021 07:11:40 +0000 you wrote:
> 'nj_setup' in netjet.c might fail with -EIO and in this case
> 'card->irq' is initialized and is bigger than zero. A subsequent call to
> 'nj_release' will free the irq that has not been requested.
> 
> Fix this bug by deleting the previous assignment to 'card->irq' and just
> keep the assignment before 'request_irq'.
> 
> [...]

Here is the summary with links:
  - isdn: mISDN: netjet: Fix crash in nj_probe:
    https://git.kernel.org/netdev/net/c/9f6f852550d0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


