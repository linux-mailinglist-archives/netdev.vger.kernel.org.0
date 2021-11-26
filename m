Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD1445F58B
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbhKZT7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236615AbhKZT5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:57:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25981C0613F9;
        Fri, 26 Nov 2021 11:40:11 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8D4862356;
        Fri, 26 Nov 2021 19:40:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id EE4FE601FA;
        Fri, 26 Nov 2021 19:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637955610;
        bh=gZcfDZRWbi0lwEwboFbHH2tZWLnMQsT5dnASfyBMbxg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mddIfmcoHSPPq1CjHNcv6vA9OwL1dBtwwGonwikdQfHbWPiaREc5SpiPOQQr1dyo2
         YbSkUNg66inVoPax5WQhBlJSIibapZ0hBNqVv1hgAbK6WROs3mR8b8AZkDO/1AMxg3
         Qe/xX684O5pBhxZk1dnp/nbksyyvZPMihTqA1q7FQ/SEJ2/Wj+MESTAW1x06DxwMzg
         7/DwxRLJysvKDFuk8AkTHqUV9bc+exLxPwklO7r/WduTGb5aPRL7cv3IuXj02H8vGk
         nT6gVgWALsq3U3ecZU0/5wh3pCWtcp8yC+ILmRbnEYbNoEdYUDjilui7XjoXrhSE5I
         cj5OU/MRmWUIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DE4AE609D5;
        Fri, 26 Nov 2021 19:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] net: hns3: add some fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163795560990.18431.5458942100313021092.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 19:40:09 +0000
References: <20211126120318.33921-1-huangguangbin2@huawei.com>
In-Reply-To: <20211126120318.33921-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 Nov 2021 20:03:14 +0800 you wrote:
> This series adds some fixes for the HNS3 ethernet driver.
> 
> Guangbin Huang (1):
>   net: hns3: fix VF RSS failed problem after PF enable multi-TCs
> 
> Hao Chen (2):
>   net: hns3: add check NULL address for page pool
>   net: hns3: fix one incorrect value of page pool info when queried by
>     debugfs
> 
> [...]

Here is the summary with links:
  - [net,1/4] net: hns3: fix VF RSS failed problem after PF enable multi-TCs
    https://git.kernel.org/netdev/net/c/8d2ad993aa05
  - [net,2/4] net: hns3: add check NULL address for page pool
    https://git.kernel.org/netdev/net/c/b8af344cfea1
  - [net,3/4] net: hns3: fix one incorrect value of page pool info when queried by debugfs
    https://git.kernel.org/netdev/net/c/9c1479174870
  - [net,4/4] net: hns3: fix incorrect components info of ethtool --reset command
    https://git.kernel.org/netdev/net/c/82229c4dbb8a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


