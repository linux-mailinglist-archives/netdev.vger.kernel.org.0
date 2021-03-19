Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB3E3412BB
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhCSCUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231233AbhCSCUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 22:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5E71964F3B;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616120412;
        bh=fLO7mwrVrswGtkXBVrBfhs3d6vsRyHpBFRmwenGADSo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T2yMSswwf7Ig65BiZcJETAIsILkqrqvH13UnCXGQqlYZFG8tvvcyJtgS2JSS67C4k
         fR+yb8eRedRn7naY3W1wWi/yKxkGue/uILxfybr+mjI1WwuKlF3aYmkd1XB2IEiIxW
         W3sXNo+PTlwVXgh6ZrgYdy4VKUnXO/vltUCJHO0beFdE8yTi3jG4L/c6RPbWf2dSBZ
         wcz/Zj4UZAVfLb4y/flUPW0TKT0jSVLxjgQxrwBV9Aa+uf7hOkqaCetcY4r+WrsKP7
         2sHwksEDuGmjsIxGwWHJ4FEovEyjtSw0UEYG14oKb9US8Y1fWCYa439rvZOvJSlp8F
         nmyytBPkgjz4A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 57CE160951;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] /net/hsr: fix misspellings using codespell tool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161612041235.22955.5015436057969983535.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 02:20:12 +0000
References: <20210318113941.473650-1-xiong.zhenwu@zte.com.cn>
In-Reply-To: <20210318113941.473650-1-xiong.zhenwu@zte.com.cn>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, m-karicheri2@ti.com,
        andriy.shevchenko@linux.intel.com, xiong.zhenwu@zte.com.cn,
        miaoqinglang@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 04:39:41 -0700 you wrote:
> From: Xiong Zhenwu <xiong.zhenwu@zte.com.cn>
> 
> A typo is found out by codespell tool in 111th line of hsr_debugfs.c:
> 
> $ codespell ./net/hsr/
> 
> net/hsr/hsr_debugfs.c:111: Debufs  ==> Debugfs
> 
> [...]

Here is the summary with links:
  - [net-next] /net/hsr: fix misspellings using codespell tool
    https://git.kernel.org/netdev/net-next/c/7f1330c1b19d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


