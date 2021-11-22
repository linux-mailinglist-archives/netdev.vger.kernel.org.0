Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71D54590FF
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239740AbhKVPNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:13:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233449AbhKVPNP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 10:13:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A7BB460E73;
        Mon, 22 Nov 2021 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637593808;
        bh=cGEy36TjM7Lam+HqAZeg0XYPBk8u058WrdkP3d6FmB4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VEXvX8ySX2Wf5NC1C2gz6CtyHFKCOAC4OvWJ+GD8uRKOyX1VYmJQfUXyHRbwGeS6n
         E76TZ6qTdLUptDqhOozKwxEf1qFgdoso5Cb4HP7h5JVi4TgNJiIFd3eWuXBjzWNElx
         1LqZX5c3bC6UfRVogN9cqyBzrnnzIo9w+LPQms7IXypLGPNBsqalB0w44Bbc7b5l60
         9/hA4KIdV/MN5oXuFykbv+ZDXv12Y3dx1FQwuPnj7XpEhsJuGTDs+AJchEb5+IuFWf
         2EuRJO75g+LCJqDONfYg0UGEXSJREJdTIvsj4NHhxT8C/tYQ05a6MuhcRAAOd/dsPG
         vT4zEhcdznpBw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8D11F609D9;
        Mon, 22 Nov 2021 15:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nixge: fix mac address error handling again
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759380857.16406.12654623998882821582.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 15:10:08 +0000
References: <20211122150322.4043037-1-arnd@kernel.org>
In-Reply-To: <20211122150322.4043037-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, mdf@kernel.org,
        arnd@arndb.de, yangyingliang@huawei.com, moyufeng@huawei.com,
        tanhuazhong@huawei.com, caihuoqing@baidu.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 16:02:49 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The change to eth_hw_addr_set() caused gcc to correctly spot a
> bug that was introduced in an earlier incorrect fix:
> 
> In file included from include/linux/etherdevice.h:21,
>                  from drivers/net/ethernet/ni/nixge.c:7:
> In function '__dev_addr_set',
>     inlined from 'eth_hw_addr_set' at include/linux/etherdevice.h:319:2,
>     inlined from 'nixge_probe' at drivers/net/ethernet/ni/nixge.c:1286:3:
> include/linux/netdevice.h:4648:9: error: 'memcpy' reading 6 bytes from a region of size 0 [-Werror=stringop-overread]
>  4648 |         memcpy(dev->dev_addr, addr, len);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - nixge: fix mac address error handling again
    https://git.kernel.org/netdev/net/c/a68229ca6340

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


