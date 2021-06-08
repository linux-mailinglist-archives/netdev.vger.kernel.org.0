Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BA73A0671
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbhFHVwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234786AbhFHVwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 17:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7967A613B6;
        Tue,  8 Jun 2021 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623189009;
        bh=KA2BVkEe3P6YWRt+be8s7bQ9Vsp/w5L7BEcnXXdddxo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZmFfdhXLzMC90wSsuLvSCuYlWeOS6mms4FWVl3p7b2iwjnDV7C/NF96TLucUAYAFP
         bHzmvelbDaxBYmw16vL5Aidf6VxpEe4IGT9O47fyhaBKuzdCId3MUfhVoIJXiSOKuJ
         /f5nP6sgcei/IfJfQa1pBqHL/8ApOe57BF7cEfNyw6iiLNyClYiuojIq1rt01yP+Ka
         ypD4oHhexsveqdqTMMTf0GV6VlPQj70gMLlCaP6l0hZyrlfTQw3g7gon8wYpbkdiON
         6tIH246vEzX0Mbj3yJsccsQjnPdBjmC0muYJ1PDdzRrnlmwGM3aNN7zyLxgwY/SxV/
         U+Uvt/VPCIq+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6B8CD60BE2;
        Tue,  8 Jun 2021 21:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch v1 net-next 00/10] Use build_skb and reorganize some code in
 ENA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162318900943.8715.3406966963040622626.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 21:50:09 +0000
References: <20210608160118.3767932-1-shayagr@amazon.com>
In-Reply-To: <20210608160118.3767932-1-shayagr@amazon.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com, ndagan@amazon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 8 Jun 2021 19:01:08 +0300 you wrote:
> Hi all,
> this patchset introduces several changes:
> 
> - Use build_skb() on RX side.
>   This allows to ensure that the headers are in the linear part
> 
> - Batch some code into functions and remove some of the code to make it more
>   readable and less error prone
> 
> [...]

Here is the summary with links:
  - [v1,net-next,01/10] net: ena: optimize data access in fast-path code
    https://git.kernel.org/netdev/net-next/c/e4ac382ebfb4
  - [v1,net-next,02/10] net: ena: Remove unused code
    https://git.kernel.org/netdev/net-next/c/9912c72edd8c
  - [v1,net-next,03/10] net: ena: Improve error logging in driver
    https://git.kernel.org/netdev/net-next/c/091d0e85a0d4
  - [v1,net-next,04/10] net: ena: use build_skb() in RX path
    https://git.kernel.org/netdev/net-next/c/9e5269a915a8
  - [v1,net-next,05/10] net: ena: add jiffies of last napi call to stats
    https://git.kernel.org/netdev/net-next/c/0ee251cd9a63
  - [v1,net-next,06/10] net: ena: Remove module param and change message severity
    https://git.kernel.org/netdev/net-next/c/15efff76491e
  - [v1,net-next,07/10] net: ena: fix RST format in ENA documentation file
    https://git.kernel.org/netdev/net-next/c/511c537bb564
  - [v1,net-next,08/10] net: ena: aggregate doorbell common operations into a function
    https://git.kernel.org/netdev/net-next/c/9e8afb059611
  - [v1,net-next,09/10] net: ena: Use dev_alloc() in RX buffer allocation
    https://git.kernel.org/netdev/net-next/c/947c54c395cb
  - [v1,net-next,10/10] net: ena: re-organize code to improve readability
    https://git.kernel.org/netdev/net-next/c/a01f2cd0ccf4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


