Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31D133F932
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 20:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhCQTak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 15:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232932AbhCQTaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 15:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 84C8764EED;
        Wed, 17 Mar 2021 19:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616009410;
        bh=4aYg0mKu6fno88r2r5jj9ib5134+RmQDHuzGLXcTshg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OOft98S9U8iltVm6UhRh1Qiz54JeegPuo087UzLYsf9FZBr8+MTq2cTtz1nbbo3Ma
         ayGX2kkOYPzcTqHgC8ZKVoaimFi8SQSBOomqjgfUqRcpnAjPk+WsGcda/iOK+p2fnE
         RVQTXe///lhYw64wDHrE3sm2pPjzaTEkQd/PDcjln+CYldKHUmuK4AYj89ErrXTDje
         anQJxGT3yXD3qEvOtTySUgAnJ19h1u19c3AqlpK5VguiHtUMj6Eqn4RbUjkFsikh68
         utIxDKTOAP0OTXf6LjKfFdMCRk2N5OgX/6WRel1w4JyGuEFMeZjuEx9wgh9fFgSVsZ
         Nl8cjUXpnFuQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7573A60A69;
        Wed, 17 Mar 2021 19:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ppp: Mundane typo fixes in the file pppoe.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161600941047.18835.9865272069949944316.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 19:30:10 +0000
References: <20210317090059.4145144-1-unixbhaskar@gmail.com>
In-Reply-To: <20210317090059.4145144-1-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     mostrows@earthlink.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Mar 2021 14:30:59 +0530 you wrote:
> s/procesing/processing/
> s/comparations/comparisons/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/ppp/pppoe.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> [...]

Here is the summary with links:
  - net: ppp: Mundane typo fixes in the file pppoe.c
    https://git.kernel.org/netdev/net-next/c/73a2218cb268

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


