Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484B4311FA3
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 20:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhBFTVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 14:21:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230131AbhBFTUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 14:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9127D64E37;
        Sat,  6 Feb 2021 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612639207;
        bh=BjZRiIakt7B56z4nBVLZY8vsaDDDEf7WLoPXoLb8VT0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JaBMiHROrSR4a2cH3EzxLERxczUhbiVww9eMF4KaPwllCGIGb9Mf9A+GgWB85XHPt
         D/7MXfsTNC/lt49uyfaRF3B491Uel1TWENhQg/aVKfJBs2Msdms1po1yREi40XrTV1
         XTgcZbz+fHOM+ZoFbFjJgsZvXfdZkzNzYWK5wYeXYxJ2AWqItLLfid3PFglntrsRQf
         bAZO+AM9B/WNNG+V27pPG/zKamqlkjVcNy9+ji6V23LOhas5PKLclt9rpWFuh+uq0O
         mVaGPvR/KVt8FShgRaVRFT4GQD5LzFNkzK2jQtb2GUO8I+X0SLSVwQtcty3aE0d72V
         wKbGOtn7uBinw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 849A7609F7;
        Sat,  6 Feb 2021 19:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] dccp: Return the correct errno code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161263920753.23851.11461572850833171527.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 19:20:07 +0000
References: <20210204072820.17723-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210204072820.17723-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, kuba@kernel.org,
        dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 4 Feb 2021 15:28:20 +0800 you wrote:
> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/dccp/feat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] dccp: Return the correct errno code
    https://git.kernel.org/netdev/net-next/c/247b557ee52a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


