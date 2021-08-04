Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9513DFDB0
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbhHDJKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236965AbhHDJKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 05:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BADC261050;
        Wed,  4 Aug 2021 09:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628068205;
        bh=MB37BoflNXbs9FH9YcZB2Z2pMR25pzrNeNuYx1/iBBU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t68VeIp3hOUBKxWiS0NxNof70QR57kqqiqsaaGC/pSULVh7NNiGONmTnWOW+kO+6W
         u8owK+ofVTJ+lSzRcj56tBUCytWn+E1kNvAdl+iD8fPw8CKttz2fYnkDzzVG0GAYss
         N62v0D/8BQWYZqr29/jTIautFQj1oJ8EqgtkqCNJnig27wgedGF5cUP42fbrJo/t1E
         c7xOD2etOkMan4mwAStQjv9W8bSj9vf1lhBsaAmDYm8cxUDCqd0hGzH/BHMhkrp8B3
         hOqL8cdfGtkXUWh4fB5Uo/bfOjIzCLXUFVocxcLHjIMX+6hBmd6KB/ES1vQEsEhEY9
         YibzmYJXLOYyA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B59C660A48;
        Wed,  4 Aug 2021 09:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: add extack arg for link ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162806820573.32022.14403323895648321150.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 09:10:05 +0000
References: <20210803120250.32642-1-rocco.yue@mediatek.com>
In-Reply-To: <20210803120250.32642-1-rocco.yue@mediatek.com>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 3 Aug 2021 20:02:50 +0800 you wrote:
> Pass extack arg to validate_linkmsg and validate_link_af callbacks.
> If a netlink attribute has a reject_message, use the extended ack
> mechanism to carry the message back to user space.
> 
> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
> ---
>  include/net/rtnetlink.h | 3 ++-
>  net/core/rtnetlink.c    | 9 +++++----
>  net/ipv4/devinet.c      | 5 +++--
>  net/ipv6/addrconf.c     | 5 +++--
>  4 files changed, 13 insertions(+), 9 deletions(-)

Here is the summary with links:
  - [net-next] net: add extack arg for link ops
    https://git.kernel.org/netdev/net-next/c/8679c31e0284

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


