Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842B639E8EE
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhFGVMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230502AbhFGVL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:11:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E628961287;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100205;
        bh=KaKyZqxX7sWADuol+leMyCmcCaydK7mR4faNAcJsN1A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S8+074EdrgjOJpvmUmDOrie+dh1IOb7XQ8XLXmpdKHavF3VFNhRkOSfRpoalnFVkx
         Nzo2cRwLHa+spUxsR1vDBAfoOgGcHuwxHu9pfguI2MlEIIHXlnI4bGqDMBYsnEou/O
         2c8TmYtNxITHLdg3WhAyecifW2SNZhTw1amsztMbp5pAD01/FWVGW+n5d9O0JBtSoi
         CxW7+rn5rG1H61A8abYGtOEZ/2KVecSTvD5xGvmulqFd5LAx3P7xyVQ4A29bnjQWcQ
         JZsGswMs5kQgrfRUH4M3BwEwA08EVvtB++eCDrfCfR9CLTRNqXrXkFd6nhnhtZI9Hb
         /HpEHSZj1/Xug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DF6A260BE2;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bcmgenet: check return value after calling
 platform_get_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310020591.31357.15817131133501890671.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:10:05 +0000
References: <20210607133837.3579163-1-yangyingliang@huawei.com>
In-Reply-To: <20210607133837.3579163-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 21:38:37 +0800 you wrote:
> It will cause null-ptr-deref if platform_get_resource() returns NULL,
> we need check the return value.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/broadcom/genet/bcmmii.c | 4 ++++
>  1 file changed, 4 insertions(+)

Here is the summary with links:
  - [net-next] net: bcmgenet: check return value after calling platform_get_resource()
    https://git.kernel.org/netdev/net-next/c/74325bf01045

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


