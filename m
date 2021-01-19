Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746F22FB13A
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 07:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbhASGWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 01:22:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:60700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404020AbhASFuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 00:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B9B522B49;
        Tue, 19 Jan 2021 05:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611035410;
        bh=iCqo0LyFJW91MjANA/HWsFegwHsFucrKPdtF/UumK5c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=URci2OeBE3sEsAx8hJTbt5rzApAxMjORzsMy6noO9Rks4iw4KTpJ50cCIJcfQQ9un
         dE8R01luyK0pXZJfB5aJnVhd6QLITIF7+1159DsfUokl/FtZuEr1hJYBe7kGAWsUTn
         U6ILMWBDwKQTvITlahLFo6juXRHxN8o62GY51RX0cz79txz3BjMCeRBTqd1TXmiiQA
         IcEVo2xSwcpjKmahMpEMPjHxwAp4crUnLllbgdPsWRuWOBHfatJ7rr5CmdqCwsPRQl
         aq69aPA7jmXM2QGAdhkXoLrZNvAc6q/LLnu2aGw1uTxToYVU/rfczySXf2IOmQOIR3
         FunvIg3WXyHCA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 7E89D601A5;
        Tue, 19 Jan 2021 05:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] arcnet: fix macro name when DEBUG is defined
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161103541051.1484.16409203594027734802.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jan 2021 05:50:10 +0000
References: <20210117181519.527625-1-trix@redhat.com>
In-Reply-To: <20210117181519.527625-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     m.grzeschik@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 17 Jan 2021 10:15:19 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> When DEBUG is defined this error occurs
> 
> drivers/net/arcnet/com20020_cs.c:70:15: error: ‘com20020_REG_W_ADDR_HI’
>   undeclared (first use in this function);
>   did you mean ‘COM20020_REG_W_ADDR_HI’?
>        ioaddr, com20020_REG_W_ADDR_HI);
>                ^~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - arcnet: fix macro name when DEBUG is defined
    https://git.kernel.org/netdev/net-next/c/7cfabe4f85a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


