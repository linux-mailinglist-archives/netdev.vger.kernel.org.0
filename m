Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759EC3A49B2
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhFKUCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230181AbhFKUCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 16:02:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ED1FF60E0C;
        Fri, 11 Jun 2021 20:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623441607;
        bh=aYrv64uDG/U84k2iieUvEjfQOcc0/NP4JPZLq61NYcY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iXWi2/sY9zedaXpQa3mzfydH0RA6D/OKIoJ45AXeVlvyg4s55L6LuKoY5KrlZS4iL
         Zw1SlNxiuTglzArMCiZQgRR8yPO7xfQ9bkGRiyjU79VuDAe4OEJoRlHTObm6UL83ll
         Zkwmhqs7wsZolrSmunbj+y8SC019BdPbxaQakItwdUh64CZe0CEkFMR18osph5y4AG
         ERjZOeaeJWBDjqTxWOzTHcz+TDOJQDVKCYPCPrv2jcqw01MEP+aY49ldT6sS9+9YP0
         pCfmbwYI7vrI/tS4uPTk/64/wjVFR/m51WcFzeVHRWBbY53kvAr8H0KdEa2+UTrEyD
         Fa7OojyVzTmgg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E097960972;
        Fri, 11 Jun 2021 20:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: devres: Correct a grammatical error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344160691.3583.14867613052245570741.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 20:00:06 +0000
References: <20210611013333.12843-1-13145886936@163.com>
In-Reply-To: <20210611013333.12843-1-13145886936@163.com>
To:     None <13145886936@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 09:33:33 +0800 you wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Correct a grammatical error.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/devres.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: devres: Correct a grammatical error
    https://git.kernel.org/netdev/net-next/c/51a1ebc35b46

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


