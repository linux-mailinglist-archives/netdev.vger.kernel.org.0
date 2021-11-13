Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DCF44F127
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 05:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbhKMEXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 23:23:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235604AbhKMEXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 23:23:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B767C61105;
        Sat, 13 Nov 2021 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636777209;
        bh=xHCEyQgmmneU5BQvjkALsnRvAKyNzijjKS1VT4RgCNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BnNfEhCopjuBaqXjOo0IxsE3xbcJ+nvuFpzME+HXZCC9Hz6EgZI+xxgB8cjM1dMwb
         8MC/gNwycqotQCQNWc74ZSiWJ9y+H3BvllXfPkmu7dk0CkqGQ1+CkIAh5v9QaNjK62
         upCfzcbrYKTEF7YfovWBTxmj/z3SlqHDaEz75wp1IFXk7jAzzmF9E/Mb9xLDVsXjta
         /QF/CxMuUgIfQxkWXljZp6RfZXnyK5KQy1SZEMaPR7/5xxpisOKS3pjbmkK1DadOBZ
         E6+PJD4qrw1MsI22S9shmMBcOshZAkCsNFGMl68Uv2xdSS0STdTKpz+tQN+R94lPNv
         DzfYu8Aov84Mw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A13F5609F4;
        Sat, 13 Nov 2021 04:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] hamradio: remove needs_free_netdev to avoid UAF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163677720965.27008.11067084190149438214.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Nov 2021 04:20:09 +0000
References: <20211111141402.7551-1-linma@zju.edu.cn>
In-Reply-To: <20211111141402.7551-1-linma@zju.edu.cn>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jirislaby@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 11 Nov 2021 22:14:02 +0800 you wrote:
> The former patch "defer 6pack kfree after unregister_netdev" reorders
> the kfree of two buffer after the unregister_netdev to prevent the race
> condition. It also adds free_netdev() function in sixpack_close(), which
> is a direct copy from the similar code in mkiss_close().
> 
> However, in sixpack driver, the flag needs_free_netdev is set to true in
> sp_setup(), hence the unregister_netdev() will free the netdev
> automatically. Therefore, as the sp is netdev_priv, use-after-free
> occurs.
> 
> [...]

Here is the summary with links:
  - [v1] hamradio: remove needs_free_netdev to avoid UAF
    https://git.kernel.org/netdev/net/c/81b1d548d00b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


