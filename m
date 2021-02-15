Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6D931C338
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhBOUut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhBOUur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 15:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 705F664DEC;
        Mon, 15 Feb 2021 20:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613422207;
        bh=xobw78+CKH3Nw20TYk/1vigfT5mX76GOXCAqnPC8XCk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q2tInRWpj3GI/YD0eDV6UeTh7dgTxWyxdCzVZIXYJK/CDPHRHvv+De2ooyFCsOWxB
         tps0rrFK5cs4xkp4uzja0S82lKmBtNtRix4eB0ZMD+uc6Ffyb0WHJKKhwRBY+Axmp8
         CLWtvRhzziQWQgTCNxLzC5y8wYms0CuR+mnglZFJif8IcDsjollj93Io+KcNRwU2d7
         3ROxrneMGa6iGEGmoED69XUaMEVDyqe6mG2tGd8G3RANNUXWpJuX9b286b09fQDDLv
         t6wtzLlmtitgF+Rtzx196fEbzBeayWfETa+wlK1AQaTbAWAFvkvzw2AQVCAMNnpEql
         LoyaKo+P/3i1A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 60A3F609D9;
        Mon, 15 Feb 2021 20:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] atm: idt77252: fix build broken on amd64
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161342220739.9745.6613932639458138139.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 20:50:07 +0000
References: <20210214234308.1524014-1-ztong0001@gmail.com>
In-Reply-To: <20210214234308.1524014-1-ztong0001@gmail.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 14 Feb 2021 18:43:08 -0500 you wrote:
> idt77252 is broken and wont load on amd64 systems
>   modprobe idt77252 shows the following
> 
>     idt77252_init: skb->cb is too small (48 < 56)
> 
>   Add packed attribute to struct idt77252_skb_prv and struct atm_skb_data
>   so that the total size can be <= sizeof(skb->cb)
>   Also convert runtime size check to buildtime size check in
>   idt77252_init()
> 
> [...]

Here is the summary with links:
  - [v1] atm: idt77252: fix build broken on amd64
    https://git.kernel.org/netdev/net/c/d0a0bbe7b0a1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


