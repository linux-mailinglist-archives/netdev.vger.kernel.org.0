Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D73B42A26E
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhJLKmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235872AbhJLKmI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 06:42:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 739B261078;
        Tue, 12 Oct 2021 10:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634035207;
        bh=Uzedw/TaN1V5uNbmMLry3sosjhIZCWQyxQ25SbxkIU0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CtAyax1CQovCFHNdcR4FiyT7HdGKO9Z43ECa/qa+1XrMchCsrEDxGDaClsnrNAT7z
         BQcqiEvtsYKgFjWyZq2ihPVNT0b3OdI7AInS2Zrf4uZbtP69EoP/DjBMHHPCLQbYMq
         pPxdcH1qvL/9+Cy4RoFfnuRceQS911vH4VWZbfN95QyvxLDNOmC8iUMVBJYQTiFVJZ
         eAzWrAUlZPB4NMWy7SaeEt8YuXFruURn9MmN2uTC5YpsPF2lYzCKINRetm7ByGSMZz
         o27Iw5RtWM7tNW64J5IdPuBJEo/VoceWazNluYrcoi7MU31VlqdAquntoWCvkcH8/B
         2x7gVUYi+RQDw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 68D7F60965;
        Tue, 12 Oct 2021 10:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163403520742.25122.16952890625323973877.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Oct 2021 10:40:07 +0000
References: <20211011152249.12387-1-vegard.nossum@oracle.com>
In-Reply-To: <20211011152249.12387-1-vegard.nossum@oracle.com>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hayeswang@realtek.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 11 Oct 2021 17:22:49 +0200 you wrote:
> Fix the following build/link errors by adding a dependency on
> CRYPTO, CRYPTO_HASH, CRYPTO_SHA256 and CRC32:
> 
>   ld: drivers/net/usb/r8152.o: in function `rtl8152_fw_verify_checksum':
>   r8152.c:(.text+0x2b2a): undefined reference to `crypto_alloc_shash'
>   ld: r8152.c:(.text+0x2bed): undefined reference to `crypto_shash_digest'
>   ld: r8152.c:(.text+0x2c50): undefined reference to `crypto_destroy_tfm'
>   ld: drivers/net/usb/r8152.o: in function `_rtl8152_set_rx_mode':
>   r8152.c:(.text+0xdcb0): undefined reference to `crc32_le'
> 
> [...]

Here is the summary with links:
  - r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256
    https://git.kernel.org/netdev/net/c/9973a43012b6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


