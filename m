Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6C8419442
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 14:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbhI0Mbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 08:31:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234314AbhI0Mbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 08:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 37498611C5;
        Mon, 27 Sep 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632745808;
        bh=vHRvx4bqIrTDmW3gd3OAO2wkD6tvqIjrAO/RflxqAaQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jHVBVDlBE6WTF8/sZCjZ5wbH5HHspUnup8aDFyZ+YOJEBc/ztmzIbwuUkaeFaYIH0
         TcBuSQDeqYTamVvIiyDca57x5h7oMlIVDmb2bWGA8Bz0C6iqJlEVQFsdM7InUntIlP
         /WZDjNxwtfvHugYoJamTOKatRhlwTqZdk+VvncjEc0PdbAciFiUhS46VArIOPJgas5
         GEAVgMPhUuqx9T73pL5teTTPq6mot1rhPekPfMAMqcI+68VhVexLUSPnj7rZAFOIn4
         GKlC606bV8kAc7XKa0Ue459YizvqxO+O5j5IG/Yym4rGeRxId7RC/d5Ki6rAsNopwl
         lnEpfy1z2vBEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2D0E960A3E;
        Mon, 27 Sep 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ibmveth: Use dma_alloc_coherent() instead of
 kmalloc/dma_map_single()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274580818.1790.2020882951937790208.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 12:30:08 +0000
References: <20210926065214.495-1-caihuoqing@baidu.com>
In-Reply-To: <20210926065214.495-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     cforno12@linux.ibm.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 26 Sep 2021 14:52:14 +0800 you wrote:
> Replacing kmalloc/kfree/dma_map_single/dma_unmap_single()
> with dma_alloc_coherent/dma_free_coherent() helps to reduce
> code size, and simplify the code, and coherent DMA will not
> clear the cache every time.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> 
> [...]

Here is the summary with links:
  - [v2] ibmveth: Use dma_alloc_coherent() instead of kmalloc/dma_map_single()
    https://git.kernel.org/netdev/net-next/c/4247ef026937

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


