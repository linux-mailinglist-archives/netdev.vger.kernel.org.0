Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBD239ADD7
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhFCWV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230344AbhFCWVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 46EBF6140A;
        Thu,  3 Jun 2021 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622758806;
        bh=hQN2UZAy+im+Fbux8BhW47nuaMvBm6++WvivhYqV+xU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X4M0fR5bjn5NS3tLXSJ26IkT75xrCGfo8AFCnPKYU9CGhwfcXkRYjrzrE6shTAaOi
         O3b99iMm435hoGLROa/1UMtIvaD68XMzrLhYV9aPinhRx+NYzmFJF0l48a2sL76Cb/
         f9mlTGGnMmRJ7XPrv5mI51vDFb3dhlLfwDHJA6im/kETS6YT5C+o2QDL8YrCJA6soL
         RkfdAgSGQbSj1CE4alwkd7kjqUyRqR0GPD+R+DJ/bTp3zBy5BNgmvd8DkCNoEUDDe6
         5dQTxVW23oI8Ofi1gwmmxK3LAqXlcih/N5VA329UdIT+7nqeRgdSznsdDZKFQ3FWqi
         KSutOiE9mLnZA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3837360A6C;
        Thu,  3 Jun 2021 22:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/x25: Return the correct errno code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275880622.4249.2288247595417992464.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:20:06 +0000
References: <20210602140630.486073-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210602140630.486073-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     ms@dev.tdt.de, davem@davemloft.net, kuba@kernel.org,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 2 Jun 2021 22:06:30 +0800 you wrote:
> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/x25/af_x25.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net/x25: Return the correct errno code
    https://git.kernel.org/netdev/net/c/d7736958668c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


