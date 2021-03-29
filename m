Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD95634C0CC
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhC2BAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230402AbhC2BAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 21:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4366B61930;
        Mon, 29 Mar 2021 01:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616979611;
        bh=mOxbeA1yPzx7HyYNiXkyRHhNMKvkklfxKtqvdsHWmus=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hOuEf3wEi6L0bLaE5VK0Q4CBo8y90WVUfcSOQPlQqq9lbvmaY76y0lwbikoaayCVB
         etYpbjA9kpbAGu4bWEb01MzMCwk9fFb6fokNTlPdPJp3dZHPwBs+uyE0H5G+/w4DiR
         /kMZxTAKnPJSIJwV7/DnxXlNQ2h83/XDK37H2BMOxAbWRG0IJd+1AVc5BzvPzhKZb3
         59LnZKxlogkle2iZZOBrPw2SKSAhsAKzu/E+C6ukE9R3dm815PVF6aFz1rdG22yE8/
         RMJgX6Ydufpi8l268PQw9bsn2QyuZJoC36fqcXMC7/zl2M0NewZ34Ghkj7pWS3Rxpw
         eNYqfdmTG8qHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3428A60A56;
        Mon, 29 Mar 2021 01:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/9] net: Correct function names in the kerneldoc comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161697961120.31306.8836440711867920631.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 01:00:11 +0000
References: <20210327081556.113140-1-wangxiongfeng2@huawei.com>
In-Reply-To: <20210327081556.113140-1-wangxiongfeng2@huawei.com>
To:     Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc:     dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 16:15:47 +0800 you wrote:
> Xiongfeng Wang (9):
>   l3mdev: Correct function names in the kerneldoc comments
>   netlabel: Correct function name netlbl_mgmt_add() in the kerneldoc
>     comments
>   net: core: Correct function name dev_uc_flush() in the kerneldoc
>   net: core: Correct function name netevent_unregister_notifier() in the
>     kerneldoc
>   net: 9p: Correct function name errstr2errno() in the kerneldoc
>     comments
>   9p/trans_fd: Correct function name p9_mux_destroy() in the kerneldoc
>   net: 9p: Correct function names in the kerneldoc comments
>   ip6_tunnel:: Correct function name parse_tvl_tnl_enc_lim() in the
>     kerneldoc comments
>   NFC: digital: Correct function name in the kerneldoc comments
> 
> [...]

Here is the summary with links:
  - [1/9] l3mdev: Correct function names in the kerneldoc comments
    https://git.kernel.org/netdev/net-next/c/37569287cba1
  - [2/9] netlabel: Correct function name netlbl_mgmt_add() in the kerneldoc comments
    https://git.kernel.org/netdev/net-next/c/3ba937fb95e8
  - [3/9] net: core: Correct function name dev_uc_flush() in the kerneldoc
    https://git.kernel.org/netdev/net-next/c/af825087433f
  - [4/9] net: core: Correct function name netevent_unregister_notifier() in the kerneldoc
    https://git.kernel.org/netdev/net-next/c/bb2882bc6c54
  - [5/9] net: 9p: Correct function name errstr2errno() in the kerneldoc comments
    https://git.kernel.org/netdev/net-next/c/8bf94a92505e
  - [6/9] 9p/trans_fd: Correct function name p9_mux_destroy() in the kerneldoc
    https://git.kernel.org/netdev/net-next/c/54e625e3bd1d
  - [7/9] net: 9p: Correct function names in the kerneldoc comments
    https://git.kernel.org/netdev/net-next/c/03ff7371cba4
  - [8/9] ip6_tunnel:: Correct function name parse_tvl_tnl_enc_lim() in the kerneldoc comments
    https://git.kernel.org/netdev/net-next/c/f7b88985a1ae
  - [9/9] NFC: digital: Correct function name in the kerneldoc comments
    https://git.kernel.org/netdev/net-next/c/b6908cf795e9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


