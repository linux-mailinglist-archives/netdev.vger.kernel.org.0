Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9860B2FB141
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 07:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbhASGXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 01:23:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404018AbhASFuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 00:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9671822C9D;
        Tue, 19 Jan 2021 05:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611035410;
        bh=PE5fOYF64qYdnIZ3SUdiCMhNLow+nhfFvkCNiJdpz6w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ba+gC0OeBXD+uOVOFEWLwZwxGWpRoAem6HVjrnyn0Fwwf3a9vzYRx1qW/glgzW3ge
         XfDoRu6KzjWPuuNFvw9RvuS17B2Yd4HWANP5aR70xwxEwKmqbTYI1bxkQfHmJEovCN
         gBvlgEi4ggrZ3Wt+zu3M0YPOh8U5HxnuyrK9Q80AXz6jhE24Cpks+H67J6OWBAeSDn
         eXXeJMDUC6BioYxZm6mrwcX3463ot1Hc42roMCGLieV7u9TV/CtbSMAnWq+BrwYAoc
         /JNPp4dADo4ww5AYtgryMl/uHhsXQEqS53+PwBOqENIRZBHWzFlRr6cf7QVMcUVxUh
         iFn+x/zK0E04g==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 8AE53604FC;
        Tue, 19 Jan 2021 05:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hns: fix variable used when DEBUG is defined
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161103541056.1484.11203374342891862522.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jan 2021 05:50:10 +0000
References: <20210117191044.533725-1-trix@redhat.com>
In-Reply-To: <20210117191044.533725-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, timur@kernel.org,
        hkallweit1@gmail.com, song.bao.hua@hisilicon.com,
        tariqt@mellanox.com, wanghai38@huawei.com, Jason@zx2c4.com,
        jesse.brandeburg@intel.com, dinghao.liu@zju.edu.cn,
        liguozhu@huawei.com, huangdaode@hisilicon.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 17 Jan 2021 11:10:44 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> When DEBUG is defined this error occurs
> 
> drivers/net/ethernet/hisilicon/hns/hns_enet.c:1505:36: error:
>   ‘struct net_device’ has no member named ‘ae_handle’;
>   did you mean ‘rx_handler’?
>   assert(skb->queue_mapping < ndev->ae_handle->q_num);
>                                     ^~~~~~~~~
> 
> [...]

Here is the summary with links:
  - net: hns: fix variable used when DEBUG is defined
    https://git.kernel.org/netdev/net-next/c/99d518970c5a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


