Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38DD349D1D
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhCZAAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhCZAAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E402619F8;
        Fri, 26 Mar 2021 00:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616716809;
        bh=JUkk+C6V7Igg5yYK8r+Z7x6w99EX8HjzpiL3587doXY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LYZeOdNFqCMdYgg0vWBIRC0EgfHrbGAeuSouGiY/2a6IKc5QoKy0pZfX6LhAbaek1
         sszwH0Yy/6fWNkMv3HkLA9C+y4GRzJwXxw5IBKA7mwMCt0F5vbEZiuzsj6MN3jNTcb
         JOi7Bn4+qRrGhEkr7fQWjlCAVEmQX+lH0mbk4jBOqIxcYvxnrs1sT5eLvBwifAzIHL
         aGPwqmuJKyvfSxvE9WFVFVkJmTkrs2UpUm9N9bJPM29qSjaLcVjmdOEvd6YPlC59MP
         rw/TJJe1Q+3BtcfNxV4nFOabex2Y1X47QodMeChgoavbVrBcoc/e6tf2ddu/jUSCBf
         GhL77eauq+ZDA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3CC0760A6A;
        Fri, 26 Mar 2021 00:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: Fix a misspell in socket.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671680924.21425.14440255983771687484.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:00:09 +0000
References: <20210325030155.221795-1-luwei32@huawei.com>
In-Reply-To: <20210325030155.221795-1-luwei32@huawei.com>
To:     Lu Wei <luwei32@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 11:01:55 +0800 you wrote:
> s/addres/address
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  net/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: Fix a misspell in socket.c
    https://git.kernel.org/netdev/net-next/c/f1dcffcc8abe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


