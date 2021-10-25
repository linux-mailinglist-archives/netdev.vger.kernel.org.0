Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DE043975D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhJYNWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230109AbhJYNWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 09:22:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7F11B60F4F;
        Mon, 25 Oct 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635168008;
        bh=bS2nVyYvUqRVlnDhCWIa9fec2MjB+VtCQaKTMYVSWcM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TTZtuNxlANmJ1SO2m8aUTbYHUN6enZroxqIQGV9S5vBZyKtDLOGAuGBhuiAsfDCk4
         35lHLqSedTd04DDAF78hz/zxqnZrbaiQqc4Wwqw+f1nB+aJ/YlzXSXOFFhufPWWbGv
         jrxggo+2yLlZQ2iDbsH12S0sdHCGq1N+rLuzitrE5YOXsKhGgs4etGLmX2Slcp3iVs
         YxeAXtNn7LQC8RHHq4IFe9e+5Yasbs4nMw1B0lFlB8KvxJKv4bXlRJK0IYy+CcyzRG
         Mcp+wwqE2lbtxgaZAc7pg81gmpq1eJv8cUV/mpVQHYVlevmB0UNNtU+pK/+535NNzk
         OSHicXwM5K6Eg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7693D60A90;
        Mon, 25 Oct 2021 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] gve: Add jumbo-frame support for GQ
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163516800848.2904.10878522866556441352.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 13:20:08 +0000
References: <20211024184238.409589-1-jeroendb@google.com>
In-Reply-To: <20211024184238.409589-1-jeroendb@google.com>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Oct 2021 11:42:35 -0700 you wrote:
> This patchset introduces jumbo-frame support for the GQ queue format.
> The device already supports jumbo-frames on TX. This introduces
> multi-descriptor RX packets using a packet continuation bit.
> 
> A widely deployed driver has a bug with causes it to fail to load
> when a MTU greater than 2048 bytes is configured. A jumbo-frame device
> option is introduced to pass a jumbo-frame MTU only to drivers that
> support it.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] gve: Add RX context.
    https://git.kernel.org/netdev/net-next/c/1344e751e910
  - [net-next,2/3] gve: Implement packet continuation for RX.
    https://git.kernel.org/netdev/net-next/c/37149e9374bf
  - [net-next,3/3] gve: Add a jumbo-frame device option.
    https://git.kernel.org/netdev/net-next/c/255489f5b33c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


