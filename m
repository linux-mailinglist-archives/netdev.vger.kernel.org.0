Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD532FC72F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbhATBwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:52:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731138AbhATBuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8C7ED22CE3;
        Wed, 20 Jan 2021 01:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611107410;
        bh=BiEgtoQNxGyW3CRuCJ3i4VnSIzaDJg13qEScSNmD3Ww=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EJKDBB70wQrMFGGBp8NDO2PKuBvPoKLXkD+uxlxkTGV/xuFPmFWQ8pQIoWBKewKtH
         UF5ZrhVVB6UQXgEzA9SloCqmA/IbudRmyiG4C5oxG7eMpuCA7wqQ4Vfy665Prez+Cm
         EruI6xgHA7ICdomyC3BSRWj6g6rFwQMt9j8KJLHiYCYyvTdxI+YIhmNeOb7rtIjfUu
         6eH6K+85IoDyAH4RC+MJb0VRAqg6jt4XDgvQ1QHbHTS5i5ccAIWC6DA26Kg+1j6MZ9
         XyrwtEPtxH0ov5xCAw+zrKBfMGfdcXlHdgE5vcQiF5K+CCEXEg+xwxR1HToCMOb6bm
         ytnYtY7L6Frog==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 8D420605D2;
        Wed, 20 Jan 2021 01:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: tun: fix misspellings using codespell tool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161110741057.23772.6253878194715945679.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jan 2021 01:50:10 +0000
References: <20210118111539.35886-1-dong.menglong@zte.com.cn>
In-Reply-To: <20210118111539.35886-1-dong.menglong@zte.com.cn>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dong.menglong@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 18 Jan 2021 03:15:39 -0800 you wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> Some typos are found out by codespell tool:
> 
> $ codespell -w -i 3 ./drivers/net/tun.c
> aovid  ==> avoid
> 
> [...]

Here is the summary with links:
  - [net-next] net: tun: fix misspellings using codespell tool
    https://git.kernel.org/netdev/net-next/c/c2e315b8c399

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


