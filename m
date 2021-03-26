Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDDA349D1E
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhCZAAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhCZAAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 66DAD61A36;
        Fri, 26 Mar 2021 00:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616716809;
        bh=IKCSr02I8XF3WCu9pdXgWOoezAZmcyZnLNBzQ5DCcic=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sn4Hh+CrbdSAXgOXjN2d0feqYZBt8AaAi1DkHBfnt+rlk5DKwHpB4BBJuLh+YRQqj
         Rj51AKIrRG5Dis9Tf/6BPWUE9D8CWWQZp792bQkUr1Mh6Pks5rVF2fI0IxZ95HpG+0
         Du9uZ99WAMC2hKs1VEFFtwr6M/oQNLXXz5sZ3fZB9Tkj6RFjGQKqstBWw2yyaR6H5F
         +CtT+BWnlWoEzkGyU3hIUdS3Ia7scJ8U7Df4xIa6JBow/t8MpuzfOAPAMUrqsFs3QP
         GaRjR8T4YmzlE73zQwEF7p+TcGym/Qu6vLk1xVeW/flRAQE+tW1USPpsxdE8ybSsVo
         xd1nRP1nHBtKQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B2FA60C25;
        Fri, 26 Mar 2021 00:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bcmgenet: remove unused including
 <linux/version.h>
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671680937.21425.17841438025656510708.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:00:09 +0000
References: <20210325032932.1550232-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210325032932.1550232-1-zhengyongjun3@huawei.com>
To:     'Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 11:29:32 +0800 you wrote:
> From: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> Remove including <linux/version.h> that don't need it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: bcmgenet: remove unused including <linux/version.h>
    https://git.kernel.org/netdev/net-next/c/ba8be0d49caf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


