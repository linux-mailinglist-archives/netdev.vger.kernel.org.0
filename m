Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5153637214E
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 22:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhECUbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 16:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhECUbD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 16:31:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A6DF661208;
        Mon,  3 May 2021 20:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620073809;
        bh=WND7bRnxiucv/kfzIV93/0SYl1x0FDVvOnTtfjsQoPY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n9/lP1krF4cC24+y4M7yMb80vssvd+mlgNDZnxmmLP7hJHFDlHAke/IuRd/3KPVV7
         a8fIUfWJvzn7VfMAL36XpKJqWI9D4KLFxCltpXBJ/vN2vdpa9fKgiwoTatErsyWy6q
         ypF9Vj/9/mIGNPec/FGXFPQX1Xw1woZmOVLBpJkXnh5y8hUzl9Ui96Iuc/esXYWWsV
         mfjSDUDiyv+xacnLpLvYhBi17dmhgQCzRTJaDTlv2B7CoeLgMMO+EgFORK84w/x+kA
         1KGl+0vkyqa1GKeSpLmTsFRpQeLr1XoaHhOQNvXHwpG6snAe1RVdHoveswPeXH6XM0
         fIi0xBzkGtsHw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9668A60A22;
        Mon,  3 May 2021 20:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ethernet:enic: Fix a use after free bug in
 enic_hard_start_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162007380961.28407.4171328445002886340.git-patchwork-notify@kernel.org>
Date:   Mon, 03 May 2021 20:30:09 +0000
References: <20210502115818.3523-1-lyl2019@mail.ustc.edu.cn>
In-Reply-To: <20210502115818.3523-1-lyl2019@mail.ustc.edu.cn>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     benve@cisco.com, _govind@gmx.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  2 May 2021 04:58:18 -0700 you wrote:
> In enic_hard_start_xmit, it calls enic_queue_wq_skb(). Inside
> enic_queue_wq_skb, if some error happens, the skb will be freed
> by dev_kfree_skb(skb). But the freed skb is still used in
> skb_tx_timestamp(skb).
> 
> My patch makes enic_queue_wq_skb() return error and goto spin_unlock()
> incase of error. The solution is provided by Govind.
> See https://lkml.org/lkml/2021/4/30/961.
> 
> [...]

Here is the summary with links:
  - [v2] ethernet:enic: Fix a use after free bug in enic_hard_start_xmit
    https://git.kernel.org/netdev/net/c/643001b47adc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


