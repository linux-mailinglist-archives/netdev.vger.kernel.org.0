Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EF842CB2F
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhJMUmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhJMUmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C4886610EA;
        Wed, 13 Oct 2021 20:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157606;
        bh=y2RjxwsrNg9Ps4x3Z8Te73NbdlkaT+RC21J7GmbWa8w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r8zG8TE4gZE9oz0NEwVnpiAEPqBEtVmNV9XN5ZTlZym70MrAd095W/0O8ShBk5kXn
         EHXQnf45tWdb4lSv1KErgSOV8RlZr1GDtvVS/8PvVJlZsdLZWm4ejzO7JLkVXzVY9W
         jShrP2QzqnCTGZphxbMxJYT3S61M1ohVagnLPj47CKU6mTLyaBQgosryICjEgJd8MV
         LbsKYg+1AhzZb0YvIIiXS7cvV6duBJ3/dEu6q2IHfWEM57zACpdz8X91DzqR/F2EfX
         kWXi1TM6pY/DXe6qLBmVdHhOLpebkLKuLoDSrg6YibLgTeffl5UrIrN5c6wpS3ba4y
         WY5M0ZL/aXEgg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AE30C609EF;
        Wed, 13 Oct 2021 20:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: korina: select CRC32
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163415760670.2895.2938605961052747912.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 20:40:06 +0000
References: <20211012152509.21771-1-vegard.nossum@oracle.com>
In-Reply-To: <20211012152509.21771-1-vegard.nossum@oracle.com>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 17:25:09 +0200 you wrote:
> Fix the following build/link error by adding a dependency on the CRC32
> routines:
> 
>   ld: drivers/net/ethernet/korina.o: in function `korina_multicast_list':
>   korina.c:(.text+0x1af): undefined reference to `crc32_le'
> 
> Fixes: ef11291bcd5f9 ("Add support the Korina (IDT RC32434) Ethernet MAC")
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> 
> [...]

Here is the summary with links:
  - net: korina: select CRC32
    https://git.kernel.org/netdev/net/c/427f974d9727

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


