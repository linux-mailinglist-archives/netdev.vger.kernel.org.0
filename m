Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A643813B5
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhENWVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233904AbhENWV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:21:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 15BD861461;
        Fri, 14 May 2021 22:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621030814;
        bh=98SaeUo9DJHFI/d6+3XYGO+gO5esd8wR+uHvJcTObks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uFJbiyv7A7li/v65XVszFLoJ9WML3sqqrq74P8khopq2sleVa1CpBAeCY2ApN7SHq
         B5vjoL/YP5MG44oHqHHBRnN8USb/O2rb8E8kllLZGGkgbvN5fKhmpFiNYsQUdd0rcV
         WuGYUMS8HHG25eGGRigagQX4obN4NqKVrEMzDhMhcuBxc7PWvouKJeATAI3ZY9o7pA
         ODPwBZZoPKNxAkGbn6RBa29/19vgkor+M5lky+Yfm8yfJFQ5+p8O3f/K5UAjpfK9aM
         i/1CPYtRY8MO1ZMxoBBaB10XYINoaU4Z+C/znhosTE3pJSfngApr1/uNKM6g9xVZDn
         Bkyvl5g5J+aiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0C23560A56;
        Fri, 14 May 2021 22:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] alx: fix missing unlock on error in
 alx_set_pauseparam()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103081404.6483.10580485988083694355.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 22:20:14 +0000
References: <20210514082405.91011-1-pulehui@huawei.com>
In-Reply-To: <20210514082405.91011-1-pulehui@huawei.com>
To:     Pu Lehui <pulehui@huawei.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 14 May 2021 16:24:05 +0800 you wrote:
> Add the missing unlock before return from function alx_set_pauseparam()
> in the error handling case.
> 
> Fixes: 4a5fe57e7751 ("alx: use fine-grained locking instead of RTNL")
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---
>  drivers/net/ethernet/atheros/alx/ethtool.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] alx: fix missing unlock on error in alx_set_pauseparam()
    https://git.kernel.org/netdev/net-next/c/2d1c5f29d27a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


