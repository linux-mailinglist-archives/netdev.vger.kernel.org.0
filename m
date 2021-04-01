Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAF235235E
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhDAXUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235904AbhDAXUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1D8261139;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617319209;
        bh=Dod8tidBgEGHqoYcWN/zCaRh4gwYgiM6CYCxR4bPJSU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T/AkB6voAD9rxPlGJbCyXN/XqVQpaei8ndcL63cW7zsYnFmssBUgvNXE5R4XOLHaH
         rvSxeY4hzb96XEGf+aqyYYOpUPJQErmMwx6SH0PCREPftn+1hImhj/egfZ2BCE7xnN
         VVMmq72kt+eIY91CUrWy8i4rz/Z23CLk055zO+ecsSj+U9KpQC+6n4nHcfuP7W/09s
         ah8/2n+KfcQzkzdEgz9vqZ7I75Y7T0sgCO5AmRLoigvvlR/TJsNa+RED74Xj8eD/A3
         1umK33+JEIPYS0vGlahDKtScO1tsN7cTfrlsN8EyhCT6MvjdutO8liQE0BIXNlAAG0
         M0U8G6xoo/g8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9F320609D3;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hns: Fix some typos
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731920964.16404.13172472594134454465.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 23:20:09 +0000
References: <20210401092701.281820-1-luwei32@huawei.com>
In-Reply-To: <20210401092701.281820-1-luwei32@huawei.com>
To:     Lu Wei <luwei32@huawei.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, trix@redhat.com,
        jesse.brandeburg@intel.com, wanghai38@huawei.com,
        dinghao.liu@zju.edu.cn, baijiaju1990@gmail.com,
        song.bao.hua@hisilicon.com, tariqt@mellanox.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 1 Apr 2021 17:27:01 +0800 you wrote:
> Fix some typos.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns/hns_enet.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - net: hns: Fix some typos
    https://git.kernel.org/netdev/net-next/c/c8ad0cf37c00

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


